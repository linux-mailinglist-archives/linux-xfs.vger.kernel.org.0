Return-Path: <linux-xfs+bounces-4700-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1410D875A00
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Mar 2024 23:10:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0EA21F2230A
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Mar 2024 22:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B4EF13DB87;
	Thu,  7 Mar 2024 22:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zx03Isms"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC89F139597;
	Thu,  7 Mar 2024 22:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709849398; cv=none; b=UeE3o5Glr/HwptcH83wUxZBCn3PELqw33b2GLpgqEd1ny7gzlI0RhCtFAWwbbrlFoD6OIqGR0g6wmEHTnCNFh109Rrk4r4saEaHam3FDmCuAeHQLw3Zk11+V9vmBir2X0aZZ9JC1N2aVr3Os02M+bX5T2Ud7kCsKtLl+Y1YE5dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709849398; c=relaxed/simple;
	bh=JUJ/METish4FJwRLv/hSOGZeObs6nFKwI/FzJLcCxAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LpGvDnXHbDS+6sPjEgGWpqyljlBnPmWsYbH7YrYN7jhG+ZTHlZoN8itvN2yurQuVfUHqMKWRslwQpDK99uiaiLuV+DJ0JLIyDyYp2+VtJDua/ramXVC/bLiLVFsefmSyubeTOodbJDwVUJmznD6SJmcXAaR0O4uirxIz10OWYpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zx03Isms; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A95C433F1;
	Thu,  7 Mar 2024 22:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709849397;
	bh=JUJ/METish4FJwRLv/hSOGZeObs6nFKwI/FzJLcCxAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zx03IsmsvPUI1w5+n6hx2xtzrwPDWBpS0oHLnB7Nxnlg2N3BvcwsmCe68XjKL9uGH
	 nok5Sv/KqERofekV92SbgHlluGYo+lM5E0HbOCAYUm2r5GLMbPUfrHfdrRuzM9T8K3
	 w21U1od6c57X52JNjd6QDoBiQTGnpitgC2IflSGciw4xSY4eTVrPFxtcwhrE8SoXj5
	 Of8eufa1OpFbi0wu9YeGKnrS0pWzPrJ1F3IGDtnev5QdqmYmJRmST7oJa3XZMDUcyY
	 TNd7NWuSR2IgukLxb5Z9hhapHbOYWhGgxEJW+QDPAW+LFp468D9Nim1MxvyIICEPVL
	 DpDucwyW23TcQ==
Date: Thu, 7 Mar 2024 14:09:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chandan.babu@oracle.com,
	ebiggers@kernel.org
Subject: Re: [PATCH v5 19/24] xfs: don't allow to enable DAX on fs-verity
 sealsed inode
Message-ID: <20240307220956.GW1927156@frogsfrogsfrogs>
References: <20240304191046.157464-2-aalbersh@redhat.com>
 <20240304191046.157464-21-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240304191046.157464-21-aalbersh@redhat.com>

On Mon, Mar 04, 2024 at 08:10:42PM +0100, Andrey Albershteyn wrote:
> fs-verity doesn't support DAX. Forbid filesystem to enable DAX on
> inodes which already have fs-verity enabled. The opposite is checked
> when fs-verity is enabled, it won't be enabled if DAX is.

What's the problem with allowing fsdax and fsverity at the same time?
Was that merely not in scope, or is there a fundamental incompatibility
between the two?

--D

> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/xfs/xfs_iops.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 0e5cdb82b231..6f97d777f702 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1213,6 +1213,8 @@ xfs_inode_should_enable_dax(
>  		return false;
>  	if (!xfs_inode_supports_dax(ip))
>  		return false;
> +	if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
> +		return false;
>  	if (xfs_has_dax_always(ip->i_mount))
>  		return true;
>  	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
> -- 
> 2.42.0
> 
> 

