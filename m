Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D0C2C1A16
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Nov 2020 01:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbgKXAbp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 23 Nov 2020 19:31:45 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54478 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730538AbgKXAbn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Nov 2020 19:31:43 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO0UY1s116271;
        Tue, 24 Nov 2020 00:30:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=UJ2IooOa3qth53Eu+aG8b6OfZ/oPhvjmH3uhWCeRPCE=;
 b=ClZ031gci3rQUKsgxg0lXlThAUmtTjhTQifnW7MEGJFqe1jyUPGtkPyDwCaPQB7Utjj9
 V79Ju30qtxuEPa+MZc+3Hy+Zq0gGRhplKrcl7kPAUs9fRFeDxLRrbpQcG98wzIO32Fc0
 H0MgoLziVSLE8GotvFbFUKhYOFCKnL1Sg6I91U5EOWk+z5Osqk8jXE1W2l2asDonRmtM
 Tzuwwg730dI8QKkBtzkkpLv2KDyBgQoZNQ9L0V47PWG0wSOssXdg0J04kZq39VcdsJF+
 o6uhd/zaqao2CurncyZVwOSzg+hyk3pbmrxCOwL90NYK1+hN7yOYDyhQJapCh/Cg3f4T 2Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34xrdar70p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 00:30:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO0TtDE020732;
        Tue, 24 Nov 2020 00:30:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34ycnrp9fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 00:30:33 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AO0UTV3002451;
        Tue, 24 Nov 2020 00:30:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 16:30:29 -0800
Date:   Mon, 23 Nov 2020 16:30:28 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: show the proper user quota options
Message-ID: <20201124003028.GF7880@magnolia>
References: <1606124332-22100-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606124332-22100-1-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=3
 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 adultscore=0 suspectscore=3 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 23, 2020 at 05:38:52PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The quota option 'usrquota' should be shown if both the XFS_UQUOTA_ACCT
> and XFS_UQUOTA_ENFD flags are set. The option 'uqnoenforce' should be
> shown when only the XFS_UQUOTA_ACCT flag is set. The current code logic
> seems wrong, Fix it and show proper options.

This needs a regression test case to make sure that quota mount options
passed in ==> quota options in /proc/mounts, wouldn't you say? ;)

--D

> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/xfs_super.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e3e229e52512..5ebd6cdc44a7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -199,10 +199,12 @@ xfs_fs_show_options(
>  		seq_printf(m, ",swidth=%d",
>  				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
>  
> -	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
> -		seq_puts(m, ",usrquota");
> -	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
> -		seq_puts(m, ",uqnoenforce");
> +	if (mp->m_qflags & XFS_UQUOTA_ACCT) {
> +		if (mp->m_qflags & XFS_UQUOTA_ENFD)
> +			seq_puts(m, ",usrquota");
> +		else
> +			seq_puts(m, ",uqnoenforce");
> +	}
>  
>  	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
>  		if (mp->m_qflags & XFS_PQUOTA_ENFD)
> -- 
> 2.20.0
> 
