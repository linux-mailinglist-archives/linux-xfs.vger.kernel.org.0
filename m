Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B4840EE5E
	for <lists+linux-xfs@lfdr.de>; Fri, 17 Sep 2021 02:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbhIQAkg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Sep 2021 20:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241715AbhIQAkf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 20:40:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37FBD611C8;
        Fri, 17 Sep 2021 00:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631839154;
        bh=edvYxAWVofztTkwUNRUZw6hsNqSHMrxaVT1HHKiU3e4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=obVFCJRIhm8tMFdm8Ug5KsySsFTJasIZGbrja8ZQ1ZrcpKpB1vQqwmzjpNdOOfoCw
         UFwBRgHyL4t/JgbC/R5Dqz2F1J4E0Ja71YTrfx2zbaMaA2kaeH7GIk7ewCVx5zynlK
         H9BWYKz9HFPW5fBC/IqAqy8eqtgJA6vfnU+xnPV9nyfXdgHOKZ4kFwa1TEESnHMPzx
         LF8WNWIcEuFK5pWV2CHQKZX6dbjhf+Ubk/T6YLivY1n6zfHxzmkFW4QO9NkrxXKQ+q
         yPwAVan4LwzeXMzIBCkkGAMyFSKIihMNqJtE3NP2LM8IuGytLQMRF5eKU0qRP0TWhe
         LURIwf9+D9YsA==
Subject: [PATCH 2/8] xfs: move reflink tests into the clone group
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Christoph Hellwig <hch@lst.de>,
        Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 16 Sep 2021 17:39:13 -0700
Message-ID: <163183915396.952957.3817149043337015594.stgit@magnolia>
In-Reply-To: <163183914290.952957.11558799225344566504.stgit@magnolia>
References: <163183914290.952957.11558799225344566504.stgit@magnolia>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
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

