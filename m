Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7E7555EF89
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Jun 2022 22:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbiF1UZD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 28 Jun 2022 16:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbiF1UYp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:24:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CF138BCC;
        Tue, 28 Jun 2022 13:22:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 925AD615DD;
        Tue, 28 Jun 2022 20:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E1BC3411D;
        Tue, 28 Jun 2022 20:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656447723;
        bh=BAil+zq4pmcoLZscz2szx7QFIXfoqD67HveiQlnNTss=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sxVC2HgiGMsG0+DPp7TxW1bMNu0fhVCljj4CQ4/XlWTY2QAMIqqHAqYYC862I6S8g
         i2cwGP1vpTJUNs4NDBTETOllhxYmk3Np4F/g3bu+w53d6faUKOJ/S4QV+GfAf/MWYZ
         FngfesdWzopMzx4Cq/ePVCzQrc0Kzz5cEM3xCXnihLebMHwdCTWW2GkhvKgYyQ33on
         h+eq/XknLYrAjAOE/TI8zHTeQ59DSxkjRaTqJ8dVd1XD+9XS4SIsONpxGSgpknxZxz
         YPG0+RXAdZKtwpSUJG+6M96pnyim4LKvkstR2R1Di3E1lV5SVj6fU4sPxdrv3gpoYm
         Vzb0FleRSLEAw==
Subject: [PATCH 8/9] xfs/166: fix golden output failures when multipage folios
 enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 28 Jun 2022 13:22:02 -0700
Message-ID: <165644772249.1045534.3583119178643533811.stgit@magnolia>
In-Reply-To: <165644767753.1045534.18231838177395571946.stgit@magnolia>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Beginning with 5.18, some filesystems support creating large folios for
the page cache.  A system with 64k pages can create 256k folios, which
means that with the old file size of 1M, the last half of the file is
completely converted from unwritten to written by page_mkwrite.  The
test encodes a translated version of the xfs_bmap output in the golden
output, which means that the test now fails on 64k pages.  Fixing the
64k page case by increasing the file size to 2MB broke fsdax because
fsdax uses 2MB PMDs, hence 12MB.

Increase the size to prevent this from happening.  This may require
further revision if folios get larger or fsdax starts supporting PMDs
that are larger than 2MB.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/166 |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)


diff --git a/tests/xfs/166 b/tests/xfs/166
index 42379961..d45dc5e8 100755
--- a/tests/xfs/166
+++ b/tests/xfs/166
@@ -16,12 +16,12 @@ _begin_fstest rw metadata auto quick
 # the others are unwritten.
 _filter_blocks()
 {
-	$AWK_PROG '
+	$AWK_PROG -v file_size=$FILE_SIZE '
 /^ +[0-9]/ {
 	if (!written_size) {
 		written_size = $6
-		unwritten1 = ((1048576/512) / 2) - written_size
-		unwritten2 = ((1048576/512) / 2) - 2 * written_size
+		unwritten1 = ((file_size/512) / 2) - written_size
+		unwritten2 = ((file_size/512) / 2) - 2 * written_size
 	}
 
 	# is the extent unwritten?
@@ -58,7 +58,18 @@ _scratch_mount
 
 TEST_FILE=$SCRATCH_MNT/test_file
 TEST_PROG=$here/src/unwritten_mmap
-FILE_SIZE=1048576
+
+# Beginning with 5.18, some filesystems support creating large folios for the
+# page cache.  A system with 64k pages can create 256k folios, which means
+# that with the old file size of 1M, the last half of the file is completely
+# converted from unwritten to written by page_mkwrite.  The test will fail on
+# the golden output when this happens, so increase the size from the original
+# 1MB file size to at least (6 * 256k == 1.5MB) prevent this from happening.
+#
+# However, increasing the file size to around 2MB causes regressions when fsdax
+# is enabled because fsdax will try to use PMD entries for the mappings.  Hence
+# we need to set the file size to (6 * 2MB == 12MB) to cover all cases.
+FILE_SIZE=$((12 * 1048576))
 
 rm -f $TEST_FILE
 $TEST_PROG $FILE_SIZE $TEST_FILE

