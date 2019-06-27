Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5981058585
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Jun 2019 17:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfF0P1X (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Jun 2019 11:27:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33216 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfF0P1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 11:27:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5RFOMWC080276;
        Thu, 27 Jun 2019 15:26:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=nAWucu9SyumY3cWlPIQTvZjPFkXl1Zmmfj8lYBo0gi0=;
 b=HPf1FoygBZJOdvV5uJ/5J7gMppCi1SIhOmuRBJY/rvhVrFw5ruHJqlmkSJ7w9Hle2Ux2
 IiDbQTJKHCYtxih7lTcgmMPBZumTY/Xn0D5pBhOSaHAxYx0HDyw5vUbnmAnYHyxBw1kh
 3aXKeTgKHtKKe6x8YyEkSUzWzD9NyHU/gwrItEykMbdnRjrAvpn9Ivc0j/8JmDaxbk02
 uPntewJENx0IdzSPtD3C+fHRecrK+WbjRj+TtsygKfQZG8gYgDlyXZUCm0FxwPM+jFcj
 VixPy7Dyz+P5gVabl+6T2NAzqBu4Ou4Z9WrLaGhgSR8x7p6u6IAnWkoWeUUkVpI1POkF fA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t9cyqrxpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 15:26:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5RFPTdw094902;
        Thu, 27 Jun 2019 15:26:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tat7desuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 15:26:40 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5RFQdpU016219;
        Thu, 27 Jun 2019 15:26:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Jun 2019 08:26:39 -0700
Date:   Thu, 27 Jun 2019 08:26:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     hch@lst.de, dchinner@redhat.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH -next] xfs: remove duplicated include
Message-ID: <20190627152638.GN5171@magnolia>
References: <20190627073323.45516-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627073323.45516-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9301 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906270178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9301 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906270178
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 27, 2019 at 03:33:23PM +0800, YueHaibing wrote:
> Remove duplicated include.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

NAK, Eric Sandeen already sent this to the list.

--D

> ---
>  fs/xfs/xfs_extfree_item.c | 1 -
>  fs/xfs/xfs_filestream.c   | 1 -
>  fs/xfs/xfs_pnfs.c         | 1 -
>  3 files changed, 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 99fd40eb..e515506 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -13,7 +13,6 @@
>  #include "xfs_mount.h"
>  #include "xfs_defer.h"
>  #include "xfs_trans.h"
> -#include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_extfree_item.h"
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index b1869ae..a6d228c 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -21,7 +21,6 @@
>  #include "xfs_trace.h"
>  #include "xfs_ag_resv.h"
>  #include "xfs_trans.h"
> -#include "xfs_shared.h"
>  
>  struct xfs_fstrm_item {
>  	struct xfs_mru_cache_elem	mru;
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index 2d95355..6018e1c 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -17,7 +17,6 @@
>  #include "xfs_bmap_util.h"
>  #include "xfs_error.h"
>  #include "xfs_iomap.h"
> -#include "xfs_shared.h"
>  #include "xfs_bit.h"
>  #include "xfs_pnfs.h"
>  
> -- 
> 2.7.4
> 
> 
