Return-Path: <linux-xfs+bounces-1002-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD70F819920
	for <lists+linux-xfs@lfdr.de>; Wed, 20 Dec 2023 08:09:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BBE81C21083
	for <lists+linux-xfs@lfdr.de>; Wed, 20 Dec 2023 07:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8C81EB5D;
	Wed, 20 Dec 2023 07:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dV/BZjQ2"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168311EA7D
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 07:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82444C433C7;
	Wed, 20 Dec 2023 07:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703056182;
	bh=ZIPtpzVy0Gose798ftSF8MV2vnmY2QdQC6ZCrhBC0rg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dV/BZjQ2JxJtKx9i9zc7UEyEUNZdNwSQOMQIyAxwBCDY4WSb4+LlXuT81EbCaQw5S
	 NJ6tywx1v7bz0H20J5uPzfS/2ntKVdgtuZbgMVPqZFXXkjiQ//xVU5Jhdz/71DtzER
	 i8w2MJ+UKYxrHfsiPH7WfFzUjfQo1tD8dZqYdXTg6lzJSAfFSGIKDW8iBA5eJPeB9w
	 CMiJOOCZr44xotWjG59IfztJCe2dyJVw9BmYxKuwpseT7nRxOMGLULz+pH9eIhztZg
	 bsuW+i4VynI8EPp7P2Br30065EvIFEOOsOR5mvJ42nrVWD0Nkzr0ajYwJyF3kliwO6
	 JYQ7A3PgGOPrA==
Date: Tue, 19 Dec 2023 23:09:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: turn the XFS_DA_OP_REPLACE checks in
 xfs_attr_shortform_addname into asserts
Message-ID: <20231220070942.GP361584@frogsfrogsfrogs>
References: <20231220063503.1005804-1-hch@lst.de>
 <20231220063503.1005804-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231220063503.1005804-10-hch@lst.de>

On Wed, Dec 20, 2023 at 07:35:03AM +0100, Christoph Hellwig wrote:
> Since commit deed9512872d ("xfs: Check for -ENOATTR or -EEXIST"), the
> high-level attr code does a lookup for any attr we're trying to set,
> and does the checks to handle the create vs replace cases, which thus
> never hit the low-level attr code.
> 
> Turn the checks in xfs_attr_shortform_addname as they must never trip.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index ec4061db7ffccd..9976a00a73f99c 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1072,8 +1072,7 @@ xfs_attr_shortform_addname(
>  	if (xfs_attr_sf_findname(args)) {
>  		int		error;
>  
> -		if (!(args->op_flags & XFS_DA_OP_REPLACE))
> -			return -EEXIST;
> +		ASSERT(args->op_flags & XFS_DA_OP_REPLACE);
>  
>  		error = xfs_attr_sf_removename(args);
>  		if (error)
> @@ -1087,8 +1086,7 @@ xfs_attr_shortform_addname(
>  		 */
>  		args->op_flags &= ~XFS_DA_OP_REPLACE;
>  	} else {
> -		if (args->op_flags & XFS_DA_OP_REPLACE)
> -			return -ENOATTR;
> +		ASSERT(!(args->op_flags & XFS_DA_OP_REPLACE));
>  	}
>  
>  	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||
> -- 
> 2.39.2
> 
> 

