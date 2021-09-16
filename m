Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8F840D05C
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Sep 2021 01:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhIOXoQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 Sep 2021 19:44:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233046AbhIOXoO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:44:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25E1960F8F;
        Wed, 15 Sep 2021 23:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631749374;
        bh=rxk/t4cR1g4piI1VKbOEcrL83pmv/7seWPEVoC2Ns3s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Mqe2Rc8mdkkaVqdZ/tuFLqtb9Sf3m7jj+RYwixWZYeZLgQKJalldUSqaw8WXzRJzL
         AuZLsrOXCdqYpuTl9PuaWk6UfgRSEjoyCRUDq4nq2nzJUQ96XWSnS1yfHPxksbUSKQ
         wVcQegHdJD+phjYpaYLZyQ9a6ijHqH8zyf2Z2EnSqX3dmKuvJ0ivsLGFh6eA/Kcmh0
         R3clduMlYiygabJR6ZR/YZI8Wgx2CggAo74+V+X3iMtIPx0I8o4dARDP0trzHsFllv
         FGR5vYkr62OLoqJL8exe4s/iDhH6fa7AYH5ws52yJKLow0hgSNeeRU6z9GcgwUdcoM
         63yy7Xk9BwJBQ==
Subject: [PATCH 3/9] xfs: fix incorrect fuzz test group name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 15 Sep 2021 16:42:53 -0700
Message-ID: <163174937390.380880.10714985927715519622.stgit@magnolia>
In-Reply-To: <163174935747.380880.7635671692624086987.stgit@magnolia>
References: <163174935747.380880.7635671692624086987.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The group name for fuzz tests is 'fuzzers'.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/491 |    2 +-
 tests/xfs/492 |    2 +-
 tests/xfs/493 |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/491 b/tests/xfs/491
index 5c7c5d1f..7402b09a 100755
--- a/tests/xfs/491
+++ b/tests/xfs/491
@@ -7,7 +7,7 @@
 # Test detection & fixing of bad summary block counts at mount time.
 #
 . ./common/preamble
-_begin_fstest auto quick fuzz
+_begin_fstest auto quick fuzzers
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/492 b/tests/xfs/492
index 8258e5d8..514ac1e4 100755
--- a/tests/xfs/492
+++ b/tests/xfs/492
@@ -7,7 +7,7 @@
 # Test detection & fixing of bad summary inode counts at mount time.
 #
 . ./common/preamble
-_begin_fstest auto quick fuzz
+_begin_fstest auto quick fuzzers
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/493 b/tests/xfs/493
index 58fd9c99..58091ad7 100755
--- a/tests/xfs/493
+++ b/tests/xfs/493
@@ -8,7 +8,7 @@
 # Corrupt the AGFs to test mount failure when mount-fixing fails.
 #
 . ./common/preamble
-_begin_fstest auto quick fuzz
+_begin_fstest auto quick fuzzers
 
 # Import common functions.
 . ./common/filter

