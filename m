Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E701C3AF8FA
	for <lists+linux-xfs@lfdr.de>; Tue, 22 Jun 2021 01:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhFUXMo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 21 Jun 2021 19:12:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:32838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231321AbhFUXMn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jun 2021 19:12:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7B3F61164;
        Mon, 21 Jun 2021 23:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624317028;
        bh=9wpMlNRFR79HuGP8o06CLQOuNKtKppvG1pEnF9wp3ps=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ekgzqPcyCvCVe3qEx8FLF1d3I4VtxNK3UMmKujZWc4yUHWwSf7ptI1Eg5rYrWUV/m
         DmPa11XNfnDmQoeoLJL9gLHx1b/avsRNqwi+2e1MC8oA289j/Mtni5f367Y3JSSDYa
         kpr85yaxjrz/Ju/bxFsZNkGmTatTI4G3an9d0kcuCAtvzFxszTODWnGL3YBFQtZ/Lr
         /9lHkScJwIWFlXG+Wnxki3mZB18yWuo93uo0jfNluJqdVyzPEJy18GhzlMdPGbny3R
         qpU5Uh1d+b4sEUh88PpmRCAO0jBNA2wFq8glbejsjBUJsCaOcnM/0hvBl21yGvdOXS
         2HCcW9eV67LWg==
Subject: [PATCH 04/13] fstests: add tool migrate group membership data to test
 files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com,
        ebiggers@kernel.org
Date:   Mon, 21 Jun 2021 16:10:28 -0700
Message-ID: <162431702856.4090790.8962121526105342327.stgit@locust>
In-Reply-To: <162431700639.4090790.11684371602638166127.stgit@locust>
References: <162431700639.4090790.11684371602638166127.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a tool to migrate the mapping of tests <-> groups out of the
group file and into the individual test file as a _begin_fstest
call.  In the next patches we'll rewrite all the test files and auto
generate the group files from the tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tools/convert-group |  138 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)
 create mode 100755 tools/convert-group


