Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E63314760
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Feb 2021 05:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhBIEPf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Feb 2021 23:15:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230264AbhBIEN1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:13:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 096E664EC2;
        Tue,  9 Feb 2021 04:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843833;
        bh=aAmzJf18ktp3SedQLpPnsnauEZAbPBZYRg1zo7DJOBg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AxDtHxycYitSEcimM2gqRWnJJjwMcpQl2Jyg4LHspVJ2mLnTRZu2f+H84P9puh37l
         hKsOGlPMiVvOl++68G/CRiSfsziUeBxsS4QApBgQORxEMEWKyx33M/OjrpB1Rm+b0f
         DQXiUJVpMl8TqZ93VH5IL/9vPzDe4F/8BL86iBdpdtuR4c9AaaWmVD+1BQ0wvyx0V/
         KikshYDXcbxSPk9KyDQ8OGIJiecTaJidNh8G1Z3z49D2myehROIhg8QogbELFxPgLP
         9IlX3Xgl+SCV1jAFGr7eTdGV5ChA/LHe2urP9RLCm8VIxfKMwa4G8H6cf7etBdxxb6
         3JrTArNfBvNMQ==
Subject: [PATCH 05/10] xfs_repair: clear quota CHKD flags on the incore
 superblock too
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 08 Feb 2021 20:10:32 -0800
Message-ID: <161284383258.3057868.6167060787728229726.stgit@magnolia>
In-Reply-To: <161284380403.3057868.11153586180065627226.stgit@magnolia>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

At the end of a repair run, xfs_repair clears the superblock's quota
checked flags if it found mistakes in the quota accounting to force a
quotacheck at the next mount.  This is currently the last time repair
modifies the primary superblock, so it is sufficient to update the
ondisk buffer and not the incore mount structure.

However, we're about to introduce code to clear the needsrepair feature
at the very end of repair, after all metadata blocks have been written
to disk and all disk caches flush.  Since the convention everywhere else
in xfs is to update the incore superblock, call libxfs_sb_to_disk to
translate that into the ondisk buffer, and then write the buffer to
disk, switch the quota CHKD code to use this mechanism too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/xfs_repair.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9409f0d8..32755821 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1108,10 +1108,9 @@ _("Warning:  project quota information would be cleared.\n"
 	if ((mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD) != quotacheck_results()) {
 		do_warn(_("Note - quota info will be regenerated on next "
 			"quota mount.\n"));
-		dsb->sb_qflags &= cpu_to_be16(~(XFS_UQUOTA_CHKD |
-						XFS_GQUOTA_CHKD |
-						XFS_PQUOTA_CHKD |
-						XFS_OQUOTA_CHKD));
+		mp->m_sb.sb_qflags &= ~(XFS_UQUOTA_CHKD | XFS_GQUOTA_CHKD |
+					XFS_PQUOTA_CHKD | XFS_OQUOTA_CHKD);
+		libxfs_sb_to_disk(sbp->b_addr, &mp->m_sb);
 	}
 
 	if (copied_sunit) {

