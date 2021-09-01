Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362D53FD03C
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Sep 2021 02:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243252AbhIAANj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 31 Aug 2021 20:13:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243245AbhIAANg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 20:13:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C4D56102A;
        Wed,  1 Sep 2021 00:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630455161;
        bh=UTa46hKvumgBDKbs3/0GuZY6WwZqlrceo2oBhIUCyR8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JkvE5XoFfZgRzsc8QqS6NMfDiEeW15mNWFjWarRNDaPcRYkN9i8cXlUGdvRbaYo5y
         XP7BOSwNC92xcpHNZBeSpbe2bPxjVGFzl2PZiYfynRJlZ5d1rseh2dhxdqB2d7bcBO
         lyyGObWX8NTBU4rjbgmMG8EMDfRF8GK99Q+kSGc/apzxqNBllO5tmcHON58UWM5UmZ
         5nHSV1T01jKY0MlZPz61/chMpP29tJLvV1OQ/Y/EPKqjs8O2Sks9oZsf40ecKQbDG8
         4B/7rymBoeT4dEO6g15/eVEx3qxMFeJSHftj0Jb/5Xk0P62IOy6UN4b9HsdZn6ozZT
         T4BKzv60wBATw==
Subject: [PATCH 2/5] xfs: move reflink tests into the clone group
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Aug 2021 17:12:40 -0700
Message-ID: <163045516076.771564.422157391342318386.stgit@magnolia>
In-Reply-To: <163045514980.771564.6282165259140399788.stgit@magnolia>
References: <163045514980.771564.6282165259140399788.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

"clone" is the group for tests that exercise FICLONERANGE, so move these
tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/519 |    2 +-
 tests/xfs/520 |    2 +-
 tests/xfs/535 |    2 +-
 tests/xfs/536 |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/tests/xfs/519 b/tests/xfs/519
index 675ec07e..49c62b56 100755
--- a/tests/xfs/519
+++ b/tests/xfs/519
@@ -9,7 +9,7 @@
 # flushing the log and then remounting to check file contents.
 
 . ./common/preamble
-_begin_fstest auto quick reflink
+_begin_fstest auto quick clone
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/520 b/tests/xfs/520
index 8410f2ba..2fceb07c 100755
--- a/tests/xfs/520
+++ b/tests/xfs/520
@@ -12,7 +12,7 @@
 # is included in the current kernel.
 #
 . ./common/preamble
-_begin_fstest auto quick reflink
+_begin_fstest auto quick clone
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/xfs/535 b/tests/xfs/535
index 4c883675..1a5da61b 100755
--- a/tests/xfs/535
+++ b/tests/xfs/535
@@ -7,7 +7,7 @@
 # Verify that XFS does not cause inode fork's extent count to overflow when
 # writing to a shared extent.
 . ./common/preamble
-_begin_fstest auto quick reflink
+_begin_fstest auto quick clone
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/536 b/tests/xfs/536
index e5f904f5..64fa4fbf 100755
--- a/tests/xfs/536
+++ b/tests/xfs/536
@@ -7,7 +7,7 @@
 # Verify that XFS does not cause inode fork's extent count to overflow when
 # remapping extents from one file's inode fork to another.
 . ./common/preamble
-_begin_fstest auto quick reflink
+_begin_fstest auto quick clone
 
 # Import common functions.
 . ./common/filter

