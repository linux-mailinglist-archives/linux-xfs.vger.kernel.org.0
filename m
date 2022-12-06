Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB452644106
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Dec 2022 11:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbiLFKL2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Dec 2022 05:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235163AbiLFKLE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2022 05:11:04 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F57110B72;
        Tue,  6 Dec 2022 02:05:53 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=ziyangzhang@linux.alibaba.com;NM=0;PH=DS;RN=6;SR=0;TI=SMTPD_---0VWfB1Z-_1670321140;
Received: from localhost.localdomain(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VWfB1Z-_1670321140)
          by smtp.aliyun-inc.com;
          Tue, 06 Dec 2022 18:05:51 +0800
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
To:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, hsiangkao@linux.alibaba.com,
        allison.henderson@oracle.com,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Subject: [PATCH V3 1/2] common/xfs: Add a helper to export inode core size
Date:   Tue,  6 Dec 2022 18:05:16 +0800
Message-Id: <20221206100517.1369625-2-ZiyangZhang@linux.alibaba.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20221206100517.1369625-1-ZiyangZhang@linux.alibaba.com>
References: <20221206100517.1369625-1-ZiyangZhang@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Some xfs test cases need the number of bytes reserved for only the inode
record, excluding the immediate fork areas. Now the value is hard-coded
and it is not a good chioce. Add a helper in common/xfs to export the
inode core size.

Signed-off-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
---
 common/xfs    | 7 +++++++
 tests/xfs/335 | 3 ++-
 tests/xfs/336 | 3 ++-
 tests/xfs/337 | 3 ++-
 tests/xfs/341 | 3 ++-
 tests/xfs/342 | 3 ++-
 6 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/common/xfs b/common/xfs
index 8ac1964e..5180b9d3 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1486,3 +1486,10 @@ _require_xfsrestore_xflag()
 	$XFSRESTORE_PROG -h 2>&1 | grep -q -e '-x' || \
 			_notrun 'xfsrestore does not support -x flag.'
 }
+
+# Number of bytes reserved for only the inode record, excluding the
+# immediate fork areas.
+_xfs_inode_core_bytes()
+{
+	echo 176
+}
diff --git a/tests/xfs/335 b/tests/xfs/335
index ccc508e7..624a8fd1 100755
--- a/tests/xfs/335
+++ b/tests/xfs/335
@@ -31,7 +31,8 @@ blksz="$(_get_block_size $SCRATCH_MNT)"
 echo "Create a three-level rtrmapbt"
 # inode core size is at least 176 bytes; btree header is 56 bytes;
 # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
-i_ptrs=$(( (isize - 176) / 56 ))
+i_core_size="$(_xfs_inode_core_bytes)"
+i_ptrs=$(( (isize - i_core_size) / 56 ))
 bt_ptrs=$(( (blksz - 56) / 56 ))
 bt_recs=$(( (blksz - 56) / 32 ))
 
diff --git a/tests/xfs/336 b/tests/xfs/336
index b1de8e5f..e601632d 100755
--- a/tests/xfs/336
+++ b/tests/xfs/336
@@ -42,7 +42,8 @@ rm -rf $metadump_file
 echo "Create a three-level rtrmapbt"
 # inode core size is at least 176 bytes; btree header is 56 bytes;
 # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
-i_ptrs=$(( (isize - 176) / 56 ))
+i_core_size="$(_xfs_inode_core_bytes)"
+i_ptrs=$(( (isize - i_core_size) / 56 ))
 bt_ptrs=$(( (blksz - 56) / 56 ))
 bt_recs=$(( (blksz - 56) / 32 ))
 
diff --git a/tests/xfs/337 b/tests/xfs/337
index a2515e36..5d5ec8dc 100755
--- a/tests/xfs/337
+++ b/tests/xfs/337
@@ -33,7 +33,8 @@ blksz="$(_get_block_size $SCRATCH_MNT)"
 
 # inode core size is at least 176 bytes; btree header is 56 bytes;
 # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
-i_ptrs=$(( (isize - 176) / 56 ))
+i_core_size="$(_xfs_inode_core_bytes)"
+i_ptrs=$(( (isize - i_core_size) / 56 ))
 bt_ptrs=$(( (blksz - 56) / 56 ))
 bt_recs=$(( (blksz - 56) / 32 ))
 
diff --git a/tests/xfs/341 b/tests/xfs/341
index f026aa37..45afd407 100755
--- a/tests/xfs/341
+++ b/tests/xfs/341
@@ -33,7 +33,8 @@ rtextsz_blks=$((rtextsz / blksz))
 
 # inode core size is at least 176 bytes; btree header is 56 bytes;
 # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
-i_ptrs=$(( (isize - 176) / 56 ))
+i_core_size="$(_xfs_inode_core_bytes)"
+i_ptrs=$(( (isize - i_core_size) / 56 ))
 bt_recs=$(( (blksz - 56) / 32 ))
 
 blocks=$((i_ptrs * bt_recs + 1))
diff --git a/tests/xfs/342 b/tests/xfs/342
index 1ae414eb..d4f54168 100755
--- a/tests/xfs/342
+++ b/tests/xfs/342
@@ -30,7 +30,8 @@ blksz="$(_get_block_size $SCRATCH_MNT)"
 
 # inode core size is at least 176 bytes; btree header is 56 bytes;
 # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
-i_ptrs=$(( (isize - 176) / 56 ))
+i_core_size="$(_xfs_inode_core_bytes)"
+i_ptrs=$(( (isize - i_core_size) / 56 ))
 bt_recs=$(( (blksz - 56) / 32 ))
 
 blocks=$((i_ptrs * bt_recs + 1))
-- 
2.18.4

