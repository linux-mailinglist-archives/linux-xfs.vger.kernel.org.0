Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFCE640ED
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Jul 2019 08:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfGJGKL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Jul 2019 02:10:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49536 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfGJGKL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 02:10:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6A68wT6047534;
        Wed, 10 Jul 2019 06:09:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=ROYbDPCr8kTOc9jt1m4Yk4hxMeCgBTc+y69KJQuY3NI=;
 b=ogYnDCgshflidAiSzoC1x9peN7ism496OVMtvrLDG2//F6//9CwPVTi7zfpkZ6Ej5sa2
 i8pQ13uPEpsYTyPUn5MzBUjZO6BRQdDMfWBZFnMB/oZZu0URGGp66K7Byuu7ub6Vz6RG
 6xJPJI3/gX6zBG9ARXtV2CJukcACq+b373xvA77Ty2LBqh6hsXXuOFoxwM1c6RKI5h5C
 xgRLX4bX4P+EUMWmSoxY4V9/8VumXAlCdHqYrbk/7+7rKpCTFLgpd1qJkssYJLv5+9CB
 p90rwjwfEZjyAyiAvusJo02MADBeU9YIBkdsIvTKaW4cCQ/aPsP+GdYIW0fYHCmfV543 6g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2tjk2tr3gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 06:09:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6A67xXj092499;
        Wed, 10 Jul 2019 06:09:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tjjym6qby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 06:09:53 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6A69qYV011424;
        Wed, 10 Jul 2019 06:09:53 GMT
Received: from localhost (/10.159.238.37)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 23:09:52 -0700
Date:   Tue, 9 Jul 2019 23:09:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs: don't use xfs_verify_fsbno() before m_sb is fully
 set up
Message-ID: <20190710060952.GU1404256@magnolia>
References: <d04c688e-4d67-83f4-8401-d064d13bdc33@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d04c688e-4d67-83f4-8401-d064d13bdc33@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907100075
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907100075
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 09, 2019 at 03:09:00PM -0500, Eric Sandeen wrote:
> Commit 8da5298 mkfs: validate start and end of aligned logs stopped
> open-coding log end block checks, and used xfs_verify_fsbno() instead.
> It also used xfs_verify_fsbno() to validate the log start.  This
> seemed to make sense, but then xfs/306 started failing on 4k sector
> filesystems, which leads to a log striep unite being set on a single
> AG filesystem.
> 
> As it turns out, if xfs_verify_fsbno() is testing a block in the
> last AG, it needs to have mp->m_sb.sb_dblocks set, which isn't done
> until later.  With sb_dblocks unset we can't know how many blocks
> are in the last AG, and hence can't validate it.
> 
> To fix all this, go back to open-coding the checks; note that this
> /does/ rely on m_sb.sb_agblklog being set, but that /is/ already
> done in the early call to start_superblock_setup().
> 
> Fixes: 8da5298 ("mkfs: validate start and end of aligned logs")
> Reported-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Sorry for missing this one in regression testing :/

Sorry for totally not noticing that we're validating using an incomplete
xfs_mount... <grumble>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 468b8fde..4e576a5c 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3040,7 +3040,7 @@ align_internal_log(
>  		cfg->logstart = ((cfg->logstart + (sunit - 1)) / sunit) * sunit;
>  
>  	/* If our log start overlaps the next AG's metadata, fail. */
> -	if (!xfs_verify_fsbno(mp, cfg->logstart)) {
> +	if (XFS_FSB_TO_AGBNO(mp, cfg->logstart) <= XFS_AGFL_BLOCK(mp)) {
>  			fprintf(stderr,
>  _("Due to stripe alignment, the internal log start (%lld) cannot be aligned\n"
>    "within an allocation group.\n"),
> @@ -3051,10 +3051,9 @@ _("Due to stripe alignment, the internal log start (%lld) cannot be aligned\n"
>  	/* round up/down the log size now */
>  	align_log_size(cfg, sunit);
>  
> -	/* check the aligned log still fits in an AG. */
> +	/* check the aligned log still starts and ends in the same AG. */
>  	logend = cfg->logstart + cfg->logblocks - 1;
> -	if (XFS_FSB_TO_AGNO(mp, cfg->logstart) != XFS_FSB_TO_AGNO(mp, logend) ||
> -	    !xfs_verify_fsbno(mp, logend)) {
> +	if (XFS_FSB_TO_AGNO(mp, cfg->logstart) != XFS_FSB_TO_AGNO(mp, logend)) {
>  		fprintf(stderr,
>  _("Due to stripe alignment, the internal log size (%lld) is too large.\n"
>    "Must fit within an allocation group.\n"),
> 
