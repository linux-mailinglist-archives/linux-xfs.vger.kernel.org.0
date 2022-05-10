Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364DD52249C
	for <lists+linux-xfs@lfdr.de>; Tue, 10 May 2022 21:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiEJTTW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 May 2022 15:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiEJTTV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 15:19:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C71261954
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 12:19:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EB7F61203
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 19:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782E2C385C8;
        Tue, 10 May 2022 19:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652210359;
        bh=87/WEgNCydMTbo4Urbg0atjaecBTgIkACwsiqUJhOXc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K0u7IORJ9tLJBZX9nfC9ffqTAUfQAZSJ67RmFNFFu+XcFpOUzBCVteVaiuyoOsQAd
         VuyKuuCapREEH5V5rAMg7/nZSv25qsSM1Vxmgs+3hiXVYQiXI4ljVcV5OonMEYJMWo
         v8MOdPM3a5cHnXapM/o9DV538ruUT+GjPunXz3JhUOdRUBuGNW72An/u6DFMWOzH5b
         KmTbm17b310Wf/U5Ub/kb1nvAd+ZOb1Krd+aRtCawHxAjNBzMMwKd9LJXNihR3W/ZA
         1HaU80L1OW/lIJdgmZ7Ptrz//IqXk62QGIeGtX1jPVq0aWrpL/jMs0+x3TJuiqIaOp
         aWLmRHHP2JENw==
Date:   Tue, 10 May 2022 12:19:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chris Dunlop <chris@onthe.net.au>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: Highly reflinked and fragmented considered harmful?
Message-ID: <20220510191918.GD27195@magnolia>
References: <20220509024659.GA62606@onthe.net.au>
 <20220509230918.GP1098723@dread.disaster.area>
 <CAOQ4uxgf6AHzLM-mGte_L-A+piSZTRsbdLMBT3hZFNhk-yfxZQ@mail.gmail.com>
 <20220510051057.GY27195@magnolia>
 <20220510063051.GA215522@onthe.net.au>
 <20220510081632.GS1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510081632.GS1098723@dread.disaster.area>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 10, 2022 at 06:16:32PM +1000, Dave Chinner wrote:
