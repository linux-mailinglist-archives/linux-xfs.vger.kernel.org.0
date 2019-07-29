Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB764783DD
	for <lists+linux-xfs@lfdr.de>; Mon, 29 Jul 2019 06:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfG2EUx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 29 Jul 2019 00:20:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53078 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfG2EUw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jul 2019 00:20:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6T4JQ2t135574;
        Mon, 29 Jul 2019 04:20:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=KJOwyKfBt2HnHY+cw2gWHTBRREdfic7k/AhbXGx7f3g=;
 b=VzTddNoFOlQpv3f6xBFCY1P8iJGShnkogLd7tc2Kbo60tNv3szbv7GQRFD2RNLznRcpN
 KQ5M9CHRfmOBYqH2v5IVo3faYRJUaF2ZhFXBfKS+t9e1APU0UIKZyzaVNk0DFllddlTn
 LpbeCAh7F2oBXxNy7YVSj5e2Hqp6Sn3B2mw9bH06C/I0zWEujiIvYRt3jFo3HXRscjjz
 8d5n0rt9CUL1wZAal/y4ehlrTvZzb8xVtY/3eo8Kz/ocbLCB1l3LXuyp4cRFhfO++VoW
 qPHsuipHcnjPsDLxQ5jgCHcqf+FMFx+yEIItMXkn3EOUFaN4LJS4NQ5YkpeSX5dVeNzv rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2u0f8qmpw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Jul 2019 04:20:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6T4HnoI087007;
        Mon, 29 Jul 2019 04:20:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2u0bqt8xe6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Jul 2019 04:20:34 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6T4KXcq030951;
        Mon, 29 Jul 2019 04:20:33 GMT
Received: from localhost (/10.159.132.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 28 Jul 2019 21:20:32 -0700
Date:   Sun, 28 Jul 2019 21:20:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     bfoster@redhat.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: xfs: Fix possible null-pointer dereferences in
 xchk_da_btree_block_check_sibling()
Message-ID: <20190729042034.GM1561054@magnolia>
References: <20190729032401.28081-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729032401.28081-1-baijiaju1990@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9332 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907290052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9332 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907290052
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 29, 2019 at 11:24:01AM +0800, Jia-Ju Bai wrote:
> In xchk_da_btree_block_check_sibling(), there is an if statement on 
> line 274 to check whether ds->state->altpath.blk[level].bp is NULL:
>     if (ds->state->altpath.blk[level].bp)
> 
> When ds->state->altpath.blk[level].bp is NULL, it is used on line 281: 
>     xfs_trans_brelse(..., ds->state->altpath.blk[level].bp);
>         struct xfs_buf_log_item	*bip = bp->b_log_item;
>         ASSERT(bp->b_transp == tp);
> 
> Thus, possible null-pointer dereferences may occur.
> 
> To fix these bugs, ds->state->altpath.blk[level].bp is checked before
> being used.
> 
> These bugs are found by a static analysis tool STCheck written by us.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  fs/xfs/scrub/dabtree.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index 94c4f1de1922..33ff90c0dd70 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -278,7 +278,9 @@ xchk_da_btree_block_check_sibling(
>  	/* Compare upper level pointer to sibling pointer. */
>  	if (ds->state->altpath.blk[level].blkno != sibling)
>  		xchk_da_set_corrupt(ds, level);
> -	xfs_trans_brelse(ds->dargs.trans, ds->state->altpath.blk[level].bp);
> +	if (ds->state->altpath.blk[level].bp)
> +		xfs_trans_brelse(ds->dargs.trans, 
> +						ds->state->altpath.blk[level].bp);

Indentation here (in xfs we use two spaces)

Also, uh, shouldn't we set ds->state->altpath.blk[level].bp to NULL
since we've released the buffer?

--D

>  out:
>  	return error;
>  }
> -- 
> 2.17.0
> 
