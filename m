Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C14732B11D
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Mar 2021 04:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351089AbhCCDQW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 2 Mar 2021 22:16:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2361112AbhCBXXh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Mar 2021 18:23:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 895B264F3C;
        Tue,  2 Mar 2021 23:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614727376;
        bh=697Nb2di+BUNIoecDPwRGI5l1BRr1zPGoqYUfZiiDag=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rz1rISzIZI9+2jEpsw2jt7jJPbMHtOJSeuXONj6chUHAZnGed09ps+bSMjQ6l4raf
         S/MnOES1JOUEOc4mhKJA8vIIWPUYkBYiVreBTNdnoTsJCgKnzHjRRT6Z4OThXaUWPc
         g7wdGGW08g2xKGFpGwQMotYhS4CsYJxQagOgDIZX/AqCze3FKT3ywehjzz6BGvbWvh
         eFaSjZO04Ne+pIRuCP8VszFZKECMThMmKTh3Tc6FtIkNxEaow47/TKbiy4XMAv4qCv
         +HIkQD7vIZK2mkJcmlUuIUIsjTonkGYCSsI45piCbKbDXDMV6MBqNX5gk7XDmd2STB
         Ou5TeBWufV6bA==
Subject: [PATCH 4/4] generic/60[78]: ensure the initial DAX file flag state
 before test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 Mar 2021 15:22:56 -0800
Message-ID: <161472737624.3478298.18322455058303982173.stgit@magnolia>
In-Reply-To: <161472735404.3478298.8179031068431918520.stgit@magnolia>
References: <161472735404.3478298.8179031068431918520.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Since this test checks the behaviors of both the in-core S_DAX flag and
the ondisk FS_XFLAG_DAX inode flags, it must be careful about the
initial state of the filesystem w.r.t. the inode flag.

Make sure that the root directory does /not/ have the inode flag set
before we begin testing, so that the initial state doesn't throw off
inheritance testing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/607 |    4 ++++
 tests/generic/608 |    3 +++
 2 files changed, 7 insertions(+)


diff --git a/tests/generic/607 b/tests/generic/607
index dd6dbd65..ba7da11b 100755
--- a/tests/generic/607
+++ b/tests/generic/607
@@ -156,6 +156,10 @@ do_xflag_tests()
 	local option=$1
 
 	_scratch_mount "$option"
+
+	# Make sure the root dir doesn't have FS_XFLAG_DAX set before we start.
+	chattr -x $SCRATCH_MNT &>> $seqres.full
+
 	cd $SCRATCH_MNT
 
 	for i in $(seq 1 5); do
diff --git a/tests/generic/608 b/tests/generic/608
index dd89d91c..13a751d7 100755
--- a/tests/generic/608
+++ b/tests/generic/608
@@ -98,6 +98,9 @@ do_tests()
 
 	_scratch_mount "$mount_option"
 
+	# Make sure the root dir doesn't have FS_XFLAG_DAX set before we start.
+	chattr -x $SCRATCH_MNT &>> $seqres.full
+
 	test_drop_caches
 
 	test_cycle_mount "$cycle_mount_option"

