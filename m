Return-Path: <linux-xfs+bounces-11640-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C63A9513C1
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Aug 2024 07:12:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FCE81C22F25
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Aug 2024 05:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0327B4D8BA;
	Wed, 14 Aug 2024 05:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iCcMDFWu"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D0E39879
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 05:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723612368; cv=none; b=ZOiLvMEX44Y1gynerNDGtVMYpczbnW/U66eEKPSqfkXJEHkXgzaSZIq+XyxBmaxDfJTec7jQOl+cSsLC77gcAznjBUYdyn9vL6D6rrTkC5y1kD+AJuHwWhDFV6qARbmQsBrKv3gvW3wp4/K9LjWrO/7X/yQZfOlstO4RWf5P+MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723612368; c=relaxed/simple;
	bh=FO36I3pFNTcxClIWMWi+FcgUpR/FD/NjaYkECGr2Roc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rXHwmJOcOU4V8Lq74qiFe2m3Nh0+LFmh9/yPJ7d8B9eZpU0OetUBhM9MaJuzWqpcqPlI3uNKLZHN1OcSAAAqvcFTs8Zis06ViyfKw/G4aQOWV5ByaqHF/wex2C+byEGU2wB1ys2+ur4vxOsPQdUdvBjILtUYpHcMMs9AJFipHOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iCcMDFWu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B9FC32786;
	Wed, 14 Aug 2024 05:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723612368;
	bh=FO36I3pFNTcxClIWMWi+FcgUpR/FD/NjaYkECGr2Roc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iCcMDFWumWTt9lLvI1dHQBN2h18hrm2IfUlvcuiNHssmdJkflA1nf/EmxqeAdGvOJ
	 cGD5J174Oej7DlfipfWUM53TmoveNfEquqHJum+cJmRnT7B2pOUOb344HGAwrd9wAO
	 PZwSPH2/B/V6RlIuDTQA6LW74lgInbrekxRARnmUMyhFeRAdAm8FOyv/eamMZmWoOG
	 9D37fGwekj3XiSvlAEUe9j0l4cg+LyN7FgkDQfk4y+N8cvJ9wGfhl9EPR53K2v4Ghl
	 ThZSm8hoaGwTQr2S3JObS4/dIchc5dkQ64DpPQYJ7KMPPBzUaDyuEaeZNBGvsM96gi
	 9AnQ4cmiG1Iaw==
Date: Tue, 13 Aug 2024 22:12:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove a stale comment in xfs_ioc_trim
Message-ID: <20240814051247.GD865349@frogsfrogsfrogs>
References: <20240814042358.19297-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814042358.19297-1-hch@lst.de>

On Wed, Aug 14, 2024 at 06:23:57AM +0200, Christoph Hellwig wrote:
> There is no truncating down going on here, the code has changed multiple
> times since the comment was added with the initial FITRIM implementation
> and it doesn't make sense in the current context.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Heh, whoops.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_discard.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 6f0fc7fe1f2ba9..6516afecce0979 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -689,13 +689,6 @@ xfs_ioc_trim(
>  	range.minlen = max_t(u64, granularity, range.minlen);
>  	minlen = XFS_B_TO_FSB(mp, range.minlen);
>  
> -	/*
> -	 * Truncating down the len isn't actually quite correct, but using
> -	 * BBTOB would mean we trivially get overflows for values
> -	 * of ULLONG_MAX or slightly lower.  And ULLONG_MAX is the default
> -	 * used by the fstrim application.  In the end it really doesn't
> -	 * matter as trimming blocks is an advisory interface.
> -	 */
>  	max_blocks = mp->m_sb.sb_dblocks + mp->m_sb.sb_rblocks;
>  	if (range.start >= XFS_FSB_TO_B(mp, max_blocks) ||
>  	    range.minlen > XFS_FSB_TO_B(mp, mp->m_ag_max_usable) ||
> -- 
> 2.43.0
> 
> 

