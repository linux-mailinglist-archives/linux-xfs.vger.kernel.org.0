Return-Path: <linux-xfs+bounces-28160-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D8626C7CC60
	for <lists+linux-xfs@lfdr.de>; Sat, 22 Nov 2025 11:15:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 294CE344A46
	for <lists+linux-xfs@lfdr.de>; Sat, 22 Nov 2025 10:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B3FB2F532F;
	Sat, 22 Nov 2025 10:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V3EoGumW"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C8F2561A7
	for <linux-xfs@vger.kernel.org>; Sat, 22 Nov 2025 10:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763806528; cv=none; b=R4M0DapWM0YkPvW58sQ9Evdgqcc58AQP+jx6xullf7x/BgWTXtta0DrabaFH/pKlFVKTy7KFeHFFf1V8SZNWTK9H+IKNO0uB42FK8D2PpNnmOrhNaKnwGp7vV3uVdsV4RYx1hI913yay6l4+toEZs1EHXT0gSirRiAnstlo1LN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763806528; c=relaxed/simple;
	bh=cd6s0fUiU3DpCLK0l3/2aQuEXHr45GA0ox5ULsoh3Qc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=g+l0y71ymeGmSYxSKDhJShWV6HqdxH0cGP8WDLMsBiipg/aPEWVsLuaVQJxHOeoK3T8XEb4laU819B1ZJaXkO2k2MFXlT+6g2rvAFE2koBtNcztpmxDill1dDVkwp7KikTS9ziKqvyS+tVh0rtrDEAYj/PPFbRbk5LHgM+XDzM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V3EoGumW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52A4C4CEF5;
	Sat, 22 Nov 2025 10:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763806527;
	bh=cd6s0fUiU3DpCLK0l3/2aQuEXHr45GA0ox5ULsoh3Qc=;
	h=Date:From:To:Cc:Subject:From;
	b=V3EoGumWzR4a0gvZigICzm8+by2+uh4DmVuDBg5gAB5HTJla+k71WLxnrLtcCOcZI
	 n2NBG7EC9zCQljynG7/fVCpz0iZvbbKM2v2U7CYxRm1QdBYLqRHKocdFN525z3DmjV
	 v6lPkYq9yr6NXHYg+T/Sb7nWo2ipuZIIfGXdTjDdr2tbzyfv6i7AvVVMVb2fNpeb+t
	 1gNewOPe3wN+pWK7CsxDP0WPYG3af6aKfQL1MJn8JrlkfsI6zm1jq7mvU2PKruhSKB
	 T7DaIBUr3cVchXDEkQ2LwkWmnPn6/dclKx1lpiccda5O1DTy6To3GOsJc77F1J4btC
	 VmA+ikqN5wZAQ==
Date: Sat, 22 Nov 2025 11:15:24 +0100
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: Fixes for for v6.18-rc7
Message-ID: <wcxsin6uzmospeiqmgzxxtg4nn6uwnamywzcd4blxjkjmbbrfq@p7kvosodwcrd>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

An attempt merge against your current TOT has been successful.

It just contains a Out-of-bounds fix, nothing special, but I couldn't
let it cook in linux-next this time.

Thanks,
Carlos

The following changes since commit d8a823c6f04ef03e3bd7249d2e796da903e7238d:

  xfs: free xfs_busy_extents structure when no RT extents are queued (2025-11-06 08:59:19 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.18-rc7

for you to fetch changes up to 678e1cc2f482e0985a0613ab4a5bf89c497e5acc:

  xfs: fix out of bounds memory read error in symlink repair (2025-11-20 11:06:24 +0100)

----------------------------------------------------------------
xfs: fixes for 6.18-rc7

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
      xfs: fix out of bounds memory read error in symlink repair

 fs/xfs/scrub/symlink_repair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


