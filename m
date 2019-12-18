Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F98B1254A3
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Dec 2019 22:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfLRVaB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Dec 2019 16:30:01 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54204 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbfLRVaB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 16:30:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBILTsfS016069;
        Wed, 18 Dec 2019 21:29:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=pEu/wevBP+vXacJchcE9ZYIZDW6WFseRQ7lMsjNBluQ=;
 b=pYoBx6s3wOquE3Zwe9YxgG6KSy9dh0uMK0D0+yCey/QGYH4GE/FPfG4GaTjQeMcCWmgs
 YYttq3SNg7Gs15aIkMYSPdRz4XtuCihh0CZrbKqswRWT/URGbftLEux/PVPmTS/SddSN
 Sb/Z8/NgtzfHMQ59ZoOL88EXG5Fan63iGPxjeEniZKPOPfjzkZ4vHatj98EcALoblCdu
 /ca5S7VE3jPMqw9GAmKgLJ1chGsBLyZdOyy0Y5L+ZLQq1s4V7v5yiAVY9b9QedQZg0L2
 gSd2flX0MRRMQfBkUvPu3OVXNjxY3lQYde6kqO3T1KWSDhId9SSQifrNVbhKq8zlvC2R KA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wvrcrg65r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 21:29:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBILTdjC080805;
        Wed, 18 Dec 2019 21:29:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wyk3btqvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 21:29:55 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBILTs45027537;
        Wed, 18 Dec 2019 21:29:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 13:29:53 -0800
Date:   Wed, 18 Dec 2019 13:29:52 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 02/33] xfs: reject invalid flags combinations in
 XFS_IOC_ATTRMULTI_BY_HANDLE
Message-ID: <20191218212952.GE7489@magnolia>
References: <20191212105433.1692-1-hch@lst.de>
 <20191212105433.1692-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212105433.1692-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 12, 2019 at 11:54:02AM +0100, Christoph Hellwig wrote:
> While the flags field in the ABI and the on-disk format allows for
> multiple namespace flags, that is a logically invalid combination that
> scrub complains about.  Reject it at the ioctl level, as all other
> interface already get this right at higher levels.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok I think.  We never have attrs in two namespaces at once...
assuming that "attr_multi(3)" is the right manpage for all this?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl.c   | 5 +++++
>  fs/xfs/xfs_ioctl32.c | 5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 2f76d0a7b818..f3a53e0db2cf 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -462,6 +462,11 @@ xfs_attrmulti_by_handle(
>  
>  	error = 0;
>  	for (i = 0; i < am_hreq.opcount; i++) {
> +		if ((ops[i].am_flags & ATTR_ROOT) &&
> +		    (ops[i].am_flags & ATTR_SECURE)) {
> +			ops[i].am_error = -EINVAL;
> +			continue;
> +		}
>  		ops[i].am_flags &= ATTR_KERNEL_FLAGS;
>  
>  		ops[i].am_error = strncpy_from_user((char *)attr_name,
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 8b5acf8c42e1..720eb72f3be3 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -450,6 +450,11 @@ xfs_compat_attrmulti_by_handle(
>  
>  	error = 0;
>  	for (i = 0; i < am_hreq.opcount; i++) {
> +		if ((ops[i].am_flags & ATTR_ROOT) &&
> +		    (ops[i].am_flags & ATTR_SECURE)) {
> +			ops[i].am_error = -EINVAL;
> +			continue;
> +		}
>  		ops[i].am_flags &= ATTR_KERNEL_FLAGS;
>  
>  		ops[i].am_error = strncpy_from_user((char *)attr_name,
> -- 
> 2.20.1
> 
