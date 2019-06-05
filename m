Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E45735FF9
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 17:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfFEPNn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 11:13:43 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59308 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728364AbfFEPNn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 11:13:43 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x55F43Ei033758;
        Wed, 5 Jun 2019 15:13:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=VtaYk66fL3CN9KSZooKZIKu5MArc65frD5wEKBEG5G0=;
 b=hHwSJQYIsEFRfudDh6ci7BiSYdU1LW6m82lR91YSTPT2SxVpDnH9qOMcTa2AhBVLtf8r
 hPcxjctgHBfKI38Axx4a1i/ElR4ES8WFGAM/G5VWNHYuc5kxnDaR1EsIzbPVr8JYo/YL
 VOsWIuV43X8E3gpupAoLAq2dzbw85mMRrr6pShpLkqinA2LqDlWzMUdRq3TPHj/kwwwP
 frTX9xnWMFv3XFe8YCSWVi7JhHkG23JEbNejoGoX2iOaaMaWfofiEFgnhHZONkG0BBxw
 T6yGl8jtDW5Ai6jr3MTvI82279qQ2pCr5Ma4oyBKUbgAkQbji/1/CV4AmF1heKSe8gbd Nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2suevdkhmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jun 2019 15:13:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x55FBsGP118383;
        Wed, 5 Jun 2019 15:13:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2swnghxksk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jun 2019 15:13:21 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x55FDJ0r012426;
        Wed, 5 Jun 2019 15:13:19 GMT
Received: from localhost (/10.159.242.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 05 Jun 2019 08:13:19 -0700
Date:   Wed, 5 Jun 2019 08:13:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] include WARN, REPAIR build options in XFS_BUILD_OPTIONS
Message-ID: <20190605151318.GG1200785@magnolia>
References: <15ed3957-d4f5-01a0-3d2e-d8a69cc435ce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15ed3957-d4f5-01a0-3d2e-d8a69cc435ce@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906050095
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906050095
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 06:23:25PM -0500, Eric Sandeen wrote:
> The XFS_BUILD_OPTIONS string, shown at module init time and 
> in modinfo output, does not currently include all available
> build options.  So, add in CONFIG_XFS_WARN and CONFIG_XFS_REPAIR.
> 
> It has been suggested in some quarters
> That this is not enough.
> Well ... 
> 
> Anybody who would like to see this in a sysfs file can send
> a patch.  :)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> I might send that patch, but would like to have the string
> advertising build options be complete, for now.
> 

Er, are you working on that patch now?

LGTM,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index 21cb49a..763e43d 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -38,6 +38,18 @@
>  # define XFS_SCRUB_STRING
>  #endif
>  
> +#ifdef CONFIG_XFS_ONLINE_REPAIR
> +# define XFS_REPAIR_STRING	"repair, "
> +#else
> +# define XFS_REPAIR_STRING
> +#endif
> +
> +#ifdef CONFIG_XFS_WARN
> +# define XFS_WARN_STRING	"verbose warnings, "
> +#else
> +# define XFS_WARN_STRING
> +#endif
> +
>  #ifdef DEBUG
>  # define XFS_DBG_STRING		"debug"
>  #else
> @@ -49,6 +61,8 @@
>  				XFS_SECURITY_STRING \
>  				XFS_REALTIME_STRING \
>  				XFS_SCRUB_STRING \
> +				XFS_REPAIR_STRING \
> +				XFS_WARN_STRING \
>  				XFS_DBG_STRING /* DBG must be last */
>  
>  struct xfs_inode;
> 
