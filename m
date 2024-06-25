Return-Path: <linux-xfs+bounces-9864-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5023A915BAD
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2024 03:27:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07449283E6B
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2024 01:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B72717BA3;
	Tue, 25 Jun 2024 01:27:29 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8127E1A270;
	Tue, 25 Jun 2024 01:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719278849; cv=none; b=X0hraWTvdKNvbLkA3zA0/XpflIIWURimg/PzsQ3oLpQsyXqBko+J/7HGLm7GZ1i6LHe6LS9493ITI+v9Ng/f2yvgkO9uzwcpZ0OdDKnmzXzI6dRw25eCsSu5XlZTAcSoaVQvzLtemFwuKu7EHKoV6a9WBJZxUxE0Ra/86h+yya0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719278849; c=relaxed/simple;
	bh=N0luAetec1KTt6Yag/mATjZdNBYa9u4l3jCJinC00Lg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=iGBjvybu7++VSrxJs3g90PKrcf3SSduqz6+weEJRYvMDayHCkURd8NB4oP3S2grHMQwXkAw1GxdJmRwKGgdMuNi/YhQR1x1SDyBcHL82yub9LpYwZvSVsJm4yIJVEBClqHHmcZwKaI/k4GHfViX1FMR3aDyrDImw/6SUxXiKptY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4W7Rt41JFsz2Ckc4;
	Tue, 25 Jun 2024 09:23:24 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 225B1140381;
	Tue, 25 Jun 2024 09:27:22 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 25 Jun 2024 09:27:21 +0800
Message-ID: <6e8dc67c-10a3-4637-8ddb-28fbba163772@huawei.com>
Date: Tue, 25 Jun 2024 09:27:20 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] xfs: Avoid races with cnt_btree lastrec updates
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <chandan.babu@oracle.com>, <dchinner@redhat.com>,
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yangerkun@huawei.com>
References: <20240622085218.2701495-1-wozizhi@huawei.com>
 <20240624155958.GO3058325@frogsfrogsfrogs>
From: Zizhi Wo <wozizhi@huawei.com>
In-Reply-To: <20240624155958.GO3058325@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemf100017.china.huawei.com (7.202.181.16)



