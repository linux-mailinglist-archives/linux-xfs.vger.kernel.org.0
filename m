Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC978303432
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Jan 2021 06:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731779AbhAZFTI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 26 Jan 2021 00:19:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:37364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732208AbhAZCGi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Jan 2021 21:06:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD83422E03;
        Tue, 26 Jan 2021 02:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611626743;
        bh=PfKauCSsXgS0LTwb4+UoMt5sMVeqLhjD/LZMuELX7Gg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NBzLZX1OF5ZBVn7wBxQp4RB/3EBogBuyB+nbBfCeRT+W3vv03q3iWcL7tKf6o4WFL
         1zQSl291vz1GIGXwUFX4xIzxzWcZimeeDyUJafaGrk1I2Go6fCTnh9QptimdISiwjp
         KULmDPKBWpVHtxLaMs9ZSO0jeOCrLq/O2phxBCPdpguKXhO+BCHgfUNpSv30NXP1Y/
         X9J+iON6iXRy4G/iOdyE+ohB1ppCWXe+1xV64Sb+1Aoh3dBoefYSS8Q42n9J+k0HWq
         CwwRXxwfyEDMvFfUpnJffkYd9TbsbR+lqGpDNKj7jCiJHkPpFto5UWRMSpeFMg6nZT
         WSQ4a2WL2wsmQ==
Date:   Mon, 25 Jan 2021 18:05:42 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Musings over REQ_PREFLUSH and REQ_FUA in journal IO
Message-ID: <20210126020542.GJ7698@magnolia>
References: <20210125061422.GF4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125061422.GF4662@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 25, 2021 at 05:14:22PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> I've been thinking a little about the way we write use cache flushes
> recently and I was thinking about how we do journal writes and
> whether we need to issue as many cache flushes as we currently do.

Pardon my stream of consciousness, as I try to see if I follow what
you're talking about. :)

> RIght now, every journal write is REQ_PREFLUSH | REQ_FUA, except in
> two cases:
> 
> 1. the log and data devices are different, and we've already issued
> a cache flush to the data device, and
> 
> 2. it's the second write of a split iclog (i.e. tail wrapping) and
> so the second bio doesn't need another pre-flush to be run before
> submission.
> 
> For the purposes of my thinking, #1 above is irrelevant - if we are
> able to elide pre-flush from most iclog IOs, we can elide most of
> the data dev cache flushes when the log is on a separate device.
> 
> However, it's #2 that has got me thinking: the pre-flush isn't
> necessary if the journal IO has already received a cache flush that
> covers the context of the larger journal write. This behaviour has
> been with us since, well, since explicit log IO cache flushes were
> added almost 2 decades ago by Steve Lord:

IOWs, we only need to flush if we've written something log related since
the last log write; if we haven't, then we don't need to flush whatever
dirty file data might also be lurking in there, because the user has
fsync for that?

> commit 95d97c36e5155075ba2eb22b17562cfcc53fcf96
> Author: Steve Lord <lord@sgi.com>
> Date:   Fri May 24 14:30:21 2002 +0000
> 
>     Add support for drive write cache flushing - should the kernel
>         have the infrastructure
> 
> But things have changed greatly since then, namely delayed logging
> and CIL checkpoints. They have greatly changed how we use iclogs for
> writing changes to the journal, but the journal IO mechanisms are
> largely unchanged.
> 
> That is, the pre-flush is ensuring that all the metadata in the LSN
> range of the journal that the iclog sync is about overwrite is
> already on stable storage. This means that the metadata writeback in
> that range of LSNs has been completed and so we can write the
> current log tail into this iclog and correctly order the journal IO
> against the already-signalled metadata completion by using a pre-IO
> cache flush on the journal IO.

Put another way -- if we've already checkpointed into the filesystem all
of the updates contained in an iclog, we don't have to PREFLUSH before
ovewriting that iclog with a new iclog?

> From this observation, it seems to me that we only actually need a
> pre-flush to guarantee the metadata being overwritten is stable if the
> log tail has moved between the last iclog write and this one. i.e. if
> the tail hasn't moved, then a previous iclog write issued the cache
> flush to make the metadata in the current LSN overwrite range stable
> and so this iclog doesn't need to do it again.

...I think the gist of this is that if our log currently contains iclogs
A, B, and C, we have dirty iclogs D, E, and F that we want to write, and
nobody's been adding things to the log, then we don't have to flush
before writing E because we already took care of that when we wrote D on
top of A?

