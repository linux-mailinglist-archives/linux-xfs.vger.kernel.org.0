Return-Path: <linux-xfs+bounces-19459-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13FD7A31CEC
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Feb 2025 04:37:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8D88163623
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Feb 2025 03:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA171D95A9;
	Wed, 12 Feb 2025 03:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLCVJ6hx"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EE5271839;
	Wed, 12 Feb 2025 03:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331432; cv=none; b=dSlFhSRg6E3ZBEgML2Je2UdcCXDwisypbkZQC/SoTJVMVom/YzOjBVZcLvXysWFy81u7lLXVVQPRVvFfJhushWVYrbE6mLoFVCzOQV75rA2l4SfdSkDDi2p5QZDvZjPheWkZ/Uqzi1+MKdUqLvVRj8g4JQ6XVUZje2nrHMi+XXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331432; c=relaxed/simple;
	bh=BlrJdqEN8OTCIHIAF5hwfqQqvYbGc101v8hqFaKziIs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S1jnTzwafjhiac8Zua+TK4GfLPFn4btNjjG/bKM5HRpZWGFhqR/1o/+KGzmaWhF0mfeqepfv7l/Fq3Qee6M91Whn1oXCSFP1jbVPSE3yPXRIMw5wbVxDKx5vfTfsfdFA6C9drANotKhxnZcD+XR1WVpPUXNwRbP7XeHXoUYg9dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLCVJ6hx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E944C4CEDF;
	Wed, 12 Feb 2025 03:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331432;
	bh=BlrJdqEN8OTCIHIAF5hwfqQqvYbGc101v8hqFaKziIs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BLCVJ6hxAsun1RDWS7tdrp2kDe6xJ4cxkqslvUxd6LNTyuCMlUYQgJaX7MDLIDduI
	 igjwgtHVSkSYOHRq6tJxrjYkwqRX1+7c6DQ5Djgf8jNOwb3PIpHTcE2WChkDOc4XnF
	 c8ZrgW1BME0FOPz6y31R7EbEk2xoPCfPaKSIpAaxYVHTwT8i3hGwt3Uelfpxly092I
	 8BrJ0xr5t8DyDCSLHNBx3Ju+LxXa3h36M7EYjZZpOM35pnAkpZn6jKNj+Jw4LVyN90
	 qWL8puQEclgChpy97VTa8hFW0zdCpvF7o+KaTCdE8e0dUHMRa/NwttxCtdhc5RJ+4y
	 5OfCXCYV/28Ng==
Date: Tue, 11 Feb 2025 19:37:11 -0800
Subject: [PATCH 25/34] fuzzy: don't use readarray for xfsfind output
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094738.1758477.1203472845850458322.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Some of the scrub stress tests (e.g. xfs/796) walk the directory tree to
find filepaths to scrub, and load the entire list of paths into a bash
array.  On a large filesystem or a long-running test this is hugely
wasteful of memory because we use each path exactly once.

Fix __stress_one_scrub_loop to avoid this by reading lines directly from
the output of the xfsfind utility.  However, we play some games with fd
77 so that the processes in the loop body will use the same stdin as the
test and /not/ the piped stdout of xfsfind.

To avoid read(1) becoming confused by newlines in the file paths, adapt
xfsfind to print nulls between pathnames, and the bash code to recognize
them.