在 2024/6/24 23:59, Darrick J. Wong 写道:
> On Sat, Jun 22, 2024 at 04:52:18PM +0800, Zizhi Wo wrote:
>> A concurrent file creation and little writing could unexpectedly return
>> -ENOSPC error since there is a race window that the allocator could get
>> the wrong agf->agf_longest.
>>
>> Write file process steps:
>> 1) Find the entry that best meets the conditions, then calculate the start
>>     address and length of the remaining part of the entry after allocation.
>> 2) Delete this entry and update the agf->agf_longest.
>> 3) Insert the remaining unused parts of this entry based on the
>>     calculations in 1), and update the agf->agf_longest again if necessary.
>>
>> Create file process steps:
>> 1) Check whether there are free inodes in the inode chunk.
>> 2) If there is no free inode, check whether there has space for creating
>>     inode chunks, perform the no-lock judgment first.
>> 3) If the judgment succeeds, the judgment is performed again with agf lock
>>     held. Otherwire, an error is returned directly.
>>
>> If the write process is in step 2) but not go to 3) yet, the create file
>> process goes to 2) at this time, it will be mistaken for no space,
>> resulting in the file system still has space but the file creation fails.
>>
>> We have sent two different commits to the community in order to fix this
>> problem[1][2]. Unfortunately, both solutions have flaws. In [2], I
>> discussed with Dave and Darrick, realized that a better solution to this
>> problem requires the "last cnt record tracking" to be ripped out of the
>> generic btree code. And surprisingly, Dave directly provided his fix code.
>> This patch includes appropriate modifications based on his tmp-code to
>> address this issue.
>>
>> The entire fix can be roughly divided into two parts:
>> 1) Delete the code related to lastrec-update in the generic btree code.
>> 2) Place the process of updating longest freespace with cntbt separately
>>     to the end of the cntbt modifications. Move the cursor to the rightmost
>>     firstly, and update the longest free extent based on the record.
>>
>> Note that we can not update the longest with xfs_alloc_get_rec() after
>> find the longest record, as xfs_verify_agbno() may not pass because
>> pag->block_count is updated on the outside. Therefore, use
>> xfs_btree_get_rec() as a replacement.
>>
>> [1] https://lore.kernel.org/all/20240419061848.1032366-2-yebin10@huawei.com
>> [2] https://lore.kernel.org/all/20240604071121.3981686-1-wozizhi@huawei.com
>>
>> Reported by: Ye Bin <yebin10@huawei.com>
>> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
>> ---
>>   fs/xfs/libxfs/xfs_alloc.c       | 117 ++++++++++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_alloc_btree.c |  64 -----------------
>>   fs/xfs/libxfs/xfs_btree.c       |  51 --------------
>>   fs/xfs/libxfs/xfs_btree.h       |  16 +----
>>   4 files changed, 118 insertions(+), 130 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
>> index 6c55a6e88eba..a3412f133b7f 100644
>> --- a/fs/xfs/libxfs/xfs_alloc.c
>> +++ b/fs/xfs/libxfs/xfs_alloc.c
>> @@ -465,6 +465,100 @@ xfs_alloc_fix_len(
>>   	args->len = rlen;
>>   }
>>   
>> +/*
>> + * Determine if the cursor points to the block that contains the right-most
>> + * block of records in the by-count btree. This block contains the largest
>> + * contiguous free extent in the AG, so if we modify a record in this block we
>> + * need to call xfs_alloc_fixup_longest() once the modifications are done to
>> + * ensure the agf->agf_longest field is kept up to date with the longest free
>> + * extent tracked by the by-count btree.
>> + */
>> +static bool
>> +xfs_alloc_cursor_at_lastrec(
>> +	struct xfs_btree_cur	*cnt_cur)
>> +{
>> +	struct xfs_btree_block	*block;
>> +	union xfs_btree_ptr	ptr;
>> +	struct xfs_buf		*bp;
>> +
>> +	block = xfs_btree_get_block(cnt_cur, 0, &bp);
>> +
>> +	xfs_btree_get_sibling(cnt_cur, block, &ptr, XFS_BB_RIGHTSIB);
>> +	if (!xfs_btree_ptr_is_null(cnt_cur, &ptr))
>> +		return false;
>> +	return true;
> 
> This could be simplified to:
> 
> 	return xfs_btree_ptr_is_null(cnt_cur, &ptr);
> 
> Everything else looks ok to me.
> 
> --D

It does seem simpler. I will send version V3 to simplify this part.

Thanks,
Zizhi Wo

> 
>> +}
>> +
>> +/*
>> + * Find the rightmost record of the cntbt, and return the longest free space
>> + * recorded in it. Simply set both the block number and the length to their
>> + * maximum values before searching.
>> + */
>> +static int
>> +xfs_cntbt_longest(
>> +	struct xfs_btree_cur	*cnt_cur,
>> +	xfs_extlen_t		*longest)
>> +{
>> +	struct xfs_alloc_rec_incore irec;
>> +	union xfs_btree_rec	    *rec;
>> +	int			    stat = 0;
>> +	int			    error;
>> +
>> +	memset(&cnt_cur->bc_rec, 0xFF, sizeof(cnt_cur->bc_rec));
>> +	error = xfs_btree_lookup(cnt_cur, XFS_LOOKUP_LE, &stat);
>> +	if (error)
>> +		return error;
>> +	if (!stat) {
>> +		/* totally empty tree */
>> +		*longest = 0;
>> +		return 0;
>> +	}
>> +
>> +	error = xfs_btree_get_rec(cnt_cur, &rec, &stat);
>> +	if (error)
>> +		return error;
>> +	if (!stat) {
>> +		ASSERT(0);
>> +		*longest = 0;
>> +		return 0;
>> +	}
>> +
>> +	xfs_alloc_btrec_to_irec(rec, &irec);
>> +	*longest = irec.ar_blockcount;
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Update the longest contiguous free extent in the AG from the by-count cursor
>> + * that is passed to us. This should be done at the end of any allocation or
>> + * freeing operation that touches the longest extent in the btree.
>> + *
>> + * Needing to update the longest extent can be determined by calling
>> + * xfs_alloc_cursor_at_lastrec() after the cursor is positioned for record
>> + * modification but before the modification begins.
>> + */
>> +static int
>> +xfs_alloc_fixup_longest(
>> +	struct xfs_btree_cur	*cnt_cur)
>> +{
>> +	struct xfs_perag	*pag = cnt_cur->bc_ag.pag;
>> +	struct xfs_buf		*bp = cnt_cur->bc_ag.agbp;
>> +	struct xfs_agf		*agf = bp->b_addr;
>> +	xfs_extlen_t		longest = 0;
>> +	int			error;
>> +
>> +	/* Lookup last rec in order to update AGF. */
>> +	error = xfs_cntbt_longest(cnt_cur, &longest);
>> +	if (error)
>> +		return error;
>> +
>> +	pag->pagf_longest = longest;
>> +	agf->agf_longest = cpu_to_be32(pag->pagf_longest);
>> +	xfs_alloc_log_agf(cnt_cur->bc_tp, bp, XFS_AGF_LONGEST);
>> +
>> +	return 0;
>> +}
>> +
>>   /*
>>    * Update the two btrees, logically removing from freespace the extent
>>    * starting at rbno, rlen blocks.  The extent is contained within the
>> @@ -489,6 +583,7 @@ xfs_alloc_fixup_trees(
>>   	xfs_extlen_t	nflen1=0;	/* first new free length */
>>   	xfs_extlen_t	nflen2=0;	/* second new free length */
>>   	struct xfs_mount *mp;
>> +	bool		fixup_longest = false;
>>   
>>   	mp = cnt_cur->bc_mp;
>>   
>> @@ -577,6 +672,10 @@ xfs_alloc_fixup_trees(
>>   		nfbno2 = rbno + rlen;
>>   		nflen2 = (fbno + flen) - nfbno2;
>>   	}
>> +
>> +	if (xfs_alloc_cursor_at_lastrec(cnt_cur))
>> +		fixup_longest = true;
>> +
>>   	/*
>>   	 * Delete the entry from the by-size btree.
>>   	 */
>> @@ -654,6 +753,10 @@ xfs_alloc_fixup_trees(
>>   			return -EFSCORRUPTED;
>>   		}
>>   	}
>> +
>> +	if (fixup_longest)
>> +		return xfs_alloc_fixup_longest(cnt_cur);
>> +
>>   	return 0;
>>   }
>>   
>> @@ -1956,6 +2059,7 @@ xfs_free_ag_extent(
>>   	int				i;
>>   	int				error;
>>   	struct xfs_perag		*pag = agbp->b_pag;
>> +	bool				fixup_longest = false;
>>   
>>   	bno_cur = cnt_cur = NULL;
>>   	mp = tp->t_mountp;
>> @@ -2219,8 +2323,13 @@ xfs_free_ag_extent(
>>   	}
>>   	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
>>   	bno_cur = NULL;
>> +
>>   	/*
>>   	 * In all cases we need to insert the new freespace in the by-size tree.
>> +	 *
>> +	 * If this new freespace is being inserted in the block that contains
>> +	 * the largest free space in the btree, make sure we also fix up the
>> +	 * agf->agf-longest tracker field.
>>   	 */
>>   	if ((error = xfs_alloc_lookup_eq(cnt_cur, nbno, nlen, &i)))
>>   		goto error0;
>> @@ -2229,6 +2338,8 @@ xfs_free_ag_extent(
>>   		error = -EFSCORRUPTED;
>>   		goto error0;
>>   	}
>> +	if (xfs_alloc_cursor_at_lastrec(cnt_cur))
>> +		fixup_longest = true;
>>   	if ((error = xfs_btree_insert(cnt_cur, &i)))
>>   		goto error0;
>>   	if (XFS_IS_CORRUPT(mp, i != 1)) {
>> @@ -2236,6 +2347,12 @@ xfs_free_ag_extent(
>>   		error = -EFSCORRUPTED;
>>   		goto error0;
>>   	}
>> +	if (fixup_longest) {
>> +		error = xfs_alloc_fixup_longest(cnt_cur);
>> +		if (error)
>> +			goto error0;
>> +	}
>> +
>>   	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
>>   	cnt_cur = NULL;
>>   
>> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
>> index 6ef5ddd89600..585e98e87ef9 100644
>> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
>> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
>> @@ -115,67 +115,6 @@ xfs_allocbt_free_block(
>>   	return 0;
>>   }
>>   
>> -/*
>> - * Update the longest extent in the AGF
>> - */
>> -STATIC void
>> -xfs_allocbt_update_lastrec(
>> -	struct xfs_btree_cur		*cur,
>> -	const struct xfs_btree_block	*block,
>> -	const union xfs_btree_rec	*rec,
>> -	int				ptr,
>> -	int				reason)
>> -{
>> -	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
>> -	struct xfs_perag	*pag;
>> -	__be32			len;
>> -	int			numrecs;
>> -
>> -	ASSERT(!xfs_btree_is_bno(cur->bc_ops));
>> -
>> -	switch (reason) {
>> -	case LASTREC_UPDATE:
>> -		/*
>> -		 * If this is the last leaf block and it's the last record,
>> -		 * then update the size of the longest extent in the AG.
>> -		 */
>> -		if (ptr != xfs_btree_get_numrecs(block))
>> -			return;
>> -		len = rec->alloc.ar_blockcount;
>> -		break;
>> -	case LASTREC_INSREC:
>> -		if (be32_to_cpu(rec->alloc.ar_blockcount) <=
>> -		    be32_to_cpu(agf->agf_longest))
>> -			return;
>> -		len = rec->alloc.ar_blockcount;
>> -		break;
>> -	case LASTREC_DELREC:
>> -		numrecs = xfs_btree_get_numrecs(block);
>> -		if (ptr <= numrecs)
>> -			return;
>> -		ASSERT(ptr == numrecs + 1);
>> -
>> -		if (numrecs) {
>> -			xfs_alloc_rec_t *rrp;
>> -
>> -			rrp = XFS_ALLOC_REC_ADDR(cur->bc_mp, block, numrecs);
>> -			len = rrp->ar_blockcount;
>> -		} else {
>> -			len = 0;
>> -		}
>> -
>> -		break;
>> -	default:
>> -		ASSERT(0);
>> -		return;
>> -	}
>> -
>> -	agf->agf_longest = len;
>> -	pag = cur->bc_ag.agbp->b_pag;
>> -	pag->pagf_longest = be32_to_cpu(len);
>> -	xfs_alloc_log_agf(cur->bc_tp, cur->bc_ag.agbp, XFS_AGF_LONGEST);
>> -}
>> -
>>   STATIC int
>>   xfs_allocbt_get_minrecs(
>>   	struct xfs_btree_cur	*cur,
>> @@ -493,7 +432,6 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
>>   	.set_root		= xfs_allocbt_set_root,
>>   	.alloc_block		= xfs_allocbt_alloc_block,
>>   	.free_block		= xfs_allocbt_free_block,
>> -	.update_lastrec		= xfs_allocbt_update_lastrec,
>>   	.get_minrecs		= xfs_allocbt_get_minrecs,
>>   	.get_maxrecs		= xfs_allocbt_get_maxrecs,
>>   	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
>> @@ -511,7 +449,6 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
>>   const struct xfs_btree_ops xfs_cntbt_ops = {
>>   	.name			= "cnt",
>>   	.type			= XFS_BTREE_TYPE_AG,
>> -	.geom_flags		= XFS_BTGEO_LASTREC_UPDATE,
>>   
>>   	.rec_len		= sizeof(xfs_alloc_rec_t),
>>   	.key_len		= sizeof(xfs_alloc_key_t),
>> @@ -525,7 +462,6 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
>>   	.set_root		= xfs_allocbt_set_root,
>>   	.alloc_block		= xfs_allocbt_alloc_block,
>>   	.free_block		= xfs_allocbt_free_block,
>> -	.update_lastrec		= xfs_allocbt_update_lastrec,
>>   	.get_minrecs		= xfs_allocbt_get_minrecs,
>>   	.get_maxrecs		= xfs_allocbt_get_maxrecs,
>>   	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
>> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
>> index d29547572a68..a5c4af148853 100644
>> --- a/fs/xfs/libxfs/xfs_btree.c
>> +++ b/fs/xfs/libxfs/xfs_btree.c
>> @@ -1331,30 +1331,6 @@ xfs_btree_init_block_cur(
>>   			xfs_btree_owner(cur));
>>   }
>>   
>> -/*
>> - * Return true if ptr is the last record in the btree and
>> - * we need to track updates to this record.  The decision
>> - * will be further refined in the update_lastrec method.
>> - */
>> -STATIC int
>> -xfs_btree_is_lastrec(
>> -	struct xfs_btree_cur	*cur,
>> -	struct xfs_btree_block	*block,
>> -	int			level)
>> -{
>> -	union xfs_btree_ptr	ptr;
>> -
>> -	if (level > 0)
>> -		return 0;
>> -	if (!(cur->bc_ops->geom_flags & XFS_BTGEO_LASTREC_UPDATE))
>> -		return 0;
>> -
>> -	xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
>> -	if (!xfs_btree_ptr_is_null(cur, &ptr))
>> -		return 0;
>> -	return 1;
>> -}
>> -
>>   STATIC void
>>   xfs_btree_buf_to_ptr(
>>   	struct xfs_btree_cur	*cur,
>> @@ -2420,15 +2396,6 @@ xfs_btree_update(
>>   	xfs_btree_copy_recs(cur, rp, rec, 1);
>>   	xfs_btree_log_recs(cur, bp, ptr, ptr);
>>   
>> -	/*
>> -	 * If we are tracking the last record in the tree and
>> -	 * we are at the far right edge of the tree, update it.
>> -	 */
>> -	if (xfs_btree_is_lastrec(cur, block, 0)) {
>> -		cur->bc_ops->update_lastrec(cur, block, rec,
>> -					    ptr, LASTREC_UPDATE);
>> -	}
>> -
>>   	/* Pass new key value up to our parent. */
>>   	if (xfs_btree_needs_key_update(cur, ptr)) {
>>   		error = xfs_btree_update_keys(cur, 0);
>> @@ -3617,15 +3584,6 @@ xfs_btree_insrec(
>>   			goto error0;
>>   	}
>>   
>> -	/*
>> -	 * If we are tracking the last record in the tree and
>> -	 * we are at the far right edge of the tree, update it.
>> -	 */
>> -	if (xfs_btree_is_lastrec(cur, block, level)) {
>> -		cur->bc_ops->update_lastrec(cur, block, rec,
>> -					    ptr, LASTREC_INSREC);
>> -	}
>> -
>>   	/*
>>   	 * Return the new block number, if any.
>>   	 * If there is one, give back a record value and a cursor too.
>> @@ -3983,15 +3941,6 @@ xfs_btree_delrec(
>>   	xfs_btree_set_numrecs(block, --numrecs);
>>   	xfs_btree_log_block(cur, bp, XFS_BB_NUMRECS);
>>   
>> -	/*
>> -	 * If we are tracking the last record in the tree and
>> -	 * we are at the far right edge of the tree, update it.
>> -	 */
>> -	if (xfs_btree_is_lastrec(cur, block, level)) {
>> -		cur->bc_ops->update_lastrec(cur, block, NULL,
>> -					    ptr, LASTREC_DELREC);
>> -	}
>> -
>>   	/*
>>   	 * We're at the root level.  First, shrink the root block in-memory.
>>   	 * Try to get rid of the next level down.  If we can't then there's
>> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
>> index f93374278aa1..10b7ddc3b2b3 100644
>> --- a/fs/xfs/libxfs/xfs_btree.h
>> +++ b/fs/xfs/libxfs/xfs_btree.h
>> @@ -154,12 +154,6 @@ struct xfs_btree_ops {
>>   			       int *stat);
>>   	int	(*free_block)(struct xfs_btree_cur *cur, struct xfs_buf *bp);
>>   
>> -	/* update last record information */
>> -	void	(*update_lastrec)(struct xfs_btree_cur *cur,
>> -				  const struct xfs_btree_block *block,
>> -				  const union xfs_btree_rec *rec,
>> -				  int ptr, int reason);
>> -
>>   	/* records in block/level */
>>   	int	(*get_minrecs)(struct xfs_btree_cur *cur, int level);
>>   	int	(*get_maxrecs)(struct xfs_btree_cur *cur, int level);
>> @@ -222,15 +216,7 @@ struct xfs_btree_ops {
>>   };
>>   
>>   /* btree geometry flags */
>> -#define XFS_BTGEO_LASTREC_UPDATE	(1U << 0) /* track last rec externally */
>> -#define XFS_BTGEO_OVERLAPPING		(1U << 1) /* overlapping intervals */
>> -
>> -/*
>> - * Reasons for the update_lastrec method to be called.
>> - */
>> -#define LASTREC_UPDATE	0
>> -#define LASTREC_INSREC	1
>> -#define LASTREC_DELREC	2
>> +#define XFS_BTGEO_OVERLAPPING		(1U << 0) /* overlapping intervals */
>>   
>>   
>>   union xfs_btree_irec {
>> -- 
>> 2.39.2
>>
>>
> 

