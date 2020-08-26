Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53205253630
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Aug 2020 19:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgHZRtO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Aug 2020 13:49:14 -0400
Received: from sandeen.net ([63.231.237.45]:52432 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgHZRtO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Aug 2020 13:49:14 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id CC48E323BE3;
        Wed, 26 Aug 2020 12:49:02 -0500 (CDT)
Subject: Re: [PATCH v2] xfs: initialize the shortform attr header padding
 entry
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
References: <20200826153912.GN6096@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5d078b4d-134f-aa14-4317-ea69794e2810@sandeen.net>
Date:   Wed, 26 Aug 2020 12:49:13 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200826153912.GN6096@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/26/20 10:39 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't leak kernel memory contents into the shortform attr fork.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: memset instead of setting padding by hand

yeah I think that's good.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 8623c815164a..e730586bff85 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -653,8 +653,8 @@ xfs_attr_shortform_create(
>  		ASSERT(ifp->if_flags & XFS_IFINLINE);
>  	}
>  	xfs_idata_realloc(dp, sizeof(*hdr), XFS_ATTR_FORK);
> -	hdr = (xfs_attr_sf_hdr_t *)ifp->if_u1.if_data;
> -	hdr->count = 0;
> +	hdr = (struct xfs_attr_sf_hdr *)ifp->if_u1.if_data;
> +	memset(hdr, 0, sizeof(*hdr));
>  	hdr->totsize = cpu_to_be16(sizeof(*hdr));
>  	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_ADATA);
>  }
> 
