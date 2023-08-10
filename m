Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15FC1776CB4
	for <lists+linux-xfs@lfdr.de>; Thu, 10 Aug 2023 01:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjHIXRb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 9 Aug 2023 19:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjHIXRa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2023 19:17:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6828E7C
        for <linux-xfs@vger.kernel.org>; Wed,  9 Aug 2023 16:17:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55111640FD
        for <linux-xfs@vger.kernel.org>; Wed,  9 Aug 2023 23:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0465C433C7;
        Wed,  9 Aug 2023 23:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691623048;
        bh=aeFVJGNPUoCwkRfgS8a7jBL5qFVncZkP80N1KYrVrxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JWugDHT+eXqegggDA7+/kPEtgcaFpjhBfS+VAdphy3aU3Ea1oYd6I6RwmPk8P+vT1
         HeoyYtWeqqiwCszHHlAHJO6620IJHh7ltzm9DXSMXqYDTWftcM97whoHSspUFXYoFd
         PorqXUXKvzAf8eT8WCuLmFPWpt512k2G4jPs6WfHpsLdd2qTWnn9YHpjd75MBN5fvI
         PKhNDT5KG03Qc4qqv/ug51FxwmKQbbtkam+D2vIdPz1haNUOV+1JFZ/7l2rzkIiL28
         cOnHby4gKOoCTnitUJn0Yf5fMN7xR3/IURrBApVT9vFLsFYWRQZzsj8B//WJX6WACH
         KEMG6C7rnDj3A==
Date:   Wed, 9 Aug 2023 16:17:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v26.0 0/9] xfs: fix online repair block reaping
Message-ID: <20230809231728.GY11352@frogsfrogsfrogs>
References: <20230727221158.GE11352@frogsfrogsfrogs>
 <169049622719.921010.16542808514375882520.stgit@frogsfrogsfrogs>
 <ZNCM35YJ/yroXI/n@dread.disaster.area>
 <20230808004007.GM11352@frogsfrogsfrogs>
 <ZNHP4TqsOQPIpiqf@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNHP4TqsOQPIpiqf@dread.disaster.area>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 08, 2023 at 03:17:21PM +1000, Dave Chinner wrote:
