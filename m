Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48E63A7296
	for <lists+linux-xfs@lfdr.de>; Tue, 15 Jun 2021 01:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhFNXoF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 14 Jun 2021 19:44:05 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:48821 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229689AbhFNXoE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Jun 2021 19:44:04 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 8AEE780B755;
        Tue, 15 Jun 2021 09:41:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lswDB-00Cpzo-B5; Tue, 15 Jun 2021 09:41:45 +1000
Date:   Tue, 15 Jun 2021 09:41:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [BUG] generic/475 recovery failure(s)
Message-ID: <20210614234145.GU664593@dread.disaster.area>
References: <YMIsWJ0Cb2ot/UjG@bfoster>
 <YMOzT1goreWVgo8S@bfoster>
 <20210611223332.GS664593@dread.disaster.area>
 <YMdMehWQoBJC9l0W@bfoster>
 <YMdR4E+0cERrmTZi@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMdR4E+0cERrmTZi@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=ZpK34dDYdgYj5-rVxHkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 14, 2021 at 08:56:00AM -0400, Brian Foster wrote:
> On Mon, Jun 14, 2021 at 08:32:58AM -0400, Brian Foster wrote:
> > On Sat, Jun 12, 2021 at 08:33:32AM +1000, Dave Chinner wrote:
> > > On Fri, Jun 11, 2021 at 03:02:39PM -0400, Brian Foster wrote:
> > > > On Thu, Jun 10, 2021 at 11:14:32AM -0400, Brian Foster wrote:
> ...
> > 
> > I've also now been hitting a deadlock issue more frequently with the
> > same test. I'll provide more on that in a separate mail..
> > 
> 
> So I originally thought this one was shutdown related (there still may
> be a shutdown hang, I was quickly working around other issues to give
> priority to the corruption issue), but what I'm seeing actually looks
> like a log reservation deadlock. More specifically, it looks like a
> stuck CIL push and everything else backed up behind it.
> 
> I suspect this is related to the same patch (it does show 4 concurrent
> CIL push tasks, fwiw), but I'm not 100% certain atm. I'll repeat some
> tests on the prior commit to try and confirm or rule that out. In the
> meantime, dmesg with blocked task output is attached.
> 
> [49989.354537] sysrq: Show Blocked State
> [49989.362009] task:kworker/u161:4  state:D stack:    0 pid:105326 ppid:     2 flags:0x00004000
> [49989.370464] Workqueue: xfs-cil/dm-5 xlog_cil_push_work [xfs]
> [49989.376278] Call Trace:
> [49989.378744]  __schedule+0x38b/0xc50
> [49989.382250]  ? lock_release+0x1cd/0x2a0
> [49989.386097]  schedule+0x5b/0xc0
> [49989.389251]  xlog_wait_on_iclog+0xeb/0x100 [xfs]
> [49989.393932]  ? wake_up_q+0xa0/0xa0
> [49989.397353]  xlog_cil_push_work+0x5cb/0x630 [xfs]
> [49989.402123]  ? sched_clock_cpu+0xc/0xb0
> [49989.405971]  ? lock_acquire+0x15d/0x380
> [49989.409823]  ? lock_release+0x1cd/0x2a0
> [49989.413662]  ? lock_acquire+0x15d/0x380
> [49989.417502]  ? lock_release+0x1cd/0x2a0
> [49989.421353]  ? finish_task_switch.isra.0+0xa0/0x2c0
> [49989.426238]  process_one_work+0x26e/0x560
> [49989.430271]  worker_thread+0x52/0x3b0
> [49989.433942]  ? process_one_work+0x560/0x560
> [49989.438138]  kthread+0x12c/0x150
> [49989.441380]  ? __kthread_bind_mask+0x60/0x60

Only way we can get stuck here is that the ctx->start_lsn !=
commit_lsn and the previous iclog is still in WANT_SYNC/SYNC state.
This implies the iclog has an elevated reference count and so while
it has been released, IO wasn't issued on it because refcount > 0.

The only way I can see this happening is start_lsn != commit_lsn
on the same iclog, or we have a bug in the iclog reference counting
and it's never reaching zero on the previous iclog.

Ok, I think I've reproduced this - took about 300 iterations of
g/019, but I've got a system stuck like this but all the other CIL
pushes in progress are stuck here:

[ 2458.915655] INFO: task kworker/u8:4:31656 blocked for more than 123 seconds.
[ 2458.917629]       Not tainted 5.13.0-rc6-dgc+ #205
[ 2458.919011] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2458.921205] task:kworker/u8:4    state:D stack:12160 pid:31656 ppid:     2 flags:0x00004000
[ 2458.923538] Workqueue: xfs-cil/vdb xlog_cil_push_work
[ 2458.925000] Call Trace:
[ 2458.925763]  __schedule+0x30b/0x9f0
[ 2458.926811]  schedule+0x68/0xe0
[ 2458.927757]  xlog_state_get_iclog_space+0x1b8/0x2d0
[ 2458.929122]  ? wake_up_q+0xa0/0xa0
[ 2458.930142]  xlog_write+0x7b/0x650
[ 2458.931145]  ? _raw_spin_unlock_irq+0xe/0x30
[ 2458.932405]  ? __wait_for_common+0x133/0x160
[ 2458.933647]  xlog_cil_push_work+0x5eb/0xa10
[ 2458.934854]  ? wake_up_q+0xa0/0xa0
[ 2458.935881]  ? xfs_swap_extents+0x920/0x920
[ 2458.937126]  process_one_work+0x1ab/0x390
[ 2458.938284]  worker_thread+0x56/0x3d0
[ 2458.939355]  ? rescuer_thread+0x3c0/0x3c0
[ 2458.940557]  kthread+0x14d/0x170
[ 2458.941530]  ? __kthread_bind_mask+0x70/0x70
[ 2458.942779]  ret_from_fork+0x1f/0x30

Which indicates that there are no iclogs in XLOG_STATE_ACTIVE (i.e.
the "noiclogs" state, and that definitely correlates with an iclog
stuck in an WANT_SYNC state....

Now I know I can reproduce it, I'll dig into it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
