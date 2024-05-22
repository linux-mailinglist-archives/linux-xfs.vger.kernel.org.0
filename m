Return-Path: <linux-xfs+bounces-8479-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1CB68CB90F
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 04:47:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F6771F2362D
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 02:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89C5B1E4A2;
	Wed, 22 May 2024 02:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pEbNM1wa"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4932433C9
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346017; cv=none; b=g0DGHJiCGhp216ChtfIYMESa2Tj3nMaM1fuqZXnR2ap1aN4zuC1Krp/6ikV24pxXPHL1/TRoQ08ZUn5Goi6RXSg8NKWliIPR0RwKI9IffTs59sBDpFKped8Gt6v4v/JjXqe8kGMHqHraOrH0ZoCs2U3Pe1TEpt9N9aYQZwulFrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346017; c=relaxed/simple;
	bh=6UmEbsbaaLbnzw3sk4mT9xcHi5sYPvweoGejSE6r1R4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=STcxSDNlSHVGAaabWpy6q6TQw7rXCZ+ME6jjgEg8s+yO9PCxpr755wRl0fBjHgIrC3D66pkGvQVNiSEbinbBcleMucs+5tPgiyse3eF4tq09ZWN7p7zcsP5sPu74X+uKuDO4PRYI/Dg/dnvs1d/lJrLpxL2UVJDAgJkY52lZ13g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pEbNM1wa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0F1C2BD11;
	Wed, 22 May 2024 02:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346016;
	bh=6UmEbsbaaLbnzw3sk4mT9xcHi5sYPvweoGejSE6r1R4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pEbNM1waGWqUogAILaUPmdEoe9qC1orv6MY00WA0myowrpH22+KJzzdT5COVPRbDA
	 1+T4t3QDcrU5xrbuvAi7brYklxY9cdVYqyQ97b1u91Ig0E9nTjpNIIdOr0edcdP57L
	 eN1yLDtvLk6DcZIbGWTr5MtFUNowsk8uhpcVgrgwfkSzwccULFLzESTxQ+ZmUWiUJl
	 rFg3tqZf3+TTyEsAC3U11lC2zT8xLhpwp3UhiZpGEu1LjvNQpS3CCQGFZVO1vnKlsV
	 xGAasMPa8RfDAc1hbGhHOOfOhWHsy6MtPKv/13oJFHp/S57hIFRpakA8isUNm0Brd4
	 GhxcIwbrcOmmA==
Date: Tue, 21 May 2024 19:46:56 -0700
Subject: [PATCHSET v30.4 06/10] xfs_scrub: updates for 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634534709.2482960.7052575979502113240.stgit@frogsfrogsfrogs>
In-Reply-To: <20240522023341.GB25546@frogsfrogsfrogs>
References: <20240522023341.GB25546@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Now that the kernel has the code for userspace to upload a clean bill of
health (which clears out all the secondary markers of ill health that
hint at forgotten sicknesses), let's make xfs_scrub do that if the
filesystem is actually clean.

Second, restructure the xfs_scrub program so that it scrubs file link
counts and quotacheck in parallel.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-fixes-6.9
---
Commits in this patchset:
 * xfs_scrub: implement live quotacheck inode scan
 * xfs_scrub: check file link counts
 * xfs_scrub: update health status if we get a clean bill of health
 * xfs_scrub: use multiple threads to run in-kernel metadata scrubs that scan inodes
 * xfs_scrub: upload clean bills of health
---
 libfrog/scrub.c                     |   15 ++++
 man/man2/ioctl_xfs_scrub_metadata.2 |   10 ++
 scrub/phase1.c                      |   38 +++++++++
 scrub/phase4.c                      |   17 ++++
 scrub/phase5.c                      |  150 ++++++++++++++++++++++++++++++++---
 scrub/repair.c                      |   18 ++++
 scrub/repair.h                      |    1 
 scrub/scrub.c                       |   43 +++++++---
 scrub/scrub.h                       |    3 +
 9 files changed, 265 insertions(+), 30 deletions(-)