> On Tue, May 10, 2022 at 04:30:51PM +1000, Chris Dunlop wrote:
> > On Mon, May 09, 2022 at 10:10:57PM -0700, Darrick J. Wong wrote:
> > > On Tue, May 10, 2022 at 07:07:35AM +0300, Amir Goldstein wrote:
> > > > On Mon, May 09, 2022 at 12:46:59PM +1000, Chris Dunlop wrote:
> > > > > Is it to be expected that removing 29TB of highly reflinked and fragmented
> > > > > data could take days, the entire time blocking other tasks like "rm" and
> > > > > "df" on the same filesystem?
> > ...
> > > > From a product POV, I think what should have happened here is that
> > > > freeing up the space would have taken 10 days in the background, but
> > > > otherwise, filesystem should not have been blocking other processes
> > > > for long periods of time.
> 
> Sure, that's obvious, and without looking at the code I know what
> that is: statfs()
> 
> > > Indeed.  Chris, do you happen to have the sysrq-w output handy?  I'm
> > > curious if the stall warning backtraces all had xfs_inodegc_flush() in
> > > them, or were there other parts of the system stalling elsewhere too?
> > > 50 billion updates is a lot, but there shouldn't be stall warnings.
> > 
> > Sure: https://file.io/25za5BNBlnU8  (6.8M)
> > 
> > Of the 3677 tasks in there, only 38 do NOT show xfs_inodegc_flush().
> 
> yup, 3677 tasks in statfs(). The majority are rm, df, and check_disk
> processes, there's a couple of veeamagent processes stuck and
> an (ostnamed) process, whatever that is...
> 
> No real surprises there, and it's not why the filesystem is taking
> so long to remove all the reflink references.
> 
> There is just one background inodegc worker thread running, so
> there's no excessive load being generated by inodegc, either. It's
> no different to a single rm running xfs_inactive() directly on a
> slightly older kernel and filling the journal:
> 
> May 06 09:49:01 d5 kernel: task:kworker/6:1     state:D stack:    0 pid:23258 ppid:     2 flags:0x00004000
> May 06 09:49:01 d5 kernel: Workqueue: xfs-inodegc/dm-1 xfs_inodegc_worker [xfs]
> May 06 09:49:01 d5 kernel: Call Trace:
> May 06 09:49:01 d5 kernel:  <TASK>
> May 06 09:49:01 d5 kernel:  __schedule+0x241/0x740
> May 06 09:49:01 d5 kernel:  schedule+0x3a/0xa0
> May 06 09:49:01 d5 kernel:  schedule_timeout+0x271/0x310
> May 06 09:49:01 d5 kernel:  __down+0x6c/0xa0
> May 06 09:49:01 d5 kernel:  down+0x3b/0x50
> May 06 09:49:01 d5 kernel:  xfs_buf_lock+0x40/0xe0 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_buf_find.isra.32+0x3ee/0x730 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_buf_get_map+0x3c/0x430 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_buf_read_map+0x37/0x2c0 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_trans_read_buf_map+0x1cb/0x300 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_btree_read_buf_block.constprop.40+0x75/0xb0 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_btree_lookup_get_block+0x85/0x150 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_btree_overlapped_query_range+0x33c/0x3c0 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_btree_query_range+0xd5/0x100 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_rmap_query_range+0x71/0x80 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_rmap_lookup_le_range+0x88/0x180 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_rmap_unmap_shared+0x89/0x560 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_rmap_finish_one+0x201/0x260 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_rmap_update_finish_item+0x33/0x60 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_defer_finish_noroll+0x215/0x5a0 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_defer_finish+0x13/0x70 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_itruncate_extents_flags+0xc4/0x240 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_inactive_truncate+0x7f/0xc0 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_inactive+0x10c/0x130 [xfs]
> May 06 09:49:01 d5 kernel:  xfs_inodegc_worker+0xb5/0x140 [xfs]
> May 06 09:49:01 d5 kernel:  process_one_work+0x2a8/0x4c0
> May 06 09:49:01 d5 kernel:  worker_thread+0x21b/0x3c0
> May 06 09:49:01 d5 kernel:  kthread+0x121/0x140
> 
> There are 18 tasks in destroy_inode() blocked on a workqueue flush
> - these are new unlinks that are getting throttled because that
> per-cpu inodegc queue is full and work is ongoing. Not a huge
> deal, maybe we should look to hand full queues to another CPU if
> the neighbour CPU has an empty queue. That would reduce
> unnecessary throttling, though it may mean more long running
> inodegc processes in the background....
> 
> Really, though, I don't see anything deadlocked, just a system
> backed up doing a really large amount of metadata modification.
> Everything is sitting on throttles or waiting on IO and making
> slow forwards progress as metadata writeback allows log space to be
> freed.
> 
> I think we should just accept that statfs() can never really report
> exactly accurate space usagei to userspace and get rid of the flush.

What about all the code that flushes gc work when we hit ENOSPC/EDQUOT?
Do we let those threads stall too because the fs is out of resources and
they can just wait?  Or would that also be better off with a flush
timeout and userspace can just eat the ENOSPC/EDQUOT after 30 seconds?

> Work around the specific fstests dependencies on rm always
> immediately making unlinked inodes free space in fstests rather than
> in the kernel code.

<grumble> I *really* don't want to launch *yet another* full scale audit
of XFS + supporting software behavior on tiny and/or full filesystems.
If someone else wants to take that on then please do with my blessings,
but I haven't even succeeded at landing all the patches resulting from
... whichever month it was where you suggested disallowing those tiny
filesystems.

(I didn't even bother sending the "disallow < 300MB filesystems" series
because there were 30+ patches of bugfixes that have been backing up in
my tree forever now, and I figured that was more than plenty for 5.18.)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