> On Mon, Aug 07, 2023 at 05:40:07PM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 07, 2023 at 04:19:11PM +1000, Dave Chinner wrote:
> > > On Thu, Jul 27, 2023 at 03:18:32PM -0700, Darrick J. Wong wrote:
> > > > Hi all,
> > > > 
> > > > These patches fix a few problems that I noticed in the code that deals
> > > > with old btree blocks after a successful repair.
> > > > 
> > > > First, I observed that it is possible for repair to incorrectly
> > > > invalidate and delete old btree blocks if they were crosslinked.  The
> > > > solution here is to consult the reverse mappings for each block in the
> > > > extent -- singly owned blocks are invalidated and freed, whereas for
> > > > crosslinked blocks, we merely drop the incorrect reverse mapping.
> > > > 
> > > > A largeish change in this patchset is moving the reaping code to a
> > > > separate file, because the code are mostly interrelated static
> > > > functions.  For now this also drops the ability to reap file blocks,
> > > > which will return when we add the bmbt repair functions.
> > > > 
> > > > Second, we convert the reap function to use EFIs so that we can commit
> > > > to freeing as many blocks in as few transactions as we dare.  We would
> > > > like to free as many old blocks as we can in the same transaction that
> > > > commits the new structure to the ondisk filesystem to minimize the
> > > > number of blocks that leak if the system crashes before the repair fully
> > > > completes.
> > > > 
> > > > The third change made in this series is to avoid tripping buffer cache
> > > > assertions if we're merely scanning the buffer cache for buffers to
> > > > invalidate, and find a non-stale buffer of the wrong length.  This is
> > > > primarily cosmetic, but makes my life easier.
> > > > 
> > > > The fourth change restructures the reaping code to try to process as many
> > > > blocks in one go as possible, to reduce logging traffic.
> > > > 
> > > > The last change switches the reaping mechanism to use per-AG bitmaps
> > > > defined in a previous patchset.  This should reduce type confusion when
> > > > reading the source code.
> > > > 
> > > > If you're going to start using this mess, you probably ought to just
> > > > pull from my git trees, which are linked below.
> > > > 
> > > > This is an extraordinary way to destroy everything.  Enjoy!
> > > > Comments and questions are, as always, welcome.
> > > 
> > > Overall I don't see any red flags, so from that perspective I think
> > > it's good to merge as is. THe buffer cache interactions are much
> > > neater this time around.
> > > 
> > > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > 
> > Thanks!
> > 
> > > The main thing I noticed is that the deferred freeing mechanism ifo
> > > rbulk reaping will add up to 128 XEFIs to the transaction. That
> > > could result in a single EFI with up to 128 extents in it, right?
> > 
> > Welllp... the defer ops code only logs up to 16 extents per EFI log item
> > due to my, er, butchering of max_items.  So in the end, we log up to 8x
> > EFI items, each of which has up to 16y EFIs...
> > 
> > > What happens when we try to free that many extents in a single
> > > transaction loop? The extent free processing doesn't have a "have we
> > > run out of transaction reservation" check in it like the refcount
> > > item processing does, so I don't think it can roll to renew the
> > > transaction reservation if it is needed. DO we need to catch this
> > > and renew the reservation by returning -EAGAIN from
> > > xfs_extent_free_finish_item() if there isn't enough of a reservation
> > > remaining to free an extent?
> > 
> > ...and by my estimation, those eight items consume a fraction of the
> > reservation available with tr_itruncate:
> > 
> > 16 x xfs_extent_64_t   = 256 bytes
> > 1 x xfs_efi_log_format = 8 bytes
> >                        = 272 bytes per EFI
> > 
> > 8 x EFI                = 2176 bytes
> 
> I'm not worried by the EFIs themselves when they are created and
> committed, it's the processing of the XEFIs which are all done in a
> single transaction unless a ->finish_item() call returns -EAGAIN.

*OH*.  You're right, we don't really have a guarantee that someone won't
queue 16 extents to an EFI logitem and then ->finish_item will blow out
the reservation...

> i.e. it's the xfs_trans_free_extent() calls that are done one after
> another, and potential log different AG metadata blocks on each
> extent free operation....
> 
> And it's not just runtime we have to worry about - if we crash and
> have to recover on of these EFIs with 16 extents in it, we have the
> problem of processing a 16 extent EFI on a single transaction
> reservation, right?

...so to answer your question, there isn't anything in the
xfs_trans_free_extent codepath that would trigger a transaction roll,
nor is there anything to prevent repair from logging a huge EFI.

I also don't see anything preventing *other* parts of the filesystem
from logging a huge number of deferred frees and having them end up as
one big EFI.  Maybe I should monitor that to see what fstests comes up
with?

The only situation where a lot of extents get queued to a single EFI
logitem (I think) would be the xfs_refcount code, which could end up
freeing a lot of small extents while decrementing one physical extent's
refcount.

> > So far, I haven't seen any overflows with the reaping code -- for the AG
> > btree rebuilders, we end up logging and relogging the same bnobt/cntbt
> > buffers over and over again.  tr_itruncate gives us ~320K per transaction,
> > and I haven't seen any overflows yet.
> 
> I suspect it might be different with aged filesystems where the
> extents being freed could be spread across many, many btree leaf
> nodes...

Hmm.  I already think the refcount overhead calculation thing is sort of
handwavy -- the estimates are (hopefully) deliberately overlarge to
avoid triggering a shutdown.  Last time I checked, there wasn't a good
way to figure out how much of a transaction's reservation has actually
been used, since we don't really know that until log item formatting
time, right?

I wonder if we'd be better off lowering XFS_EFI_MAX_FAST_EXTENTS...?

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
