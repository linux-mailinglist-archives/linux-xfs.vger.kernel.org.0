Return-Path: <linux-xfs+bounces-16999-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 22B7B9F54FD
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Dec 2024 18:51:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50B927A3C6A
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Dec 2024 17:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24D1D1F8EED;
	Tue, 17 Dec 2024 17:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JjSnaqKI"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EBB1F8AE1
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 17:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734457487; cv=none; b=WpZFtqXVC3CfX35quLvTI1/fXcTWDAggF11WdzFmJFnh2DEoHQdeC4/vatByogOy4DZotZ4mvvZcDFE0H4H9j3PGOwUAzsZhfmiPYmuNb38IcU0vxYfNbKTF7OAyLNZgjARTwNTlyGibqpRbMaNp5wbJ2IhepX+VGVthH1o9RqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734457487; c=relaxed/simple;
	bh=59BmmoWx9VIWeSVopyfTxEj0mMyMh5l9pHQdZOuu7UA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Qw1nOrqvMU0kYs2GstKvtcfVPxNJY+qlVxvMGv0rwUlZ2By7DCNG6LVOiIfvQix8MDda6TSOjxJ+xxtutW5mKT4oAddgU0nknsHQOTilbxRb4PHVatRfCuXcAzvT15a7AUKHSOdJoNhKNLxYaglc/cJHSSnP6UjaBhNENPtCkvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JjSnaqKI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E881C4CED7;
	Tue, 17 Dec 2024 17:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734457487;
	bh=59BmmoWx9VIWeSVopyfTxEj0mMyMh5l9pHQdZOuu7UA=;
	h=Date:From:To:Cc:Subject:From;
	b=JjSnaqKIMAt3qM5SlPK2qnr3DPL7H/Fg6iOwETmmHM5Tm/kTwIoCcGV/obpxEBp+a
	 BY2leXTVT7lpTO6TD4Ir0fc9hP/6W78kiRbEKHegY3IzL2Y2zT9ihIWhO2keXCdKoL
	 EOR/RFBMblKynY3nf4MLzjr0kC8Yakq3XSgnNMMFh7GklDmXe7mVMHsNUUAwZgaeXQ
	 TpCsB+J+xesrSYrE3SsB9j3JVo6cCKbvfOJQfF1d3BQ5uUTNMCYJzdI2MPH/BUGOv/
	 Gar2eAon7XkVGJqT2G9As21B1OIAFYgYDCh7sUfc2BvDjzv0/ryPPsMavskuzNRX9W
	 oLIAwlnKR12Lw==
Date: Tue, 17 Dec 2024 09:44:46 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Emmanuel Florac <eflorac@intellique.com>,
	xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: don't over-report free space or inodes in statvfs
Message-ID: <20241217174446.GN6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Emmanual Florac reports a strange occurrence when project quota limits
are enabled, free space is lower than the remaining quota, and someone
runs statvfs:

  # mkfs.xfs -f /dev/sda
  # mount /dev/sda /mnt -o prjquota
  # xfs_quota  -x -c 'limit -p bhard=2G 55' /mnt
  # mkdir /mnt/dir
  # xfs_io -c 'chproj 55' -c 'chattr +P' -c 'stat -vvvv' /mnt/dir
  # fallocate -l 19g /mnt/a
  # df /mnt /mnt/dir
  Filesystem      Size  Used Avail Use% Mounted on
  /dev/sda         20G   20G  345M  99% /mnt
  /dev/sda        2.0G     0  2.0G   0% /mnt

I think the bug here is that xfs_fill_statvfs_from_dquot unconditionally
assigns to f_bfree without checking that the filesystem has enough free
space to fill the remaining project quota.  However, this is a
longstanding behavior of xfs so it's unclear what to do here.

Cc: <stable@vger.kernel.org> # v2.6.18
Fixes: 932f2c323196c2 ("[XFS] statvfs component of directory/project quota support, code originally by Glen.")
Reported-by: Emmanuel Florac <eflorac@intellique.com>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_qm_bhv.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 847ba29630e9d8..db5b8afd9d1b97 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -32,21 +32,28 @@ xfs_fill_statvfs_from_dquot(
 	limit = blkres->softlimit ?
 		blkres->softlimit :
 		blkres->hardlimit;
-	if (limit && statp->f_blocks > limit) {
-		statp->f_blocks = limit;
-		statp->f_bfree = statp->f_bavail =
-			(statp->f_blocks > blkres->reserved) ?
-			 (statp->f_blocks - blkres->reserved) : 0;
+	if (limit) {
+		uint64_t	remaining = 0;
+
+		if (limit > blkres->reserved)
+			remaining = limit - blkres->reserved;
+
+		statp->f_blocks = min(statp->f_blocks, limit);
+		statp->f_bfree = min(statp->f_bfree, remaining);
+		statp->f_bavail = min(statp->f_bavail, remaining);
 	}
 
 	limit = dqp->q_ino.softlimit ?
 		dqp->q_ino.softlimit :
 		dqp->q_ino.hardlimit;
-	if (limit && statp->f_files > limit) {
-		statp->f_files = limit;
-		statp->f_ffree =
-			(statp->f_files > dqp->q_ino.reserved) ?
-			 (statp->f_files - dqp->q_ino.reserved) : 0;
+	if (limit) {
+		uint64_t	remaining = 0;
+
+		if (limit > dqp->q_ino.reserved)
+			remaining = limit - dqp->q_ino.reserved;
+
+		statp->f_files = min(statp->f_files, limit);
+		statp->f_ffree = min(statp->f_ffree, remaining);
 	}
 }
 

