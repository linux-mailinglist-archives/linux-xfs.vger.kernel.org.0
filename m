Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2CC148BD5
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Jun 2019 20:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfFQSWd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Jun 2019 14:22:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39436 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfFQSWc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jun 2019 14:22:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HI8vu8159165;
        Mon, 17 Jun 2019 18:22:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=sp7PO7v+w9TNoZ60kHrsMjRl4qnTdiRh/02CMJ7aDB4=;
 b=xVTaXjUTYGrGpIqWZZ1ciN7qWqyRI95S8L/YOtZTQ3cUBFPxE2lO4tr2QtyWuQhBgS2F
 4fRgrjFOx5dewRjj9nUpJgf80VHUyI6PpB3cZ0iGoRSbmwV519wkxNMQmJDjS/zbyOc6
 nJv3woHbbOr4n5VpuHqg5R2Y0TJ0n6hj3JBYFFs4qTmrnpZ6d4kVphCt+aPRasuZXOae
 3+Dkul3p6RcyO93Jme2BvVsa+2iBXQxHH6kIShW8xiO/gCDq792es3fuYSmx4PUpEbxN
 TEVEmS8JKrmja/xfn2LOlq3GUNNKwXJ30mJSnrW+gyMkALW2x6sq5zQQVxG8oqe1EkCs 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t4saq807a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 18:22:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HIL5aP065437;
        Mon, 17 Jun 2019 18:22:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2t5h5t9jv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 18:22:28 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5HIMRAF003481;
        Mon, 17 Jun 2019 18:22:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Jun 2019 11:22:27 -0700
Date:   Mon, 17 Jun 2019 11:22:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH] xfs_info: limit findmnt to find mounted xfs filesystems
Message-ID: <20190617182226.GM3773859@magnolia>
References: <20190617095447.3748-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617095447.3748-1-amir73il@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906170162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906170162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 17, 2019 at 12:54:47PM +0300, Amir Goldstein wrote:
> When running xfstests with -overlay, the xfs mount point
> (a.k.a $OVL_BASE_SCRATCH_MNT) is used as the $SCRATCH_DEV argument
> to the overlay mount, like this:
> 
> /dev/vdf /vdf xfs rw,relatime,attr2,inode64,noquota 0 0
> /vdf /vdf/ovl-mnt overlay rw,lowerdir=/vdf/lower,upperdir=/vdf/upper...
> 
> Ever since commit bbb43745, when xfs_info started using findmnt,
> when calling the helper `_supports_filetype /vdf` it returns false,
> and reports: "/vdf/ovl-mnt: Not on a mounted XFS filesystem".
> 
> Fix this ambiguity by preferring to query a mounted XFS filesystem,
> if one can be found.
> 
> Fixes: bbb43745 ("xfs_info: use findmnt to handle mounted block devices")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Looks good to me, so long as findmnt /has/ a -t option in, uh, whatever
enterprise distro(s) for which the xfsprogs maintainer might be a
stakeholder. :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> Eric,
> 
> FYI, I don't *need* to fix xfs_info in order to fix xfstests
> and I do plan to send an independent fix to xfstests, but this
> seems like a correct fix regardless of the specific xfstests
> regression.
> 
> Thanks,
> Amir.
> 
>  spaceman/xfs_info.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/spaceman/xfs_info.sh b/spaceman/xfs_info.sh
> index 1bf6d2c3..3b10dc14 100755
> --- a/spaceman/xfs_info.sh
> +++ b/spaceman/xfs_info.sh
> @@ -40,7 +40,7 @@ case $# in
>  
>  		# If we find a mountpoint for the device, do a live query;
>  		# otherwise try reading the fs with xfs_db.
> -		if mountpt="$(findmnt -f -n -o TARGET "${arg}" 2> /dev/null)"; then
> +		if mountpt="$(findmnt -t xfs -f -n -o TARGET "${arg}" 2> /dev/null)"; then
>  			xfs_spaceman -p xfs_info -c "info" $OPTS "${mountpt}"
>  			status=$?
>  		else
> -- 
> 2.17.1
> 
