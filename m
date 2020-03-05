Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B37179DDB
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Mar 2020 03:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgCECbx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Mar 2020 21:31:53 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37542 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgCECbx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 21:31:53 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0252NdCM022495;
        Thu, 5 Mar 2020 02:31:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=MREw4bGFAzWiCHJlJZ4RsBqXa9ItQhfIsddI+3Vyqoo=;
 b=rsTDpl43/BcnIYjpV86dm5ueW0aeXfbIr56ydr7sOjuYh5xmxcxYdgiv7fzSlfYwcmq1
 RmXem6egEWkKzQlIwUQZ+VUeeXggIGOdMnu/w6hK4H9FIqyxgj1kswAk+0mW/Vs2GCRW
 FsJ9BVWnhQ/6GtdejkAkorolwlCoNLegvPru697YemUx3iotVRGuVqi/+EueL6f1bu8g
 jdQL3HFzEQRstXdY1sCflcsLeeIc9t1HCRckYncKlASOR7YfOCNl9z6vqd+Nf0y3S1m9
 qt5yVhAyx2cJKDLzINkA+ioAHZZdtovdmcJ3NaN5ulZKrvyfFa/0l/P/kDSMyJ1V8ngG HA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yghn3e3yw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Mar 2020 02:31:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0252N6OW057793;
        Thu, 5 Mar 2020 02:31:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2yg1h2977r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Mar 2020 02:31:43 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0252VgPM020133;
        Thu, 5 Mar 2020 02:31:42 GMT
Received: from localhost (/10.159.138.101)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Mar 2020 18:31:42 -0800
Date:   Wed, 4 Mar 2020 18:31:41 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: convert btree cursor ag private member name
Message-ID: <20200305023141.GQ8045@magnolia>
References: <20200305014537.11236-1-david@fromorbit.com>
 <20200305014537.11236-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305014537.11236-3-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9550 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=2 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003050010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9550 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003050010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 05, 2020 at 12:45:32PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> bc_private.a -> bc_ag conversion via script:
> 
> `sed -i 's/bc_private\.a/bc_ag/g' fs/xfs/*[ch] fs/xfs/*/*[ch]`

Just out of curiosity, does the following cocci script do this more
cleanly:

@@
expression cur
@@

- cur->bc_private.a
+ cur->bc_ag

<EOF>

Coccinelle does know how to do some kernel-style cleanups of the lines
it touches, though I admit that the spatch format is /really/ hard to
understand (and I barely grok it).  When it works, it's a wonderful
refactoring tool.

--D