This was a debugging patch while I was trying to figure out why xfs/286
and other scrub soak tests started OOMing after the v2024.12.08 changes,
though in the end the OOMs were the result of memory leaks in fsstress.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/fuzzy  |   22 +++++++++++++---------
 src/xfsfind.c |   14 +++++++++++---
 2 files changed, 24 insertions(+), 12 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 9d5f01fb087033..41547add83121a 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -861,14 +861,14 @@ __stress_one_scrub_loop() {
 		;;
 	esac
 
-	local target_cmd=(echo "$scrub_tgt")
+	local target_cmd=(echo -en "$scrub_tgt\0")
 	case "$scrub_tgt" in
-	"%file%")	target_cmd=($here/src/xfsfind -q  "$SCRATCH_MNT");;
-	"%attrfile%")	target_cmd=($here/src/xfsfind -qa "$SCRATCH_MNT");;
-	"%datafile%")	target_cmd=($here/src/xfsfind -qb "$SCRATCH_MNT");;
-	"%dir%")	target_cmd=($here/src/xfsfind -qd "$SCRATCH_MNT");;
-	"%regfile%")	target_cmd=($here/src/xfsfind -qr "$SCRATCH_MNT");;
-	"%cowfile%")	target_cmd=($here/src/xfsfind -qs "$SCRATCH_MNT");;
+	"%file%")	target_cmd=($here/src/xfsfind -0q  "$SCRATCH_MNT");;
+	"%attrfile%")	target_cmd=($here/src/xfsfind -0qa "$SCRATCH_MNT");;
+	"%datafile%")	target_cmd=($here/src/xfsfind -0qb "$SCRATCH_MNT");;
+	"%dir%")	target_cmd=($here/src/xfsfind -0qd "$SCRATCH_MNT");;
+	"%regfile%")	target_cmd=($here/src/xfsfind -0qr "$SCRATCH_MNT");;
+	"%cowfile%")	target_cmd=($here/src/xfsfind -0qs "$SCRATCH_MNT");;
 	esac
 
 	while __stress_scrub_running "$scrub_startat" "$runningfile"; do
@@ -876,12 +876,16 @@ __stress_one_scrub_loop() {
 	done
 
 	while __stress_scrub_running "$end" "$runningfile"; do
-		readarray -t fnames < <("${target_cmd[@]}" 2>> $seqres.full)
-		for fname in "${fnames[@]}"; do
+		# Attach the stdout of xfsfind to fd 77 so that we can read
+		# pathnames from that file descriptor without passing the pipe
+		# to the loop body as stdin.
+		exec 77< <("${target_cmd[@]}" 2>> $seqres.full)
+		while read -u 77 -d '' fname; do
 			$XFS_IO_PROG -x "${xfs_io_args[@]}" "$fname" 2>&1 | \
 				__stress_scrub_filter_output "${extra_filters[@]}"
 			__stress_scrub_running "$end" "$runningfile" || break
 		done
+		exec 77<&-
 	done
 }
 
diff --git a/src/xfsfind.c b/src/xfsfind.c
index c81deaf64f57e9..2043d01ded3210 100644
--- a/src/xfsfind.c
+++ b/src/xfsfind.c
@@ -20,6 +20,7 @@ static int want_dir;
 static int want_regfile;
 static int want_sharedfile;
 static int report_errors = 1;
+static int print0;
 
 static int
 check_datafile(
@@ -115,6 +116,7 @@ print_help(
 	printf("\n");
 	printf("Print all file paths matching any of the given predicates.\n");
 	printf("\n");
+	printf("-0	Print nulls between paths instead of newlines.\n");
 	printf("-a	Match files with xattrs.\n");
 	printf("-b	Match files with data blocks.\n");
 	printf("-d	Match directories.\n");
@@ -208,8 +210,13 @@ visit(
 out_fd:
 	close(fd);
 out:
-	if (printme)
-		printf("%s\n", path);
+	if (printme) {
+		if (print0)
+			printf("%s%c", path, 0);
+		else
+			printf("%s\n", path);
+		fflush(stdout);
+	}
 	return retval;
 }
 
@@ -236,8 +243,9 @@ main(
 	int			c;
 	int			ret;
 
-	while ((c = getopt(argc, argv, "abdqrs")) >= 0) {
+	while ((c = getopt(argc, argv, "0abdqrs")) >= 0) {
 		switch (c) {
+		case '0':	print0 = 1;          break;
 		case 'a':	want_attrfile = 1;   break;
 		case 'b':	want_datafile = 1;   break;
 		case 'd':	want_dir = 1;        break;


