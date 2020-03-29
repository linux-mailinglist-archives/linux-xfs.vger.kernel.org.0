Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1049D1970B7
	for <lists+linux-xfs@lfdr.de>; Mon, 30 Mar 2020 00:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgC2WII (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 29 Mar 2020 18:08:08 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42432 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728775AbgC2WII (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Mar 2020 18:08:08 -0400
Received: from dread.disaster.area (pa49-179-23-206.pa.nsw.optusnet.com.au [49.179.23.206])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A4E4E3A2E57;
        Mon, 30 Mar 2020 09:08:03 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jIg66-0005CO-Pi; Mon, 30 Mar 2020 09:08:02 +1100
Date:   Mon, 30 Mar 2020 09:08:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: ratelimit inode flush on buffered write ENOSPC
Message-ID: <20200329220802.GS10776@dread.disaster.area>
References: <20200329172209.GA80283@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200329172209.GA80283@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=n/Z79dAqQwRlp4tcgfhWYA==:117 a=n/Z79dAqQwRlp4tcgfhWYA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=IYgIukRHt2wbHxH0704A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 29, 2020 at 10:22:09AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> A customer reported rcu stalls and softlockup warnings on a computer
> with many CPU cores and many many more IO threads trying to write to a
> filesystem that is totally out of space.  Subsequent analysis pointed to
> the many many IO threads calling xfs_flush_inodes -> sync_inodes_sb,
> which causes a lot of wb_writeback_work to be queued.  The writeback
> worker spends so much time trying to wake the many many threads waiting
> for writeback completion that it trips the softlockup detector, and (in
> this case) the system automatically reboots.
> 
> In addition, they complain that the lengthy xfs_flush_inodes scan traps
> all of those threads in uninterruptible sleep, which hampers their
> ability to kill the program or do anything else to escape the situation.
> 
> If there's thousands of threads trying to write to files on a full
> filesystem, each of those threads will start separate copies of the
> inode flush scan.  This is kind of pointless since we only need one
> scan, so rate limit the inode flush.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_mount.h |    1 +
>  fs/xfs/xfs_super.c |   14 ++++++++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 88ab09ed29e7..50c43422fa17 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -167,6 +167,7 @@ typedef struct xfs_mount {
>  	struct xfs_kobj		m_error_meta_kobj;
>  	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
>  	struct xstats		m_stats;	/* per-fs stats */
> +	struct ratelimit_state	m_flush_inodes_ratelimit;
>  
>  	struct workqueue_struct *m_buf_workqueue;
>  	struct workqueue_struct	*m_unwritten_workqueue;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 68fea439d974..abf06bf9c3f3 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -528,6 +528,9 @@ xfs_flush_inodes(
>  {
>  	struct super_block	*sb = mp->m_super;
>  
> +	if (!__ratelimit(&mp->m_flush_inodes_ratelimit))
> +		return;
> +
>  	if (down_read_trylock(&sb->s_umount)) {
>  		sync_inodes_sb(sb);
>  		up_read(&sb->s_umount);
> @@ -1366,6 +1369,17 @@ xfs_fc_fill_super(
>  	if (error)
>  		goto out_free_names;
>  
> +	/*
> +	 * Cap the number of invocations of xfs_flush_inodes to 16 for every
> +	 * quarter of a second.  The magic numbers here were determined by
> +	 * observation neither to cause stalls in writeback when there are a
> +	 * lot of IO threads and the fs is near ENOSPC, nor cause any fstest
> +	 * regressions.  YMMV.
> +	 */
> +	ratelimit_state_init(&mp->m_flush_inodes_ratelimit, HZ / 4, 16);
> +	ratelimit_set_flags(&mp->m_flush_inodes_ratelimit,
> +			RATELIMIT_MSG_ON_RELEASE);

Urk.

RATELIMIT_MSG_ON_RELEASE prevents "callbacks suppressed"
messages when rate limiting was active and resets via __rate_limit().
However, in ratelimit_state_exit(), that flag -enables- printing
"callbacks suppressed" messages when rate limiting was active and is
reset.

Same flag, exact opposite behaviour...

The comment says it's behaviour is supposed to match that of
ratelimit_state_exit() (i.e. print message on ratelimit exit), so I
really can't tell if this is correct/intended usage or just API
abuse....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
