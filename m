Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0432D3AB46B
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Jun 2021 15:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhFQNRO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Jun 2021 09:17:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30226 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231224AbhFQNRO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 09:17:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623935706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0YAByv84Cx0PP+28jp5WZunAmD4iSttimvq0BKuZ+/U=;
        b=SnGRFjvX2V6YdLU8wwfcWmbPtWjeZopSCz/wjXZRcsRNl7zSn3bwv/MlFhdRLdPMaPVw3o
        52wf15Kp1o+siT5xsefjc5xnn33+Q/nyAgfY+WUEMULeqPFnjYfCrZYOPQB1TzGFX4RMNl
        +NHXC2KQVzCRI7hE5F0lr3FUHbd4dF8=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-2chK11ACO8GtMIeQrzxt7A-1; Thu, 17 Jun 2021 09:15:04 -0400
X-MC-Unique: 2chK11ACO8GtMIeQrzxt7A-1
Received: by mail-oi1-f200.google.com with SMTP id w12-20020aca490c0000b02901f1fdc1435aso2952879oia.14
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 06:15:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0YAByv84Cx0PP+28jp5WZunAmD4iSttimvq0BKuZ+/U=;
        b=OOSmp7lF5SgXsv9cqnVGSuFx+IfBtnfesggrL7UafT5sAv3TntiTp4dIWxUHkAWiS0
         mkVZmg6m1I7J3/n00wQjhxl5hatRD0dw26l5azTpNXY4WKon9e0zhCG96AgjGDvdLgbf
         WsEyfz9s8dmQfltYOWXa0Qoy5eJLzDbWtja20C65tzi3+JWZV7XqZa18Oq/ohhM1mQbV
         MnPbTvacnNe4T8IMxHSabZ3VJnAUkw0Brr4RKgKkFdpOOWYZhb25dNP3y1b+12AMaeDr
         yjAYDwZlyOLMDDWo5zfyxDXkqU27yY9mPXYQNRH+ZaIttnZIkoCu2IVS9v9zqkmcadrd
         jbng==
X-Gm-Message-State: AOAM5331VLQfdAPTf9TfnNMYnG33JD3cEfhyT5OlZd19V8q2ntd0NgXi
        XfMbCTz5NXiCCW8AlZEWCfEeii0i1UAklMlXXenzAk78/HGPmUoW0PekSpLnEP3TBKeQN2C5YLP
        M2lFObqkHFqapVFS5TXYc
X-Received: by 2002:a05:6808:a9a:: with SMTP id q26mr657040oij.53.1623935704080;
        Thu, 17 Jun 2021 06:15:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQdOZV+Dzjahcru9RGUZW0/dghmAjadEPIzK78SHrFBoTlB/4kpjYIabAWh3UQqRS+3pM9cQ==
X-Received: by 2002:a05:6808:a9a:: with SMTP id q26mr657027oij.53.1623935703825;
        Thu, 17 Jun 2021 06:15:03 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id j132sm1092396oih.11.2021.06.17.06.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 06:15:03 -0700 (PDT)
Date:   Thu, 17 Jun 2021 09:15:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't wait on future iclogs when pushing the CIL
Message-ID: <YMtK1d8mkxpi5y5N@bfoster>
References: <20210615161921.GC158209@locust>
 <YMjJZigzh3AbpOPA@bfoster>
 <20210615220944.GW664593@dread.disaster.area>
 <YMoRWWI6Yt7FWySc@bfoster>
 <20210616222054.GZ664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616222054.GZ664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 08:20:54AM +1000, Dave Chinner wrote:
