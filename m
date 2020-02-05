Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38C96152600
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Feb 2020 06:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbgBEF3E (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Feb 2020 00:29:04 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41674 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgBEF3E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 00:29:04 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0155Snge110124;
        Wed, 5 Feb 2020 05:29:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=eI1uOdNOgznRF11d9aUa+ktsJFI50OhKrefh44lUvGA=;
 b=gtSprPSB970KuY/OWMJCCwQrIkXWt2xLaOJQgOuIxCunTNWI4sWamKWNx7OXaEW9mo11
 KBcPGZgnDl0N5Sb4Vg8HlG7J6T+LDSvuik24uqjn2TbOCJPcoFctxpUqPPXFazTWpGim
 MFmPw9VgjfsB8Rbyduabryqv1DXBNkyB9aR5Y+4dVzyVVW/XWx3Z/MJC1668vUHzvz5g
 SpR1zDGW1LohEMTV9l8m+qgqbZZ0xxuLfDYg1EGpa52uJQI4453DNeHK9/pccRwU8Ulm
 PmQYRhTwjp6ybAgugIl7WU1pu765tPO4/BkI9kvKVzPZRNi7IUSt+uotQ1l6HsMbVLqG +A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xykbp8rtd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 05:29:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0155SkvZ068437;
        Wed, 5 Feb 2020 05:29:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xykc43dhc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 05:29:00 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0155Sxv6011194;
        Wed, 5 Feb 2020 05:28:59 GMT
Received: from [192.168.1.9] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 21:28:59 -0800
Subject: Re: [PATCH 3/4] xfs_repair: refactor attr root block pointer check
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <158086356778.2079557.17601708483399404544.stgit@magnolia>
 <158086358798.2079557.6562544272527988911.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <0acbf074-b430-e8bb-eb05-c36307a2c797@oracle.com>
Date:   Tue, 4 Feb 2020 22:28:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <158086358798.2079557.6562544272527988911.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050045
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/4/20 5:46 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In process_longform_attr, replace the agcount check with a call to the
> fsblock verification function in libxfs.  Now we can also catch blocks
> that point to static FS metadata.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok, looks good
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   repair/attr_repair.c |   10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 9a44f610..7b26df33 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -980,21 +980,21 @@ process_longform_attr(
>   	*repair = 0;
>   
>   	bno = blkmap_get(blkmap, 0);
> -
> -	if ( bno == NULLFSBLOCK ) {
> +	if (bno == NULLFSBLOCK) {
>   		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
>   				be16_to_cpu(dip->di_anextents) == 0)
>   			return(0); /* the kernel can handle this state */
>   		do_warn(
>   	_("block 0 of inode %" PRIu64 " attribute fork is missing\n"),
>   			ino);
> -		return(1);
> +		return 1;
>   	}
> +
>   	/* FIX FOR bug 653709 -- EKN */
> -	if (mp->m_sb.sb_agcount < XFS_FSB_TO_AGNO(mp, bno)) {
> +	if (!xfs_verify_fsbno(mp, bno)) {
>   		do_warn(
>   	_("agno of attribute fork of inode %" PRIu64 " out of regular partition\n"), ino);
> -		return(1);
> +		return 1;
>   	}
>   
>   	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
> 
