Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9169F3A70E9
	for <lists+linux-xfs@lfdr.de>; Mon, 14 Jun 2021 23:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbhFNVCJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 14 Jun 2021 17:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234397AbhFNVCI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jun 2021 17:02:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FAAD601FC;
        Mon, 14 Jun 2021 21:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623704405;
        bh=6jyfIs/qrO64M8K4oZoAzAtUitozedJ/aZl67v7+qck=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mcwguwvooyWOEqnWNy6xdvUe3blTG9MwUXziG/BiERX9TKmyYPHwKuCd838G4k2Fk
         PdHv3nck8kIi5gva6Q6sDybEKLHG7UDizPOF1uY/yKsakB4izY0KCZjP+5rawxBzu2
         TK46rhmwjuU3mvJm/eGybiDffGS0CXJiWDK04OxE/1YP5XFLOtsmK/UisJBaXtAOSR
         mooWUL9xgiGy7egrtuamncrys5uwXiRNrthYvYE38ue7yQJyP1n181SUKvNjAqAq3I
         jiAKXO/aGeq+FKgp2z2SAqjOLSpFOBTk62K2ECyPrhbxy1YepXi7BtBI6hDSjf/QlY
         pP0ey9NTPzPsg==
Subject: [PATCH 12/13] fstests: remove test group management code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Date:   Mon, 14 Jun 2021 14:00:05 -0700
Message-ID: <162370440523.3800603.5113348731405331858.stgit@locust>
In-Reply-To: <162370433910.3800603.9623820748404628250.stgit@locust>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove all the code that manages group files, since we now generate
them at build time.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 tools/mvtest     |   12 ------
 tools/sort-group |  112 ------------------------------------------------------
 2 files changed, 124 deletions(-)
 delete mode 100755 tools/sort-group


diff --git a/tools/mvtest b/tools/mvtest
index 572ae14e..fa967832 100755
--- a/tools/mvtest
+++ b/tools/mvtest
@@ -32,24 +32,12 @@ did="$(basename "${dest}")"
 sgroup="$(basename "$(dirname "tests/${src}")")"
 dgroup="$(basename "$(dirname "tests/${dest}")")"
 
-sgroupfile="tests/${sgroup}/group"
-dgroupfile="tests/${dgroup}/group"
-
 git mv "tests/${src}" "tests/${dest}"
 git mv "tests/${src}.out" "tests/${dest}.out"
 sed -e "s/^# FS[[:space:]]*QA.*Test.*[0-9]\+$/# FS QA Test No. ${did}/g" -i "tests/${dest}"
 sed -e "s/^QA output created by ${sid}$/QA output created by ${did}/g" -i "tests/${dest}.out"
 sed -e "s/test-${sid}/test-${did}/g" -i "tests/${dest}.out"
 
-grpline="$(grep "^${sid} " "${sgroupfile}")"
-newgrpline="$(echo "${grpline}" | sed -e "s/^${sid} /${did} /g")"
-
-sed -e "/^${sid} .*$/d" -i "${sgroupfile}"
-cp "${dgroupfile}" "${dgroupfile}.new"
-append "${dgroupfile}.new" "${newgrpline}"
-"${dir}/sort-group" "${dgroupfile}.new"
-mv "${dgroupfile}.new" "${dgroupfile}"
-
 echo "Moved \"${src}\" to \"${dest}\"."
 
 exit 0
diff --git a/tools/sort-group b/tools/sort-group
deleted file mode 100755
index 6fcaad77..00000000
--- a/tools/sort-group
+++ /dev/null
@@ -1,112 +0,0 @@
-#!/usr/bin/env python
-import sys
-
-# Sort a group list, carefully preserving comments.
-
-def xfstest_key(key):
-	'''Extract the numeric part of a test name if possible.'''
-	k = 0
-
-	assert type(key) == str
-
-	# No test number at all...
-	if not key[0].isdigit():
-		return key
-
-	# ...otherwise extract as much number as we can.
-	for digit in key:
-		if digit.isdigit():
-			k = k * 10 + int(digit)
-		else:
-			return k
-	return k
-
-def read_group(fd):
-	'''Read the group list, carefully attaching comments to the next test.'''
-	tests = {}
-	comments = None
-
-	for line in fd:
-		sline = line.strip()
-		tokens = sline.split()
-		if len(tokens) == 0 or tokens[0] == '#':
-			if comments == None:
-				comments = []
-			comments.append(sline)
-		else:
-			tests[tokens[0]] = (comments, tokens[1:])
-			comments = None
-	return tests
-
-def sort_keys(keys):
-	'''Separate keys into integer and non-integer tests.'''
-	int_keys = []
-	int_xkeys = []
-	str_keys = []
-
-	# Sort keys into integer(ish) tests and other
-	for key in keys:
-		xkey = xfstest_key(key)
-		if type(xkey) == int:
-			int_keys.append(key)
-			int_xkeys.append(xkey)
-		else:
-			str_keys.append(key)
-	return (int_keys, int_xkeys, str_keys)
-
-def write_sorted(tests, fd):
-	def dump_xkey(xkey):
-		(comments, tokens) = tests[key]
-		if comments:
-			for c in comments:
-				fd.write('%s\n' % c)
-		fd.write('%s %s\n' % (key, ' '.join(tokens)))
-	'''Print tests (and comments) in number order.'''
-
-	(int_keys, ignored, str_keys) = sort_keys(tests.keys())
-	for key in sorted(int_keys, key = xfstest_key):
-		dump_xkey(key)
-	for key in sorted(str_keys):
-		dump_xkey(key)
-
-def sort_main():
-	if '--help' in sys.argv[1:]:
-		print('Usage: %s groupfiles' % sys.argv[0])
-		sys.exit(0)
-
-	for arg in sys.argv[1:]:
-		with open(arg, 'r+') as fd:
-			x = read_group(fd)
-			fd.seek(0, 0)
-			write_sorted(x, fd)
-
-def nextid_main():
-	if '--help' in sys.argv[1:]:
-		print('Usage: %s group[/startid] ' % sys.argv[0])
-		sys.exit(0)
-
-	if len(sys.argv) != 2:
-		print('Specify exactly one group name.')
-		sys.exit(1)
-
-	c = sys.argv[1].split('/')
-	if len(c) > 1:
-		startid = int(c[1])
-	else:
-		startid = 1
-	group = c[0]
-
-	with open('tests/%s/group' % group, 'r') as fd:
-		x = read_group(fd)
-		xkeys = {int(x) for x in sort_keys(x.keys())[1]}
-
-		xid = startid
-		while xid in xkeys:
-			xid += 1
-		print('%s/%03d' % (group, xid))
-
-if __name__ == '__main__':
-	if 'nextid' in sys.argv[0]:
-		nextid_main()
-	else:
-		sort_main()

