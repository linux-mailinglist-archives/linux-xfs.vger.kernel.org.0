Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3AA76DA1C1
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Apr 2023 21:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237407AbjDFTnX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 6 Apr 2023 15:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238068AbjDFTnK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:43:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F5CA5D4;
        Thu,  6 Apr 2023 12:42:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 173D5643AB;
        Thu,  6 Apr 2023 19:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73397C433D2;
        Thu,  6 Apr 2023 19:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680810165;
        bh=WqRsG7aInZPzdmZbtN/9VM+ahwVFurogghGn9dInYb4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=o3cb5/Z13sIldb8pvaRkVnWfDTseMdKtFvQlCBlcY0F7S9FPxJ0jbWX6ZSqH0TW/a
         aF05evnTzU2DwAU3FacwZqvKBBnG2coweM2+NZlDG8JH85PJIh5iFOk5rJBItALbGM
         WHoTVDl9BLBQimFi8+kzfK82TYoUO6clY/GOt9zHUvh0Ql9Zk1DaACTqoHNjeFLiii
         z/vL1csXkgZ4n8c4CFETMkFne3sc05r2kxv8/85NH0NTHdbHOGSwFyfu4nJbdlsL1H
         vhxcfaWjBcMJk5O3Ay8/QqHc9KA/dgBUeFxJsfkYCH4dqeOr33W2GwYft+JF63KANc
         EtwzAFyIkfwUg==
Date:   Thu, 06 Apr 2023 12:42:45 -0700
Subject: [PATCH 04/11] xfs/021: adapt golden output files for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <168080829059.618488.16679138740411539107.stgit@frogsfrogsfrogs>
In-Reply-To: <168080829003.618488.1769223982280364994.stgit@frogsfrogsfrogs>
References: <168080829003.618488.1769223982280364994.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Parent pointers change the xattr structure dramatically, so fix this
test to handle them.  For the most part we can get away with filtering
out the parent pointer fields (which xfs_db decodes for us), but the
namelen/valuelen/attr_filter fields still show through.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc                 |    4 +++
 tests/xfs/021             |   15 +++++++++--
 tests/xfs/021.cfg         |    1 +
 tests/xfs/021.out.default |    0 
 tests/xfs/021.out.parent  |   62 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 80 insertions(+), 2 deletions(-)
 create mode 100644 tests/xfs/021.cfg
 rename tests/xfs/{021.out => 021.out.default} (100%)
 create mode 100644 tests/xfs/021.out.parent


