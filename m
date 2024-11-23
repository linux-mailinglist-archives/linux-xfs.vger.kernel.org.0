Return-Path: <linux-xfs+bounces-15815-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8BF59D6710
	for <lists+linux-xfs@lfdr.de>; Sat, 23 Nov 2024 02:38:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B18BB22AD8
	for <lists+linux-xfs@lfdr.de>; Sat, 23 Nov 2024 01:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 618A61F949;
	Sat, 23 Nov 2024 01:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E2w6E7VY"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A16817;
	Sat, 23 Nov 2024 01:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732325909; cv=none; b=jDvNiN/V39AT/wjYYZVvgsqX+bHt7zGosJ9mCvhXTdONOL49Guc2bVCCSIoJUtBd8ZLPLV+y8xwT1tIAdxkpDkfaUAdNv5KCaMOT2fZuYi49FwOnIeNWn1ZfueE18RfBWwqq/O0IOhbb6P61PUCrI5oydiJHBhVPFbm6ZjPZtQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732325909; c=relaxed/simple;
	bh=cz/erW3GiJ8pa6B0eJclDFPPxuOHoVI/iurseYC62j0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=V1BzVTWZHf95S2FVLWjDl7cje7r6WenaAf9eC9P4188TNMIkhkhVUCfcNW9fLDJ/gYgjbB2bZsvEsY10yo2GyC5AlCrxEDslf907TAhk9r1OBIpruG2YwLlFs2EY9+XIRUTAt3d9H22wqiamojkSb5uJsBi/qeQA8tWzJL04xFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E2w6E7VY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDE2C4CECE;
	Sat, 23 Nov 2024 01:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732325908;
	bh=cz/erW3GiJ8pa6B0eJclDFPPxuOHoVI/iurseYC62j0=;
	h=Date:From:To:Cc:Subject:From;
	b=E2w6E7VYZfBAx1ON3GRq78lcY9y/B0anWMPw9GRMysRP5gHRzoxHrx0imM3KldsjV
	 mEU5dMSab4Fhkvt+AYBKXcE5RsZDZdOwtB1MSlVTODVDJYc30xxdDptYG2h0FgBO00
	 oFyJthPpQ+N66eM21FHZmD7WBdaQUSZJlMtPfaLnlE+7mqYEuTM0vIDGSo7BonWxBJ
	 LJ/oU7o+cs8A7gmKk2s2n1ynEl4MWmhLfijHqZuCaYm3Zvn46YkkMiJEswKBIahRaw
	 L5Xnra2iRY5870CLma5YBsKv02hrT/D+K1Hy6fl5kpY2cqGeFxUH1aRB+gKRRAZpfb
	 HGqcrNrV0SAxg==
Date: Fri, 22 Nov 2024 17:38:28 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH 6.12] MAINTAINERS: appoint myself the XFS maintainer for 6.12
 LTS
Message-ID: <20241123013828.GA620578@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

I'm appointing myself to be responsible for getting after people to
submit their upstream bug fixes with the appropriate Fixes tags and to
cc stable; to find whatever slips through the cracks; and to keep an eye
on the automatic QA of all that stuff.

Cc: <stable@vger.kernel.org> # v6.12
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b878ddc99f94e7..23d89f2a3008e2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -25358,8 +25358,7 @@ F:	include/xen/arm/swiotlb-xen.h
 F:	include/xen/swiotlb-xen.h
 
 XFS FILESYSTEM
-M:	Carlos Maiolino <cem@kernel.org>
-R:	Darrick J. Wong <djwong@kernel.org>
+M:	Darrick J. Wong <djwong@kernel.org>
 L:	linux-xfs@vger.kernel.org
 S:	Supported
 W:	http://xfs.org/

