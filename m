Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B8B322462
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Feb 2021 04:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhBWDBk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Feb 2021 22:01:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:47568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231267AbhBWDBe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 22:01:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5526764E4A;
        Tue, 23 Feb 2021 03:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049253;
        bh=E+nr4GUSFhrROrwtzLXtQkq0fOas518cxwYs4EPNyX8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gLV3QYdZpzQLasqexM9HfBqCd3f1ko/uj3HqjdRnMJhbo9cpi8/PiG+88pUsekzo4
         839RWMzPcbx8VzUeBMXUwp4v3j9ORFSp/adhJ28pa0Jqg9qpEtmlePuhFBiHofFz7U
         ZPa39tif1XYg6OlcjvxVL4OB6+E674z7bTcdimC6UvRCQcj0Xzp/f6XEMf2/lO4OP7
         6zeOJhw5XHTojgR/CNAry4hlk9IIm1fP27e6pGybcpaZqskRN88wbRVOUFpwOn9s+T
         011WCwFYOqPZQCzxW2JV5ArhNAW1uYcEsHyIlh6gkBe1qgHD14sPbWOWsyDcskFkbE
         XCh+ziRaV4Fiw==
Subject: [PATCH 6/7] xfs_repair: clear quota CHKD flags on the incore
 superblock too
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 22 Feb 2021 19:00:52 -0800
Message-ID: <161404925290.425352.17614643483707405953.stgit@magnolia>
In-Reply-To: <161404921827.425352.18151735716678009691.stgit@magnolia>
References: <161404921827.425352.18151735716678009691.stgit@magnolia>
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

(Get rid of dsb too, since the incore super should be in sync with the
ondisk super.)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 repair/xfs_repair.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9409f0d8..40352458 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -717,7 +717,6 @@ main(int argc, char **argv)
 {
 	xfs_mount_t	*temp_mp;
 	xfs_mount_t	*mp;
-	xfs_dsb_t	*dsb;
 	struct xfs_buf	*sbp;
 	xfs_mount_t	xfs_m;
 	struct xlog	log = {0};
@@ -1103,22 +1102,19 @@ _("Warning:  project quota information would be cleared.\n"
 	if (!sbp)
 		do_error(_("couldn't get superblock\n"));
 
-	dsb = sbp->b_addr;
-
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
 		do_warn(
 _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\n"
   "Please reset with mount -o sunit=<value>,swidth=<value> if necessary\n"),
-			be32_to_cpu(dsb->sb_unit), be32_to_cpu(dsb->sb_width));
+			mp->m_sb.sb_unit, mp->m_sb.sb_width);
 	}
 
 	libxfs_buf_mark_dirty(sbp);

