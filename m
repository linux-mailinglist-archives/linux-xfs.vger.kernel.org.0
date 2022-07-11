Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB7756B18B
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Jul 2022 06:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbiGHE07 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Jul 2022 00:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236655AbiGHE07 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jul 2022 00:26:59 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A37D27B37
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 21:26:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9F2EF10E7C3A;
        Fri,  8 Jul 2022 14:26:55 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o9fZt-00FtJW-CV; Fri, 08 Jul 2022 14:26:53 +1000
Date:   Fri, 8 Jul 2022 14:26:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, hch@lst.de, oliver.sang@intel.com
Subject: Re: [PATCH] xfs: fix use-after-free in xattr node block inactivation
Message-ID: <20220708042653.GQ227878@dread.disaster.area>
References: <YsdcZY8KtyFmPdmS@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsdcZY8KtyFmPdmS@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62c7b211
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
        a=7-415B0cAAAA:8 a=MLm4_iqMXJw3LN40TLEA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 07, 2022 at 03:21:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The kernel build robot reported a UAF error while running xfs/433
> (edited somewhat for brevity):
> 
>  BUG: KASAN: use-after-free in xfs_attr3_node_inactive (fs/xfs/xfs_attr_inactive.c:214) xfs
>  Read of size 4 at addr ffff88820ac2bd44 by task kworker/0:2/139
> 
>  CPU: 0 PID: 139 Comm: kworker/0:2 Tainted: G S                5.19.0-rc2-00004-g7cf2b0f9611b #1
>  Hardware name: Hewlett-Packard p6-1451cx/2ADA, BIOS 8.15 02/05/2013
>  Workqueue: xfs-inodegc/sdb4 xfs_inodegc_worker [xfs]
>  Call Trace:
>   <TASK>
>  dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1))
>  print_address_description+0x1f/0x200
>  print_report.cold (mm/kasan/report.c:430)
>  kasan_report (mm/kasan/report.c:162 mm/kasan/report.c:493)
>  xfs_attr3_node_inactive (fs/xfs/xfs_attr_inactive.c:214) xfs
>  xfs_attr3_root_inactive (fs/xfs/xfs_attr_inactive.c:296) xfs
>  xfs_attr_inactive (fs/xfs/xfs_attr_inactive.c:371) xfs
>  xfs_inactive (fs/xfs/xfs_inode.c:1781) xfs
>  xfs_inodegc_worker (fs/xfs/xfs_icache.c:1837 fs/xfs/xfs_icache.c:1860) xfs
>  process_one_work
>  worker_thread
>  kthread
>  ret_from_fork
>   </TASK>
> 
>  Allocated by task 139:
>  kasan_save_stack (mm/kasan/common.c:39)
>  __kasan_slab_alloc (mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasan/common.c:469)
>  kmem_cache_alloc (mm/slab.h:750 mm/slub.c:3214 mm/slub.c:3222 mm/slub.c:3229 mm/slub.c:3239)
>  _xfs_buf_alloc (include/linux/instrumented.h:86 include/linux/atomic/atomic-instrumented.h:41 fs/xfs/xfs_buf.c:232) xfs
>  xfs_buf_get_map (fs/xfs/xfs_buf.c:660) xfs
>  xfs_buf_read_map (fs/xfs/xfs_buf.c:777) xfs
>  xfs_trans_read_buf_map (fs/xfs/xfs_trans_buf.c:289) xfs
>  xfs_da_read_buf (fs/xfs/libxfs/xfs_da_btree.c:2652) xfs
>  xfs_da3_node_read (fs/xfs/libxfs/xfs_da_btree.c:392) xfs
>  xfs_attr3_root_inactive (fs/xfs/xfs_attr_inactive.c:272) xfs
>  xfs_attr_inactive (fs/xfs/xfs_attr_inactive.c:371) xfs
>  xfs_inactive (fs/xfs/xfs_inode.c:1781) xfs
>  xfs_inodegc_worker (fs/xfs/xfs_icache.c:1837 fs/xfs/xfs_icache.c:1860) xfs
>  process_one_work
>  worker_thread
>  kthread
>  ret_from_fork
> 
>  Freed by task 139:
>  kasan_save_stack (mm/kasan/common.c:39)
>  kasan_set_track (mm/kasan/common.c:45)
>  kasan_set_free_info (mm/kasan/generic.c:372)
>  __kasan_slab_free (mm/kasan/common.c:368 mm/kasan/common.c:328 mm/kasan/common.c:374)
>  kmem_cache_free (mm/slub.c:1753 mm/slub.c:3507 mm/slub.c:3524)
>  xfs_buf_rele (fs/xfs/xfs_buf.c:1040) xfs
>  xfs_attr3_node_inactive (fs/xfs/xfs_attr_inactive.c:210) xfs
>  xfs_attr3_root_inactive (fs/xfs/xfs_attr_inactive.c:296) xfs
>  xfs_attr_inactive (fs/xfs/xfs_attr_inactive.c:371) xfs
>  xfs_inactive (fs/xfs/xfs_inode.c:1781) xfs
>  xfs_inodegc_worker (fs/xfs/xfs_icache.c:1837 fs/xfs/xfs_icache.c:1860) xfs
>  process_one_work
>  worker_thread
>  kthread
>  ret_from_fork
> 
> I reproduced this for my own satisfaction, and got the same report,
> along with an extra morsel:
> 
>  The buggy address belongs to the object at ffff88802103a800
>   which belongs to the cache xfs_buf of size 432
>  The buggy address is located 396 bytes inside of
>   432-byte region [ffff88802103a800, ffff88802103a9b0)
> 
> I tracked this code down to:
> 
> 	error = xfs_trans_get_buf(*trans, mp->m_ddev_targp,
> 			child_blkno,
> 			XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0,
> 			&child_bp);
> 	if (error)
> 		return error;
> 	error = bp->b_error;
> 
> That doesn't look right -- I think this should be dereferencing
> child_bp, not bp.

