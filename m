Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79BA24F209
	for <lists+linux-xfs@lfdr.de>; Sat, 22 Jun 2019 01:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbfFUX7Z (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 19:59:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50530 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbfFUX7Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 19:59:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LNvFfa054185;
        Fri, 21 Jun 2019 23:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=/y8tLOEETYuQmk1e3nB79zQIH8reKmGkhWgYr7DprD8=;
 b=Fd/1vTxAL4NVYoyKJNHVJ8t/9X8/8c3Ld8BNTDawIZQZvRj7yKCXbH7QdvYJCAVrEc2V
 s8wPAYsUfvGwC9w26P+a5wgWuTou0xh26PcXz0bdLF8prYoHPMMup2uPMkJOGqx1SJsZ
 AAI3yH86/enIYl22Xz8mwJLp0/fLtmaIjDJU7AvPTWM8ouZGdcbgsceHJn40b4Yn8AK7
 PC4Q4btdx74SaifA7TWOsmTxQByXbxe+RA6vMPYeLQ+A/1ySWrwyCJmFXYDjtgLfNkLg
 bskUozLyQlW47TdOh2qwZ6rDASXoylSWs8C1yyYfNZeqmjfnJbe2ur+fcvNlXPGC86Lw vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t7809rt16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 23:59:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LNvFfq108897;
        Fri, 21 Jun 2019 23:59:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2t77ypetnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 23:59:08 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5LNx72H012782;
        Fri, 21 Jun 2019 23:59:07 GMT
Received: from localhost (/10.159.131.214)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Jun 2019 16:59:07 -0700
Date:   Fri, 21 Jun 2019 16:59:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 04/11] xfs: always update params on small allocation
Message-ID: <20190621235906.GC5387@magnolia>
References: <20190522180546.17063-1-bfoster@redhat.com>
 <20190522180546.17063-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522180546.17063-5-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906210182
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906210182
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 22, 2019 at 02:05:39PM -0400, Brian Foster wrote:
> xfs_alloc_ag_vextent_small() doesn't update the output parameters in
> the event of an AGFL allocation. Instead, it updates the
> xfs_alloc_arg structure directly to complete the allocation.
> 
> Update both args and the output params to provide consistent
> behavior for future callers.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 436f8eb0bc4c..e2fa58f4d477 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -759,8 +759,8 @@ xfs_alloc_ag_vextent_small(
>  		}
>  		xfs_trans_binval(args->tp, bp);
>  	}
> -	args->len = 1;
> -	args->agbno = fbno;
> +	*fbnop = args->agbno = fbno;
> +	*flenp = args->len = 1;
>  	XFS_WANT_CORRUPTED_GOTO(args->mp,
>  		fbno < be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
>  		error);
> -- 
> 2.17.2
> 
