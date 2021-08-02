Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A933DCE6F
	for <lists+linux-xfs@lfdr.de>; Mon,  2 Aug 2021 02:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhHBAzo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 1 Aug 2021 20:55:44 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45663 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231787AbhHBAzo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Aug 2021 20:55:44 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 51EEE865A64;
        Mon,  2 Aug 2021 10:55:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mAMEu-00DTQY-AI; Mon, 02 Aug 2021 10:55:32 +1000
Date:   Mon, 2 Aug 2021 10:55:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 14/20] xfs: parallelize inode inactivation
Message-ID: <20210802005532.GF2757197@dread.disaster.area>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758431072.332903.17159226037941080971.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162758431072.332903.17159226037941080971.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=2ex_qVBf06IpfOGingwA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 29, 2021 at 11:45:10AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Split the inode inactivation work into per-AG work items so that we can
> take advantage of parallelization.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_ag.c |   12 ++++++-
>  fs/xfs/libxfs/xfs_ag.h |   10 +++++
>  fs/xfs/xfs_icache.c    |   88 ++++++++++++++++++++++++++++--------------------
>  fs/xfs/xfs_icache.h    |    2 +
>  fs/xfs/xfs_mount.c     |    9 +----
>  fs/xfs/xfs_mount.h     |    8 ----
>  fs/xfs/xfs_super.c     |    2 -
>  fs/xfs/xfs_trace.h     |   82 ++++++++++++++++++++++++++++++++-------------
>  8 files changed, 134 insertions(+), 79 deletions(-)

....

> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -420,9 +420,11 @@ xfs_blockgc_queue(
>   */
>  static void
>  xfs_inodegc_queue(
> -	struct xfs_mount        *mp,
> +	struct xfs_perag	*pag,
>  	struct xfs_inode	*ip)
>  {
> +	struct xfs_mount        *mp = pag->pag_mount;
> +
>  	if (!test_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
>  		return;
>  
> @@ -431,8 +433,8 @@ xfs_inodegc_queue(
>  		unsigned int	delay;
>  
>  		delay = xfs_gc_delay_ms(mp, ip, XFS_ICI_INODEGC_TAG);
> -		trace_xfs_inodegc_queue(mp, delay);
> -		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work,
> +		trace_xfs_inodegc_queue(pag, delay);
> +		queue_delayed_work(mp->m_gc_workqueue, &pag->pag_inodegc_work,
>  				msecs_to_jiffies(delay));
>  	}
>  	rcu_read_unlock();

I think you missed this change in xfs_inodegc_queue():

@@ -492,7 +492,7 @@ xfs_inodegc_queue(
 		return;
 
 	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG)) {
+	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_INODEGC_TAG)) {
 		unsigned int    delay;
 
 		delay = xfs_gc_delay_ms(pag, ip, XFS_ICI_INODEGC_TAG);

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