diff --git a/common/rc b/common/rc
index 58fa580a55..a7e7d1f25b 100644
--- a/common/rc
+++ b/common/rc
@@ -3307,6 +3307,8 @@ _get_os_name()
 
 _link_out_file_named()
 {
+	test -n "$seqfull" || _fail "need to set seqfull"
+
 	local features=$2
 	local suffix=$(FEATURES="$features" perl -e '
 		my %feathash;
@@ -3342,6 +3344,8 @@ _link_out_file()
 {
 	local features
 
+	test -n "$seqfull" || _fail "need to set seqfull"
+
 	if [ $# -eq 0 ]; then
 		features="$(_get_os_name),$FSTYP"
 		if [ -n "$MOUNT_OPTIONS" ]; then
diff --git a/tests/xfs/021 b/tests/xfs/021
index 9432e2acb0..ef307fc064 100755
--- a/tests/xfs/021
+++ b/tests/xfs/021
@@ -67,6 +67,13 @@ _scratch_mkfs_xfs >/dev/null \
 echo "*** mount FS"
 _scratch_mount
 
+seqfull=$0
+if _xfs_has_feature $SCRATCH_MNT parent; then
+	_link_out_file "parent"
+else
+	_link_out_file ""
+fi
+
 testfile=$SCRATCH_MNT/testfile
 echo "*** make test file 1"
 
@@ -108,7 +115,10 @@ _scratch_unmount >>$seqres.full 2>&1 \
 echo "*** dump attributes (1)"
 
 _scratch_xfs_db -r -c "inode $inum_1" -c "print a.sfattr"  | \
-	sed -e '/secure = /d' | sed -e '/parent = /d'
+	perl -ne '
+/\.secure/ && next;
+/\.parent/ && next;
+	print unless /^\d+:\[.*/;'
 
 echo "*** dump attributes (2)"
 
@@ -124,10 +134,11 @@ s/info.hdr/info/;
 /hdr.info.uuid/ && next;
 /hdr.info.lsn/ && next;
 /hdr.info.owner/ && next;
+/\.parent/ && next;
 s/^(hdr.info.magic =) 0x3bee/\1 0xfbee/;
 s/^(hdr.firstused =) (\d+)/\1 FIRSTUSED/;
 s/^(hdr.freemap\[0-2] = \[base,size]).*/\1 [FREEMAP..]/;
-s/^(entries\[0-2] = \[hashval,nameidx,incomplete,root,local]).*/\1 [ENTRIES..]/;
+s/^(entries\[0-[23]] = \[hashval,nameidx,incomplete,root,local]).*/\1 [ENTRIES..]/;
 	print unless /^\d+:\[.*/;'
 
 echo "*** done"
diff --git a/tests/xfs/021.cfg b/tests/xfs/021.cfg
new file mode 100644
index 0000000000..73b127260c
--- /dev/null
+++ b/tests/xfs/021.cfg
@@ -0,0 +1 @@
+parent: parent
diff --git a/tests/xfs/021.out b/tests/xfs/021.out.default
similarity index 100%
rename from tests/xfs/021.out
rename to tests/xfs/021.out.default
diff --git a/tests/xfs/021.out.parent b/tests/xfs/021.out.parent
new file mode 100644
index 0000000000..1af1301061
--- /dev/null
+++ b/tests/xfs/021.out.parent
@@ -0,0 +1,62 @@
+QA output created by 021
+*** mkfs
+*** mount FS
+*** make test file 1
+# file: <TESTFILE>.1
+user.a1
+user.a2--
+
+*** make test file 2
+1+0 records in
+1+0 records out
+# file: <TESTFILE>.2
+user.a1
+user.a2-----
+user.a3
+
+Attribute "a3" had a 65535 byte value for <TESTFILE>.2:
+size of attr value = 65536
+
+*** unmount FS
+*** dump attributes (1)
+a.sfattr.hdr.totsize = 53
+a.sfattr.hdr.count = 3
+a.sfattr.list[0].namelen = 16
+a.sfattr.list[0].valuelen = 10
+a.sfattr.list[0].root = 0
+a.sfattr.list[1].namelen = 2
+a.sfattr.list[1].valuelen = 3
+a.sfattr.list[1].root = 0
+a.sfattr.list[1].name = "a1"
+a.sfattr.list[1].value = "v1\d"
+a.sfattr.list[2].namelen = 4
+a.sfattr.list[2].valuelen = 5
+a.sfattr.list[2].root = 0
+a.sfattr.list[2].name = "a2--"
+a.sfattr.list[2].value = "v2--\d"
+*** dump attributes (2)
+hdr.info.forw = 0
+hdr.info.back = 0
+hdr.info.magic = 0xfbee
+hdr.count = 4
+hdr.usedbytes = 84
+hdr.firstused = FIRSTUSED
+hdr.holes = 0
+hdr.freemap[0-2] = [base,size] [FREEMAP..]
+entries[0-3] = [hashval,nameidx,incomplete,root,local] [ENTRIES..]
+nvlist[0].valuelen = 8
+nvlist[0].namelen = 2
+nvlist[0].name = "a1"
+nvlist[0].value = "value_1\d"
+nvlist[1].valueblk = 0x1
+nvlist[1].valuelen = 65535
+nvlist[1].namelen = 2
+nvlist[1].name = "a3"
+nvlist[2].valuelen = 10
+nvlist[2].namelen = 16
+nvlist[3].valuelen = 8
+nvlist[3].namelen = 7
+nvlist[3].name = "a2-----"
+nvlist[3].value = "value_2\d"
+*** done
+*** unmount

