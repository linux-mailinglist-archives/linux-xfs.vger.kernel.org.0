Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDA72204A
	for <lists+linux-xfs@lfdr.de>; Sat, 18 May 2019 00:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbfEQW3q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 18:29:46 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:53812 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbfEQW3q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 18:29:46 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4HMNtD8067275;
        Fri, 17 May 2019 22:29:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=CDpVKTSFBmrVujE4Mky/7TdWiYFlUQdEY7HfYibwQbw=;
 b=gtfpWx4wL4aKjkh9BSLsaZsHtZDn8c9zT0BF19K2da14rik5IfC5qmDhtttx8sPcKMal
 +pXTQhp1rh7Sxp02vxUG2Ewkrb61NNBpXTq+sQeL5iEOzqP4HDQhvhw+SBrkojey0Gcu
 Ivoq5uOZKroUWlQMxyqybZBDfyOwnzN/ij53tOIbgvrJMPhG6JVX8sD/e1S5Sh/7JTQo
 vezwak+etl61T4xQoVwgKf3RM92rX+buM6eo7RY1/FKPeL/p9M7Fvqz8i2ycBKrfP0Ap
 iu+5BDQmCHUUdtVM5q8/sqqM2MC1l/o0tHKccTCeMwunmrgtK51OxxVWD9Tam4qORY3f xA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2sdkwech4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 22:29:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4HMRSj6103701;
        Fri, 17 May 2019 22:29:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2sgp33utwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 22:29:12 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4HMTAuP008387;
        Fri, 17 May 2019 22:29:10 GMT
Received: from [192.168.1.226] (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 May 2019 15:29:10 -0700
Subject: Re: [PATCH 5/3] libxfs: rename bli_format to avoid confusion with
 bli_formats
To:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
 <d8f37464-9d76-2b09-f458-e236ef9afd95@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <aa0a48c4-2f75-7f83-eeda-f55855994bd5@oracle.com>
Date:   Fri, 17 May 2019 15:29:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <d8f37464-9d76-2b09-f458-e236ef9afd95@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9260 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905170135
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9260 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905170135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/16/19 1:39 PM, Eric Sandeen wrote:
> Rename the bli_format structure to __bli_format to avoid
> accidently confusing them with the bli_formats pointer.
> 
> (nb: userspace currently has no bli_formats pointer)
> 
> Source kernel commit: b94381737e9c4d014a4003e8ece9ba88670a2dd4
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>   include/xfs_trans.h | 2 +-
>   libxfs/logitem.c    | 6 +++---
>   libxfs/trans.c      | 4 ++--
>   3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/xfs_trans.h b/include/xfs_trans.h
> index 953da5d1..fe03ba64 100644
> --- a/include/xfs_trans.h
> +++ b/include/xfs_trans.h
> @@ -39,7 +39,7 @@ typedef struct xfs_buf_log_item {
>   	struct xfs_buf		*bli_buf;	/* real buffer pointer */
>   	unsigned int		bli_flags;	/* misc flags */
>   	unsigned int		bli_recur;	/* recursion count */
> -	xfs_buf_log_format_t	bli_format;	/* in-log header */
> +	xfs_buf_log_format_t	__bli_format;	/* in-log header */
>   } xfs_buf_log_item_t;
>   
>   #define XFS_BLI_DIRTY			(1<<0)
> diff --git a/libxfs/logitem.c b/libxfs/logitem.c
> index 4da9bc1b..e862ab4f 100644
> --- a/libxfs/logitem.c
> +++ b/libxfs/logitem.c
> @@ -107,9 +107,9 @@ xfs_buf_item_init(
>   	bip->bli_item.li_mountp = mp;
>   	INIT_LIST_HEAD(&bip->bli_item.li_trans);
>   	bip->bli_buf = bp;
> -	bip->bli_format.blf_type = XFS_LI_BUF;
> -	bip->bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
> -	bip->bli_format.blf_len = (unsigned short)BTOBB(bp->b_bcount);
> +	bip->__bli_format.blf_type = XFS_LI_BUF;
> +	bip->__bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
> +	bip->__bli_format.blf_len = (unsigned short)BTOBB(bp->b_bcount);
>   	bp->b_log_item = bip;

I had a look around this area of code, and I see where the bli_format is 
getting referenced, but I don't see a bli_formats.  So I feel like I'm 
missing the motivation for the change.  Did I miss the bli_formats 
somewhere?  Thanks!

Allison

>   }
>   
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 6967a1de..f3c28fa7 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -531,8 +531,8 @@ xfs_trans_binval(
>   	xfs_buf_stale(bp);
>   	bip->bli_flags |= XFS_BLI_STALE;
>   	bip->bli_flags &= ~XFS_BLI_DIRTY;
> -	bip->bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
> -	bip->bli_format.blf_flags |= XFS_BLF_CANCEL;
> +	bip->__bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
> +	bip->__bli_format.blf_flags |= XFS_BLF_CANCEL;
>   	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
>   	tp->t_flags |= XFS_TRANS_DIRTY;
>   }
> 
