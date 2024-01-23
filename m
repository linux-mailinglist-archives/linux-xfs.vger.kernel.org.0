Return-Path: <linux-xfs+bounces-2932-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4F5C838BE6
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Jan 2024 11:29:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E79BF1C224E5
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Jan 2024 10:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABD945BADB;
	Tue, 23 Jan 2024 10:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ID/8gre8"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3C45BAE7
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 10:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706005780; cv=none; b=kFysI6gHQEvbfiSpv+ikJf1wa/2ySVGRMkmROUMkDlaIqznmXl0UD8jY5ecZ/ZrRWfkIEUkyKR6l/95ynOK+FMRiuZj7DeHv6mPczzwu3D7DDgW+kMkQfhGVCzcEDK96XdKKvXFWkC2wYyvTqbLO79nq2D0glxznzuQRM+iJgWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706005780; c=relaxed/simple;
	bh=2wUkxfgYpofnkA2/LjnWmRTn4nScecYU/D750cu/kvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GZayP0Z2vDj+6vyxSM+QjdhxzPeU4xbvSRQwRQzk7To7txVXBmjeqTb0UDPyq8ZiJCgJdDpFkbPhjfAnZ11dDYp/bEyN04LkLzCjI4itu0NO+VgN//qUgjcdVB3NSR8U1DPVXv/XjIcLKzw8mP4Dp5ORWAA9hsvR4XF0zXBjNRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ID/8gre8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE254C433C7;
	Tue, 23 Jan 2024 10:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706005779;
	bh=2wUkxfgYpofnkA2/LjnWmRTn4nScecYU/D750cu/kvI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ID/8gre8aptYqtdeu7uOuteYwcCpLeNpkRWkC3SbeH6JXtOh0g+F0awUu2EDRweqs
	 CtlTCL3RQZ8BUpb+UeCYhE+plAm7HiFpajMlc8wNpg2xEZERkgGgwBmn/FnCCZOXM7
	 U1WplzWZpnf/vtPQGsxFLShoFbcHghQDbxbIPFfAeiV1AZ+dUgwimcVGh8P2T5/Z4M
	 GxhqTkANHptEgTxYViE372sNeZ6Biun6j0boK3OujbmoeBbtU6LmMFZi9AfbYyngbF
	 eMsay1sqriKJgiQMk3JUruo+tnu6cFF7QK2cDSNWcx8rLniyAnYyBKzYVyNx0rBLLy
	 1V/uM/ST7e1sg==
Date: Tue, 23 Jan 2024 11:29:34 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL 3/6] xfs_scrub: fixes to the repair code
Message-ID: <hu63j7c6gwphvzge73fwjqmn7zkscr2xif523or6ti5l7quzus@b7m6avpz7dff>
References: <ciGNO1q9jvG-g9wEBfpT2U6k7IQyoT4LQiyHbytjSYoklyvQ5DrBo1VhztWxhBsuWW-xidrd1g4JtKyGr0i5kA==@protonmail.internalid>
 <170502573357.996574.18197732259576686299.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170502573357.996574.18197732259576686299.stg-ugh@frogsfrogsfrogs>

On Thu, Jan 11, 2024 at 06:16:56PM -0800, Darrick J. Wong wrote:
> Hi Carlos,
> 
> Please pull this branch with changes for xfsprogs for 6.6-rc1.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> The following changes since commit 52520522199efa984dcf172a3eb8d835b93e324e:
> 
> xfs_scrub: update copyright years for scrub/ files (2024-01-11 18:08:46 -0800)
> 
> are available in the Git repository at:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-repair-fixes-6.6_2024-01-11
> 
> for you to fetch changes up to 96ac83c88e01ff7f59563ff76a96e555477c8637:
> 
> xfs_scrub: don't report media errors for space with unknowable owner (2024-01-11 18:08:46 -0800)

Pulled, thanks!

Carlos

> 
> ----------------------------------------------------------------
> xfs_scrub: fixes to the repair code [v28.3 3/6]
> 
> Now that we've landed the new kernel code, it's time to reorganize the
> xfs_scrub code that handles repairs.  Clean up various naming warts and
> misleading error messages.  Move the repair code to scrub/repair.c as
> the first step.  Then, fix various issues in the repair code before we
> start reorganizing things.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> ----------------------------------------------------------------
> Darrick J. Wong (2):
> xfs_scrub: flush stdout after printing to it
> xfs_scrub: don't report media errors for space with unknowable owner
> 
> scrub/phase6.c    | 13 ++++++++++++-
> scrub/xfs_scrub.c |  2 ++
> 2 files changed, 14 insertions(+), 1 deletion(-)
> 

