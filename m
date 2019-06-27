Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEAB58552
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Jun 2019 17:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfF0PNR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Jun 2019 11:13:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42504 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfF0PNR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 11:13:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5RF8VhL174949;
        Thu, 27 Jun 2019 15:13:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=ey0WSLTBN7NyZL+7CFUJpr/Edgc2xrzTWaBKkdBtXA8=;
 b=n84Xcs1rb0rf4yTdHPJtHKA0O8yv5O7FuLRxkqGX/ZNePOzzRBwCdbEk+ze8ofjAkr6C
 YXWS9fyt1+GT7oBGKKqcWNkqnYrOdkDZUJwn4h3xuN6WG8FWY7hYt8WFw1izMe/NJ57D
 OpfAODnBXxYZrmu41uUHGBduvJ2+P2Nr10PBZ81FwJ5VCJj6mDgQGEQ03LO85vxc4euq
 UWgbAA/i/mm9JZLWMqp/0qOUJ3PHzjItcdBpEz4MP5g0Z2hPd5Pq79o92Erd/RWl8bVz
 PuzIk8HKxN0wDOJ2nU5G0PEvjcWiSyZ1VC5cY9fYZnmj1cm4IqRJsD/h7UdiSEtzVt8V oQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2t9c9q0xut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 15:13:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5RFBwWK195344;
        Thu, 27 Jun 2019 15:13:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2t99f52wx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 15:13:11 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5RFD8rs008675;
        Thu, 27 Jun 2019 15:13:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Jun 2019 08:13:08 -0700
Date:   Thu, 27 Jun 2019 08:13:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: fix iclog allocation size
Message-ID: <20190627151307.GM5171@magnolia>
References: <20190627143950.19558-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627143950.19558-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9301 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906270177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9301 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906270177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 27, 2019 at 04:39:50PM +0200, Christoph Hellwig wrote:
> Properly allocate the space for the bio_vecs instead of just one byte
> per bio_vec.
> 
> Fixes: 991fc1d2e65e ("xfs: use bios directly to write log buffers")
> Reported-by: syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Doh....

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 0f849b4095d6..e230f3c18ceb 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1415,7 +1415,8 @@ xlog_alloc_log(
>  	 */
>  	ASSERT(log->l_iclog_size >= 4096);
>  	for (i = 0; i < log->l_iclog_bufs; i++) {
> -		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE);
> +		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE) *
> +				sizeof(struct bio_vec);
>  
>  		iclog = kmem_zalloc(sizeof(*iclog) + bvec_size, KM_MAYFAIL);
>  		if (!iclog)
> -- 
> 2.20.1
> 