It shouldn't even be there. If xfs_trans_get_buf() returns a buffer,
it should not have a pending error on it at all. i.e. it's supposed
to return either an error or a buffer handle that is ready for use.

> Looking through the codebase history, I think this
> was added by commit 2911edb653b9 ("xfs: remove the mappedbno argument to
> xfs_da_get_buf"), which replaced a call to xfs_da_get_buf with the
> current call to xfs_trans_get_buf.  Not sure why we trans_brelse'd @bp
> earlier in the function, but I'm guessing it's to avoid pinning too many
> buffers in memory while we inactivate the bottom of the attr tree.
> Hence we now have to get the buffer back.

That whole loop just looks wrong.

WE do:

xfs_attr3_node_inactive(bp)
{

	parent_blkno = xfs_buf_daddr(bp);
	....
	child_fsb = be32_to_cpu(ichdr.btree[0].before);
	xfs_trans_brelse(*trans, bp);   /* no locks for later trans */

	for (0 < i < ichdr.count) {
		xfs_da3_node_read_mapped(child_fsb, &child_bp)

		child_blkno = xfs_buf_daddr(child_bp);

		if (child is node) {
			/* recurse! */
			xfs_attr3_node_inactive(child_bp);
			/* released child_bp */
		}
		....

		/* re-get child_bp */
		xfs_trans_get_buf(child_blkno, &child_bp);

		/* whacky bp reference here */

		xfs_trans_binval(child_bp)

		/* read next child_bp */
		xfs_da3_node_read_mapped(parent_blkno, &bp)
		child_fsb = be32_to_cpu(phdr.btree[i + 1].before);
		xfs_trans_brelse(*trans, bp);
	}

So, this is dropping parent buffers so they aren't held over
the recursion down the sub tree. I can't see why this would be done for
lock ordering reasons - parent->child is the only ordering that
happens in this recursion, and only the direct ancestors of any
given child node are locked at any point in time, which is the same
a happens with a path walk....

Oh, right.

It's the fact that it can only invalidate a single child buffer
at a time and it will only do one per transaction. Hence it needs to
do a re-read of the parent buffer rather than
xfs_trans_bhold() it because the code is depth-first recursive and
so it has no idea of how deep the child will need to go (or, for
that matter, how deep we already are).

Whoever wrote this didn't, for some reason, use the da btree path
tracking (i.e. a struct xfs_da_state) to keep track of all the
parent buffers of the current child being invalidated. That would
make this code a whole lot simpler and neater....

Ugh. Nasty, nasty code.

> I /think/ this was supposed to check child_bp->b_error and fail the rest
> of the invalidation if child_bp had experienced any kind of IO or
> corruption error.  I bet the xfs_da3_node_read earlier in the loop will
> catch most cases of incoming on-disk corruption which makes this check
> mostly moot unless someone corrupts the buffer and the AIL or someone
> happens to try to push it out to disk while the buffer's unlocked.

In which case, I think we probably already should have shut down and
errored out.

> However, this is clearly a UAF bug, so fix this.
> 
> Cc: hch@lst.de
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Fixes: 2911edb653b9 ("xfs: remove the mappedbno argument to xfs_da_get_buf")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_attr_inactive.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index 0e83cab9cdde..e892040eb86b 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -158,6 +158,7 @@ xfs_attr3_node_inactive(
>  	}
>  	child_fsb = be32_to_cpu(ichdr.btree[0].before);
>  	xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
> +	bp = NULL;
>  
>  	/*
>  	 * If this is the node level just above the leaves, simply loop
> @@ -211,7 +212,7 @@ xfs_attr3_node_inactive(
>  				&child_bp);
>  		if (error)
>  			return error;
> -		error = bp->b_error;
> +		error = child_bp->b_error;
>  		if (error) {
>  			xfs_trans_brelse(*trans, child_bp);
>  			return error;

I'd just remove the child_bp error checking altogether - if there
was an IOi or corruption error on it, that shouldn't keep us from
invalidating it to free the underlying space. We're trashing the
contents, so who cares if the contents is already trashed?

Also, you probably need to set bp = NULL after the
xfs_trans_brelse() call at the bottom of the loop....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
