Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDBD19348E
	for <lists+linux-xfs@lfdr.de>; Thu, 26 Mar 2020 00:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgCYX0p (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Mar 2020 19:26:45 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42819 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727395AbgCYX0p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 19:26:45 -0400
Received: from dread.disaster.area (pa49-195-110-5.pa.nsw.optusnet.com.au [49.195.110.5])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D349E3A3017;
        Thu, 26 Mar 2020 10:26:41 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jHFQ0-0005aY-Bx; Thu, 26 Mar 2020 10:26:40 +1100
Date:   Thu, 26 Mar 2020 10:26:40 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] xfs: prohibit fs freezing when using empty
 transactions
Message-ID: <20200325232640.GL10776@dread.disaster.area>
References: <158510667039.922633.6138311243444001882.stgit@magnolia>
 <158510667670.922633.9371387481128286027.stgit@magnolia>
 <20200325060627.GW29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325060627.GW29339@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=UL8WcDbXXJQENuhYI/M0Yg==:117 a=UL8WcDbXXJQENuhYI/M0Yg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=eFAJVGdYXRnGeneTAcIA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 11:06:27PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I noticed that fsfreeze can take a very long time to freeze an XFS if
> there happens to be a GETFSMAP caller running in the background.  I also
> happened to notice the following in dmesg:
> 
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 43492 at fs/xfs/xfs_super.c:853 xfs_quiesce_attr+0x83/0x90 [xfs]
> Modules linked in: xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 ip_set_hash_ip ip_set_hash_net xt_tcpudp xt_set ip_set_hash_mac ip_set nfnetlink ip6table_filter ip6_tables bfq iptable_filter sch_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: xfs]
> CPU: 2 PID: 43492 Comm: xfs_io Not tainted 5.6.0-rc4-djw #rc4
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
> RIP: 0010:xfs_quiesce_attr+0x83/0x90 [xfs]
> Code: 7c 07 00 00 85 c0 75 22 48 89 df 5b e9 96 c1 00 00 48 c7 c6 b0 2d 38 a0 48 89 df e8 57 64 ff ff 8b 83 7c 07 00 00 85 c0 74 de <0f> 0b 48 89 df 5b e9 72 c1 00 00 66 90 0f 1f 44 00 00 41 55 41 54
> RSP: 0018:ffffc900030f3e28 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: ffff88802ac54000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff81e4a6f0 RDI: 00000000ffffffff
> RBP: ffff88807859f070 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000010 R12: 0000000000000000
> R13: ffff88807859f388 R14: ffff88807859f4b8 R15: ffff88807859f5e8
> FS:  00007fad1c6c0fc0(0000) GS:ffff88807e000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f0c7d237000 CR3: 0000000077f01003 CR4: 00000000001606a0
> Call Trace:
>  xfs_fs_freeze+0x25/0x40 [xfs]
>  freeze_super+0xc8/0x180
>  do_vfs_ioctl+0x70b/0x750
>  ? __fget_files+0x135/0x210
>  ksys_ioctl+0x3a/0xb0
>  __x64_sys_ioctl+0x16/0x20
>  do_syscall_64+0x50/0x1a0
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> These two things appear to be related.  The assertion trips when another
> thread initiates a fsmap request (which uses an empty transaction) after
> the freezer waited for m_active_trans to hit zero but before the the
> freezer executes the WARN_ON just prior to calling xfs_log_quiesce.
> 
> The lengthy delays in freezing happen because the freezer calls
> xfs_wait_buftarg to clean out the buffer lru list.  Meanwhile, the
> GETFSMAP caller is continuing to grab and release buffers, which means
> that it can take a very long time for the buffer lru list to empty out.
> 
> We fix both of these races by calling sb_start_write to obtain freeze
> protection while using empty transactions for GETFSMAP and for metadata
> scrubbing.  The other two users occur during mount, during which time we
> cannot fs freeze.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: improve comments

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
