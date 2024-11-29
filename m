Return-Path: <linux-xfs+bounces-15802-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2433A9D6299
	for <lists+linux-xfs@lfdr.de>; Fri, 22 Nov 2024 17:52:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88089B24B19
	for <lists+linux-xfs@lfdr.de>; Fri, 22 Nov 2024 16:52:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C57184D13;
	Fri, 22 Nov 2024 16:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nBTyq7ai"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F5522339;
	Fri, 22 Nov 2024 16:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294369; cv=none; b=Qa8uk73jkU8IXpRmsEbE1VnFQpdYLw3KNaR+OYgbCWk38bOQe/uBXgjSetyKoUpfCQC/MFxk2JQEfglNC7/+ehWNlo3616i2+NyyyTkRc4FvcGy2ZOjJVdbwv79CVMtghkqLFYzR/x4KeaorhlCk/Nz/qkXceviiQr6BAsxTk/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294369; c=relaxed/simple;
	bh=jtDg7rV60EHbv2fundEmPAeiRtCpunRCaDZWcIOnfxo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WXRhy9H4zuc7wBrJH8m8Iy3Go6EYutJarEY2Gf8rToFx2e2PwXT1n/YGC2tItWu29voBFNu6IDUQY5kwsCAJXM6AfNcdS/ClEHcZWT24sjIztR4WTq3vjLmomA3KV6z7+3ISRqNSZ1MTE8lAzffdlpZELgA5kjWgCdP5Cdw/g68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nBTyq7ai; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F51C4CECE;
	Fri, 22 Nov 2024 16:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732294368;
	bh=jtDg7rV60EHbv2fundEmPAeiRtCpunRCaDZWcIOnfxo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nBTyq7aiHEeVFYR42FdzZq1yhWg1m1FfRdP340nG8hXmV4VVGdvZSJQlTxmLDPkBd
	 zSL9a8XR6VzwJb6xSGt5L4/jCs4/fusLvEw1tBwDRTMDxWzN9CCq8njrhAeANjSB9+
	 0MOJybkhnCN0KssjVLdGmFh+G8PidO5ygm/csAhE9gFKMUiAvdH2d5rcbwEPgSYuTQ
	 sd67THhY6L6mcmSxEIXOd1CGhoahJ5cYUHcwJ2Kn7ntbF/9zgCa7qaH1Vy9pY+IUFU
	 C/CpifjUHenS+vYNeS3SXH1UtGLqvkbjxZgn8ELGd5B8ZgalCW0KLqvmMaxleyOaZ/
	 q+fejYjxwQDXg==
Date: Fri, 22 Nov 2024 08:52:48 -0800
Subject: [PATCH 09/17] generic/562: handle ENOSPC while cloning gracefully
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173229420148.358248.4652252209849197144.stgit@frogsfrogsfrogs>
In-Reply-To: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This test creates a couple of patterned files on a tiny filesystem,
fragments the free space, clones one patterned file to the other, and
checks that the entire file was cloned.

However, this test doesn't work on a 64k fsblock filesystem because
we've used up all the free space reservation for the rmapbt, and that
causes the FICLONE to error out with ENOSPC partway through.  Hence we
need to detect the ENOSPC and _notrun the test.

That said, it turns out that XFS has been silently dropping error codes
if we managed to make some progress cloning extents.  That's ok if the
operation has REMAP_FILE_CAN_SHORTEN like copy_file_range does, but
FICLONE/FICLONERANGE do not permit partial results, so the dropped error
codes is actually an error.

Therefore, this testcase now becomes a regression test for the patch to
fix that.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/562 |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/tests/generic/562 b/tests/generic/562
index 91360c4154a6a2..36bd02911c96b8 100755
--- a/tests/generic/562
+++ b/tests/generic/562
@@ -15,6 +15,9 @@ _begin_fstest auto clone punch
 . ./common/filter
 . ./common/reflink
 
+test "$FSTYP" = "xfs" && \
+	_fixed_by_kernel_commit XXXXXXXXXX "xfs: don't drop errno values when we fail to ficlone the entire range"
+
 _require_scratch_reflink
 _require_test_program "punch-alternating"
 _require_xfs_io_command "fpunch"
@@ -48,8 +51,11 @@ while true; do
 done
 
 # Now clone file bar into file foo. This is supposed to succeed and not fail
-# with ENOSPC for example.
-_reflink $SCRATCH_MNT/bar $SCRATCH_MNT/foo >>$seqres.full
+# with ENOSPC for example.  However, XFS will sometimes run out of space.
+_reflink $SCRATCH_MNT/bar $SCRATCH_MNT/foo >>$seqres.full 2> $tmp.err
+cat $tmp.err
+test "$FSTYP" = "xfs" && grep -q 'No space left on device' $tmp.err && \
+	_notrun "ran out of space while cloning"
 
 # Unmount and mount the filesystem again to verify the operation was durably
 # persisted.


