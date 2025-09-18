Return-Path: <linux-xfs+bounces-25660-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0803BB59374
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Sep 2025 12:24:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A363D4E1D19
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Sep 2025 10:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EFFC3054EF;
	Tue, 16 Sep 2025 10:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rYqfsavk"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE272E92AD;
	Tue, 16 Sep 2025 10:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758018181; cv=none; b=h4q2vs1kJz9fmq0NMGYk5RXjU7NY68UXjGFovJKCnsjckqIAUF+iIoJvoWOn6eej+kK6uef7To1tR5pF3GVffWTlljwXzUhytHjAuMAHAvrEIJVoWqaneYv0I5zewb1DL4Uy5fWw/0s84fflrTA7lOUdFRvF1bST7zZZxEkhcQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758018181; c=relaxed/simple;
	bh=MlUpvAIai8ibvR7PK9nk2y4mI/Ot44xQtJkMrmuistQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cKHKBR2H+Y1NslpLYUsDBSb52mStoZe2LljPHp7P/agmH3kgoW4/8q7ZKt/NyypGz8CmhyVki/8LbX9kwzWt/KKxJE45xMPi5Wm3UDBIkMIQoEXkhD7FlUyH8E9KBkU1IhI1S6IuZ9aO4bCvImwDXJUYXzf++CKXKMVVHZk8t4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rYqfsavk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34A5C4CEEB;
	Tue, 16 Sep 2025 10:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758018181;
	bh=MlUpvAIai8ibvR7PK9nk2y4mI/Ot44xQtJkMrmuistQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rYqfsavkeSSzwh2rHlvHWEAKsxympVQGpX1f/wWJPXY9GZI9UD2Vl+mN/BVtK4s6G
	 3NlnAXmXSqv7+w0X/4TPczofFjaNoktZlISOMAk5xo2c4fpbxmBjFG6HrJ6MCBhyxM
	 CB8/vMjzWGi14Wm0GVASZg7p7OTTbgPyLJLUxDOk3nfZbhWbh/0IYETwaMRJAZ8OEi
	 df+1Udp8+7yaTiy+Vm2rIhnagFMuoDjz2QZyXM6BGXGOsXSNkQQoB09iNCIDW5yWrU
	 a8D4Kk1hCM241KSs8FvIn1zQ9ltPtUL7zLY5em8VT9TCn+eaHBEJsqTUWgOJ+hZFPG
	 REMbzN1gL01kw==
Date: Tue, 16 Sep 2025 12:22:55 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, 
	"Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the xfs tree
Message-ID: <af5xdo5mdyogilfxbthpdsce33qjwfupkotc7hyr646pujselp@rkl3kutglp2k>
References: <D20pUU7kdgWfIpAYmLR776cP2sU4_NhTrc4Fasx5DbMewO7J6UW6QX_81athF3DSSPP2tZiEZNid_Rlin4p6lw==@protonmail.internalid>
 <20250908180406.32124fb7@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908180406.32124fb7@canb.auug.org.au>

On Mon, Sep 08, 2025 at 06:04:06PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the xfs tree, today's linux-next build (htmldocs) produced
> this warning:
> 
> Documentation/admin-guide/xfs.rst:365: ERROR: Malformed table.
> Text in column margin in table line 8.

Thanks, we've got a fix for it already, I will push it soon.

> 
> =============================   =======
>   Name                          Removed
> =============================   =======
>   fs.xfs.xfsbufd_centisec       v4.0
>   fs.xfs.age_buffer_centisecs   v4.0
>   fs.xfs.irix_symlink_mode      v6.18
>   fs.xfs.irix_sgid_inherit      v6.18
>   fs.xfs.speculative_cow_prealloc_lifetime      v6.18
> =============================   ======= [docutils]
> 
> Introduced by commit
> 
>   21d59d00221e ("xfs: remove deprecated sysctl knobs")
> 
> -- 
> Cheers,
> Stephen Rothwell