diff --git a/tools/convert-group b/tools/convert-group
new file mode 100755
index 00000000..81ad9934
--- /dev/null
+++ b/tools/convert-group
@@ -0,0 +1,138 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+
+# Move group tags from the groups file into the test files themselves.
+
+if [ -z "$1" ] || [ "$1" = "--help" ]; then
+	echo "Usage: $0 test_dir [test_dirs...]"
+	exit 1
+fi
+
+obliterate_group_file() {
+	sed -e 's/^#.*$//g' < group | while read test groups; do
+		if [ -z "$test" ]; then
+			continue;
+		elif [ ! -e "$test" ]; then
+			echo "Ignoring unknown test file \"$test\"."
+			continue
+		fi
+
+		# Replace all the open-coded test preparation code with a
+		# single call to _begin_fstest.
+		sed -e '/^seqres=\$RESULT_DIR\/\$seq$/d' \
+		    -e '/^seqres=\"\$RESULT_DIR\/\$seq\"$/d' \
+		    -e '/^echo "QA output created by \$seq"$/d' \
+		    -e '/^here=`pwd`$/d' \
+		    -e '/^here=\$(pwd)$/d' \
+		    -e '/^here=\$PWD$/d' \
+		    -e '/^here=\"`pwd`\"$/d' \
+		    -e '/^tmp=\/tmp\/\$\$$/d' \
+		    -e '/^status=1.*failure.*is.*the.*default/d' \
+		    -e '/^status=1.*FAILure.*is.*the.*default/d' \
+		    -e '/^status=1.*success.*is.*the.*default/d' \
+		    -e '/^status=1.*default.*failure/d' \
+		    -e '/^echo.*QA output created by.*seq/d' \
+		    -e '/^# remove previous \$seqres.full before test/d' \
+		    -e '/^rm -f \$seqres.full/d' \
+		    -e 's|^# get standard environment, filters and checks|# Import common functions.|g' \
+		    -e '/^\. \.\/common\/rc/d' \
+		    -e '/^\. common\/rc/d' \
+		    -e 's|^seq=.*$|. ./common/preamble\n_begin_fstest '"$groups"'|g' \
+		    -i "$test"
+
+		# Replace the open-coded trap calls that register cleanup code
+		# with a call to _register_cleanup.
+		#
+		# For tests that registered empty-string cleanups or open-coded
+		# calls to remove $tmp files, remove the _register_cleanup
+		# calls entirely because the default _cleanup does that for us.
+		#
+		# For tests that now have a _register_cleanup call for the
+		# _cleanup function, remove the explicit call because
+		# _begin_fstest already registers that for us.
+		#
+		# For tests that override _cleanup, insert a comment noting
+		# that it is overriding the default, to match the ./new
+		# template.
+		sed -e 's|^trap "exit \\\$status" 0 1 2 3 15|_register_cleanup ""|g' \
+		    -e 's|^trap "\(.*\)[[:space:]]*; exit \\\$status" 0 1 2 3 15|_register_cleanup "\1"|g' \
+		    -e 's|^trap "\(.*\)[[:space:]]*; exit \\\$status" 1 2 3 15|_register_cleanup "\1"|g' \
+		    -e 's|^trap '"'"'\(.*\)[[:space:]]*; exit \$status'"'"' 0 1 2 3 15|_register_cleanup "\1"|g' \
+		    -e 's|^trap "\(.*\)[[:space:]]*; exit \\\$status" 0 1 2 3 7 15|_register_cleanup "\1" BUS|g' \
+		    -e 's|^_register_cleanup "[[:space:]]*\([^[:space:]]*\)[[:space:]]*"|_register_cleanup "\1"|g' \
+		    -e '/^_register_cleanup ""$/d' \
+		    -e '/^_register_cleanup "rm -f \$tmp.*"$/d' \
+		    -e '/^_register_cleanup "_cleanup"$/d' \
+		    -e 's|^_cleanup()|# Override the default cleanup function.\n_cleanup()|g' \
+		    -i "$test"
+
+		# If the test doesn't import any common functionality,
+		# get rid of the pointless comment.
+		if ! grep -q '^\. .*common' "$test"; then
+			sed -e '/^# Import common functions.$/d' -i "$test"
+		fi
+
+		# Replace the "status=1" lines that don't have the usual
+		# "failure is the default" message if there's no other code
+		# between _begin_fstest and status=1.
+		if grep -q '^status=1$' "$test"; then
+			awk '
+BEGIN {
+	saw_groupinfo = 0;
+}
+{
+	if ($0 ~ /^_begin_fstest/) {
+		saw_groupinfo = 1;
+		printf("%s\n", $0);
+	} else if ($0 ~ /^status=1$/) {
+		if (saw_groupinfo == 0) {
+			printf("%s\n", $0);
+		}
+	} else if ($0 == "") {
+		printf("\n");
+	} else {
+		saw_groupinfo = 0;
+		printf("%s\n", $0);
+	}
+}
+' < "$test" > "$test.new"
+			cat "$test.new" > "$test"
+			rm -f "$test.new"
+		fi
+
+		# Get rid of _cleanup functions that match the standard one.
+		# Thanks to Eric Biggers for providing this.
+		sed -z -E \
+			-e 's/(#[^#\n]*\n)*_cleanup\(\)\n\{\n(\s+cd \/\n)?\s+rm -r?f "?\$tmp"?\.\*\n\}\n\n?//' \
+			-e 's/(#[^#\n]*\n)*_cleanup\(\)\n\{\n(\s+cd \/\n)?\s+rm -fr "?\$tmp"?\.\*\n\}\n\n?//' \
+			-i "$test"
+
+		# Collapse sequences of blank lines to a single blank line.
+		awk '
+BEGIN {
+	saw_blank = 0;
+}
+{
+	if ($0 ~ /^$/) {
+		if (saw_blank == 0) {
+			printf("\n");
+			saw_blank = 1;
+		}
+	} else {
+		printf("%s\n", $0);
+		saw_blank = 0;
+	}
+}
+' < "$test" > "$test.new"
+		cat "$test.new" > "$test"
+		rm -f "$test.new"
+	done
+}
+
+curr_dir="$PWD"
+for tdir in "$@"; do
+	cd "tests/$tdir"
+	obliterate_group_file
+	cd "$curr_dir"
+done