> This implies that that we only need a device cache pre-flush if
> (iclog->ic_header.h_lsn != iclog->ic_prev->ic_header.h_lsn).  This
> alone would greatly reduce the number of pre-flushes we issue during
> a long running CIL checkpoint as tail updates don't occur
> frequently.
> 
> But the CIL and checkpoint transactions allows us to take this
> further.  That is, when we start a checkpoint transaction we've
> actually reserved all the space in the log that we require to write
> the entire checkpoint. The tail *must* already be beyond where the
> end of the checkpoint will reach into the journal because the space
> reservations guarantee that the reserve head never wraps around past
> the current journal tail.
> 
> Hence, when we start a new checkpoint, it will already fit into the
> dead LSN range between the head and the tail, and so we only need a
> single cache pre-flush to guarantee completion to submission
> ordering of the metadata and to-be-issued checkpoint IO into that LSN
> range.  That means we only need one data device cache flush per CIL
> checkpoint, not one per iclog written in the CIL checkpoint.

Hmm, are you saying we only need to flush caches after we've written the
last iclog in that cil checkpoint?  Or maybe not, given what I see later
on...?

> IOWs, if we running a 32MB CIL (2GB log) and running full
> checkpoints every push, we could reduce the number of cache flushes
> by a factor of 100 (256kb iclog = 128 journal IOs for a full CIL
> push) to 1000 (32kB journal = 1024 journal IOs). That's a
> significant, ongoing reduction in cache flushes.
> 
> And then I woundered if we could apply the same logic to
> post-journal write cache flushes (REQ_FUA) that guarantee that the
> journal writes are stable before we allow writeback of the metadata
> in that LSN range (i.e. once they are unpinned). Again, we have a
> completion to submission ordering requirement here, only this time
> it is journal IO completion to metadata IO submission.

I think this seems reasonable...

> IOWs, I think the same observation about the log head and the AIL
> writeback mechanism can be made here: we only need to ensure a cache
> flush occurs before we start writing back metadata at an LSN higher

"we start writing back metadata" ... you mean xfsaild writing dirty
buffers back into the fs after a transaction commits to the log?

> than the journal head at the time of the last cache flush. The first
> iclog write of last CIL checkpoint will have ensured all
> metadata lower than the LSN of the CIL checkpoint is stable, hence
> we only need to concern ourselves about metadata at the same LSN as
> that checkpoint. checkpoint completion will unpin that metadata, but
> we still need a cache flush to guarantee ordering at the stable
> storage level.

So assuming the answer to my last question is yes, then ... an iclog
write will flush the cache to ensure anything written (previously) by
the AIL(?) with a lower LSN than the iclog has made it to disk...?

> Hence we can use an on-demand AIL traversal cache flush to ensure
> we have journal-to-metadata ordering. This will be much rarer than
> every using FUA for every iclog write, and should be of similar
> order of gains to the REQ_PREFLUSH optimisation.

...and in turn if the AIL wants to write a buffer back to the fs, and
that buffer has an LSN higher than whatever the LSN was the last time we
flushed the disk cache, then the AIL needs to induce a cache flush to
stabilize the log before it actually does that writeback?

> FWIW, because we use checksums to detect complete checkpoints in
> the journal now, we don't actually need to use FUA writes to
> guarantee they hit stable storage. We don't have a guarantee in what
> order they will hit the disk (even with FUA), so the only thing that
> the FUA write gains us is that on some hardware it elides the need
> for a post-write cache flush. Hence I don't think we need REQ_FUA,
> either.
> 
> I suspect that the first iclog in a CIL checkpoint should also use
> REQ_FUA, if only to ensure that the log is dirtied as quickly as
> possible when a new checkpoint starts. The rest of the checkpoint
> ordering or cache flushing just doesn't matter until other external
> events require explicit ordering.

Yeah, probably. :)

> The only explicit ordering we really have are log forces. As long as
> log forces issue a cache flush when they are left pending by CIL
> transaction completion, we shouldn't require anything more here. The
> situation is similar to the AIL requirement...
> 
> In summary, I think we can get rid of almost all iclog REQ_PREFLUSH
> and REQ_FUA usage simply by:
> 
> 	- first iclog write in a CIL checkpoint uses REQ_PREFLUSH

PREFLUSH?  Didn't you say FUA for the first iclog two paragraphs up?

> 	- AIL traversal to an item with the current head LSN
> 	  triggers a cache flush

I think this confirms the answer to my question about xfsaild inducing
cache flushes.

> 	- SYNC log force triggers a cache flush if required to
> 	  stabilise the last checkpoint written to the log,
> 	  otherwise caller flushes caches as necessary (same as
> 	  current fsync semantics)

<nod>

> Given that metadata intensive workloads can result in hundreds to
> thousands of journal IOs every second, getting rid of the vast
> majority of these cache flush operations would be a major
> performance win for such workloads...
> 
> Of course, this seems so simple now that I've written it, making me
> wonder what I've missed.

"Every time I tangle with the log it takes all day and my brain hurts by
the end so I don't tangle with the log" ? :)

And with that, my brain hurts...

--D

> Thoughts?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
