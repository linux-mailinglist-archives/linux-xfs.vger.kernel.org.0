Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCD3E63C7C
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jul 2019 22:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbfGIUJB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Jul 2019 16:09:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31371 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729155AbfGIUJB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Jul 2019 16:09:01 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1D1D7300BEB6;
        Tue,  9 Jul 2019 20:09:01 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C61AF7E48D;
        Tue,  9 Jul 2019 20:09:00 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mkfs: don't use xfs_verify_fsbno() before m_sb is fully set
 up
Message-ID: <d04c688e-4d67-83f4-8401-d064d13bdc33@redhat.com>
Date:   Tue, 9 Jul 2019 15:09:00 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 09 Jul 2019 20:09:01 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Commit 8da5298 mkfs: validate start and end of aligned logs stopped
open-coding log end block checks, and used xfs_verify_fsbno() instead.
It also used xfs_verify_fsbno() to validate the log start.  This
seemed to make sense, but then xfs/306 started failing on 4k sector
filesystems, which leads to a log striep unite being set on a single
AG filesystem.

As it turns out, if xfs_verify_fsbno() is testing a block in the
last AG, it needs to have mp->m_sb.sb_dblocks set, which isn't done
until later.  With sb_dblocks unset we can't know how many blocks
are in the last AG, and hence can't validate it.

To fix all this, go back to open-coding the checks; note that this
/does/ rely on m_sb.sb_agblklog being set, but that /is/ already
done in the early call to start_superblock_setup().

Fixes: 8da5298 ("mkfs: validate start and end of aligned logs")
Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Sorry for missing this one in regression testing :/

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 468b8fde..4e576a5c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3040,7 +3040,7 @@ align_internal_log(
 		cfg->logstart = ((cfg->logstart + (sunit - 1)) / sunit) * sunit;
 
 	/* If our log start overlaps the next AG's metadata, fail. */
-	if (!xfs_verify_fsbno(mp, cfg->logstart)) {
+	if (XFS_FSB_TO_AGBNO(mp, cfg->logstart) <= XFS_AGFL_BLOCK(mp)) {
 			fprintf(stderr,
 _("Due to stripe alignment, the internal log start (%lld) cannot be aligned\n"
   "within an allocation group.\n"),
@@ -3051,10 +3051,9 @@ _("Due to stripe alignment, the internal log start (%lld) cannot be aligned\n"
 	/* round up/down the log size now */
 	align_log_size(cfg, sunit);
 
-	/* check the aligned log still fits in an AG. */
+	/* check the aligned log still starts and ends in the same AG. */
 	logend = cfg->logstart + cfg->logblocks - 1;
-	if (XFS_FSB_TO_AGNO(mp, cfg->logstart) != XFS_FSB_TO_AGNO(mp, logend) ||
-	    !xfs_verify_fsbno(mp, logend)) {
+	if (XFS_FSB_TO_AGNO(mp, cfg->logstart) != XFS_FSB_TO_AGNO(mp, logend)) {
 		fprintf(stderr,
 _("Due to stripe alignment, the internal log size (%lld) is too large.\n"
   "Must fit within an allocation group.\n"),

