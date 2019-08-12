Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0098A3A6
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 18:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfHLQqM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 12:46:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51082 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfHLQqM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:46:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGhkMj163745
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:46:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=gHRyGEV0z1Bo01dKHPeYgnUF5E92xk7TBjj2lysvVWw=;
 b=YirIQH6AmEb7xjtIfSsubwDlCcW1+/kgkl3stbu15PZDoW9WSMhKqgSRQsZFT6l4Gctv
 xLrUNNRqjKEYNF8GP4LFG9ZXqMgePGlQkl/Sc0KnvUu38r+2rz9i6Ntkf9t7KGz91/Ri
 jKq8Xn34iy/FUcQsVanNeNXtSRxr4WfGL/ZuoyELbsBr6kdxFH93wxZBaE8yY5OTqDly
 ktcSR3x2ldGIIpJHGD7zn25+bIcvdp/FTJPKBOEvh2xeAuove23Ogrdg0UbnwZJslZbt
 vPbJutNmO5RhUdd6rtIFe/w5M2gTts1VrdSVMJYgBwJohNJFjI7SONt770NZXCLp17NJ 6w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=gHRyGEV0z1Bo01dKHPeYgnUF5E92xk7TBjj2lysvVWw=;
 b=5L3/1K6ebB/7KM/0vGyie8dSioq1p0dmK83Df1bwli10By9ZLb6FvLtxzIDymW9wwdT/
 qr0m3fPsNuxK7Gvd6wH6+/l9jaZsbcOa20wbaxcVp8/93HO6IMjT+6dYT5iglJtLy9fx
 gqM5irwp+0CIanb5k3BoayJUTFa/hRrmBaVYr1SXMSOp6zLcsYE4qicd/dvm6xoYYJTi
 26c8oSAkUSrpD+S/Zp4yB2Pq/LtB+a1unFwZEWgMWE/DLLsMJgeP4gb02A3lBdyBFrL4
 rKmL4EoEqZmYyBX2RbTbth/5gK3poqGLN5C11JP18LceNOO+5+Cn3bd3UNqtdssNRLQs Pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbt8vqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:46:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGcRFm102519
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:44:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2u9n9h2sx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:44:10 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CGi9bR028170
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:44:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 09:44:08 -0700
Date:   Mon, 12 Aug 2019 09:44:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 18/19] xfsprogs: Add delayed attributes error tag
Message-ID: <20190812164407.GE7138@magnolia>
References: <20190809213804.32628-1-allison.henderson@oracle.com>
 <20190809213804.32628-19-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213804.32628-19-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120187
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:38:03PM -0700, Allison Collins wrote:
> Subject: [PATCH v1 18/19] xfsprogs: Add delayed attributes error tag

In the final version this ought to be "xfs_io:", not "xfsprogs:" since
the libxfs changes will invariably land through a separate
libxfs-apply'd patch.

Looks ok otherwise,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> This patch adds an error tag that we can use to test
> delayed attribute recovery and replay
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  io/inject.c           | 1 +
>  libxfs/xfs_errortag.h | 4 +++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/io/inject.c b/io/inject.c
> index cabfc3e..05bd4db 100644
> --- a/io/inject.c
> +++ b/io/inject.c
> @@ -54,6 +54,7 @@ error_tag(char *name)
>  		{ XFS_ERRTAG_FORCE_SCRUB_REPAIR,	"force_repair" },
>  		{ XFS_ERRTAG_FORCE_SUMMARY_RECALC,	"bad_summary" },
>  		{ XFS_ERRTAG_IUNLINK_FALLBACK,		"iunlink_fallback" },
> +		{ XFS_ERRTAG_DELAYED_ATTR,		"delayed_attr" },
>  		{ XFS_ERRTAG_MAX,			NULL }
>  	};
>  	int	count;
> diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
> index 79e6c4f..85d5850 100644
> --- a/libxfs/xfs_errortag.h
> +++ b/libxfs/xfs_errortag.h
> @@ -55,7 +55,8 @@
>  #define XFS_ERRTAG_FORCE_SCRUB_REPAIR			32
>  #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
>  #define XFS_ERRTAG_IUNLINK_FALLBACK			34
> -#define XFS_ERRTAG_MAX					35
> +#define XFS_ERRTAG_DELAYED_ATTR				35
> +#define XFS_ERRTAG_MAX					36
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -95,5 +96,6 @@
>  #define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
>  #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
>  #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
> +#define XFS_RANDOM_DELAYED_ATTR				1
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> -- 
> 2.7.4
> 