> On Wed, Jun 16, 2021 at 10:57:29AM -0400, Brian Foster wrote:
> > On Wed, Jun 16, 2021 at 08:09:44AM +1000, Dave Chinner wrote:
> > > On Tue, Jun 15, 2021 at 11:38:14AM -0400, Brian Foster wrote:
> > > > On Tue, Jun 15, 2021 at 04:46:58PM +1000, Dave Chinner wrote:
> > > So I went and looked at all the cases where we check
> > > ic_prev->ic_state to make decisions. There's only one place that
> > > does that: log forces. The sync transaction/log force aggregation
> > > code is the only thing that checks the state of the previous iclog,
> > > and it appears to avoid the "future iclog" problem in two ways.
> > > First, it only checks the previous iclog state when the current head
> > > iclog state is ACTIVE (i.e. no future iclogs). Secondly, even if it
> > > ic-prev is a future iclog, it only waits on the ic_write_wait queue,
> > > which means the log force gets woken when IO completion occurs and
> > > the iclog transitions to DONE_SYNC, hence it never waits for
> > > ordering of callbacks (other log force code does that).
> > > 
> > > IOWs, there's only one place that actually tries to use the previous
> > > iclog state for making decisions, and it does doesn't really handle
> > > the case we need to handle here which is determining if the previous
> > > iclog is a past or future iclog. I does, however, handle the case of
> > > incorrect waiting safely.
> > > 
> > > That is, what we need to wait for in the CIL push is the completion
> > > of the physical IO to be signalled, not for the callbacks associated
> > > with that iclog to run. IOWs, neat as it may be,
> > > xlog_wait_on_iclog() is not the right function to be using here. We
> > > should be waiting on the ic_write_wait queue to be woken when iclog
> > > IO completion occurs, not the ic_force_wait queue that waits on
> > > ordered completion of entire journal checkpoints. We just want to
> > > ensure that all previous iclogs are physically completed before we
> > > do the pre-flush on the commit record IO, we don't need software
> > > processing of those IOs to be complete.
> > > 
> > 
> > Ok, but doesn't that leave a gap in scenarios where iclog completion
> > occurs out of order? I thought the reason for waiting on the force of
> > the previous iclog was to encapsulate that the entire content of the
> > checkpoint has been written to disk, not just the content in the
> > immediately previous iclog.
> 
> Yes. We either have to wait for all the iclogs to be written or
> we have to use ic_force_wait for sequencing.
> 

Right, Ok. That wasn't stated clearly in your earlier comment.

> > If the issue is past/future tense, is there any reason we can't filter
> > against the record header lsn of the previous iclog? E.g., assuming the
> > iclog hasn't been cleaned/reactivated (i.e. h_lsn != 0), then only block
> > on the previous iclog if XFS_LSN_CMP(prev_lsn, commit_lsn) <= 0?
> 
> That's what the patch I left running overnight does:
> 

Ok.

>         /*
>          * If the checkpoint spans multiple iclogs, wait for all previous iclogs
>          * to complete before we submit the commit_iclog. We can't use state
>          * checks for this - ACTIVE can be either a past completed iclog or a
>          * future iclog being filled, while WANT_SYNC through SYNC_DONE can be a
>          * past or future iclog awaiting IO or ordered IO completion to be run.
>          * In the latter case, if it's a future iclog and we wait on it, the we
>          * will hang because it won't get processed through to ic_force_wait
>          * wakeup until this commit_iclog is written to disk.  Hence we use the
>          * iclog header lsn and compare it to the commit lsn to determine if we
>          * need to wait on iclogs or not.
>          */
>         spin_lock(&log->l_icloglock);
>         if (ctx->start_lsn != ctx->commit_lsn) {
>                 struct xlog_in_core     *iclog;
> 
>                 for (iclog = commit_iclog->ic_prev;
>                      iclog != commit_iclog;
>                      iclog = iclog->ic_prev) {
>                         xfs_lsn_t       hlsn;
> 
>                         /*
>                          * If the LSN of the iclog is zero or in the future it
>                          * means it has passed through IO completion and
>                          * activation and hence all previous iclogs have also
>                          * done so. We do not need to wait at all in this case.
>                          */
>                         hlsn = be64_to_cpu(iclog->ic_header.h_lsn);
>                         if (!hlsn || XFS_LSN_CMP(hlsn, ctx->commit_lsn) > 0)
>                                 break;
> 
>                         /*
>                          * If the LSN of the iclog is older than the commit lsn,
>                          * we have to wait on it. Waiting on this via the
>                          * ic_force_wait should also order the completion of all
>                          * older iclogs, too, but we leave checking that to the
>                          * next loop iteration.
>                          */

What is the point of the loop? ISTM the functional change only requires
some minimal tweaking from the first patch you posted.

>                         ASSERT(XFS_LSN_CMP(hlsn, ctx->commit_lsn) < 0);
>                         xlog_wait_on_iclog(iclog);
>                         spin_lock(&log->l_icloglock);
>                 }
> 
>                 /*
>                  * Regardless of whether we need to wait or not, the the
>                  * commit_iclog write needs to issue a pre-flush so that the
>                  * ordering for this checkpoint is correctly preserved down to
>                  * stable storage.
>                  */
>                 commit_iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
>         }
> 
> 
> > Hmm.. that also has me wondering if it's possible that the previous
> > iclog might be some other future checkpoint, but then skipping the wait
> > entirely means the checkpoint might not actually be on-disk [1]. I
> 
> If the previous iclog is a future iclog, then all iclogs are future
> iclogs and this iclog is the oldest. The iclog ring only ages in one
> direction....
> 

