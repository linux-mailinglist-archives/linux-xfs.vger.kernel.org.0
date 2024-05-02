Return-Path: <linux-xfs+bounces-8079-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 667658B91BF
	for <lists+linux-xfs@lfdr.de>; Thu,  2 May 2024 00:50:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1748E1F21A71
	for <lists+linux-xfs@lfdr.de>; Wed,  1 May 2024 22:50:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3642A50286;
	Wed,  1 May 2024 22:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K9M6XOU8"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41CD2EB11;
	Wed,  1 May 2024 22:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714603809; cv=none; b=KcHOYYPQJxmO2w8B7OCiE1wzrQcLc1dyRp7aTwpwuSRarEDhoDy2cHr+eEIMTk66eouFokCdCdttG1Trhd3qFBjzgHdzOMt4iTx97OvskBE/YIb25lnPPmX6si5U3WPSUYalgozaVEFxJJbww3WEugQusk9Xv+CdOWVnDPF9a4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714603809; c=relaxed/simple;
	bh=SoV+SxEkhA3zL0egu/9ZIbQpNspvP6UGxdsgBdTLQhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eAtJOv+FxnllCsXhLhEa1kFRcatYTBzSHyUgElqppqcIbTaL0CZdXJzUriZ3SsoxzUgBNnRY7+yBg5yO3dY3hnbyUNhHi+pUMLvlzqEly6FyVGG/yCtWDDulBgqeDKKhX3EgN1mv6SlFqT9FAD0N4vdyM2EumVi6A4hVHoz9miA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K9M6XOU8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89563C072AA;
	Wed,  1 May 2024 22:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714603808;
	bh=SoV+SxEkhA3zL0egu/9ZIbQpNspvP6UGxdsgBdTLQhQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K9M6XOU8IwCWcm/PrVvOFEid4ZKCyKNshOxK18UiC2itEgrEfsCXLO2y0GLFPPdL4
	 aTJtc24c+aYNb7OF6J0jwQKfWCGj1fyKmX3zvHa+eHhf2m80XpO84OjIraN5NTjUL8
	 guHE+H8RvgZijdl9d8Rug9h2sj+SlLahhkZitzcqhb+FEvCcOeUp9IeLNoQfoQnEb3
	 qaXwF9eAlyO9R9PoHFMXrS/nZTiH+u8iQZCwSwAQUipSeXFUWsc3NZkW6UCEUi35ET
	 Flgqav5F9jctOsPyEgea1ZddDcCW5rZ1tQISuL21ofc6m1lGkPraZQQRRIipS65wGZ
	 tO6w+P2UQzRiQ==
Date: Wed, 1 May 2024 15:50:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@redhat.com, ebiggers@kernel.org, linux-xfs@vger.kernel.org,
	alexl@redhat.com, walters@verbum.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 25/26] xfs: make it possible to disable fsverity
Message-ID: <20240501225007.GM360919@frogsfrogsfrogs>
References: <171444680291.957659.15782417454902691461.stgit@frogsfrogsfrogs>
 <171444680792.957659.14055056649560052839.stgit@frogsfrogsfrogs>
 <ZjHlventem1xkuuS@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjHlventem1xkuuS@infradead.org>

On Tue, Apr 30, 2024 at 11:48:29PM -0700, Christoph Hellwig wrote:
> On Mon, Apr 29, 2024 at 08:30:37PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create an experimental ioctl so that we can turn off fsverity.
> 
> Didn't Eric argue against this?  And if we're adding this, I think
> it should be a generic feature and not just xfs specific.

The tagging is a bit wrong, but it is a generic fsverity ioctl, though
ext4/f2fs/btrfs don't have implementations.

<shrug> According to Ted, programs that care about fsverity are supposed
to check that VERITY is set in the stat data, but I imagine those
programs aren't expecting it to turn off suddenly.  Maybe I should make
this CAP_SYS_ADMIN?  Or withdraw it?

--D

