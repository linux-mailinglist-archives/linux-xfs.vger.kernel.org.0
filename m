Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E60CE8A31C
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 18:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbfHLQO5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 12:14:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39048 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbfHLQO4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:14:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGEGkf137483
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:14:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=KcPsOFECZH7U1W92maiugy/4KWWlDrptwfTyemw7XVE=;
 b=cPKojqF+Ka0OpaHGs9WcWKcMVnqUkuDTWmnukWxLhgTQlkj++wB6A22v3Kad52f/CAgn
 O2drasNc4e9F71c/o8kIkcZdxkCEME1kDD3nxZyv4yZPqvKzsfJZbABjb1PQiVvnjEQt
 p0gJpWmByafn4ITlE/yVB3O1pStveuMKzucGlMVtW45mv4lvZXU5uQsQcg2pCUd4NRVI
 JAPR82bEV/vKdjk+S4IROn0kyuznpMDY5dUkz/+q/UA9prieGbDeqz6jppmCBos5pvrj
 tpgqwydQQdBncG0T+bjrWeUvo608F3xbiJQbNIbX5munbGcuWLNeK6piz+Y3NSmup56L 7Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=KcPsOFECZH7U1W92maiugy/4KWWlDrptwfTyemw7XVE=;
 b=uc7HHPdC0rHIGkIxPkbKB1wSZIGbB1wKRQurujeO2oflFDoHrb2ohtqLWUHIfRXO4Pjt
 ZAXXFrvM2JiuBf+JKL7iDWPycU+nA4C5Y0Oh37Zwp2YV2Ffxo0P0dwo8jymp3mgHPuN4
 JQXsC16BCgVZ9jcpWsQ1Vd/vXS78vksfMOZdu+UdFvO0DPTY7ZAYQUgP6lx9n5B4AdmR
 LgJwtxMvEHsNZrf3jlMr/cPk0JZUWBGyT82B2zULvceHRxwe1d8Oaf1gkhvcIziK2fGO
 mtbM1fRL7HpkAbrV11xKRmhJmv674Mj2BYbWttzn7OvDxCQhTlibOddXitNZX9aUsg6R Tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbt8qdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:14:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGDlG7034195
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:14:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2u9n9h1sj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:14:55 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CGEsc7012869
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:14:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 09:14:53 -0700
Date:   Mon, 12 Aug 2019 09:14:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 10/18] xfs: Factor up trans roll from
 xfs_attr3_leaf_setflag
Message-ID: <20190812161452.GY7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-11-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-11-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:37:18PM -0700, Allison Collins wrote:
> New delayed allocation routines cannot be handling
> transactions so factor them up into the calling functions
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c      | 5 +++++
>  fs/xfs/libxfs/xfs_attr_leaf.c | 5 +----
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 6bd87e6..7648ceb 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1239,6 +1239,11 @@ xfs_attr_node_removename(
>  		error = xfs_attr3_leaf_setflag(args);
>  		if (error)
>  			goto out;
> +
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
> +		if (error)
> +			goto out;
> +
>  		error = xfs_attr_rmtval_remove(args);
>  		if (error)
>  			goto out;
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 8a6f5df..4a22ced 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2773,10 +2773,7 @@ xfs_attr3_leaf_setflag(
>  			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
>  	}
>  
> -	/*
> -	 * Commit the flag value change and start the next trans in series.
> -	 */
> -	return xfs_trans_roll_inode(&args->trans, args->dp);
> +	return error;
>  }
>  
>  /*
> -- 
> 2.7.4
> 
