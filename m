Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710CF257D19
	for <lists+linux-xfs@lfdr.de>; Mon, 31 Aug 2020 17:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgHaPeD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 31 Aug 2020 11:34:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52082 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728903AbgHaPbc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 11:31:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VFFclv152017;
        Mon, 31 Aug 2020 15:31:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=+Hwkm0lRUrUa0TX75jqGl99aS72UIFuB6FeKku0MXuA=;
 b=A+0SWkJfG1XUbwhWNu3IZq3hr4Atw0cLHHxvFlFL1OxG8f8rdRxqayaMUJrzPcFGwGvf
 9cq00v90qeLSzUHlbKHUHM+a/+K0suPE/PIRZxGKq38eJog7MmA9+nNAFZYDzLVqv1iK
 2mKJYqX9IhZ3GeMdS3gB7B2HdItOf1mkLZ5tIAH5jy0Uv3NhfIk8zXQwi7WjdK/QXwwY
 8Noj9+wnvEfMqiiuPKUsm2BGpyiEl3j6++QYRFfbWu0up+TFxwgUnB3SONaVRYdL+icu
 lAs93g0oi21FcXCuHA0GcDGIMjUOy4fYBZR0j6dEUYfJJL715V5K5MzlyZzr3zzHCqCX fQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 337qrhdyqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 15:31:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VFEZMH189899;
        Mon, 31 Aug 2020 15:31:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3380x0hsdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 15:31:27 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07VFVQQI009212;
        Mon, 31 Aug 2020 15:31:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 08:31:26 -0700
Date:   Mon, 31 Aug 2020 08:31:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: Use variable-size array for nameval in
 xfs_attr_sf_entry
Message-ID: <20200831153126.GA6096@magnolia>
References: <20200831130423.136509-1-cmaiolino@redhat.com>
 <20200831130423.136509-2-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831130423.136509-2-cmaiolino@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310091
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 suspectscore=1 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310091
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 03:04:20PM +0200, Carlos Maiolino wrote:
> nameval is a variable-size array, so, define it as it, and remove all
> the -1 magic number subtractions.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++----
>  fs/xfs/libxfs/xfs_attr_sf.h   | 6 +++---
>  fs/xfs/libxfs/xfs_da_format.h | 2 +-
>  3 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 305d4bc073370..7bbc97e0e4d4a 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -992,7 +992,7 @@ xfs_attr_shortform_allfit(
>  			return 0;
>  		if (be16_to_cpu(name_loc->valuelen) >= XFS_ATTR_SF_ENTSIZE_MAX)
>  			return 0;
> -		bytes += sizeof(struct xfs_attr_sf_entry) - 1
> +		bytes += sizeof(struct xfs_attr_sf_entry)
>  				+ name_loc->namelen
>  				+ be16_to_cpu(name_loc->valuelen);
>  	}
> @@ -1036,10 +1036,8 @@ xfs_attr_shortform_verify(
>  		 * struct xfs_attr_sf_entry has a variable length.
>  		 * Check the fixed-offset parts of the structure are
>  		 * within the data buffer.
> -		 * xfs_attr_sf_entry is defined with a 1-byte variable
> -		 * array at the end, so we must subtract that off.
>  		 */
> -		if (((char *)sfep + sizeof(*sfep) - 1) >= endp)
> +		if (((char *)sfep + sizeof(*sfep)) >= endp)
>  			return __this_address;
>  
>  		/* Don't allow names with known bad length. */
> diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
> index bb004fb7944a7..d93012a0be4d0 100644
> --- a/fs/xfs/libxfs/xfs_attr_sf.h
> +++ b/fs/xfs/libxfs/xfs_attr_sf.h
> @@ -28,11 +28,11 @@ typedef struct xfs_attr_sf_sort {
>  } xfs_attr_sf_sort_t;
>  
>  #define XFS_ATTR_SF_ENTSIZE_BYNAME(nlen,vlen)	/* space name/value uses */ \
> -	(((int)sizeof(xfs_attr_sf_entry_t)-1 + (nlen)+(vlen)))
> +	(((int)sizeof(xfs_attr_sf_entry_t) + (nlen)+(vlen)))
>  #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
> -	((1 << (NBBY*(int)sizeof(uint8_t))) - 1)
> +	(1 << (NBBY*(int)sizeof(uint8_t)))

The maximum space for the name and value is still UINT8_MAX, right?
I don't think this should change to 256.

I also kind of wonder if this should also get changed to be more
direct:

#define XFS_ATTR_SF_ENTSIZE_MAX		(UINT8_MAX)

but it's working code, we could/should just leave it be...

>  #define XFS_ATTR_SF_ENTSIZE(sfep)		/* space an entry uses */ \
> -	((int)sizeof(xfs_attr_sf_entry_t)-1 + (sfep)->namelen+(sfep)->valuelen)
> +	((int)sizeof(xfs_attr_sf_entry_t) + (sfep)->namelen+(sfep)->valuelen)

Can this (and ENTSIZE_BYNAME) use struct_sizeof?

--D

>  #define XFS_ATTR_SF_NEXTENTRY(sfep)		/* next entry in struct */ \
>  	((xfs_attr_sf_entry_t *)((char *)(sfep) + XFS_ATTR_SF_ENTSIZE(sfep)))
>  #define XFS_ATTR_SF_TOTSIZE(dp)			/* total space in use */ \
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 059ac108b1b39..e86185a1165b3 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -589,7 +589,7 @@ typedef struct xfs_attr_shortform {
>  		uint8_t namelen;	/* actual length of name (no NULL) */
>  		uint8_t valuelen;	/* actual length of value (no NULL) */
>  		uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
> -		uint8_t nameval[1];	/* name & value bytes concatenated */
> +		uint8_t nameval[];	/* name & value bytes concatenated */
>  	} list[1];			/* variable sized array */
>  } xfs_attr_shortform_t;
>  
> -- 
> 2.26.2
> 
