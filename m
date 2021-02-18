Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758CE31EFDD
	for <lists+linux-xfs@lfdr.de>; Thu, 18 Feb 2021 20:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhBRTaj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 18 Feb 2021 14:30:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57396 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231490AbhBRTO0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 14:14:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613675579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v9HeWDh0oNLCFu5M2LGuVP9lNj/N66LTtA4i7q7Q1ao=;
        b=K+uR4cAfBhDa8FqWBikd4di43Vag+ES8iSTLMQmtKyvCPf3ulnc10YOxNDheZjET5hF4ic
        W0PMuXR+vnQPXfa4shR7XDX1+0i8omBa8gMLjZc3omWLD7iEt+JpOwtLtdaIH2RKap2VcE
        ElKROi0hVtoFo2GcbMf5wKD+Du0kivc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-AaVnRx8TM2K7K0ZH3IFEGw-1; Thu, 18 Feb 2021 14:12:55 -0500
X-MC-Unique: AaVnRx8TM2K7K0ZH3IFEGw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B19D218449E0;
        Thu, 18 Feb 2021 19:12:54 +0000 (UTC)
Received: from bfoster (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B4E55D6AD;
        Thu, 18 Feb 2021 19:12:54 +0000 (UTC)
Date:   Thu, 18 Feb 2021 14:12:52 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: lockdep recursive locking warning on for-next
Message-ID: <20210218191252.GA709084@bfoster>
References: <20210218181450.GA705507@bfoster>
 <20210218184926.GN7190@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218184926.GN7190@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 10:49:26AM -0800, Darrick J. Wong wrote:
> On Thu, Feb 18, 2021 at 01:14:50PM -0500, Brian Foster wrote:
> > Hi Darrick,
> > 
> > I'm seeing the warning below via xfs/167 on a test machine. It looks
> > like it's just complaining about nested freeze protection between the
> > scan invocation and an underlying transaction allocation for an inode
> > eofblocks trim. I suppose we could either refactor xfs_trans_alloc() to
> > drop and reacquire freeze protection around the scan, or alternatively
> > call __sb_writers_release() and __sb_writers_acquire() around the scan
> > to retain freeze protection and quiet lockdep. Hm?
> 
> Erk, isn't that a potential log grant livelock too?
> 
> Fill up the filesystem with real data and cow blocks until it's full,
> then spawn exactly enough file writer threads to eat up all the log
> reservation, then each _reserve() fails, so every thread starts a scan
> and tries to allocate /another/ transaction ... but there's no space
> left in the log, so those scans just block indefinitely.
> 
> So... I think the solution here is to go back to a previous version of
> what that patchset did, where we'd drop the whole transaction, run the
> scan, and jump back to the top of the function to get a fresh
> transaction.
> 

But we don't call into the scan while holding log reservation. We hold
the transaction memory and freeze protection. It's probably debatable
whether we'd want to scan with freeze protection held or not, but I
don't see how dropping either of those changes anything wrt to log
reservation..?

> > BTW, the stack report also had me wondering whether we had or need any
> > nesting protection in these new scan invocations. For example, if we
> > have an fs with a bunch of tagged inodes and concurrent allocation
> > activity, would anything prevent an in-scan transaction allocation from
> > jumping back into the scan code to complete outstanding work? It looks
> > like that might not be possible right now because neither scan reserves
> > blocks, but they do both use transactions and that's quite a subtle
> > balance..
> 
> Yes, that's a subtlety that screams for better documentation.
> 

TBH, I'm not sure that's enough. I think we should at least have some
kind of warning, even if only in DEBUG mode, that explicitly calls out
if we've become susceptible to this kind of scan reentry. Otherwise I
suspect that if this problem is ever truly introduced, the person who
first discovers it will probably be user with a blown stack. :( Could we
set a flag on the task or something that warns as such (i.e. "WARNING:
attempted block reservation in block reclaim context") or perhaps just
prevents scan reentry in the first place?

Brian

> --D
> 
> > 
> > Brian
> > 
> > [  316.631387] ============================================
> > [  316.636697] WARNING: possible recursive locking detected
> > [  316.642010] 5.11.0-rc4 #35 Tainted: G        W I      
> > [  316.647148] --------------------------------------------
> > [  316.652462] fsstress/17733 is trying to acquire lock:
> > [  316.657515] ffff8e0fd1d90650 (sb_internal){++++}-{0:0}, at: xfs_free_eofblocks+0x104/0x1d0 [xfs]
> > [  316.666405] 
> >                but task is already holding lock:
> > [  316.672239] ffff8e0fd1d90650 (sb_internal){++++}-{0:0}, at: xfs_trans_alloc_inode+0x5f/0x160 [xfs]
> > [  316.681269] 
> > ...
> >                stack backtrace:
> > [  316.774735] CPU: 38 PID: 17733 Comm: fsstress Tainted: G        W I       5.11.0-rc4 #35
> > [  316.782819] Hardware name: Dell Inc. PowerEdge R740/01KPX8, BIOS 1.6.11 11/20/2018
> > [  316.790386] Call Trace:
> > [  316.792844]  dump_stack+0x8b/0xb0
> > [  316.796168]  __lock_acquire.cold+0x159/0x2ab
> > [  316.800441]  lock_acquire+0x116/0x370
> > [  316.804106]  ? xfs_free_eofblocks+0x104/0x1d0 [xfs]
> > [  316.809045]  ? rcu_read_lock_sched_held+0x3f/0x80
> > [  316.813750]  ? kmem_cache_alloc+0x287/0x2b0
> > [  316.817937]  xfs_trans_alloc+0x1ad/0x310 [xfs]
> > [  316.822445]  ? xfs_free_eofblocks+0x104/0x1d0 [xfs]
> > [  316.827376]  xfs_free_eofblocks+0x104/0x1d0 [xfs]
> > [  316.832134]  xfs_blockgc_scan_inode+0x24/0x60 [xfs]
> > [  316.837074]  xfs_inode_walk_ag+0x202/0x4b0 [xfs]
> > [  316.841754]  ? xfs_inode_free_cowblocks+0xf0/0xf0 [xfs]
> > [  316.847040]  ? __lock_acquire+0x382/0x1e10
> > [  316.851142]  ? xfs_inode_free_cowblocks+0xf0/0xf0 [xfs]
> > [  316.856425]  xfs_inode_walk+0x66/0xc0 [xfs]
> > [  316.860670]  xfs_trans_alloc+0x160/0x310 [xfs]
> > [  316.865179]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
> > [  316.870119]  xfs_alloc_file_space+0x105/0x300 [xfs]
> > [  316.875048]  ? down_write_nested+0x30/0x70
> > [  316.879148]  xfs_file_fallocate+0x270/0x460 [xfs]
> > [  316.883913]  ? lock_acquire+0x116/0x370
> > [  316.887752]  ? __x64_sys_fallocate+0x3e/0x70
> > [  316.892026]  ? selinux_file_permission+0x105/0x140
> > [  316.896820]  vfs_fallocate+0x14d/0x3d0
> > [  316.900572]  __x64_sys_fallocate+0x3e/0x70
> > [  316.904669]  do_syscall_64+0x33/0x40
> > [  316.908250]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > ...
> > 
> 

