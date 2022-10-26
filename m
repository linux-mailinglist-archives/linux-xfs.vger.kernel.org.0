Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CF760E84F
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Oct 2022 21:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbiJZTGi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Oct 2022 15:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234825AbiJZTGZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 15:06:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE9A120EE3;
        Wed, 26 Oct 2022 12:03:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4F30B82414;
        Wed, 26 Oct 2022 19:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53979C433C1;
        Wed, 26 Oct 2022 19:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666811017;
        bh=yol3ilWZxURyvtl2IzU+2N8we/3CcskPlPy81s1yIKA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=L75fPYHc98ynu5mAULCcA6QVJz3KBbTXbQJER4AZ3FtMx1WkBz1e3ya5TWvVdMbQk
         maM8LNMbXfCiWjyYOTa9lNf9PLxyTr/AKY+1z9bfuasolriZZp6kwkxR6wB5BqOn9Z
         6GSJjgFgqzqdx4B6oK71Z5UQmBA5ZhxkUjmLeiL0CN0vt4HPV1+TCmFEBQiIg1n/xX
         Knys4nc8Me/9WODZeCEA99CgYcbI/vj6Ev17Nn8IS/EuZvanEa6ByWV5wniTyVmrsV
         Zqw+PZ9cWmDlwVVo5LZzOqVichv1/vuelg4F2QdiCm6JOJ98dXpt7xt3StCp8Whtr8
         8h5bzgkX858OQ==
Subject: [PATCH 4/4] common: simplify grep pipe sed interactions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 26 Oct 2022 12:03:36 -0700
Message-ID: <166681101686.3403789.9650647383820032871.stgit@magnolia>
In-Reply-To: <166681099421.3403789.78493769502226810.stgit@magnolia>
References: <166681099421.3403789.78493769502226810.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Zorro pointed out that the idiom "program | grep | sed" isn't necessary
for field extraction -- sed is perfectly capable of performing a
substitution and only printing the lines that match that substitution.
Do that for the common helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/ext4     |    9 +++++++++
 common/populate |    4 ++--
 common/xfs      |   11 ++++-------
 3 files changed, 15 insertions(+), 9 deletions(-)


diff --git a/common/ext4 b/common/ext4
index f4c3c4139a..4a2eaa157f 100644
--- a/common/ext4
+++ b/common/ext4
@@ -191,3 +191,12 @@ _scratch_ext4_options()
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 		SCRATCH_OPTIONS="$SCRATCH_OPTIONS ${log_opt}"
 }
+
+# Get the inode flags for a particular inode number
+_ext4_get_inum_iflags() {
+	local dev="$1"
+	local inumber="$2"
+
+	debugfs -R "stat <${inumber}>" "${dev}" 2> /dev/null | \
+			sed -n 's/^.*Flags: \([0-9a-fx]*\).*$/\1/p'
+}
diff --git a/common/populate b/common/populate
index d9d4c6c300..6e00499734 100644
--- a/common/populate
+++ b/common/populate
@@ -641,7 +641,7 @@ __populate_check_ext4_dformat() {
 	extents=0
 	etree=0
 	debugfs -R "stat <${inode}>" "${dev}" 2> /dev/null | grep 'ETB[0-9]' -q && etree=1
-	iflags="$(debugfs -R "stat <${inode}>" "${dev}" 2> /dev/null | grep 'Flags:' | sed -e 's/^.*Flags: \([0-9a-fx]*\).*$/\1/g')"
+	iflags="$(_ext4_get_inum_iflags "${dev}" "${inode}")"
 	test "$(echo "${iflags}" | awk '{print and(strtonum($1), 0x80000);}')" -gt 0 && extents=1
 
 	case "${format}" in
@@ -688,7 +688,7 @@ __populate_check_ext4_dir() {
 
 	htree=0
 	inline=0
-	iflags="$(debugfs -R "stat <${inode}>" "${dev}" 2> /dev/null | grep 'Flags:' | sed -e 's/^.*Flags: \([0-9a-fx]*\).*$/\1/g')"
+	iflags="$(_ext4_get_inum_iflags "${dev}" "${inode}")"
 	test "$(echo "${iflags}" | awk '{print and(strtonum($1), 0x1000);}')" -gt 0 && htree=1
 	test "$(echo "${iflags}" | awk '{print and(strtonum($1), 0x10000000);}')" -gt 0 && inline=1
 
diff --git a/common/xfs b/common/xfs
index 7c0f3eee19..d9105a9bb1 100644
--- a/common/xfs
+++ b/common/xfs
@@ -179,8 +179,7 @@ _xfs_get_rtextents()
 {
 	local path="$1"
 
-	$XFS_INFO_PROG "$path" | grep 'rtextents' | \
-		sed -e 's/^.*rtextents=\([0-9]*\).*$/\1/g'
+	$XFS_INFO_PROG "$path" | sed -n "s/^.*rtextents=\([[:digit:]]*\).*/\1/p"
 }
 
 # Get the realtime extent size of a mounted filesystem.
@@ -188,8 +187,7 @@ _xfs_get_rtextsize()
 {
 	local path="$1"
 
-	$XFS_INFO_PROG "$path" | grep 'realtime.*extsz' | \
-		sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
+	$XFS_INFO_PROG "$path" | sed -n "s/^.*realtime.*extsz=\([[:digit:]]*\).*/\1/p"
 }
 
 # Get the size of an allocation unit of a file.  Normally this is just the
@@ -226,8 +224,7 @@ _xfs_get_dir_blocksize()
 {
 	local fs="$1"
 
-	$XFS_INFO_PROG "$fs" | grep 'naming.*bsize' | \
-		sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g'
+	$XFS_INFO_PROG "$fs" | sed -n "s/^naming.*bsize=\([[:digit:]]*\).*/\1/p"
 }
 
 # Set or clear the realtime status of every supplied path.  The first argument
@@ -1276,7 +1273,7 @@ _force_xfsv4_mount_options()
 # Find AG count of mounted filesystem
 _xfs_mount_agcount()
 {
-	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
+	$XFS_INFO_PROG "$1" | sed -n "s/^.*agcount=\([[:digit:]]*\).*/\1/p"
 }
 
 # Wipe the superblock of each XFS AGs

