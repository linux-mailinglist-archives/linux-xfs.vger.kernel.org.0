Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07F917AB38
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2019 16:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729985AbfG3Ole (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Jul 2019 10:41:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35456 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729908AbfG3Old (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jul 2019 10:41:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6UEdMY9116600;
        Tue, 30 Jul 2019 14:41:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=cuzaUqVFKfxxZPrtZonQ6fI4cI9Il+2XFjdS69q+tWY=;
 b=ZF9cgKZTjiF4K1t1gX24TwYiZmDNrvK+GkJc4+W+KYmHsP+EkXGJ4XX6fILYt0hBJaBo
 460RLDUj5dikrtkDucOLKdo5apn3AsDDD3B9jgutESX5v9qOXUql0hR4vnYt97z4vZLY
 SC2zn2CAAG8V+dTypLtL1yfs1/rSmRmtny9UmnRpUaKuUEN8OzFZMbRYo8m6x7i0//Xg
 qrgxK+bnHs4WL+sLZbkX6g0r8tvL048H4Y+jtxmIjSlaLXtgOq6fpQKEYq3dbf3aywRx
 2befN7v5l/hi0NH1mc+wQ670USAh/fsUWnXO33VvxnTDs93+7eT6QEymymxENKOPsr4p +Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2u0f8qxw1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 14:41:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6UEbv0B083346;
        Tue, 30 Jul 2019 14:41:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2u0bqu75nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 14:41:24 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6UEfNOR030003;
        Tue, 30 Jul 2019 14:41:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jul 2019 07:41:22 -0700
Date:   Tue, 30 Jul 2019 07:41:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     bfoster@redhat.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fs: xfs: Fix possible null-pointer dereferences in
 xchk_da_btree_block_check_sibling()
Message-ID: <20190730144122.GP1561054@magnolia>
References: <20190730023206.14587-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730023206.14587-1-baijiaju1990@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9334 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907300151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9334 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907300152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 30, 2019 at 10:32:06AM +0800, Jia-Ju Bai wrote:
> In xchk_da_btree_block_check_sibling(), there is an if statement on
> line 274 to check whether ds->state->altpath.blk[level].bp is NULL:
>     if (ds->state->altpath.blk[level].bp)
> 
> When ds->state->altpath.blk[level].bp is NULL, it is used on line 281:
>     xfs_trans_brelse(..., ds->state->altpath.blk[level].bp);
>         struct xfs_buf_log_item *bip = bp->b_log_item;
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

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> v2:
> * Adjust the code and add an assignment. 
>   Thank Darrick J. Wong for helpful advice. 
> 
> ---
>  fs/xfs/scrub/dabtree.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index 94c4f1de1922..77ff9f97bcda 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -278,7 +278,11 @@ xchk_da_btree_block_check_sibling(
>  	/* Compare upper level pointer to sibling pointer. */
>  	if (ds->state->altpath.blk[level].blkno != sibling)
>  		xchk_da_set_corrupt(ds, level);
> -	xfs_trans_brelse(ds->dargs.trans, ds->state->altpath.blk[level].bp);
> +	if (ds->state->altpath.blk[level].bp) {
> +		xfs_trans_brelse(ds->dargs.trans,
> +				ds->state->altpath.blk[level].bp);
> +		ds->state->altpath.blk[level].bp = NULL;
> +	}
>  out:
>  	return error;
>  }
> -- 
> 2.17.0
> 
