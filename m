Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D7B6405CD
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Dec 2022 12:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbiLBL2Q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Dec 2022 06:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbiLBL2N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2022 06:28:13 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2359053EE8;
        Fri,  2 Dec 2022 03:28:08 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VWE3TvX_1669980481;
Received: from localhost.localdomain(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VWE3TvX_1669980481)
          by smtp.aliyun-inc.com;
          Fri, 02 Dec 2022 19:28:06 +0800
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
To:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [RESEND PATCH V2] common/populate: Ensure that S_IFDIR.FMT_BTREE is in btree format
Date:   Fri,  2 Dec 2022 19:27:40 +0800
Message-Id: <20221202112740.1233028-1-ZiyangZhang@linux.alibaba.com>
X-Mailer: git-send-email 2.18.4
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Sometimes "$((128 * dblksz / 40))" dirents cannot make sure that
S_IFDIR.FMT_BTREE could become btree format for its DATA fork.

Actually we just observed it can fail after apply our inode
extent-to-btree workaround. The root cause is that the kernel may be
too good at allocating consecutive blocks so that the data fork is
still in extents format.

Therefore instead of using a fixed number, let's make sure the number
of extents is large enough than (inode size - inode core size) /
sizeof(xfs_bmbt_rec_t).

Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
---
V2: take Darrick's advice to cleanup code
 common/populate | 28 +++++++++++++++++++++++++++-
 common/xfs      | 17 +++++++++++++++++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/common/populate b/common/populate
index 6e004997..1ca76459 100644
--- a/common/populate
+++ b/common/populate
@@ -71,6 +71,31 @@ __populate_create_dir() {
 	done
 }
 
+# Create a large directory and ensure that it's a btree format
+__populate_xfs_create_btree_dir() {
+	local name="$1"
+	local isize="$2"
+	local icore_size="$(_xfs_inode_core_bytes)"
+	# We need enough extents to guarantee that the data fork is in
+	# btree format.  Cycling the mount to use xfs_db is too slow, so
+	# watch for when the extent count exceeds the space after the
+	# inode core.
+	local max_nextents="$(((isize - icore_size) / 16))"
+
+	mkdir -p "${name}"
+	d=0
+	while true; do
+		creat=mkdir
+		test "$((d % 20))" -eq 0 && creat=touch
+		$creat "${name}/$(printf "%.08d" "$d")"
+		if [ "$((d % 40))" -eq 0 ]; then
+			nextents="$(_xfs_get_fsxattr nextents $name)"
+			[ $nextents -gt $max_nextents ] && break
+		fi
+		d=$((d+1))
+	done
+}
+
 # Add a bunch of attrs to a file
 __populate_create_attr() {
 	name="$1"
@@ -176,6 +201,7 @@ _scratch_xfs_populate() {
 
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
+	isize="$(_xfs_inode_size "$SCRATCH_MNT")"
 	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
 	if [ $crc -eq 1 ]; then
 		leaf_hdr_size=64
@@ -226,7 +252,7 @@ _scratch_xfs_populate() {
 
 	# - BTREE
 	echo "+ btree dir"
-	__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$((128 * dblksz / 40))" true
+	__populate_xfs_create_btree_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$isize"
 
 	# Symlinks
 	# - FMT_LOCAL
diff --git a/common/xfs b/common/xfs
index 8ac1964e..0359e422 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1486,3 +1486,20 @@ _require_xfsrestore_xflag()
 	$XFSRESTORE_PROG -h 2>&1 | grep -q -e '-x' || \
 			_notrun 'xfsrestore does not support -x flag.'
 }
+
+
+# Number of bytes reserved for a full inode record, which includes the
+# immediate fork areas.
+_xfs_inode_size()
+{
+	local mntpoint="$1"
+
+	$XFS_INFO_PROG "$mntpoint" | grep 'meta-data=.*isize' | sed -e 's/^.*isize=\([0-9]*\).*$/\1/g'
+}
+
+# Number of bytes reserved for only the inode record, excluding the
+# immediate fork areas.
+_xfs_inode_core_bytes()
+{
+	echo 176
+}
-- 
2.18.4

