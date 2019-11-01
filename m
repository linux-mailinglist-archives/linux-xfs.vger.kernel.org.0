Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E744FEC8A5
	for <lists+linux-xfs@lfdr.de>; Fri,  1 Nov 2019 19:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfKASul (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 Nov 2019 14:50:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39468 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727387AbfKASuk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 14:50:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1InT7k166744;
        Fri, 1 Nov 2019 18:50:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=JGYirxCiqgWpeMSIH5NTF9bdWT4vFV4HGvvURxdv4zw=;
 b=ccZtHPv7P8wkDcjTWMWlj9W2f/sq/yjO/7IXDi4vsjwo/QhEj9vucb0xfcHIct6WeZcd
 xvu5BLePX/VMHcTXW0FC8SpBM9/l+inscHJ519NrTREYOHE25Qo/V+GXAECh87Tiao/B
 GXs2ShdiplQEFuadypJworJizjz+dqaGVvddS+Qn3Z6N5AIWtX+9xncmS+pweYg8zWF8
 WgWU4C2v0OIkY1sE/r9zpLF0hQQfxNXH8KFw/FbEjWRn2UBeD9GB3oeUObisRUY5wG2I
 WcYZb87iZcCdTnJ6C1g7esEGsYGgUAlfI5n72BSFNLQfpWZa1ezDqx1bIHt5jvvM7354 GA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vxwhfujkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 18:50:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1Ilqu6178256;
        Fri, 1 Nov 2019 18:50:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2w0qcrj6c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 18:50:08 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA1Io4l0021654;
        Fri, 1 Nov 2019 18:50:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 11:50:03 -0700
Date:   Fri, 1 Nov 2019 11:50:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v8 03/16] xfs: dont use XFS_IS_QUOTA_RUNNING() for option
 check
Message-ID: <20191101185002.GB15222@magnolia>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
 <157259461351.28278.7899654768801700302.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157259461351.28278.7899654768801700302.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:50:13PM +0800, Ian Kent wrote:
> When CONFIG_XFS_QUOTA is not defined any quota option is invalid.
> 
> Using the macro XFS_IS_QUOTA_RUNNING() as a check if any quota option
> has been given is a little misleading so use a simple m_qflags != 0
> check to make the intended use more explicit.
> 
> Also change to use the IS_ENABLED() macro for the kernel config check.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 6438738a204a..fb90beeb3184 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -341,12 +341,10 @@ xfs_parseargs(
>  		return -EINVAL;
>  	}
>  
> -#ifndef CONFIG_XFS_QUOTA
> -	if (XFS_IS_QUOTA_RUNNING(mp)) {
> +	if (!IS_ENABLED(CONFIG_XFS_QUOTA) && mp->m_qflags != 0) {
>  		xfs_warn(mp, "quota support not available in this kernel.");
>  		return -EINVAL;
>  	}
> -#endif
>  
>  	if ((mp->m_dalign && !mp->m_swidth) ||
>  	    (!mp->m_dalign && mp->m_swidth)) {
> 
