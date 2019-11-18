Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34627100DAF
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Nov 2019 22:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfKRV3m (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 18 Nov 2019 16:29:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51546 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfKRV3m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Nov 2019 16:29:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAILTQ9P165069;
        Mon, 18 Nov 2019 21:29:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ce3iPFoVXrsqU7eNhCyFZZirA39RnRF2o0Z8yrX+f28=;
 b=HsvaMbENffLlJcFHNjUQG8BfyUSIHKLpa3a8yG0gHN3tsaId0ncr9rrrKyit3oxje9L6
 4xbK4aow+cwJVXIKTa9+it8cf2zhFnvQ6P0LxeRWb1mnSWS2Ea9h20u01DyyzxAtohaL
 N8iTdr6foNDZ75EL3lMthMuPDteEi+iH3u4pqvVy74xoRurWX/ROBH08h+I8aFaH4W5R
 Cff/uFHiRL24MTs1VXuOJJqQztwU7exDbgW3jYMtE4D0Pl0sR8l4xLMJY/o0YtAc/aFo
 5nb/ngSK7j3yOd9rMuM1HwfHg9Q9Zu3duUzu5AMQwPKE7ERGZ2LKQLY1aJB+UPUVFw8W 7Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wa9rqaxfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 21:29:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAILDdMl135430;
        Mon, 18 Nov 2019 21:29:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2wc09w8bc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 21:29:37 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAILTaAf008467;
        Mon, 18 Nov 2019 21:29:36 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 13:29:36 -0800
Date:   Mon, 18 Nov 2019 13:29:35 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 8/9] xfs: remove the mappedbno argument to xfs_da_read_buf
Message-ID: <20191118212935.GD6219@magnolia>
References: <20191116182214.23711-1-hch@lst.de>
 <20191116182214.23711-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116182214.23711-9-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911180184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911180185
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 16, 2019 at 07:22:13PM +0100, Christoph Hellwig wrote:
> Move the code for reading an already mapped block into
> xfs_da3_node_read_mapped, which is the only caller ever passing a block
> number in the mappedbno argument and replace the mappedbno argument with
> the simple xfs_dabuf_get flags.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c  |  2 +-
>  fs/xfs/libxfs/xfs_da_btree.c   | 34 ++++++++++++++++------------------
>  fs/xfs/libxfs/xfs_da_btree.h   |  5 ++---
>  fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
>  fs/xfs/libxfs/xfs_dir2_data.c  |  6 +++---
>  fs/xfs/libxfs/xfs_dir2_leaf.c  | 13 ++++++-------
>  fs/xfs/libxfs/xfs_dir2_node.c  | 14 +++++++-------
>  fs/xfs/libxfs/xfs_dir2_priv.h  |  4 ++--
>  fs/xfs/scrub/dabtree.c         |  4 ++--
>  fs/xfs/scrub/dir.c             |  9 +++++----
>  fs/xfs/xfs_dir2_readdir.c      |  2 +-
>  11 files changed, 47 insertions(+), 50 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 9c0cdb51955e..450e75cc7c93 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -434,7 +434,7 @@ xfs_attr3_leaf_read(
>  {
>  	int			err;
>  
> -	err = xfs_da_read_buf(tp, dp, bno, -1, bpp, XFS_ATTR_FORK,
> +	err = xfs_da_read_buf(tp, dp, bno, 0, bpp, XFS_ATTR_FORK,
>  			&xfs_attr3_leaf_buf_ops);
>  	if (!err && tp && *bpp)
>  		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_ATTR_LEAF_BUF);
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 489936e01c33..34d0ce93bcc3 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -369,7 +369,7 @@ xfs_da3_node_read(
>  {
>  	int			error;
>  
> -	error = xfs_da_read_buf(tp, dp, bno, -1, bpp, whichfork,
> +	error = xfs_da_read_buf(tp, dp, bno, 0, bpp, whichfork,
>  			&xfs_da3_node_buf_ops);
>  	if (error || !*bpp || !tp)
>  		return error;
> @@ -384,12 +384,22 @@ xfs_da3_node_read_mapped(
>  	struct xfs_buf		**bpp,
>  	int			whichfork)
>  {
> +	struct xfs_mount	*mp = dp->i_mount;
>  	int			error;
>  
> -	error = xfs_da_read_buf(tp, dp, 0, mappedbno, bpp, whichfork,
> -			&xfs_da3_node_buf_ops);
> -	if (error || !*bpp || !tp)
> +	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, mappedbno,
> +			XFS_FSB_TO_BB(mp, xfs_dabuf_nfsb(mp, whichfork)), 0,
> +			bpp, &xfs_da3_node_buf_ops);
> +	if (error || !*bpp)
>  		return error;
> +
> +	if (whichfork == XFS_ATTR_FORK)
> +		xfs_buf_set_ref(*bpp, XFS_ATTR_BTREE_REF);
> +	else
> +		xfs_buf_set_ref(*bpp, XFS_DIR_BTREE_REF);
> +
> +	if (!tp)
> +		return 0;
>  	return xfs_da3_node_set_type(tp, *bpp);
>  }
>  
> @@ -2710,7 +2720,7 @@ xfs_da_read_buf(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*dp,
>  	xfs_dablk_t		bno,
> -	xfs_daddr_t		mappedbno,
> +	unsigned int		flags,
>  	struct xfs_buf		**bpp,
>  	int			whichfork,
>  	const struct xfs_buf_ops *ops)
> @@ -2722,18 +2732,7 @@ xfs_da_read_buf(
>  	int			error;
>  
>  	*bpp = NULL;
> -
> -	if (mappedbno >= 0) {
> -		error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
> -				mappedbno, XFS_FSB_TO_BB(mp,
> -					xfs_dabuf_nfsb(mp, whichfork)),
> -				0, &bp, ops);
> -		goto done;
> -	}
> -
> -	error = xfs_dabuf_map(dp, bno,
> -			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
> -			whichfork, &mapp, &nmap);
> +	error = xfs_dabuf_map(dp, bno, flags, whichfork, &mapp, &nmap);
>  	if (error) {
>  		/* mapping a hole is not an error, but we don't continue */
>  		if (error == -ENOENT)
> @@ -2743,7 +2742,6 @@ xfs_da_read_buf(
>  
>  	error = xfs_trans_read_buf_map(mp, tp, mp->m_ddev_targp, mapp, nmap, 0,
>  			&bp, ops);
> -done:
>  	if (error)
>  		goto out_free;
>  
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 74eeb97852d8..1c8347af8071 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -216,9 +216,8 @@ int	xfs_da_get_buf(struct xfs_trans *trans, struct xfs_inode *dp,
>  			      xfs_dablk_t bno, xfs_daddr_t mappedbno,
>  			      struct xfs_buf **bp, int whichfork);
>  int	xfs_da_read_buf(struct xfs_trans *trans, struct xfs_inode *dp,
> -			       xfs_dablk_t bno, xfs_daddr_t mappedbno,
> -			       struct xfs_buf **bpp, int whichfork,
> -			       const struct xfs_buf_ops *ops);
> +		xfs_dablk_t bno, unsigned int flags, struct xfs_buf **bpp,
> +		int whichfork, const struct xfs_buf_ops *ops);
>  int	xfs_da_reada_buf(struct xfs_inode *dp, xfs_dablk_t bno,
>  		unsigned int flags, int whichfork,
>  		const struct xfs_buf_ops *ops);
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 358151ddfa75..e287b3b87006 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -123,7 +123,7 @@ xfs_dir3_block_read(
>  	struct xfs_mount	*mp = dp->i_mount;
>  	int			err;
>  
> -	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk, -1, bpp,
> +	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk, 0, bpp,
>  				XFS_DATA_FORK, &xfs_dir3_block_buf_ops);
>  	if (!err && tp && *bpp)
>  		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_BLOCK_BUF);
> @@ -952,7 +952,7 @@ xfs_dir2_leaf_to_block(
>  	 * Read the data block if we don't already have it, give up if it fails.
>  	 */
>  	if (!dbp) {
> -		error = xfs_dir3_data_read(tp, dp, args->geo->datablk, -1, &dbp);
> +		error = xfs_dir3_data_read(tp, dp, args->geo->datablk, 0, &dbp);
>  		if (error)
>  			return error;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 10680f6422c2..9ac08df96b3f 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -401,13 +401,13 @@ xfs_dir3_data_read(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*dp,
>  	xfs_dablk_t		bno,
> -	xfs_daddr_t		mapped_bno,
> +	unsigned int		flags,
>  	struct xfs_buf		**bpp)
>  {
>  	int			err;
>  
> -	err = xfs_da_read_buf(tp, dp, bno, mapped_bno, bpp,
> -				XFS_DATA_FORK, &xfs_dir3_data_buf_ops);
> +	err = xfs_da_read_buf(tp, dp, bno, flags, bpp, XFS_DATA_FORK,
> +			&xfs_dir3_data_buf_ops);
>  	if (!err && tp && *bpp)
>  		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_DATA_BUF);
>  	return err;
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index a1fe45db61c3..0107a661acd8 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -266,7 +266,7 @@ xfs_dir3_leaf_read(
>  {
>  	int			err;
>  
> -	err = xfs_da_read_buf(tp, dp, fbno, -1, bpp, XFS_DATA_FORK,
> +	err = xfs_da_read_buf(tp, dp, fbno, 0, bpp, XFS_DATA_FORK,
>  			&xfs_dir3_leaf1_buf_ops);
>  	if (!err && tp && *bpp)
>  		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_LEAF1_BUF);
> @@ -282,7 +282,7 @@ xfs_dir3_leafn_read(
>  {
>  	int			err;
>  
> -	err = xfs_da_read_buf(tp, dp, fbno, -1, bpp, XFS_DATA_FORK,
> +	err = xfs_da_read_buf(tp, dp, fbno, 0, bpp, XFS_DATA_FORK,
>  			&xfs_dir3_leafn_buf_ops);
>  	if (!err && tp && *bpp)
>  		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_LEAFN_BUF);
> @@ -826,7 +826,7 @@ xfs_dir2_leaf_addname(
>  		 */
>  		error = xfs_dir3_data_read(tp, dp,
>  				   xfs_dir2_db_to_da(args->geo, use_block),
> -				   -1, &dbp);
> +				   0, &dbp);
>  		if (error) {
>  			xfs_trans_brelse(tp, lbp);
>  			return error;
> @@ -1268,7 +1268,7 @@ xfs_dir2_leaf_lookup_int(
>  				xfs_trans_brelse(tp, dbp);
>  			error = xfs_dir3_data_read(tp, dp,
>  					   xfs_dir2_db_to_da(args->geo, newdb),
> -					   -1, &dbp);
> +					   0, &dbp);
>  			if (error) {
>  				xfs_trans_brelse(tp, lbp);
>  				return error;
> @@ -1310,7 +1310,7 @@ xfs_dir2_leaf_lookup_int(
>  			xfs_trans_brelse(tp, dbp);
>  			error = xfs_dir3_data_read(tp, dp,
>  					   xfs_dir2_db_to_da(args->geo, cidb),
> -					   -1, &dbp);
> +					   0, &dbp);
>  			if (error) {
>  				xfs_trans_brelse(tp, lbp);
>  				return error;
> @@ -1602,8 +1602,7 @@ xfs_dir2_leaf_trim_data(
>  	/*
>  	 * Read the offending data block.  We need its buffer.
>  	 */
> -	error = xfs_dir3_data_read(tp, dp, xfs_dir2_db_to_da(geo, db), -1,
> -				   &dbp);
> +	error = xfs_dir3_data_read(tp, dp, xfs_dir2_db_to_da(geo, db), 0, &dbp);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index a5450229a7ef..cc1a20b69215 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -212,14 +212,14 @@ __xfs_dir3_free_read(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*dp,
>  	xfs_dablk_t		fbno,
> -	xfs_daddr_t		mappedbno,
> +	unsigned int		flags,
>  	struct xfs_buf		**bpp)
>  {
>  	xfs_failaddr_t		fa;
>  	int			err;
>  
> -	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
> -				XFS_DATA_FORK, &xfs_dir3_free_buf_ops);
> +	err = xfs_da_read_buf(tp, dp, fbno, flags, bpp, XFS_DATA_FORK,
> +			&xfs_dir3_free_buf_ops);
>  	if (err || !*bpp)
>  		return err;
>  
> @@ -297,7 +297,7 @@ xfs_dir2_free_read(
>  	xfs_dablk_t		fbno,
>  	struct xfs_buf		**bpp)
>  {
> -	return __xfs_dir3_free_read(tp, dp, fbno, -1, bpp);
> +	return __xfs_dir3_free_read(tp, dp, fbno, 0, bpp);
>  }
>  
>  static int
> @@ -307,7 +307,7 @@ xfs_dir2_free_try_read(
>  	xfs_dablk_t		fbno,
>  	struct xfs_buf		**bpp)
>  {
> -	return __xfs_dir3_free_read(tp, dp, fbno, -2, bpp);
> +	return __xfs_dir3_free_read(tp, dp, fbno, XFS_DABUF_MAP_HOLE_OK, bpp);
>  }
>  
>  static int
> @@ -858,7 +858,7 @@ xfs_dir2_leafn_lookup_for_entry(
>  				error = xfs_dir3_data_read(tp, dp,
>  						xfs_dir2_db_to_da(args->geo,
>  								  newdb),
> -						-1, &curbp);
> +						0, &curbp);
>  				if (error)
>  					return error;
>  			}
> @@ -1940,7 +1940,7 @@ xfs_dir2_node_addname_int(
>  		/* Read the data block in. */
>  		error = xfs_dir3_data_read(tp, dp,
>  					   xfs_dir2_db_to_da(args->geo, dbno),
> -					   -1, &dbp);
> +					   0, &dbp);
>  	}
>  	if (error)
>  		return error;
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 3001cf82baa6..13b80d0d264b 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -74,8 +74,8 @@ extern void xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
>  
>  extern xfs_failaddr_t __xfs_dir3_data_check(struct xfs_inode *dp,
>  		struct xfs_buf *bp);
> -extern int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
> -		xfs_dablk_t bno, xfs_daddr_t mapped_bno, struct xfs_buf **bpp);
> +int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
> +		xfs_dablk_t bno, unsigned int flags, struct xfs_buf **bpp);
>  int xfs_dir3_data_readahead(struct xfs_inode *dp, xfs_dablk_t bno,
>  		unsigned int flags);
>  
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index 85b9207359ec..97a15b6f2865 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -331,8 +331,8 @@ xchk_da_btree_block(
>  		goto out_nobuf;
>  
>  	/* Read the buffer. */
> -	error = xfs_da_read_buf(dargs->trans, dargs->dp, blk->blkno, -2,
> -			&blk->bp, dargs->whichfork,
> +	error = xfs_da_read_buf(dargs->trans, dargs->dp, blk->blkno,
> +			XFS_DABUF_MAP_HOLE_OK, &blk->bp, dargs->whichfork,
>  			&xchk_da_btree_buf_ops);
>  	if (!xchk_da_process_error(ds, level, &error))
>  		goto out_nobuf;
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 910e0bf85bd7..266da4e4bde6 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -229,7 +229,8 @@ xchk_dir_rec(
>  		xchk_da_set_corrupt(ds, level);
>  		goto out;
>  	}
> -	error = xfs_dir3_data_read(ds->dargs.trans, dp, rec_bno, -2, &bp);
> +	error = xfs_dir3_data_read(ds->dargs.trans, dp, rec_bno,
> +			XFS_DABUF_MAP_HOLE_OK, &bp);
>  	if (!xchk_fblock_process_error(ds->sc, XFS_DATA_FORK, rec_bno,
>  			&error))
>  		goto out;
> @@ -346,7 +347,7 @@ xchk_directory_data_bestfree(
>  		error = xfs_dir3_block_read(sc->tp, sc->ip, &bp);
>  	} else {
>  		/* dir data format */
> -		error = xfs_dir3_data_read(sc->tp, sc->ip, lblk, -1, &bp);
> +		error = xfs_dir3_data_read(sc->tp, sc->ip, lblk, 0, &bp);
>  	}
>  	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
>  		goto out;
> @@ -557,7 +558,7 @@ xchk_directory_leaf1_bestfree(
>  		if (best == NULLDATAOFF)
>  			continue;
>  		error = xfs_dir3_data_read(sc->tp, sc->ip,
> -				i * args->geo->fsbcount, -1, &dbp);
> +				i * args->geo->fsbcount, 0, &dbp);
>  		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
>  				&error))
>  			break;
> @@ -608,7 +609,7 @@ xchk_directory_free_bestfree(
>  		}
>  		error = xfs_dir3_data_read(sc->tp, sc->ip,
>  				(freehdr.firstdb + i) * args->geo->fsbcount,
> -				-1, &dbp);
> +				0, &dbp);
>  		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
>  				&error))
>  			break;
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index f23f3b23ec37..a01d4bb45cee 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -280,7 +280,7 @@ xfs_dir2_leaf_readbuf(
>  	new_off = xfs_dir2_da_to_byte(geo, map.br_startoff);
>  	if (new_off > *cur_off)
>  		*cur_off = new_off;
> -	error = xfs_dir3_data_read(args->trans, dp, map.br_startoff, -1, &bp);
> +	error = xfs_dir3_data_read(args->trans, dp, map.br_startoff, 0, &bp);
>  	if (error)
>  		goto out;
>  
> -- 
> 2.20.1
> 
