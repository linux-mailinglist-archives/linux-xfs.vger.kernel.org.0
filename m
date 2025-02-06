Return-Path: <linux-xfs+bounces-19192-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 815C1A2B578
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Feb 2025 23:46:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4EBF3A3C4A
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Feb 2025 22:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 957FE1A5B94;
	Thu,  6 Feb 2025 22:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ek+y9CPi"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AAD197A8E
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881997; cv=none; b=I7MPhh1PiIAzmkcTRimDLhO7Ac3yUFft5/yQuNvME5NjXzVSqUzYKkIfuvIH7THN769f84/wmJ8O93YQFyvtF9dTJRfND499k3dfDL0Um3ERzq/fxxQF1Qm7dTiKXtJyujjGsbehMpklHgC/Er7hIZvj4DLJWWnxNCDFqk818dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881997; c=relaxed/simple;
	bh=fy0ymoHqqQ1lrH1zTsh5wXaJ3COxokz5fVjduAFsdRM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kjbWYP19YPyckMkK5AYIPzx6Cac1ozxXcJcRqNaPT0UdlHJ6GVBwLfXl2gjv/wYvnXsuShXRcwDkk8za1L0e4ImjA152Ig0eVNimqsjmL1df47SLXiqNvJCPZ5A6hugp97vAW0B496ZptVw9yrIeGrIrniozfVJHMsD0H8KRjb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ek+y9CPi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19BDC4CEDD;
	Thu,  6 Feb 2025 22:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881996;
	bh=fy0ymoHqqQ1lrH1zTsh5wXaJ3COxokz5fVjduAFsdRM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ek+y9CPiBkSUc4P4XiMswFh7mJ16k7vi+/P7Bptc+5y6xSmThzZVeEckISm1g0AlI
	 2icK/Awj1CWRFH2P1naxn/ovXOD05YtIiQJbO3gHNy2WI+toNqGFF7O8LuRF2ACAM1
	 YK2OanOmiaUp7zS0hk7kB6bEU+Tz3prNKMuQi3afnV+doix8LFN78pFVqo0uhcEQxm
	 VlfQiOQ+jwZw7wYVQvMVxw2oI6iDbgoPDnq+wn/LD23daadvnpMn7SLilSNKQnxL6K
	 kHzQCf7vJBSDfdAFBhu9Hi3rNPsxTk+odi68g8tqE0U8HHhAOoGiL7Qch9hPVHmIiY
	 AHTEg+XYrVsiQ==
Date: Thu, 06 Feb 2025 14:46:36 -0800
Subject: [PATCH 44/56] xfs: allow inodes to have the realtime and reflink
 flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087466.2739176.12983043881195748531.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: c3d3605f9661a2451c437a037d338dc79fb78f37

Now that we can share blocks between realtime files, allow this
combination.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_inode_buf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 0be0625857002c..a7774fc32e2755 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -745,7 +745,8 @@ xfs_dinode_verify(
 		return __this_address;
 
 	/* don't let reflink and realtime mix */
-	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
+	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME) &&
+	    !xfs_has_rtreflink(mp))
 		return __this_address;
 
 	/* COW extent size hint validation */