> And then revert the change to the bc_ag #define in
> fs/xfs/libxfs/xfs_btree.h manually.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c          |  16 ++---
>  fs/xfs/libxfs/xfs_alloc_btree.c    |  24 +++----
>  fs/xfs/libxfs/xfs_btree.c          |  12 ++--
>  fs/xfs/libxfs/xfs_ialloc.c         |   2 +-
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |  20 +++---
>  fs/xfs/libxfs/xfs_refcount.c       | 110 ++++++++++++++---------------
>  fs/xfs/libxfs/xfs_refcount_btree.c |  28 ++++----
>  fs/xfs/libxfs/xfs_rmap.c           | 110 ++++++++++++++---------------
>  fs/xfs/libxfs/xfs_rmap_btree.c     |  28 ++++----
>  fs/xfs/scrub/agheader_repair.c     |   2 +-
>  fs/xfs/scrub/alloc.c               |   2 +-
>  fs/xfs/scrub/bmap.c                |   2 +-
>  fs/xfs/scrub/ialloc.c              |   8 +--
>  fs/xfs/scrub/refcount.c            |   2 +-
>  fs/xfs/scrub/rmap.c                |   2 +-
>  fs/xfs/scrub/trace.c               |   2 +-
>  fs/xfs/xfs_fsmap.c                 |   4 +-
>  17 files changed, 187 insertions(+), 187 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index d8053bc96c4d..0e9dea73980a 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -151,7 +151,7 @@ xfs_alloc_lookup_eq(
>  	cur->bc_rec.a.ar_startblock = bno;
>  	cur->bc_rec.a.ar_blockcount = len;
>  	error = xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
> -	cur->bc_private.a.priv.abt.active = (*stat == 1);
> +	cur->bc_ag.priv.abt.active = (*stat == 1);
>  	return error;
>  }
>  
> @@ -171,7 +171,7 @@ xfs_alloc_lookup_ge(
>  	cur->bc_rec.a.ar_startblock = bno;
>  	cur->bc_rec.a.ar_blockcount = len;
>  	error = xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
> -	cur->bc_private.a.priv.abt.active = (*stat == 1);
> +	cur->bc_ag.priv.abt.active = (*stat == 1);
>  	return error;
>  }
>  
> @@ -190,7 +190,7 @@ xfs_alloc_lookup_le(
>  	cur->bc_rec.a.ar_startblock = bno;
>  	cur->bc_rec.a.ar_blockcount = len;
>  	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
> -	cur->bc_private.a.priv.abt.active = (*stat == 1);
> +	cur->bc_ag.priv.abt.active = (*stat == 1);
>  	return error;
>  }
>  
> @@ -198,7 +198,7 @@ static inline bool
>  xfs_alloc_cur_active(
>  	struct xfs_btree_cur	*cur)
>  {
> -	return cur && cur->bc_private.a.priv.abt.active;
> +	return cur && cur->bc_ag.priv.abt.active;
>  }
>  
>  /*
> @@ -230,7 +230,7 @@ xfs_alloc_get_rec(
>  	int			*stat)	/* output: success/failure */
>  {
>  	struct xfs_mount	*mp = cur->bc_mp;
> -	xfs_agnumber_t		agno = cur->bc_private.a.agno;
> +	xfs_agnumber_t		agno = cur->bc_ag.agno;
>  	union xfs_btree_rec	*rec;
>  	int			error;
>  
> @@ -907,7 +907,7 @@ xfs_alloc_cur_check(
>  		deactivate = true;
>  out:
>  	if (deactivate)
> -		cur->bc_private.a.priv.abt.active = false;
> +		cur->bc_ag.priv.abt.active = false;
>  	trace_xfs_alloc_cur_check(args->mp, cur->bc_btnum, bno, len, diff,
>  				  *new);
>  	return 0;
> @@ -1353,7 +1353,7 @@ xfs_alloc_walk_iter(
>  		if (error)
>  			return error;
>  		if (i == 0)
> -			cur->bc_private.a.priv.abt.active = false;
> +			cur->bc_ag.priv.abt.active = false;
>  
>  		if (count > 0)
>  			count--;
> @@ -1468,7 +1468,7 @@ xfs_alloc_ag_vextent_locality(
>  		if (error)
>  			return error;
>  		if (i) {
> -			acur->cnt->bc_private.a.priv.abt.active = true;
> +			acur->cnt->bc_ag.priv.abt.active = true;
>  			fbcur = acur->cnt;
>  			fbinc = false;
>  		}
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 279694d73e4e..3bcfda4ca8e2 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -25,7 +25,7 @@ xfs_allocbt_dup_cursor(
>  	struct xfs_btree_cur	*cur)
>  {
>  	return xfs_allocbt_init_cursor(cur->bc_mp, cur->bc_tp,
> -			cur->bc_private.a.agbp, cur->bc_private.a.agno,
> +			cur->bc_ag.agbp, cur->bc_ag.agno,
>  			cur->bc_btnum);
>  }
>  
> @@ -35,7 +35,7 @@ xfs_allocbt_set_root(
>  	union xfs_btree_ptr	*ptr,
>  	int			inc)
>  {
> -	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> +	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
>  	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
>  	int			btnum = cur->bc_btnum;
> @@ -62,7 +62,7 @@ xfs_allocbt_alloc_block(
>  	xfs_agblock_t		bno;
>  
>  	/* Allocate the new block from the freelist. If we can't, give up.  */
> -	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
> +	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_ag.agbp,
>  				       &bno, 1);
>  	if (error)
>  		return error;
> @@ -72,7 +72,7 @@ xfs_allocbt_alloc_block(
>  		return 0;
>  	}
>  
> -	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_private.a.agno, bno, 1, false);
> +	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agno, bno, 1, false);
>  
>  	xfs_trans_agbtree_delta(cur->bc_tp, 1);
>  	new->s = cpu_to_be32(bno);
> @@ -86,7 +86,7 @@ xfs_allocbt_free_block(
>  	struct xfs_btree_cur	*cur,
>  	struct xfs_buf		*bp)
>  {
> -	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> +	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
>  	xfs_agblock_t		bno;
>  	int			error;
> @@ -113,7 +113,7 @@ xfs_allocbt_update_lastrec(
>  	int			ptr,
>  	int			reason)
>  {
> -	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
> +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_ag.agbp);
>  	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
>  	struct xfs_perag	*pag;
>  	__be32			len;
> @@ -162,7 +162,7 @@ xfs_allocbt_update_lastrec(
>  	pag = xfs_perag_get(cur->bc_mp, seqno);
>  	pag->pagf_longest = be32_to_cpu(len);
>  	xfs_perag_put(pag);
> -	xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp, XFS_AGF_LONGEST);
> +	xfs_alloc_log_agf(cur->bc_tp, cur->bc_ag.agbp, XFS_AGF_LONGEST);
>  }
>  
>  STATIC int
> @@ -226,9 +226,9 @@ xfs_allocbt_init_ptr_from_cur(
>  	struct xfs_btree_cur	*cur,
>  	union xfs_btree_ptr	*ptr)
>  {
> -	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
> +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_ag.agbp);
>  
> -	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
> +	ASSERT(cur->bc_ag.agno == be32_to_cpu(agf->agf_seqno));
>  
>  	ptr->s = agf->agf_roots[cur->bc_btnum];
>  }
> @@ -505,9 +505,9 @@ xfs_allocbt_init_cursor(
>  		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
>  	}
>  
> -	cur->bc_private.a.agbp = agbp;
> -	cur->bc_private.a.agno = agno;
> -	cur->bc_private.a.priv.abt.active = false;
> +	cur->bc_ag.agbp = agbp;
> +	cur->bc_ag.agno = agno;
> +	cur->bc_ag.priv.abt.active = false;
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb))
>  		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index fd300dc93ca4..2376e14b0c86 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -214,7 +214,7 @@ xfs_btree_check_sptr(
>  {
>  	if (level <= 0)
>  		return false;
> -	return xfs_verify_agbno(cur->bc_mp, cur->bc_private.a.agno, agbno);
> +	return xfs_verify_agbno(cur->bc_mp, cur->bc_ag.agno, agbno);
>  }
>  
>  /*
> @@ -243,7 +243,7 @@ xfs_btree_check_ptr(
>  			return 0;
>  		xfs_err(cur->bc_mp,
>  "AG %u: Corrupt btree %d pointer at level %d index %d.",
> -				cur->bc_private.a.agno, cur->bc_btnum,
> +				cur->bc_ag.agno, cur->bc_btnum,
>  				level, index);
>  	}
>  
> @@ -881,13 +881,13 @@ xfs_btree_readahead_sblock(
>  
>  
>  	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLAGBLOCK) {
> -		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
> +		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_ag.agno,
>  				     left, 1, cur->bc_ops->buf_ops);
>  		rval++;
>  	}
>  
>  	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLAGBLOCK) {
> -		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
> +		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_ag.agno,
>  				     right, 1, cur->bc_ops->buf_ops);
>  		rval++;
>  	}
> @@ -945,7 +945,7 @@ xfs_btree_ptr_to_daddr(
>  		*daddr = XFS_FSB_TO_DADDR(cur->bc_mp, fsbno);
>  	} else {
>  		agbno = be32_to_cpu(ptr->s);
> -		*daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
> +		*daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_ag.agno,
>  				agbno);
>  	}
>  
> @@ -1146,7 +1146,7 @@ xfs_btree_init_block_cur(
>  	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
>  		owner = cur->bc_private.b.ip->i_ino;
>  	else
> -		owner = cur->bc_private.a.agno;
> +		owner = cur->bc_ag.agno;
>  
>  	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), bp->b_bn,
>  				 cur->bc_btnum, level, numrecs,
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index bf161e930f1d..88233bd608d5 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -105,7 +105,7 @@ xfs_inobt_get_rec(
>  	int				*stat)
>  {
>  	struct xfs_mount		*mp = cur->bc_mp;
> -	xfs_agnumber_t			agno = cur->bc_private.a.agno;
> +	xfs_agnumber_t			agno = cur->bc_ag.agno;
>  	union xfs_btree_rec		*rec;
>  	int				error;
>  	uint64_t			realfree;
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index b82992f795aa..8e3331c8c053 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -34,7 +34,7 @@ xfs_inobt_dup_cursor(
>  	struct xfs_btree_cur	*cur)
>  {
>  	return xfs_inobt_init_cursor(cur->bc_mp, cur->bc_tp,
> -			cur->bc_private.a.agbp, cur->bc_private.a.agno,
> +			cur->bc_ag.agbp, cur->bc_ag.agno,
>  			cur->bc_btnum);
>  }
>  
> @@ -44,7 +44,7 @@ xfs_inobt_set_root(
>  	union xfs_btree_ptr	*nptr,
>  	int			inc)	/* level change */
>  {
> -	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> +	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
>  
>  	agi->agi_root = nptr->s;
> @@ -58,7 +58,7 @@ xfs_finobt_set_root(
>  	union xfs_btree_ptr	*nptr,
>  	int			inc)	/* level change */
>  {
> -	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> +	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
>  
>  	agi->agi_free_root = nptr->s;
> @@ -83,7 +83,7 @@ __xfs_inobt_alloc_block(
>  	args.tp = cur->bc_tp;
>  	args.mp = cur->bc_mp;
>  	args.oinfo = XFS_RMAP_OINFO_INOBT;
> -	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno, sbno);
> +	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_ag.agno, sbno);
>  	args.minlen = 1;
>  	args.maxlen = 1;
>  	args.prod = 1;
> @@ -212,9 +212,9 @@ xfs_inobt_init_ptr_from_cur(
>  	struct xfs_btree_cur	*cur,
>  	union xfs_btree_ptr	*ptr)
>  {
> -	struct xfs_agi		*agi = XFS_BUF_TO_AGI(cur->bc_private.a.agbp);
> +	struct xfs_agi		*agi = XFS_BUF_TO_AGI(cur->bc_ag.agbp);
>  
> -	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agi->agi_seqno));
> +	ASSERT(cur->bc_ag.agno == be32_to_cpu(agi->agi_seqno));
>  
>  	ptr->s = agi->agi_root;
>  }
> @@ -224,9 +224,9 @@ xfs_finobt_init_ptr_from_cur(
>  	struct xfs_btree_cur	*cur,
>  	union xfs_btree_ptr	*ptr)
>  {
> -	struct xfs_agi		*agi = XFS_BUF_TO_AGI(cur->bc_private.a.agbp);
> +	struct xfs_agi		*agi = XFS_BUF_TO_AGI(cur->bc_ag.agbp);
>  
> -	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agi->agi_seqno));
> +	ASSERT(cur->bc_ag.agno == be32_to_cpu(agi->agi_seqno));
>  	ptr->s = agi->agi_free_root;
>  }
>  
> @@ -433,8 +433,8 @@ xfs_inobt_init_cursor(
>  	if (xfs_sb_version_hascrc(&mp->m_sb))
>  		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
>  
> -	cur->bc_private.a.agbp = agbp;
> -	cur->bc_private.a.agno = agno;
> +	cur->bc_ag.agbp = agbp;
> +	cur->bc_ag.agno = agno;
>  
>  	return cur;
>  }
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 6e1665f2cb67..ef3e706f1d94 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -46,7 +46,7 @@ xfs_refcount_lookup_le(
>  	xfs_agblock_t		bno,
>  	int			*stat)
>  {
> -	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_private.a.agno, bno,
> +	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.agno, bno,
>  			XFS_LOOKUP_LE);
>  	cur->bc_rec.rc.rc_startblock = bno;
>  	cur->bc_rec.rc.rc_blockcount = 0;
> @@ -63,7 +63,7 @@ xfs_refcount_lookup_ge(
>  	xfs_agblock_t		bno,
>  	int			*stat)
>  {
> -	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_private.a.agno, bno,
> +	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.agno, bno,
>  			XFS_LOOKUP_GE);
>  	cur->bc_rec.rc.rc_startblock = bno;
>  	cur->bc_rec.rc.rc_blockcount = 0;
> @@ -80,7 +80,7 @@ xfs_refcount_lookup_eq(
>  	xfs_agblock_t		bno,
>  	int			*stat)
>  {
> -	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_private.a.agno, bno,
> +	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.agno, bno,
>  			XFS_LOOKUP_LE);
>  	cur->bc_rec.rc.rc_startblock = bno;
>  	cur->bc_rec.rc.rc_blockcount = 0;
> @@ -108,7 +108,7 @@ xfs_refcount_get_rec(
>  	int				*stat)
>  {
>  	struct xfs_mount		*mp = cur->bc_mp;
> -	xfs_agnumber_t			agno = cur->bc_private.a.agno;
> +	xfs_agnumber_t			agno = cur->bc_ag.agno;
>  	union xfs_btree_rec		*rec;
>  	int				error;
>  	xfs_agblock_t			realstart;
> @@ -119,7 +119,7 @@ xfs_refcount_get_rec(
>  
>  	xfs_refcount_btrec_to_irec(rec, irec);
>  
> -	agno = cur->bc_private.a.agno;
> +	agno = cur->bc_ag.agno;
>  	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
>  		goto out_bad_rec;
>  
> @@ -144,7 +144,7 @@ xfs_refcount_get_rec(
>  	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
>  		goto out_bad_rec;
>  
> -	trace_xfs_refcount_get(cur->bc_mp, cur->bc_private.a.agno, irec);
> +	trace_xfs_refcount_get(cur->bc_mp, cur->bc_ag.agno, irec);
>  	return 0;
>  
>  out_bad_rec:
> @@ -169,14 +169,14 @@ xfs_refcount_update(
>  	union xfs_btree_rec	rec;
>  	int			error;
>  
> -	trace_xfs_refcount_update(cur->bc_mp, cur->bc_private.a.agno, irec);
> +	trace_xfs_refcount_update(cur->bc_mp, cur->bc_ag.agno, irec);
>  	rec.refc.rc_startblock = cpu_to_be32(irec->rc_startblock);
>  	rec.refc.rc_blockcount = cpu_to_be32(irec->rc_blockcount);
>  	rec.refc.rc_refcount = cpu_to_be32(irec->rc_refcount);
>  	error = xfs_btree_update(cur, &rec);
>  	if (error)
>  		trace_xfs_refcount_update_error(cur->bc_mp,
> -				cur->bc_private.a.agno, error, _RET_IP_);
> +				cur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -193,7 +193,7 @@ xfs_refcount_insert(
>  {
>  	int				error;
>  
> -	trace_xfs_refcount_insert(cur->bc_mp, cur->bc_private.a.agno, irec);
> +	trace_xfs_refcount_insert(cur->bc_mp, cur->bc_ag.agno, irec);
>  	cur->bc_rec.rc.rc_startblock = irec->rc_startblock;
>  	cur->bc_rec.rc.rc_blockcount = irec->rc_blockcount;
>  	cur->bc_rec.rc.rc_refcount = irec->rc_refcount;
> @@ -208,7 +208,7 @@ xfs_refcount_insert(
>  out_error:
>  	if (error)
>  		trace_xfs_refcount_insert_error(cur->bc_mp,
> -				cur->bc_private.a.agno, error, _RET_IP_);
> +				cur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -234,7 +234,7 @@ xfs_refcount_delete(
>  		error = -EFSCORRUPTED;
>  		goto out_error;
>  	}
> -	trace_xfs_refcount_delete(cur->bc_mp, cur->bc_private.a.agno, &irec);
> +	trace_xfs_refcount_delete(cur->bc_mp, cur->bc_ag.agno, &irec);
>  	error = xfs_btree_delete(cur, i);
>  	if (XFS_IS_CORRUPT(cur->bc_mp, *i != 1)) {
>  		error = -EFSCORRUPTED;
> @@ -246,7 +246,7 @@ xfs_refcount_delete(
>  out_error:
>  	if (error)
>  		trace_xfs_refcount_delete_error(cur->bc_mp,
> -				cur->bc_private.a.agno, error, _RET_IP_);
> +				cur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -366,7 +366,7 @@ xfs_refcount_split_extent(
>  		return 0;
>  
>  	*shape_changed = true;
> -	trace_xfs_refcount_split_extent(cur->bc_mp, cur->bc_private.a.agno,
> +	trace_xfs_refcount_split_extent(cur->bc_mp, cur->bc_ag.agno,
>  			&rcext, agbno);
>  
>  	/* Establish the right extent. */
> @@ -391,7 +391,7 @@ xfs_refcount_split_extent(
>  
>  out_error:
>  	trace_xfs_refcount_split_extent_error(cur->bc_mp,
> -			cur->bc_private.a.agno, error, _RET_IP_);
> +			cur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -411,7 +411,7 @@ xfs_refcount_merge_center_extents(
>  	int				found_rec;
>  
>  	trace_xfs_refcount_merge_center_extents(cur->bc_mp,
> -			cur->bc_private.a.agno, left, center, right);
> +			cur->bc_ag.agno, left, center, right);
>  
>  	/*
>  	 * Make sure the center and right extents are not in the btree.
> @@ -468,7 +468,7 @@ xfs_refcount_merge_center_extents(
>  
>  out_error:
>  	trace_xfs_refcount_merge_center_extents_error(cur->bc_mp,
> -			cur->bc_private.a.agno, error, _RET_IP_);
> +			cur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -487,7 +487,7 @@ xfs_refcount_merge_left_extent(
>  	int				found_rec;
>  
>  	trace_xfs_refcount_merge_left_extent(cur->bc_mp,
> -			cur->bc_private.a.agno, left, cleft);
> +			cur->bc_ag.agno, left, cleft);
>  
>  	/* If the extent at agbno (cleft) wasn't synthesized, remove it. */
>  	if (cleft->rc_refcount > 1) {
> @@ -530,7 +530,7 @@ xfs_refcount_merge_left_extent(
>  
>  out_error:
>  	trace_xfs_refcount_merge_left_extent_error(cur->bc_mp,
> -			cur->bc_private.a.agno, error, _RET_IP_);
> +			cur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -548,7 +548,7 @@ xfs_refcount_merge_right_extent(
>  	int				found_rec;
>  
>  	trace_xfs_refcount_merge_right_extent(cur->bc_mp,
> -			cur->bc_private.a.agno, cright, right);
> +			cur->bc_ag.agno, cright, right);
>  
>  	/*
>  	 * If the extent ending at agbno+aglen (cright) wasn't synthesized,
> @@ -594,7 +594,7 @@ xfs_refcount_merge_right_extent(
>  
>  out_error:
>  	trace_xfs_refcount_merge_right_extent_error(cur->bc_mp,
> -			cur->bc_private.a.agno, error, _RET_IP_);
> +			cur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -679,13 +679,13 @@ xfs_refcount_find_left_extents(
>  		cleft->rc_blockcount = aglen;
>  		cleft->rc_refcount = 1;
>  	}
> -	trace_xfs_refcount_find_left_extent(cur->bc_mp, cur->bc_private.a.agno,
> +	trace_xfs_refcount_find_left_extent(cur->bc_mp, cur->bc_ag.agno,
>  			left, cleft, agbno);
>  	return error;
>  
>  out_error:
>  	trace_xfs_refcount_find_left_extent_error(cur->bc_mp,
> -			cur->bc_private.a.agno, error, _RET_IP_);
> +			cur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -768,13 +768,13 @@ xfs_refcount_find_right_extents(
>  		cright->rc_blockcount = aglen;
>  		cright->rc_refcount = 1;
>  	}
> -	trace_xfs_refcount_find_right_extent(cur->bc_mp, cur->bc_private.a.agno,
> +	trace_xfs_refcount_find_right_extent(cur->bc_mp, cur->bc_ag.agno,
>  			cright, right, agbno + aglen);
>  	return error;
>  
>  out_error:
>  	trace_xfs_refcount_find_right_extent_error(cur->bc_mp,
> -			cur->bc_private.a.agno, error, _RET_IP_);
> +			cur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -883,7 +883,7 @@ xfs_refcount_still_have_space(
>  {
>  	unsigned long			overhead;
>  
> -	overhead = cur->bc_private.a.priv.refc.shape_changes *
> +	overhead = cur->bc_ag.priv.refc.shape_changes *
>  			xfs_allocfree_log_count(cur->bc_mp, 1);
>  	overhead *= cur->bc_mp->m_sb.sb_blocksize;
>  
> @@ -891,17 +891,17 @@ xfs_refcount_still_have_space(
>  	 * Only allow 2 refcount extent updates per transaction if the
>  	 * refcount continue update "error" has been injected.
>  	 */
> -	if (cur->bc_private.a.priv.refc.nr_ops > 2 &&
> +	if (cur->bc_ag.priv.refc.nr_ops > 2 &&
>  	    XFS_TEST_ERROR(false, cur->bc_mp,
>  			XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE))
>  		return false;
>  
> -	if (cur->bc_private.a.priv.refc.nr_ops == 0)
> +	if (cur->bc_ag.priv.refc.nr_ops == 0)
>  		return true;
>  	else if (overhead > cur->bc_tp->t_log_res)
>  		return false;
>  	return  cur->bc_tp->t_log_res - overhead >
> -		cur->bc_private.a.priv.refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
> +		cur->bc_ag.priv.refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
>  }
>  
>  /*
> @@ -952,7 +952,7 @@ xfs_refcount_adjust_extents(
>  					ext.rc_startblock - *agbno);
>  			tmp.rc_refcount = 1 + adj;
>  			trace_xfs_refcount_modify_extent(cur->bc_mp,
> -					cur->bc_private.a.agno, &tmp);
> +					cur->bc_ag.agno, &tmp);
>  
>  			/*
>  			 * Either cover the hole (increment) or
> @@ -968,10 +968,10 @@ xfs_refcount_adjust_extents(
>  					error = -EFSCORRUPTED;
>  					goto out_error;
>  				}
> -				cur->bc_private.a.priv.refc.nr_ops++;
> +				cur->bc_ag.priv.refc.nr_ops++;
>  			} else {
>  				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
> -						cur->bc_private.a.agno,
> +						cur->bc_ag.agno,
>  						tmp.rc_startblock);
>  				xfs_bmap_add_free(cur->bc_tp, fsbno,
>  						  tmp.rc_blockcount, oinfo);
> @@ -998,12 +998,12 @@ xfs_refcount_adjust_extents(
>  			goto skip;
>  		ext.rc_refcount += adj;
>  		trace_xfs_refcount_modify_extent(cur->bc_mp,
> -				cur->bc_private.a.agno, &ext);
> +				cur->bc_ag.agno, &ext);
>  		if (ext.rc_refcount > 1) {
>  			error = xfs_refcount_update(cur, &ext);
>  			if (error)
>  				goto out_error;
> -			cur->bc_private.a.priv.refc.nr_ops++;
> +			cur->bc_ag.priv.refc.nr_ops++;
>  		} else if (ext.rc_refcount == 1) {
>  			error = xfs_refcount_delete(cur, &found_rec);
>  			if (error)
> @@ -1012,11 +1012,11 @@ xfs_refcount_adjust_extents(
>  				error = -EFSCORRUPTED;
>  				goto out_error;
>  			}
> -			cur->bc_private.a.priv.refc.nr_ops++;
> +			cur->bc_ag.priv.refc.nr_ops++;
>  			goto advloop;
>  		} else {
>  			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
> -					cur->bc_private.a.agno,
> +					cur->bc_ag.agno,
>  					ext.rc_startblock);
>  			xfs_bmap_add_free(cur->bc_tp, fsbno, ext.rc_blockcount,
>  					  oinfo);
> @@ -1035,7 +1035,7 @@ xfs_refcount_adjust_extents(
>  	return error;
>  out_error:
>  	trace_xfs_refcount_modify_extent_error(cur->bc_mp,
> -			cur->bc_private.a.agno, error, _RET_IP_);
> +			cur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -1057,10 +1057,10 @@ xfs_refcount_adjust(
>  	*new_agbno = agbno;
>  	*new_aglen = aglen;
>  	if (adj == XFS_REFCOUNT_ADJUST_INCREASE)
> -		trace_xfs_refcount_increase(cur->bc_mp, cur->bc_private.a.agno,
> +		trace_xfs_refcount_increase(cur->bc_mp, cur->bc_ag.agno,
>  				agbno, aglen);
>  	else
> -		trace_xfs_refcount_decrease(cur->bc_mp, cur->bc_private.a.agno,
> +		trace_xfs_refcount_decrease(cur->bc_mp, cur->bc_ag.agno,
>  				agbno, aglen);
>  
>  	/*
> @@ -1088,7 +1088,7 @@ xfs_refcount_adjust(
>  	if (shape_changed)
>  		shape_changes++;
>  	if (shape_changes)
> -		cur->bc_private.a.priv.refc.shape_changes++;
> +		cur->bc_ag.priv.refc.shape_changes++;
>  
>  	/* Now that we've taken care of the ends, adjust the middle extents */
>  	error = xfs_refcount_adjust_extents(cur, new_agbno, new_aglen,
> @@ -1099,7 +1099,7 @@ xfs_refcount_adjust(
>  	return 0;
>  
>  out_error:
> -	trace_xfs_refcount_adjust_error(cur->bc_mp, cur->bc_private.a.agno,
> +	trace_xfs_refcount_adjust_error(cur->bc_mp, cur->bc_ag.agno,
>  			error, _RET_IP_);
>  	return error;
>  }
> @@ -1115,7 +1115,7 @@ xfs_refcount_finish_one_cleanup(
>  
>  	if (rcur == NULL)
>  		return;
> -	agbp = rcur->bc_private.a.agbp;
> +	agbp = rcur->bc_ag.agbp;
>  	xfs_btree_del_cursor(rcur, error);
>  	if (error)
>  		xfs_trans_brelse(tp, agbp);
> @@ -1165,9 +1165,9 @@ xfs_refcount_finish_one(
>  	 * the startblock, get one now.
>  	 */
>  	rcur = *pcur;
> -	if (rcur != NULL && rcur->bc_private.a.agno != agno) {
> -		nr_ops = rcur->bc_private.a.priv.refc.nr_ops;
> -		shape_changes = rcur->bc_private.a.priv.refc.shape_changes;
> +	if (rcur != NULL && rcur->bc_ag.agno != agno) {
> +		nr_ops = rcur->bc_ag.priv.refc.nr_ops;
> +		shape_changes = rcur->bc_ag.priv.refc.shape_changes;
>  		xfs_refcount_finish_one_cleanup(tp, rcur, 0);
>  		rcur = NULL;
>  		*pcur = NULL;
> @@ -1183,8 +1183,8 @@ xfs_refcount_finish_one(
>  			error = -ENOMEM;
>  			goto out_cur;
>  		}
> -		rcur->bc_private.a.priv.refc.nr_ops = nr_ops;
> -		rcur->bc_private.a.priv.refc.shape_changes = shape_changes;
> +		rcur->bc_ag.priv.refc.nr_ops = nr_ops;
> +		rcur->bc_ag.priv.refc.shape_changes = shape_changes;
>  	}
>  	*pcur = rcur;
>  
> @@ -1303,7 +1303,7 @@ xfs_refcount_find_shared(
>  	int				have;
>  	int				error;
>  
> -	trace_xfs_refcount_find_shared(cur->bc_mp, cur->bc_private.a.agno,
> +	trace_xfs_refcount_find_shared(cur->bc_mp, cur->bc_ag.agno,
>  			agbno, aglen);
>  
>  	/* By default, skip the whole range */
> @@ -1383,12 +1383,12 @@ xfs_refcount_find_shared(
>  
>  done:
>  	trace_xfs_refcount_find_shared_result(cur->bc_mp,
> -			cur->bc_private.a.agno, *fbno, *flen);
> +			cur->bc_ag.agno, *fbno, *flen);
>  
>  out_error:
>  	if (error)
>  		trace_xfs_refcount_find_shared_error(cur->bc_mp,
> -				cur->bc_private.a.agno, error, _RET_IP_);
> +				cur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -1485,7 +1485,7 @@ xfs_refcount_adjust_cow_extents(
>  		tmp.rc_blockcount = aglen;
>  		tmp.rc_refcount = 1;
>  		trace_xfs_refcount_modify_extent(cur->bc_mp,
> -				cur->bc_private.a.agno, &tmp);
> +				cur->bc_ag.agno, &tmp);
>  
>  		error = xfs_refcount_insert(cur, &tmp,
>  				&found_tmp);
> @@ -1513,7 +1513,7 @@ xfs_refcount_adjust_cow_extents(
>  
>  		ext.rc_refcount = 0;
>  		trace_xfs_refcount_modify_extent(cur->bc_mp,
> -				cur->bc_private.a.agno, &ext);
> +				cur->bc_ag.agno, &ext);
>  		error = xfs_refcount_delete(cur, &found_rec);
>  		if (error)
>  			goto out_error;
> @@ -1529,7 +1529,7 @@ xfs_refcount_adjust_cow_extents(
>  	return error;
>  out_error:
>  	trace_xfs_refcount_modify_extent_error(cur->bc_mp,
> -			cur->bc_private.a.agno, error, _RET_IP_);
> +			cur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -1575,7 +1575,7 @@ xfs_refcount_adjust_cow(
>  	return 0;
>  
>  out_error:
> -	trace_xfs_refcount_adjust_cow_error(cur->bc_mp, cur->bc_private.a.agno,
> +	trace_xfs_refcount_adjust_cow_error(cur->bc_mp, cur->bc_ag.agno,
>  			error, _RET_IP_);
>  	return error;
>  }
> @@ -1589,7 +1589,7 @@ __xfs_refcount_cow_alloc(
>  	xfs_agblock_t		agbno,
>  	xfs_extlen_t		aglen)
>  {
> -	trace_xfs_refcount_cow_increase(rcur->bc_mp, rcur->bc_private.a.agno,
> +	trace_xfs_refcount_cow_increase(rcur->bc_mp, rcur->bc_ag.agno,
>  			agbno, aglen);
>  
>  	/* Add refcount btree reservation */
> @@ -1606,7 +1606,7 @@ __xfs_refcount_cow_free(
>  	xfs_agblock_t		agbno,
>  	xfs_extlen_t		aglen)
>  {
> -	trace_xfs_refcount_cow_decrease(rcur->bc_mp, rcur->bc_private.a.agno,
> +	trace_xfs_refcount_cow_decrease(rcur->bc_mp, rcur->bc_ag.agno,
>  			agbno, aglen);
>  
>  	/* Remove refcount btree reservation */
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 38529dbacd55..f66cd6dfbe6c 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -25,7 +25,7 @@ xfs_refcountbt_dup_cursor(
>  	struct xfs_btree_cur	*cur)
>  {
>  	return xfs_refcountbt_init_cursor(cur->bc_mp, cur->bc_tp,
> -			cur->bc_private.a.agbp, cur->bc_private.a.agno);
> +			cur->bc_ag.agbp, cur->bc_ag.agno);
>  }
>  
>  STATIC void
> @@ -34,7 +34,7 @@ xfs_refcountbt_set_root(
>  	union xfs_btree_ptr	*ptr,
>  	int			inc)
>  {
> -	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> +	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
>  	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
>  	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
> @@ -57,7 +57,7 @@ xfs_refcountbt_alloc_block(
>  	union xfs_btree_ptr	*new,
>  	int			*stat)
>  {
> -	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> +	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
>  	struct xfs_alloc_arg	args;		/* block allocation args */
>  	int			error;		/* error return value */
> @@ -66,7 +66,7 @@ xfs_refcountbt_alloc_block(
>  	args.tp = cur->bc_tp;
>  	args.mp = cur->bc_mp;
>  	args.type = XFS_ALLOCTYPE_NEAR_BNO;
> -	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
> +	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.agno,
>  			xfs_refc_block(args.mp));
>  	args.oinfo = XFS_RMAP_OINFO_REFC;
>  	args.minlen = args.maxlen = args.prod = 1;
> @@ -75,13 +75,13 @@ xfs_refcountbt_alloc_block(
>  	error = xfs_alloc_vextent(&args);
>  	if (error)
>  		goto out_error;
> -	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_private.a.agno,
> +	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_ag.agno,
>  			args.agbno, 1);
>  	if (args.fsbno == NULLFSBLOCK) {
>  		*stat = 0;
>  		return 0;
>  	}
> -	ASSERT(args.agno == cur->bc_private.a.agno);
> +	ASSERT(args.agno == cur->bc_ag.agno);
>  	ASSERT(args.len == 1);
>  
>  	new->s = cpu_to_be32(args.agbno);
> @@ -101,12 +101,12 @@ xfs_refcountbt_free_block(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = cur->bc_mp;
> -	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> +	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
>  	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
>  	int			error;
>  
> -	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_private.a.agno,
> +	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_ag.agno,
>  			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1);
>  	be32_add_cpu(&agf->agf_refcount_blocks, -1);
>  	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
> @@ -169,9 +169,9 @@ xfs_refcountbt_init_ptr_from_cur(
>  	struct xfs_btree_cur	*cur,
>  	union xfs_btree_ptr	*ptr)
>  {
> -	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
> +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_ag.agbp);
>  
> -	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
> +	ASSERT(cur->bc_ag.agno == be32_to_cpu(agf->agf_seqno));
>  
>  	ptr->s = agf->agf_refcount_root;
>  }
> @@ -336,12 +336,12 @@ xfs_refcountbt_init_cursor(
>  
>  	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
>  
> -	cur->bc_private.a.agbp = agbp;
> -	cur->bc_private.a.agno = agno;
> +	cur->bc_ag.agbp = agbp;
> +	cur->bc_ag.agno = agno;
>  	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
>  
> -	cur->bc_private.a.priv.refc.nr_ops = 0;
> -	cur->bc_private.a.priv.refc.shape_changes = 0;
> +	cur->bc_ag.priv.refc.nr_ops = 0;
> +	cur->bc_ag.priv.refc.shape_changes = 0;
>  
>  	return cur;
>  }
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index ff9412f113c4..0767b76bf8cd 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -79,7 +79,7 @@ xfs_rmap_update(
>  	union xfs_btree_rec	rec;
>  	int			error;
>  
> -	trace_xfs_rmap_update(cur->bc_mp, cur->bc_private.a.agno,
> +	trace_xfs_rmap_update(cur->bc_mp, cur->bc_ag.agno,
>  			irec->rm_startblock, irec->rm_blockcount,
>  			irec->rm_owner, irec->rm_offset, irec->rm_flags);
>  
> @@ -91,7 +91,7 @@ xfs_rmap_update(
>  	error = xfs_btree_update(cur, &rec);
>  	if (error)
>  		trace_xfs_rmap_update_error(cur->bc_mp,
> -				cur->bc_private.a.agno, error, _RET_IP_);
> +				cur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -107,7 +107,7 @@ xfs_rmap_insert(
>  	int			i;
>  	int			error;
>  
> -	trace_xfs_rmap_insert(rcur->bc_mp, rcur->bc_private.a.agno, agbno,
> +	trace_xfs_rmap_insert(rcur->bc_mp, rcur->bc_ag.agno, agbno,
>  			len, owner, offset, flags);
>  
>  	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
> @@ -133,7 +133,7 @@ xfs_rmap_insert(
>  done:
>  	if (error)
>  		trace_xfs_rmap_insert_error(rcur->bc_mp,
> -				rcur->bc_private.a.agno, error, _RET_IP_);
> +				rcur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -149,7 +149,7 @@ xfs_rmap_delete(
>  	int			i;
>  	int			error;
>  
> -	trace_xfs_rmap_delete(rcur->bc_mp, rcur->bc_private.a.agno, agbno,
> +	trace_xfs_rmap_delete(rcur->bc_mp, rcur->bc_ag.agno, agbno,
>  			len, owner, offset, flags);
>  
>  	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
> @@ -170,7 +170,7 @@ xfs_rmap_delete(
>  done:
>  	if (error)
>  		trace_xfs_rmap_delete_error(rcur->bc_mp,
> -				rcur->bc_private.a.agno, error, _RET_IP_);
> +				rcur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -197,7 +197,7 @@ xfs_rmap_get_rec(
>  	int			*stat)
>  {
>  	struct xfs_mount	*mp = cur->bc_mp;
> -	xfs_agnumber_t		agno = cur->bc_private.a.agno;
> +	xfs_agnumber_t		agno = cur->bc_ag.agno;
>  	union xfs_btree_rec	*rec;
>  	int			error;
>  
> @@ -260,7 +260,7 @@ xfs_rmap_find_left_neighbor_helper(
>  	struct xfs_find_left_neighbor_info	*info = priv;
>  
>  	trace_xfs_rmap_find_left_neighbor_candidate(cur->bc_mp,
> -			cur->bc_private.a.agno, rec->rm_startblock,
> +			cur->bc_ag.agno, rec->rm_startblock,
>  			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
>  			rec->rm_flags);
>  
> @@ -312,7 +312,7 @@ xfs_rmap_find_left_neighbor(
>  	info.stat = stat;
>  
>  	trace_xfs_rmap_find_left_neighbor_query(cur->bc_mp,
> -			cur->bc_private.a.agno, bno, 0, owner, offset, flags);
> +			cur->bc_ag.agno, bno, 0, owner, offset, flags);
>  
>  	error = xfs_rmap_query_range(cur, &info.high, &info.high,
>  			xfs_rmap_find_left_neighbor_helper, &info);
> @@ -320,7 +320,7 @@ xfs_rmap_find_left_neighbor(
>  		error = 0;
>  	if (*stat)
>  		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
> -				cur->bc_private.a.agno, irec->rm_startblock,
> +				cur->bc_ag.agno, irec->rm_startblock,
>  				irec->rm_blockcount, irec->rm_owner,
>  				irec->rm_offset, irec->rm_flags);
>  	return error;
> @@ -336,7 +336,7 @@ xfs_rmap_lookup_le_range_helper(
>  	struct xfs_find_left_neighbor_info	*info = priv;
>  
>  	trace_xfs_rmap_lookup_le_range_candidate(cur->bc_mp,
> -			cur->bc_private.a.agno, rec->rm_startblock,
> +			cur->bc_ag.agno, rec->rm_startblock,
>  			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
>  			rec->rm_flags);
>  
> @@ -385,14 +385,14 @@ xfs_rmap_lookup_le_range(
>  	info.stat = stat;
>  
>  	trace_xfs_rmap_lookup_le_range(cur->bc_mp,
> -			cur->bc_private.a.agno, bno, 0, owner, offset, flags);
> +			cur->bc_ag.agno, bno, 0, owner, offset, flags);
>  	error = xfs_rmap_query_range(cur, &info.high, &info.high,
>  			xfs_rmap_lookup_le_range_helper, &info);
>  	if (error == -ECANCELED)
>  		error = 0;
>  	if (*stat)
>  		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
> -				cur->bc_private.a.agno, irec->rm_startblock,
> +				cur->bc_ag.agno, irec->rm_startblock,
>  				irec->rm_blockcount, irec->rm_owner,
>  				irec->rm_offset, irec->rm_flags);
>  	return error;
> @@ -498,7 +498,7 @@ xfs_rmap_unmap(
>  			(flags & XFS_RMAP_BMBT_BLOCK);
>  	if (unwritten)
>  		flags |= XFS_RMAP_UNWRITTEN;
> -	trace_xfs_rmap_unmap(mp, cur->bc_private.a.agno, bno, len,
> +	trace_xfs_rmap_unmap(mp, cur->bc_ag.agno, bno, len,
>  			unwritten, oinfo);
>  
>  	/*
> @@ -522,7 +522,7 @@ xfs_rmap_unmap(
>  		goto out_error;
>  	}
>  	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
> -			cur->bc_private.a.agno, ltrec.rm_startblock,
> +			cur->bc_ag.agno, ltrec.rm_startblock,
>  			ltrec.rm_blockcount, ltrec.rm_owner,
>  			ltrec.rm_offset, ltrec.rm_flags);
>  	ltoff = ltrec.rm_offset;
> @@ -588,7 +588,7 @@ xfs_rmap_unmap(
>  
>  	if (ltrec.rm_startblock == bno && ltrec.rm_blockcount == len) {
>  		/* exact match, simply remove the record from rmap tree */
> -		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
> +		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
>  				ltrec.rm_startblock, ltrec.rm_blockcount,
>  				ltrec.rm_owner, ltrec.rm_offset,
>  				ltrec.rm_flags);
> @@ -666,7 +666,7 @@ xfs_rmap_unmap(
>  		else
>  			cur->bc_rec.r.rm_offset = offset + len;
>  		cur->bc_rec.r.rm_flags = flags;
> -		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno,
> +		trace_xfs_rmap_insert(mp, cur->bc_ag.agno,
>  				cur->bc_rec.r.rm_startblock,
>  				cur->bc_rec.r.rm_blockcount,
>  				cur->bc_rec.r.rm_owner,
> @@ -678,11 +678,11 @@ xfs_rmap_unmap(
>  	}
>  
>  out_done:
> -	trace_xfs_rmap_unmap_done(mp, cur->bc_private.a.agno, bno, len,
> +	trace_xfs_rmap_unmap_done(mp, cur->bc_ag.agno, bno, len,
>  			unwritten, oinfo);
>  out_error:
>  	if (error)
> -		trace_xfs_rmap_unmap_error(mp, cur->bc_private.a.agno,
> +		trace_xfs_rmap_unmap_error(mp, cur->bc_ag.agno,
>  				error, _RET_IP_);
>  	return error;
>  }
> @@ -773,7 +773,7 @@ xfs_rmap_map(
>  			(flags & XFS_RMAP_BMBT_BLOCK);
>  	if (unwritten)
>  		flags |= XFS_RMAP_UNWRITTEN;
> -	trace_xfs_rmap_map(mp, cur->bc_private.a.agno, bno, len,
> +	trace_xfs_rmap_map(mp, cur->bc_ag.agno, bno, len,
>  			unwritten, oinfo);
>  	ASSERT(!xfs_rmap_should_skip_owner_update(oinfo));
>  
> @@ -795,7 +795,7 @@ xfs_rmap_map(
>  			goto out_error;
>  		}
>  		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
> -				cur->bc_private.a.agno, ltrec.rm_startblock,
> +				cur->bc_ag.agno, ltrec.rm_startblock,
>  				ltrec.rm_blockcount, ltrec.rm_owner,
>  				ltrec.rm_offset, ltrec.rm_flags);
>  
> @@ -831,7 +831,7 @@ xfs_rmap_map(
>  			goto out_error;
>  		}
>  		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
> -			cur->bc_private.a.agno, gtrec.rm_startblock,
> +			cur->bc_ag.agno, gtrec.rm_startblock,
>  			gtrec.rm_blockcount, gtrec.rm_owner,
>  			gtrec.rm_offset, gtrec.rm_flags);
>  		if (!xfs_rmap_is_mergeable(&gtrec, owner, flags))
> @@ -870,7 +870,7 @@ xfs_rmap_map(
>  			 * result: |rrrrrrrrrrrrrrrrrrrrrrrrrrrrr|
>  			 */
>  			ltrec.rm_blockcount += gtrec.rm_blockcount;
> -			trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
> +			trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
>  					gtrec.rm_startblock,
>  					gtrec.rm_blockcount,
>  					gtrec.rm_owner,
> @@ -921,7 +921,7 @@ xfs_rmap_map(
>  		cur->bc_rec.r.rm_owner = owner;
>  		cur->bc_rec.r.rm_offset = offset;
>  		cur->bc_rec.r.rm_flags = flags;
> -		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno, len,
> +		trace_xfs_rmap_insert(mp, cur->bc_ag.agno, bno, len,
>  			owner, offset, flags);
>  		error = xfs_btree_insert(cur, &i);
>  		if (error)
> @@ -932,11 +932,11 @@ xfs_rmap_map(
>  		}
>  	}
>  
> -	trace_xfs_rmap_map_done(mp, cur->bc_private.a.agno, bno, len,
> +	trace_xfs_rmap_map_done(mp, cur->bc_ag.agno, bno, len,
>  			unwritten, oinfo);
>  out_error:
>  	if (error)
> -		trace_xfs_rmap_map_error(mp, cur->bc_private.a.agno,
> +		trace_xfs_rmap_map_error(mp, cur->bc_ag.agno,
>  				error, _RET_IP_);
>  	return error;
>  }
> @@ -1010,7 +1010,7 @@ xfs_rmap_convert(
>  			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
>  	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
>  	new_endoff = offset + len;
> -	trace_xfs_rmap_convert(mp, cur->bc_private.a.agno, bno, len,
> +	trace_xfs_rmap_convert(mp, cur->bc_ag.agno, bno, len,
>  			unwritten, oinfo);
>  
>  	/*
> @@ -1034,7 +1034,7 @@ xfs_rmap_convert(
>  		goto done;
>  	}
>  	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
> -			cur->bc_private.a.agno, PREV.rm_startblock,
> +			cur->bc_ag.agno, PREV.rm_startblock,
>  			PREV.rm_blockcount, PREV.rm_owner,
>  			PREV.rm_offset, PREV.rm_flags);
>  
> @@ -1076,7 +1076,7 @@ xfs_rmap_convert(
>  			goto done;
>  		}
>  		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
> -				cur->bc_private.a.agno, LEFT.rm_startblock,
> +				cur->bc_ag.agno, LEFT.rm_startblock,
>  				LEFT.rm_blockcount, LEFT.rm_owner,
>  				LEFT.rm_offset, LEFT.rm_flags);
>  		if (LEFT.rm_startblock + LEFT.rm_blockcount == bno &&
> @@ -1114,7 +1114,7 @@ xfs_rmap_convert(
>  			goto done;
>  		}
>  		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
> -				cur->bc_private.a.agno, RIGHT.rm_startblock,
> +				cur->bc_ag.agno, RIGHT.rm_startblock,
>  				RIGHT.rm_blockcount, RIGHT.rm_owner,
>  				RIGHT.rm_offset, RIGHT.rm_flags);
>  		if (bno + len == RIGHT.rm_startblock &&
> @@ -1132,7 +1132,7 @@ xfs_rmap_convert(
>  	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
>  		state &= ~RMAP_RIGHT_CONTIG;
>  
> -	trace_xfs_rmap_convert_state(mp, cur->bc_private.a.agno, state,
> +	trace_xfs_rmap_convert_state(mp, cur->bc_ag.agno, state,
>  			_RET_IP_);
>  
>  	/* reset the cursor back to PREV */
> @@ -1162,7 +1162,7 @@ xfs_rmap_convert(
>  			error = -EFSCORRUPTED;
>  			goto done;
>  		}
> -		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
> +		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
>  				RIGHT.rm_startblock, RIGHT.rm_blockcount,
>  				RIGHT.rm_owner, RIGHT.rm_offset,
>  				RIGHT.rm_flags);
> @@ -1180,7 +1180,7 @@ xfs_rmap_convert(
>  			error = -EFSCORRUPTED;
>  			goto done;
>  		}
> -		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
> +		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
>  				PREV.rm_startblock, PREV.rm_blockcount,
>  				PREV.rm_owner, PREV.rm_offset,
>  				PREV.rm_flags);
> @@ -1210,7 +1210,7 @@ xfs_rmap_convert(
>  		 * Setting all of a previous oldext extent to newext.
>  		 * The left neighbor is contiguous, the right is not.
>  		 */
> -		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
> +		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
>  				PREV.rm_startblock, PREV.rm_blockcount,
>  				PREV.rm_owner, PREV.rm_offset,
>  				PREV.rm_flags);
> @@ -1247,7 +1247,7 @@ xfs_rmap_convert(
>  			error = -EFSCORRUPTED;
>  			goto done;
>  		}
> -		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
> +		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
>  				RIGHT.rm_startblock, RIGHT.rm_blockcount,
>  				RIGHT.rm_owner, RIGHT.rm_offset,
>  				RIGHT.rm_flags);
> @@ -1326,7 +1326,7 @@ xfs_rmap_convert(
>  		NEW.rm_blockcount = len;
>  		NEW.rm_flags = newext;
>  		cur->bc_rec.r = NEW;
> -		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno,
> +		trace_xfs_rmap_insert(mp, cur->bc_ag.agno, bno,
>  				len, owner, offset, newext);
>  		error = xfs_btree_insert(cur, &i);
>  		if (error)
> @@ -1383,7 +1383,7 @@ xfs_rmap_convert(
>  		NEW.rm_blockcount = len;
>  		NEW.rm_flags = newext;
>  		cur->bc_rec.r = NEW;
> -		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno,
> +		trace_xfs_rmap_insert(mp, cur->bc_ag.agno, bno,
>  				len, owner, offset, newext);
>  		error = xfs_btree_insert(cur, &i);
>  		if (error)
> @@ -1414,7 +1414,7 @@ xfs_rmap_convert(
>  		NEW = PREV;
>  		NEW.rm_blockcount = offset - PREV.rm_offset;
>  		cur->bc_rec.r = NEW;
> -		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno,
> +		trace_xfs_rmap_insert(mp, cur->bc_ag.agno,
>  				NEW.rm_startblock, NEW.rm_blockcount,
>  				NEW.rm_owner, NEW.rm_offset,
>  				NEW.rm_flags);
> @@ -1441,7 +1441,7 @@ xfs_rmap_convert(
>  		/* new middle extent - newext */
>  		cur->bc_rec.r.rm_flags &= ~XFS_RMAP_UNWRITTEN;
>  		cur->bc_rec.r.rm_flags |= newext;
> -		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno, len,
> +		trace_xfs_rmap_insert(mp, cur->bc_ag.agno, bno, len,
>  				owner, offset, newext);
>  		error = xfs_btree_insert(cur, &i);
>  		if (error)
> @@ -1465,12 +1465,12 @@ xfs_rmap_convert(
>  		ASSERT(0);
>  	}
>  
> -	trace_xfs_rmap_convert_done(mp, cur->bc_private.a.agno, bno, len,
> +	trace_xfs_rmap_convert_done(mp, cur->bc_ag.agno, bno, len,
>  			unwritten, oinfo);
>  done:
>  	if (error)
>  		trace_xfs_rmap_convert_error(cur->bc_mp,
> -				cur->bc_private.a.agno, error, _RET_IP_);
> +				cur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -1506,7 +1506,7 @@ xfs_rmap_convert_shared(
>  			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
>  	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
>  	new_endoff = offset + len;
> -	trace_xfs_rmap_convert(mp, cur->bc_private.a.agno, bno, len,
> +	trace_xfs_rmap_convert(mp, cur->bc_ag.agno, bno, len,
>  			unwritten, oinfo);
>  
>  	/*
> @@ -1573,7 +1573,7 @@ xfs_rmap_convert_shared(
>  			goto done;
>  		}
>  		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
> -				cur->bc_private.a.agno, RIGHT.rm_startblock,
> +				cur->bc_ag.agno, RIGHT.rm_startblock,
>  				RIGHT.rm_blockcount, RIGHT.rm_owner,
>  				RIGHT.rm_offset, RIGHT.rm_flags);
>  		if (xfs_rmap_is_mergeable(&RIGHT, owner, newext))
> @@ -1589,7 +1589,7 @@ xfs_rmap_convert_shared(
>  	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
>  		state &= ~RMAP_RIGHT_CONTIG;
>  
> -	trace_xfs_rmap_convert_state(mp, cur->bc_private.a.agno, state,
> +	trace_xfs_rmap_convert_state(mp, cur->bc_ag.agno, state,
>  			_RET_IP_);
>  	/*
>  	 * Switch out based on the FILLING and CONTIG state bits.
> @@ -1880,12 +1880,12 @@ xfs_rmap_convert_shared(
>  		ASSERT(0);
>  	}
>  
> -	trace_xfs_rmap_convert_done(mp, cur->bc_private.a.agno, bno, len,
> +	trace_xfs_rmap_convert_done(mp, cur->bc_ag.agno, bno, len,
>  			unwritten, oinfo);
>  done:
>  	if (error)
>  		trace_xfs_rmap_convert_error(cur->bc_mp,
> -				cur->bc_private.a.agno, error, _RET_IP_);
> +				cur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -1923,7 +1923,7 @@ xfs_rmap_unmap_shared(
>  	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
>  	if (unwritten)
>  		flags |= XFS_RMAP_UNWRITTEN;
> -	trace_xfs_rmap_unmap(mp, cur->bc_private.a.agno, bno, len,
> +	trace_xfs_rmap_unmap(mp, cur->bc_ag.agno, bno, len,
>  			unwritten, oinfo);
>  
>  	/*
> @@ -2072,12 +2072,12 @@ xfs_rmap_unmap_shared(
>  			goto out_error;
>  	}
>  
> -	trace_xfs_rmap_unmap_done(mp, cur->bc_private.a.agno, bno, len,
> +	trace_xfs_rmap_unmap_done(mp, cur->bc_ag.agno, bno, len,
>  			unwritten, oinfo);
>  out_error:
>  	if (error)
>  		trace_xfs_rmap_unmap_error(cur->bc_mp,
> -				cur->bc_private.a.agno, error, _RET_IP_);
> +				cur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -2112,7 +2112,7 @@ xfs_rmap_map_shared(
>  	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
>  	if (unwritten)
>  		flags |= XFS_RMAP_UNWRITTEN;
> -	trace_xfs_rmap_map(mp, cur->bc_private.a.agno, bno, len,
> +	trace_xfs_rmap_map(mp, cur->bc_ag.agno, bno, len,
>  			unwritten, oinfo);
>  
>  	/* Is there a left record that abuts our range? */
> @@ -2138,7 +2138,7 @@ xfs_rmap_map_shared(
>  			goto out_error;
>  		}
>  		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
> -			cur->bc_private.a.agno, gtrec.rm_startblock,
> +			cur->bc_ag.agno, gtrec.rm_startblock,
>  			gtrec.rm_blockcount, gtrec.rm_owner,
>  			gtrec.rm_offset, gtrec.rm_flags);
>  
> @@ -2231,12 +2231,12 @@ xfs_rmap_map_shared(
>  			goto out_error;
>  	}
>  
> -	trace_xfs_rmap_map_done(mp, cur->bc_private.a.agno, bno, len,
> +	trace_xfs_rmap_map_done(mp, cur->bc_ag.agno, bno, len,
>  			unwritten, oinfo);
>  out_error:
>  	if (error)
>  		trace_xfs_rmap_map_error(cur->bc_mp,
> -				cur->bc_private.a.agno, error, _RET_IP_);
> +				cur->bc_ag.agno, error, _RET_IP_);
>  	return error;
>  }
>  
> @@ -2336,7 +2336,7 @@ xfs_rmap_finish_one_cleanup(
>  
>  	if (rcur == NULL)
>  		return;
> -	agbp = rcur->bc_private.a.agbp;
> +	agbp = rcur->bc_ag.agbp;
>  	xfs_btree_del_cursor(rcur, error);
>  	if (error)
>  		xfs_trans_brelse(tp, agbp);
> @@ -2386,7 +2386,7 @@ xfs_rmap_finish_one(
>  	 * the startblock, get one now.
>  	 */
>  	rcur = *pcur;
> -	if (rcur != NULL && rcur->bc_private.a.agno != agno) {
> +	if (rcur != NULL && rcur->bc_ag.agno != agno) {
>  		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
>  		rcur = NULL;
>  		*pcur = NULL;
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index fc78efa52c94..121d7ee2301f 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -51,7 +51,7 @@ xfs_rmapbt_dup_cursor(
>  	struct xfs_btree_cur	*cur)
>  {
>  	return xfs_rmapbt_init_cursor(cur->bc_mp, cur->bc_tp,
> -			cur->bc_private.a.agbp, cur->bc_private.a.agno);
> +			cur->bc_ag.agbp, cur->bc_ag.agno);
>  }
>  
>  STATIC void
> @@ -60,7 +60,7 @@ xfs_rmapbt_set_root(
>  	union xfs_btree_ptr	*ptr,
>  	int			inc)
>  {
> -	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> +	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
>  	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
>  	int			btnum = cur->bc_btnum;
> @@ -83,25 +83,25 @@ xfs_rmapbt_alloc_block(
>  	union xfs_btree_ptr	*new,
>  	int			*stat)
>  {
> -	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> +	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
>  	int			error;
>  	xfs_agblock_t		bno;
>  
>  	/* Allocate the new block from the freelist. If we can't, give up.  */
> -	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
> +	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_ag.agbp,
>  				       &bno, 1);
>  	if (error)
>  		return error;
>  
> -	trace_xfs_rmapbt_alloc_block(cur->bc_mp, cur->bc_private.a.agno,
> +	trace_xfs_rmapbt_alloc_block(cur->bc_mp, cur->bc_ag.agno,
>  			bno, 1);
>  	if (bno == NULLAGBLOCK) {
>  		*stat = 0;
>  		return 0;
>  	}
>  
> -	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_private.a.agno, bno, 1,
> +	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agno, bno, 1,
>  			false);
>  
>  	xfs_trans_agbtree_delta(cur->bc_tp, 1);
> @@ -109,7 +109,7 @@ xfs_rmapbt_alloc_block(
>  	be32_add_cpu(&agf->agf_rmap_blocks, 1);
>  	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
>  
> -	xfs_ag_resv_rmapbt_alloc(cur->bc_mp, cur->bc_private.a.agno);
> +	xfs_ag_resv_rmapbt_alloc(cur->bc_mp, cur->bc_ag.agno);
>  
>  	*stat = 1;
>  	return 0;
> @@ -120,13 +120,13 @@ xfs_rmapbt_free_block(
>  	struct xfs_btree_cur	*cur,
>  	struct xfs_buf		*bp)
>  {
> -	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> +	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
>  	xfs_agblock_t		bno;
>  	int			error;
>  
>  	bno = xfs_daddr_to_agbno(cur->bc_mp, XFS_BUF_ADDR(bp));
> -	trace_xfs_rmapbt_free_block(cur->bc_mp, cur->bc_private.a.agno,
> +	trace_xfs_rmapbt_free_block(cur->bc_mp, cur->bc_ag.agno,
>  			bno, 1);
>  	be32_add_cpu(&agf->agf_rmap_blocks, -1);
>  	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
> @@ -138,7 +138,7 @@ xfs_rmapbt_free_block(
>  			      XFS_EXTENT_BUSY_SKIP_DISCARD);
>  	xfs_trans_agbtree_delta(cur->bc_tp, -1);
>  
> -	xfs_ag_resv_rmapbt_free(cur->bc_mp, cur->bc_private.a.agno);
> +	xfs_ag_resv_rmapbt_free(cur->bc_mp, cur->bc_ag.agno);
>  
>  	return 0;
>  }
> @@ -215,9 +215,9 @@ xfs_rmapbt_init_ptr_from_cur(
>  	struct xfs_btree_cur	*cur,
>  	union xfs_btree_ptr	*ptr)
>  {
> -	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
> +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_ag.agbp);
>  
> -	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
> +	ASSERT(cur->bc_ag.agno == be32_to_cpu(agf->agf_seqno));
>  
>  	ptr->s = agf->agf_roots[cur->bc_btnum];
>  }
> @@ -472,8 +472,8 @@ xfs_rmapbt_init_cursor(
>  	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
>  	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
>  
> -	cur->bc_private.a.agbp = agbp;
> -	cur->bc_private.a.agno = agno;
> +	cur->bc_ag.agbp = agbp;
> +	cur->bc_ag.agno = agno;
>  
>  	return cur;
>  }
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index d5e6db9af434..c4cfa48106a8 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -453,7 +453,7 @@ xrep_agfl_walk_rmap(
>  
>  	/* Record all the OWN_AG blocks. */
>  	if (rec->rm_owner == XFS_RMAP_OWN_AG) {
> -		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
> +		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.agno,
>  				rec->rm_startblock);
>  		error = xfs_bitmap_set(ra->freesp, fsb, rec->rm_blockcount);
>  		if (error)
> diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
> index 5533e48e605d..73d924e47565 100644
> --- a/fs/xfs/scrub/alloc.c
> +++ b/fs/xfs/scrub/alloc.c
> @@ -94,7 +94,7 @@ xchk_allocbt_rec(
>  	union xfs_btree_rec	*rec)
>  {
>  	struct xfs_mount	*mp = bs->cur->bc_mp;
> -	xfs_agnumber_t		agno = bs->cur->bc_private.a.agno;
> +	xfs_agnumber_t		agno = bs->cur->bc_ag.agno;
>  	xfs_agblock_t		bno;
>  	xfs_extlen_t		len;
>  
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index fa6ea6407992..1c866594ec34 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -501,7 +501,7 @@ xchk_bmap_check_rmap(
>  			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
>  					rec->rm_offset);
>  		if (irec.br_startblock != XFS_AGB_TO_FSB(sc->mp,
> -				cur->bc_private.a.agno, rec->rm_startblock))
> +				cur->bc_ag.agno, rec->rm_startblock))
>  			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
>  					rec->rm_offset);
>  		if (irec.br_blockcount > rec->rm_blockcount)
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 681758704fda..64c217eb06a7 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -104,7 +104,7 @@ xchk_iallocbt_chunk(
>  	xfs_extlen_t			len)
>  {
>  	struct xfs_mount		*mp = bs->cur->bc_mp;
> -	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
> +	xfs_agnumber_t			agno = bs->cur->bc_ag.agno;
>  	xfs_agblock_t			bno;
>  
>  	bno = XFS_AGINO_TO_AGBNO(mp, agino);
> @@ -164,7 +164,7 @@ xchk_iallocbt_check_cluster_ifree(
>  	 * the record, compute which fs inode we're talking about.
>  	 */
>  	agino = irec->ir_startino + irec_ino;
> -	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
> +	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_ag.agno, agino);
>  	irec_free = (irec->ir_free & XFS_INOBT_MASK(irec_ino));
>  
>  	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC ||
> @@ -215,7 +215,7 @@ xchk_iallocbt_check_cluster(
>  	struct xfs_dinode		*dip;
>  	struct xfs_buf			*cluster_bp;
>  	unsigned int			nr_inodes;
> -	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
> +	xfs_agnumber_t			agno = bs->cur->bc_ag.agno;
>  	xfs_agblock_t			agbno;
>  	unsigned int			cluster_index;
>  	uint16_t			cluster_mask = 0;
> @@ -426,7 +426,7 @@ xchk_iallocbt_rec(
>  	struct xchk_iallocbt		*iabt = bs->private;
>  	struct xfs_inobt_rec_incore	irec;
>  	uint64_t			holes;
> -	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
> +	xfs_agnumber_t			agno = bs->cur->bc_ag.agno;
>  	xfs_agino_t			agino;
>  	xfs_extlen_t			len;
>  	int				holecount;
> diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> index 0cab11a5d390..beaeb6fa3119 100644
> --- a/fs/xfs/scrub/refcount.c
> +++ b/fs/xfs/scrub/refcount.c
> @@ -336,7 +336,7 @@ xchk_refcountbt_rec(
>  {
>  	struct xfs_mount	*mp = bs->cur->bc_mp;
>  	xfs_agblock_t		*cow_blocks = bs->private;
> -	xfs_agnumber_t		agno = bs->cur->bc_private.a.agno;
> +	xfs_agnumber_t		agno = bs->cur->bc_ag.agno;
>  	xfs_agblock_t		bno;
>  	xfs_extlen_t		len;
>  	xfs_nlink_t		refcount;
> diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
> index 8d4cefd761c1..f4fcb4719f41 100644
> --- a/fs/xfs/scrub/rmap.c
> +++ b/fs/xfs/scrub/rmap.c
> @@ -92,7 +92,7 @@ xchk_rmapbt_rec(
>  {
>  	struct xfs_mount	*mp = bs->cur->bc_mp;
>  	struct xfs_rmap_irec	irec;
> -	xfs_agnumber_t		agno = bs->cur->bc_private.a.agno;
> +	xfs_agnumber_t		agno = bs->cur->bc_ag.agno;
>  	bool			non_inode;
>  	bool			is_unwritten;
>  	bool			is_bmbt;
> diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
> index 9eaab2eb5ed3..731111e1448c 100644
> --- a/fs/xfs/scrub/trace.c
> +++ b/fs/xfs/scrub/trace.c
> @@ -26,7 +26,7 @@ xchk_btree_cur_fsbno(
>  		 cur->bc_flags & XFS_BTREE_LONG_PTRS)
>  		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_private.b.ip->i_ino);
>  	else if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS))
> -		return XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno, 0);
> +		return XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.agno, 0);
>  	return NULLFSBLOCK;
>  }
>  
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 918456ca29e1..910ad46e2bba 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -344,7 +344,7 @@ xfs_getfsmap_datadev_helper(
>  	xfs_fsblock_t			fsb;
>  	xfs_daddr_t			rec_daddr;
>  
> -	fsb = XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno, rec->rm_startblock);
> +	fsb = XFS_AGB_TO_FSB(mp, cur->bc_ag.agno, rec->rm_startblock);
>  	rec_daddr = XFS_FSB_TO_DADDR(mp, fsb);
>  
>  	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr);
> @@ -362,7 +362,7 @@ xfs_getfsmap_datadev_bnobt_helper(
>  	struct xfs_rmap_irec		irec;
>  	xfs_daddr_t			rec_daddr;
>  
> -	rec_daddr = XFS_AGB_TO_DADDR(mp, cur->bc_private.a.agno,
> +	rec_daddr = XFS_AGB_TO_DADDR(mp, cur->bc_ag.agno,
>  			rec->ar_startblock);
>  
>  	irec.rm_startblock = rec->ar_startblock;
> -- 
> 2.24.0.rc0
> 