Hm, yes that makes sense. I might have been confusing the new push
concurrency with the fact that all log writers still must contend over
the head iclog.

> > wonder if we need to do something like track the last lsn and/or iclog
> > touched by the current checkpoint and make sure we wait on that,
> > regardless of where it is in the ring (but as above, I'm still wrapping
> > my head around all of this).
> 
> We have to guarantee the log is completely stable up to the commit
> record, regardless of which checkpoint the iclogs belong to.  If we
> don't do that, then log recovery will consider that the checkpoint
> in the log is not complete before it finds the commit record. i.e.
> there will be a hole in the log where the previous cycle numbers
> show through between the end of the checkpoint and the commit
> record, and hence the head of the log will be pointed at the last
> fully completed checkpoint, not this one.
> 

Yet another thus far undocumented side effect of concurrent pushes..

Yes, I know that recovery has always stamped over incomplete record
blocks out beyond the prospective head block. I'm referring to the fact
that recovery clearly has some historical warts that conflict with this
change in behavior to the runtime logging code and suggesting that the
upstream merge cycle should not be the avenue to identify and resolve
these problems.

It's rather evident to me at this point that this change should be
deferred, tested much more thoroughly (not because it wasn't tested or
anything of that nature, but because our log/crash recovery testing is
historically lacking and crude) and reposted with these issues clearly
documented and addressed, at the very least in a manner that allows for
proper consideration of potential alternatives, etc., as opposed to
racing with an arbitrary upstream release deadline.

(This is of course out of my hands as it's not my tree, not my call,
etc. Just my opinion. I've thrown your latest series into my testbed
regardless.)

> Hence we have to ensure all prior iclogs have completed to stable
> storage before writing the commit record, regardless of whether the
> previous iclogs are part of the current checkpoint or not.
> 
> > [1] Once we work out the functional behavior one way or another, how do
> > we actually test/confirm that the flush behavior works as expected? I
> > feel as though the discussions going all the way to the initial review
> > feedback on this change have provided constant reminders that things
> > like the I/O flush / ordering dependencies are very easy to get wrong.
> > If that is ever the case, it's not clear to me we have any way to detect
> > it. Not that I'd expect to have some explicit 5 second fstest for that
> > problem, but have we analyzed whether the few decent crash recovery
> > tests we do have are sensitive enough to fail? I wonder if we could come
> > up with something clever and more explicit via error injection..
> 
> Given that we've found these problems soon after the code was
> integrated and made available for wider testing, I think it shows
> that, at the integration level, we have sufficiently sensitive crash
> and crash recovery tests to discover issues like this. It's not
> surprising that we may not find things like this at the
> individual developer level because they only have so much time and
> resources at their disposal.
> 

What do the bugs that were found have to do with test coverage for the
updated flush semantics? I called that out separately precisely because
recent patches demonstrate how the logic is subtle and easy to break,
but I don't see any real coverage for it at all. So it would be nice to
think about how we might improve on that.

> IOWs, I think the process is working exactly the way it should be
> working. It is expected that complex, subtle problems like these
> will be found (if they exist) once more people are actively using
> and testing the code in a variety of different environments. THis is
> exactly the function that integration testing is supposed to
> provide...
> 
> So while it's possible that we could have more reliable test to
> exercise this stuff (no real idea how, though), the way we are
> developing and merging and finding much harder to trigger problems
> once the code is available for wider testing shows that our
> engineering process is working as it should be....
> 

Yeah, that's wishful thinking. I made a point to run some tests I've
recently been hammering on (for that bli patch I still can't seem to
progress) because 1.) I know we have a bunch of logging changes in the
pipeline that I otherwise haven't been able to keep up with and 2.) I'm
about to disappear for a few months on leave at any moment and so wanted
to prioritize some testing to at least help verify we maintain
correctness or otherwise get any issues reported to the list. And TBH if
it weren't for 2., this is probably not something I would have
prioritized over some other longer term development work in the first
place.

I'd like to hope that we would have caught these issues before release
regardless, but let's be realistic.. if developer testing doesn't catch
it, upstream review/merge cycle testing doesn't catch it, then for crash
and recovery issues (no regular users are experimenting with failure and
recovery of their filesystems to see if we've found new ways to lose
their data), the odds go way down from there that somebody is going to
catch it before it's released to the wild.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

