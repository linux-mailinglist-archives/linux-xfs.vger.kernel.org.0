Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93C93107545
	for <lists+linux-xfs@lfdr.de>; Fri, 22 Nov 2019 16:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfKVP6G (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 22 Nov 2019 10:58:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48756 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfKVP6G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 10:58:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMFsInd187990;
        Fri, 22 Nov 2019 15:57:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=OA5HdT8ZzPDQYDr49dYGi4BGkVnCAlwxYbkx61AXkcQ=;
 b=grJhhpkleDWfhG70mlhVQfcvVEdzpplkykfdbrEwqKtbGm1koKtzkE+FoS8hXq2hIloD
 ufzPRqIYSUqoPaVBTPi9HOEb9O7NJIKKvPbtqwRdaepzUg2efGIQIXTYN/qVauwZvjy8
 eh/mhQyse/eL/t+5Oqy/e+5WFa96jYgJ0SpDrHZcjiFCtcILPFvgMXJ/9Dvt1f5P8z5o
 kypH48ziCAL0mdBMu+BT31zqu/gcFVhdjrXxLq2/Oi92O+TyYUvSNuLyx8fDJBRH0Lam
 Pd/d1RH9zvpoPWU0fyEmSeAehhpa5Xws3wriYzdpwnlwmM1mj/xJ08rmrg82Py2tZSRA iQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wa92qbeuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 15:57:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMFqsDd013016;
        Fri, 22 Nov 2019 15:57:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2we8yg2rc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 15:57:58 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAMFvv0f007400;
        Fri, 22 Nov 2019 15:57:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Nov 2019 07:57:57 -0800
Date:   Fri, 22 Nov 2019 07:57:56 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: Convert kmem_alloc() users
Message-ID: <20191122155756.GE6219@magnolia>
References: <20191120104425.407213-1-cmaiolino@redhat.com>
 <20191120104425.407213-6-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120104425.407213-6-cmaiolino@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911220136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911220136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 11:44:25AM +0100, Carlos Maiolino wrote:
> Use kmalloc() directly.
> 
> There is no logic change on kmem_alloc() since it's being removed soon, but for
> now, kmem_alloc_io() and kmem_alloc_large() still have use for kmem_alloc() due
> their fallback to vmalloc() and also the alignment check, so we can't completely
> remove it here.
> But, there is no need to export kmem_alloc() to the whole XFS driver anymore, so,
> convert kmem_alloc() into a static, local function __kmem_alloc().
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> V2:
> 	- Rephrase commit log
> 
>  fs/xfs/kmem.c                  |  8 ++++----
>  fs/xfs/kmem.h                  |  1 -
>  fs/xfs/libxfs/xfs_attr_leaf.c  |  6 +++---
>  fs/xfs/libxfs/xfs_bmap.c       |  2 +-
>  fs/xfs/libxfs/xfs_da_btree.c   |  4 +++-
>  fs/xfs/libxfs/xfs_defer.c      |  4 ++--
>  fs/xfs/libxfs/xfs_dir2.c       |  2 +-
>  fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
>  fs/xfs/libxfs/xfs_dir2_sf.c    |  8 ++++----
>  fs/xfs/libxfs/xfs_inode_fork.c | 10 ++++++----
>  fs/xfs/libxfs/xfs_refcount.c   |  9 +++++----
>  fs/xfs/libxfs/xfs_rmap.c       |  2 +-
>  fs/xfs/scrub/bitmap.c          |  7 ++++---
>  fs/xfs/scrub/btree.c           |  4 ++--
>  fs/xfs/scrub/refcount.c        |  4 ++--
>  fs/xfs/xfs_attr_inactive.c     |  2 +-
>  fs/xfs/xfs_attr_list.c         |  2 +-
>  fs/xfs/xfs_buf.c               |  5 +++--
>  fs/xfs/xfs_filestream.c        |  2 +-
>  fs/xfs/xfs_inode.c             |  2 +-
>  fs/xfs/xfs_iwalk.c             |  2 +-
>  fs/xfs/xfs_log_recover.c       |  7 ++++---
>  fs/xfs/xfs_qm.c                |  3 ++-
>  fs/xfs/xfs_rtalloc.c           |  2 +-
>  fs/xfs/xfs_super.c             |  2 +-
>  25 files changed, 55 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index 6e10e565632c..79467813d810 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -8,8 +8,8 @@
>  #include "xfs_message.h"
>  #include "xfs_trace.h"
>  
> -void *
> -kmem_alloc(size_t size, xfs_km_flags_t flags)
> +static void *
> +__kmem_alloc(size_t size, xfs_km_flags_t flags)
>  {
>  	int	retries = 0;
>  	gfp_t	lflags = kmem_flags_convert(flags);
> @@ -72,7 +72,7 @@ kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags)
>  	if (WARN_ON_ONCE(align_mask >= PAGE_SIZE))
>  		align_mask = PAGE_SIZE - 1;
>  
> -	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
> +	ptr = __kmem_alloc(size, flags | KM_MAYFAIL);
>  	if (ptr) {
>  		if (!((uintptr_t)ptr & align_mask))
>  			return ptr;
> @@ -88,7 +88,7 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
>  
>  	trace_kmem_alloc_large(size, flags, _RET_IP_);
>  
> -	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
> +	ptr = __kmem_alloc(size, flags | KM_MAYFAIL);
>  	if (ptr)
>  		return ptr;
>  	return __kmem_vmalloc(size, flags);
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index a18c27c99721..78a54839430a 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -52,7 +52,6 @@ kmem_flags_convert(xfs_km_flags_t flags)
>  	return lflags;
>  }
>  
> -extern void *kmem_alloc(size_t, xfs_km_flags_t);
>  extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags);
>  extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 67de68584224..807950eca17a 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -885,7 +885,7 @@ xfs_attr_shortform_to_leaf(
>  	ifp = dp->i_afp;
>  	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
>  	size = be16_to_cpu(sf->hdr.totsize);
> -	tmpbuffer = kmem_alloc(size, 0);
> +	tmpbuffer = kmalloc(size, GFP_KERNEL | __GFP_NOFAIL);
>  	ASSERT(tmpbuffer != NULL);
>  	memcpy(tmpbuffer, ifp->if_u1.if_data, size);
>  	sf = (xfs_attr_shortform_t *)tmpbuffer;
> @@ -1073,7 +1073,7 @@ xfs_attr3_leaf_to_shortform(
>  
>  	trace_xfs_attr_leaf_to_sf(args);
>  
> -	tmpbuffer = kmem_alloc(args->geo->blksize, 0);
> +	tmpbuffer = kmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
>  	if (!tmpbuffer)
>  		return -ENOMEM;
>  
> @@ -1534,7 +1534,7 @@ xfs_attr3_leaf_compact(
>  
>  	trace_xfs_attr_leaf_compact(args);
>  
> -	tmpbuffer = kmem_alloc(args->geo->blksize, 0);
> +	tmpbuffer = kmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(tmpbuffer, bp->b_addr, args->geo->blksize);
>  	memset(bp->b_addr, 0, args->geo->blksize);
>  	leaf_src = (xfs_attr_leafblock_t *)tmpbuffer;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 37596e49b92e..fc5bed95bd44 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6045,7 +6045,7 @@ __xfs_bmap_add(
>  			bmap->br_blockcount,
>  			bmap->br_state);
>  
> -	bi = kmem_alloc(sizeof(struct xfs_bmap_intent), KM_NOFS);
> +	bi = kmalloc(sizeof(struct xfs_bmap_intent), GFP_NOFS | __GFP_NOFAIL);
>  	INIT_LIST_HEAD(&bi->bi_list);
>  	bi->bi_type = type;
>  	bi->bi_owner = ip;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 29c25d1b3b76..efe84c636bd3 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2152,7 +2152,9 @@ xfs_da_grow_inode_int(
>  		 * If we didn't get it and the block might work if fragmented,
>  		 * try without the CONTIG flag.  Loop until we get it all.
>  		 */
> -		mapp = kmem_alloc(sizeof(*mapp) * count, 0);
> +		mapp = kmalloc(sizeof(*mapp) * count,
> +			       GFP_KERNEL | __GFP_NOFAIL);
> +
>  		for (b = *bno, mapi = 0; b < *bno + count; ) {
>  			nmap = min(XFS_BMAP_MAX_NMAP, count);
>  			c = (int)(*bno + count - b);
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 27c3d150068a..7dd16f208b82 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -516,8 +516,8 @@ xfs_defer_add(
>  			dfp = NULL;
>  	}
>  	if (!dfp) {
> -		dfp = kmem_alloc(sizeof(struct xfs_defer_pending),
> -				KM_NOFS);
> +		dfp = kmalloc(sizeof(struct xfs_defer_pending),
> +			      GFP_NOFS | __GFP_NOFAIL);
>  		dfp->dfp_type = type;
>  		dfp->dfp_intent = NULL;
>  		dfp->dfp_done = NULL;
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index c2deda036271..4777356b4f83 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -331,7 +331,7 @@ xfs_dir_cilookup_result(
>  					!(args->op_flags & XFS_DA_OP_CILOOKUP))
>  		return -EEXIST;
>  
> -	args->value = kmem_alloc(len, KM_NOFS | KM_MAYFAIL);
> +	args->value = kmalloc(len, GFP_NOFS | __GFP_RETRY_MAYFAIL);
>  	if (!args->value)
>  		return -ENOMEM;
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 766f282b706a..54ae07a432e4 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1083,7 +1083,7 @@ xfs_dir2_sf_to_block(
>  	 * Copy the directory into a temporary buffer.
>  	 * Then pitch the incore inode data so we can make extents.
>  	 */
> -	sfp = kmem_alloc(ifp->if_bytes, 0);
> +	sfp = kmalloc(ifp->if_bytes, GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(sfp, oldsfp, ifp->if_bytes);
>  
>  	xfs_idata_realloc(dp, -ifp->if_bytes, XFS_DATA_FORK);
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index f4de4e7b10ef..43d72aebb9cf 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -276,7 +276,7 @@ xfs_dir2_block_to_sf(
>  	 * format the data into.  Once we have formatted the data, we can free
>  	 * the block and copy the formatted data into the inode literal area.
>  	 */
> -	sfp = kmem_alloc(mp->m_sb.sb_inodesize, 0);
> +	sfp = kmalloc(mp->m_sb.sb_inodesize, GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(sfp, sfhp, xfs_dir2_sf_hdr_size(sfhp->i8count));
>  
>  	/*
> @@ -530,7 +530,7 @@ xfs_dir2_sf_addname_hard(
>  	 */
>  	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
>  	old_isize = (int)dp->i_d.di_size;
> -	buf = kmem_alloc(old_isize, 0);
> +	buf = kmalloc(old_isize, GFP_KERNEL | __GFP_NOFAIL);
>  	oldsfp = (xfs_dir2_sf_hdr_t *)buf;
>  	memcpy(oldsfp, sfp, old_isize);
>  	/*
> @@ -1162,7 +1162,7 @@ xfs_dir2_sf_toino4(
>  	 * Don't want xfs_idata_realloc copying the data here.
>  	 */
>  	oldsize = dp->i_df.if_bytes;
> -	buf = kmem_alloc(oldsize, 0);
> +	buf = kmalloc(oldsize, GFP_KERNEL | __GFP_NOFAIL);
>  	oldsfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
>  	ASSERT(oldsfp->i8count == 1);
>  	memcpy(buf, oldsfp, oldsize);
> @@ -1235,7 +1235,7 @@ xfs_dir2_sf_toino8(
>  	 * Don't want xfs_idata_realloc copying the data here.
>  	 */
>  	oldsize = dp->i_df.if_bytes;
> -	buf = kmem_alloc(oldsize, 0);
> +	buf = kmalloc(oldsize, GFP_KERNEL | __GFP_NOFAIL);
>  	oldsfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
>  	ASSERT(oldsfp->i8count == 0);
>  	memcpy(buf, oldsfp, oldsize);
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 82799dddf97d..62c305654657 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -153,7 +153,8 @@ xfs_init_local_fork(
>  
>  	if (size) {
>  		real_size = roundup(mem_size, 4);
> -		ifp->if_u1.if_data = kmem_alloc(real_size, KM_NOFS);
> +		ifp->if_u1.if_data = kmalloc(real_size,
> +					     GFP_NOFS | __GFP_NOFAIL);
>  		memcpy(ifp->if_u1.if_data, data, size);
>  		if (zero_terminate)
>  			ifp->if_u1.if_data[size] = '\0';
> @@ -308,7 +309,7 @@ xfs_iformat_btree(
>  	}
>  
>  	ifp->if_broot_bytes = size;
> -	ifp->if_broot = kmem_alloc(size, KM_NOFS);
> +	ifp->if_broot = kmalloc(size, GFP_NOFS | __GFP_NOFAIL);
>  	ASSERT(ifp->if_broot != NULL);
>  	/*
>  	 * Copy and convert from the on-disk structure
> @@ -373,7 +374,8 @@ xfs_iroot_realloc(
>  		 */
>  		if (ifp->if_broot_bytes == 0) {
>  			new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
> -			ifp->if_broot = kmem_alloc(new_size, KM_NOFS);
> +			ifp->if_broot = kmalloc(new_size,
> +						GFP_NOFS | __GFP_NOFAIL);
>  			ifp->if_broot_bytes = (int)new_size;
>  			return;
>  		}
> @@ -414,7 +416,7 @@ xfs_iroot_realloc(
>  	else
>  		new_size = 0;
>  	if (new_size > 0) {
> -		new_broot = kmem_alloc(new_size, KM_NOFS);
> +		new_broot = kmalloc(new_size, GFP_NOFS | __GFP_NOFAIL);
>  		/*
>  		 * First copy over the btree block header.
>  		 */
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 07894c53e753..6a89443da50a 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1188,8 +1188,8 @@ __xfs_refcount_add(
>  			type, XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
>  			blockcount);
>  
> -	ri = kmem_alloc(sizeof(struct xfs_refcount_intent),
> -			KM_NOFS);
> +	ri = kmalloc(sizeof(struct xfs_refcount_intent),
> +		     GFP_NOFS | __GFP_NOFAIL);
>  	INIT_LIST_HEAD(&ri->ri_list);
>  	ri->ri_type = type;
>  	ri->ri_startblock = startblock;
> @@ -1584,7 +1584,7 @@ struct xfs_refcount_recovery {
>  /* Stuff an extent on the recovery list. */
>  STATIC int
>  xfs_refcount_recover_extent(
> -	struct xfs_btree_cur 		*cur,
> +	struct xfs_btree_cur		*cur,
>  	union xfs_btree_rec		*rec,
>  	void				*priv)
>  {
> @@ -1596,7 +1596,8 @@ xfs_refcount_recover_extent(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	rr = kmem_alloc(sizeof(struct xfs_refcount_recovery), 0);
> +	rr = kmalloc(sizeof(struct xfs_refcount_recovery),
> +		     GFP_KERNEL | __GFP_NOFAIL);
>  	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
>  	list_add_tail(&rr->rr_list, debris);
>  
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 38e9414878b3..0e1e8cbb8862 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -2286,7 +2286,7 @@ __xfs_rmap_add(
>  			bmap->br_blockcount,
>  			bmap->br_state);
>  
> -	ri = kmem_alloc(sizeof(struct xfs_rmap_intent), KM_NOFS);
> +	ri = kmalloc(sizeof(struct xfs_rmap_intent), GFP_NOFS | __GFP_NOFAIL);
>  	INIT_LIST_HEAD(&ri->ri_list);
>  	ri->ri_type = type;
>  	ri->ri_owner = owner;
> diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
> index cabde1c4c235..5787d4f74e71 100644
> --- a/fs/xfs/scrub/bitmap.c
> +++ b/fs/xfs/scrub/bitmap.c
> @@ -25,7 +25,8 @@ xfs_bitmap_set(
>  {
>  	struct xfs_bitmap_range	*bmr;
>  
> -	bmr = kmem_alloc(sizeof(struct xfs_bitmap_range), KM_MAYFAIL);
> +	bmr = kmalloc(sizeof(struct xfs_bitmap_range),
> +		      GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (!bmr)
>  		return -ENOMEM;
>  
> @@ -181,8 +182,8 @@ xfs_bitmap_disunion(
>  			 * Deleting from the middle: add the new right extent
>  			 * and then shrink the left extent.
>  			 */
> -			new_br = kmem_alloc(sizeof(struct xfs_bitmap_range),
> -					KM_MAYFAIL);
> +			new_br = kmalloc(sizeof(struct xfs_bitmap_range),
> +					 GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  			if (!new_br) {
>  				error = -ENOMEM;
>  				goto out;
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index bed40b605076..857f813681ed 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -429,8 +429,8 @@ xchk_btree_check_owner(
>  	 * later scanning.
>  	 */
>  	if (cur->bc_btnum == XFS_BTNUM_BNO || cur->bc_btnum == XFS_BTNUM_RMAP) {
> -		co = kmem_alloc(sizeof(struct check_owner),
> -				KM_MAYFAIL);
> +		co = kmalloc(sizeof(struct check_owner),
> +			     GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  		if (!co)
>  			return -ENOMEM;
>  		co->level = level;
> diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> index 985724e81ebf..f5c2e320e416 100644
> --- a/fs/xfs/scrub/refcount.c
> +++ b/fs/xfs/scrub/refcount.c
> @@ -125,8 +125,8 @@ xchk_refcountbt_rmap_check(
>  		 * is healthy each rmap_irec we see will be in agbno order
>  		 * so we don't need insertion sort here.
>  		 */
> -		frag = kmem_alloc(sizeof(struct xchk_refcnt_frag),
> -				KM_MAYFAIL);
> +		frag = kmalloc(sizeof(struct xchk_refcnt_frag),
> +			       GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  		if (!frag)
>  			return -ENOMEM;
>  		memcpy(&frag->rm, rec, sizeof(frag->rm));
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index 8351b3b611ac..42d7d8cbdb6e 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -148,7 +148,7 @@ xfs_attr3_leaf_inactive(
>  	 * Allocate storage for a list of all the "remote" value extents.
>  	 */
>  	size = count * sizeof(xfs_attr_inactive_list_t);
> -	list = kmem_alloc(size, 0);
> +	list = kmalloc(size, GFP_KERNEL | __GFP_NOFAIL);
>  
>  	/*
>  	 * Identify each of the "remote" value extents.
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index e1d1c4eb9e69..2a475ca6e353 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -116,7 +116,7 @@ xfs_attr_shortform_list(
>  	 * It didn't all fit, so we have to sort everything on hashval.
>  	 */
>  	sbsize = sf->hdr.count * sizeof(*sbuf);
> -	sbp = sbuf = kmem_alloc(sbsize, KM_NOFS);
> +	sbp = sbuf = kmalloc(sbsize, GFP_NOFS | __GFP_NOFAIL);
>  
>  	/*
>  	 * Scan the attribute list for the rest of the entries, storing
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index c70122fbc2a8..7428fe6a322c 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -274,8 +274,9 @@ _xfs_buf_get_pages(
>  		if (page_count <= XB_PAGES) {
>  			bp->b_pages = bp->b_page_array;
>  		} else {
> -			bp->b_pages = kmem_alloc(sizeof(struct page *) *
> -						 page_count, KM_NOFS);
> +			bp->b_pages = kmalloc(sizeof(struct page *) *
> +					      page_count,
> +					      GFP_NOFS | __GFP_NOFAIL);
>  			if (bp->b_pages == NULL)
>  				return -ENOMEM;
>  		}
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 9778e4e69e07..38b634cef1ed 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -247,7 +247,7 @@ xfs_filestream_pick_ag(
>  		return 0;
>  
>  	err = -ENOMEM;
> -	item = kmem_alloc(sizeof(*item), KM_MAYFAIL);
> +	item = kmalloc(sizeof(*item), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (!item)
>  		goto out_put_ag;
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 297b2a73f285..1d1fe67ad237 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3493,7 +3493,7 @@ xfs_iflush_cluster(
>  	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
>  
>  	cilist_size = igeo->inodes_per_cluster * sizeof(struct xfs_inode *);
> -	cilist = kmem_alloc(cilist_size, KM_MAYFAIL|KM_NOFS);
> +	cilist = kmalloc(cilist_size, GFP_NOFS | __GFP_RETRY_MAYFAIL);
>  	if (!cilist)
>  		goto out_put;
>  
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index e6006423e140..aa6bc0555d21 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -152,7 +152,7 @@ xfs_iwalk_alloc(
>  
>  	/* Allocate a prefetch buffer for inobt records. */
>  	size = iwag->sz_recs * sizeof(struct xfs_inobt_rec_incore);
> -	iwag->recs = kmem_alloc(size, KM_MAYFAIL);
> +	iwag->recs = kmalloc(size, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (iwag->recs == NULL)
>  		return -ENOMEM;
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 5423171e0b7d..7bb53fbf32f6 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1962,7 +1962,7 @@ xlog_recover_buffer_pass1(
>  		}
>  	}
>  
> -	bcp = kmem_alloc(sizeof(struct xfs_buf_cancel), 0);
> +	bcp = kmalloc(sizeof(struct xfs_buf_cancel), GFP_KERNEL | __GFP_NOFAIL);
>  	bcp->bc_blkno = buf_f->blf_blkno;
>  	bcp->bc_len = buf_f->blf_len;
>  	bcp->bc_refcount = 1;
> @@ -2932,7 +2932,8 @@ xlog_recover_inode_pass2(
>  	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
>  		in_f = item->ri_buf[0].i_addr;
>  	} else {
> -		in_f = kmem_alloc(sizeof(struct xfs_inode_log_format), 0);
> +		in_f = kmalloc(sizeof(struct xfs_inode_log_format),
> +			       GFP_KERNEL | __GFP_NOFAIL);
>  		need_free = 1;
>  		error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
>  		if (error)
> @@ -4271,7 +4272,7 @@ xlog_recover_add_to_trans(
>  		return 0;
>  	}
>  
> -	ptr = kmem_alloc(len, 0);
> +	ptr = kmalloc(len, GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(ptr, dp, len);
>  	in_f = (struct xfs_inode_log_format *)ptr;

I noticed that kmalloc is generating warnings with generic/049 when 16k
directories (-n size=16k) are enabled.  I /think/ this is because it's
quite possible to write out an xlog_op_header with a length of more than
a single page; log recovery will then try to allocate a huge memory
buffer to recover the transaction; and so we try to do a huge NOFAIL
allocation, which makes the mm unhappy.

The one thing I've noticed with this conversion series is that the flags
translation isn't 100% 1-to-1.  Before, kmem_flags_convert didn't
explicitly set __GFP_NOFAIL anywhere; we simply took the default
behavior.  IIRC that means that small allocations actually /are/
guaranteed to succeed, but multipage allocations certainly aren't.
This seems to be one place where we could have asked for a lot of
memory, failed to get it, and crashed.

Now that we explicitly set NOFAIL in all the places where we don't also
check for a null return, I think we're just uncovering latent bugs
lurking in the code base.  The kernel does actually fulfill the
allocation request, but it's clearly not happy.

--D

Relevant snippet of dmesg; everything else was normal:

 XFS (sdd): Mounting V5 Filesystem
 XFS (sdd): Starting recovery (logdev: internal)
 ------------[ cut here ]------------
 WARNING: CPU: 1 PID: 459342 at mm/page_alloc.c:3275 get_page_from_freelist+0x434/0x1660
 Modules linked in: dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio dm_flakey xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 ip_set_hash_ip ip_set_hash_net xt_tcpudp xt_set ip_set_hash_mac bfq ip_set nfnetlink ip6table_filter ip6_tables iptable_filter sch_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: scsi_debug]
 CPU: 1 PID: 459342 Comm: mount Not tainted 5.4.0-rc3-djw #rc3
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
 RIP: 0010:get_page_from_freelist+0x434/0x1660
 Code: e6 00 00 00 00 48 89 84 24 a0 00 00 00 0f 84 08 fd ff ff f7 84 24 c0 00 00 00 00 80 00 00 74 0c 83 bc 24 84 00 00 00 01 76 02 <0f> 0b 49 8d 87 10 05 00 00 48 89 c7 48 89 84 24 88 00 00 00 e8 03
 RSP: 0018:ffffc900035d3918 EFLAGS: 00010202
 RAX: ffff88803fffb680 RBX: 0000000000002968 RCX: ffffea0000c8e108
 RDX: ffff88803fffbba8 RSI: ffff88803fffb870 RDI: 0000000000000000
 RBP: 0000000000000002 R08: 0000000000000201 R09: 000000000002ff81
 R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
 R13: 0000000000048cc0 R14: 0000000000000001 R15: ffff88803fffb680
 FS:  00007fcfdf89a080(0000) GS:ffff88803ea00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055b202ec48c8 CR3: 000000003bfdc005 CR4: 00000000001606a0
 Call Trace:
  ? kvm_clock_read+0x14/0x30
  __alloc_pages_nodemask+0x172/0x3a0
  kmalloc_order+0x18/0x80
  kmalloc_order_trace+0x1d/0x130
  xlog_recover_add_to_trans+0x4b/0x340 [xfs]
  xlog_recovery_process_trans+0xe9/0xf0 [xfs]
  xlog_recover_process_data+0x9e/0x1f0 [xfs]
  xlog_do_recovery_pass+0x3a9/0x7c0 [xfs]
  xlog_do_log_recovery+0x72/0x150 [xfs]
  xlog_do_recover+0x43/0x2a0 [xfs]
  xlog_recover+0xdf/0x170 [xfs]
  xfs_log_mount+0x2e3/0x300 [xfs]
  xfs_mountfs+0x4e7/0x9f0 [xfs]
  xfs_fc_fill_super+0x2f8/0x520 [xfs]
  ? xfs_fs_destroy_inode+0x4f0/0x4f0 [xfs]
  get_tree_bdev+0x198/0x270
  vfs_get_tree+0x23/0xb0
  do_mount+0x87e/0xa20
  ksys_mount+0xb6/0xd0
  __x64_sys_mount+0x21/0x30
  do_syscall_64+0x50/0x180
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
 RIP: 0033:0x7fcfdf15d3ca
 Code: 48 8b 0d c1 8a 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8e 8a 2c 00 f7 d8 64 89 01 48
 RSP: 002b:00007fff0af10a58 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
 RAX: ffffffffffffffda RBX: 000055b202ec1970 RCX: 00007fcfdf15d3ca
 RDX: 000055b202ec1be0 RSI: 000055b202ec1c20 RDI: 000055b202ec1c00
 RBP: 0000000000000000 R08: 000055b202ec1b80 R09: 0000000000000000
 R10: 00000000c0ed0000 R11: 0000000000000202 R12: 000055b202ec1c00
 R13: 000055b202ec1be0 R14: 0000000000000000 R15: 00007fcfdf67e8a4
 irq event stamp: 18398
 hardirqs last  enabled at (18397): [<ffffffff8123738f>] __slab_alloc.isra.83+0x6f/0x80
 hardirqs last disabled at (18398): [<ffffffff81001d8a>] trace_hardirqs_off_thunk+0x1a/0x20
 softirqs last  enabled at (18158): [<ffffffff81a003af>] __do_softirq+0x3af/0x4a4
 softirqs last disabled at (18149): [<ffffffff8106528c>] irq_exit+0xbc/0xe0
 ---[ end trace 3669c914fa8ccac6 ]---

AFAICT this is because inode buffers are 32K on this system

>  
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index a2664afa10c3..2993af4a9935 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -988,7 +988,8 @@ xfs_qm_reset_dqcounts_buf(
>  	if (qip->i_d.di_nblocks == 0)
>  		return 0;
>  
> -	map = kmem_alloc(XFS_DQITER_MAP_SIZE * sizeof(*map), 0);
> +	map = kmalloc(XFS_DQITER_MAP_SIZE * sizeof(*map),
> +		      GFP_KERNEL | __GFP_NOFAIL);
>  
>  	lblkno = 0;
>  	maxlblkcnt = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 7f03b4ab3452..dfd419d402ea 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -962,7 +962,7 @@ xfs_growfs_rt(
>  	/*
>  	 * Allocate a new (fake) mount/sb.
>  	 */
> -	nmp = kmem_alloc(sizeof(*nmp), 0);
> +	nmp = kmalloc(sizeof(*nmp), GFP_KERNEL | __GFP_NOFAIL);
>  	/*
>  	 * Loop over the bitmap blocks.
>  	 * We will do everything one bitmap block at a time.
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index cc1933dc652f..eee831681e9c 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1739,7 +1739,7 @@ static int xfs_init_fs_context(
>  {
>  	struct xfs_mount	*mp;
>  
> -	mp = kmem_alloc(sizeof(struct xfs_mount), KM_ZERO);
> +	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL | __GFP_NOFAIL);
>  	if (!mp)
>  		return -ENOMEM;
>  
> -- 
> 2.23.0
> 
