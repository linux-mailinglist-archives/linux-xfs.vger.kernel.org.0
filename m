Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCAE39FD77
	for <lists+linux-xfs@lfdr.de>; Tue,  8 Jun 2021 19:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbhFHRV7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 8 Jun 2021 13:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233094AbhFHRV7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Jun 2021 13:21:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C0A26135D;
        Tue,  8 Jun 2021 17:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623172806;
        bh=khHFOakyVAycf+dzTmFEyfVyWAUYUtbw+YMeiqeiJ9w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BfNHwXlW8Wne/MTnN3RfE5SVBkIGAlwNhRIgh9tBHlrsGbwfQOthBWEGCWmIpEv0U
         eqjvnjzx/F1K5sg2L0Yabpfj476HZRR6PpnWm36TN3KKJNfSGRn6XaUARae3HfvHWp
         gD9mYi63UrDx7VxRcxnwzv52sj3RszhaquosI2OB/k3N/Vx5E/sxn+WEKlU9xaQ/mi
         wh0D6a92eBWh37blBtXlgYJ/GdfFkwMmj7tUUMgkiNK9UOR65qiHj3WbgpwFcZREqk
         PN6+iWrcOSed0jbW0+RJBUdPjKlpA9yh6bPCRHCS06Gv2fcAFusKTwJX5nxvrb8Yxb
         wjPcekGde6omg==
Subject: [PATCH 08/13] fstests: convert nextid to use automatic group
 generation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Date:   Tue, 08 Jun 2021 10:20:05 -0700
Message-ID: <162317280590.653489.10114638028601363399.stgit@locust>
In-Reply-To: <162317276202.653489.13006238543620278716.stgit@locust>
References: <162317276202.653489.13006238543620278716.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the nextid script to use the automatic group file generation to
figure out the next available test id.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tools/nextid |    1 -
 tools/nextid |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)
 delete mode 120000 tools/nextid
 create mode 100755 tools/nextid


diff --git a/tools/nextid b/tools/nextid
deleted file mode 120000
index 5c31d602..00000000
--- a/tools/nextid
+++ /dev/null
@@ -1 +0,0 @@
-sort-group
\ No newline at end of file
diff --git a/tools/nextid b/tools/nextid
new file mode 100755
index 00000000..a65348e8
--- /dev/null
+++ b/tools/nextid
@@ -0,0 +1,39 @@
+#!/bin/bash
+
+# Compute the next available test id in a given test directory.
+
+if [ -z "$1" ] || [ "$1" = "--help" ] || [ -n "$2" ] || [ ! -d "tests/$1/" ]; then
+	echo "Usage: $0 test_dir"
+	exit 1
+fi
+
+. ./common/test_names
+
+line=0
+i=0
+eof=1
+
+while read found other_junk;
+do
+	line=$((line+1))
+	if [ -z "$found" ] || [ "$found" == "#" ]; then
+		continue
+	elif ! echo "$found" | grep -q "^$VALID_TEST_NAME$"; then
+		# this one is for tests not named by a number
+		continue
+	fi
+	i=$((i+1))
+	id=`printf "%03d" $i`
+	if [ "$id" != "$found" ]; then
+		eof=0
+		break
+	fi
+done < <(cd "tests/$1/" ; ../../tools/mkgroupfile | tr - ' ')
+
+if [ $eof -eq 1 ]; then
+   line=$((line+1))
+   i=$((i+1))
+   id=`printf "%03d" $i`
+fi
+
+echo "$1/$id"

