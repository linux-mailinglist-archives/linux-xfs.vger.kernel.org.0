Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8A532688E
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2019 18:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729862AbfEVQoK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 22 May 2019 12:44:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56776 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729572AbfEVQoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 May 2019 12:44:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4MGe3A9161890;
        Wed, 22 May 2019 16:44:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=9s12aYuV++QDcjeZAuJYR2rwLZFeIJ3jF1py9OXcJos=;
 b=IcPNLOosfhE3BK5mts3T5ElcpixJ/3TvXdbDhZFbvFdGxhLWSV5BBXMLpWd+S+DwcftB
 5LSycI6XQUE2xbcnqt3H8salDh1nw9x5/eteemRRtGZ3+g6xAXNUQXqLzNKrlhpffxSS
 uySC3nxkDpPaOplH5KsNMKsnAmGBgMe6sWDVQhZ4RKUt87cYYhVxw6M94dZisuR7HmJY
 TSwqpgR5hrfBysCjIn6s08kPV1qPQCUIkIGvxVTctSi/2JD2zy32ao4InupQWcsO5YN7
 sTW5YhtVU6jCcWKR6PJJO91mAMAzZ5uZSz3ZDJORHzuohCEBuKRvM/xFSoiaT0O0Srr2 IQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2smsk5d4st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 May 2019 16:44:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4MGhZmQ154651;
        Wed, 22 May 2019 16:44:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2smsgsqdda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 May 2019 16:44:06 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4MGi4jj003716;
        Wed, 22 May 2019 16:44:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 May 2019 16:44:04 +0000
Date:   Wed, 22 May 2019 09:44:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12 V2] mkfs: enable reflink by default
Message-ID: <20190522164403.GF5141@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839428076.68606.9379127257564633311.stgit@magnolia>
 <1f5f641c-b6f8-2067-8224-7350f0f51034@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f5f641c-b6f8-2067-8224-7350f0f51034@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905220117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905220117
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 02:30:57PM -0500, Eric Sandeen wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Data block sharing (a.k.a. reflink) has been stable for a while, so turn
> it on by default.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> [sandeen: update comments & man page]
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good to me.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Hmm I'm not allowed to RVB my own patch, right?

--D

> ---
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 4b8c78c..78b1501 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -231,7 +231,7 @@ available for the data forks of regular files.
>  .IP
>  By default,
>  .B mkfs.xfs
> -will not create reference count btrees and therefore will not enable the
> +will create reference count btrees and therefore will enable the
>  reflink feature.  This feature is only available for filesystems created with
>  the (default)
>  .B \-m crc=1
> @@ -239,6 +239,13 @@ option set. When the option
>  .B \-m crc=0
>  is used, the reference count btree feature is not supported and reflink is
>  disabled.
> +.IP
> +Note: the filesystem DAX mount option (
> +.B \-o dax
> +) is incompatible with
> +reflink-enabled XFS filesystems.  To use filesystem DAX with XFS, specify the
> +.B \-m reflink=0
> +option to mkfs.xfs to disable the reflink feature.
>  .RE
>  .TP
>  .BI \-d " data_section_options"
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 0910664..ddb25ec 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1973,15 +1973,15 @@ _("Directory ftype field always enabled on CRC enabled filesystems\n"));
>  			usage();
>  		}
>  
> -	} else {
> +	} else {	/* !crcs_enabled */
>  		/*
> -		 * The kernel doesn't currently support crc=0,finobt=1
> -		 * filesystems. If crcs are not enabled and the user has not
> -		 * explicitly turned finobt on, then silently turn it off to
> -		 * avoid an unnecessary warning.
> +		 * The kernel doesn't support crc=0,finobt=1 filesystems.
> +		 * If crcs are not enabled and the user has not explicitly
> +		 * turned finobt on, then silently turn it off to avoid an
> +		 * unnecessary warning.
>  		 * If the user explicitly tried to use crc=0,finobt=1,
>  		 * then issue an error.
> -		 * The same is also for sparse inodes.
> +		 * The same is also true for sparse inodes and reflink.
>  		 */
>  		if (cli->sb_feat.finobt && cli_opt_set(&mopts, M_FINOBT)) {
>  			fprintf(stderr,
> @@ -2004,7 +2004,7 @@ _("rmapbt not supported without CRC support\n"));
>  		}
>  		cli->sb_feat.rmapbt = false;
>  
> -		if (cli->sb_feat.reflink) {
> +		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
>  			fprintf(stderr,
>  _("reflink not supported without CRC support\n"));
>  			usage();
> @@ -3876,7 +3876,7 @@ main(
>  			.finobt = true,
>  			.spinodes = true,
>  			.rmapbt = false,
> -			.reflink = false,
> +			.reflink = true,
>  			.parent_pointers = false,
>  			.nodalign = false,
>  			.nortalign = false,
> 
> 
