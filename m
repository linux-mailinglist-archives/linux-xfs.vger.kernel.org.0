Return-Path: <linux-xfs+bounces-2354-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46AA1821293
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 01:57:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF53328281A
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 00:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7C0B4A0A;
	Mon,  1 Jan 2024 00:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e6bPizjj"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807234A02;
	Mon,  1 Jan 2024 00:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5423CC433C7;
	Mon,  1 Jan 2024 00:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070617;
	bh=2wKJIeExmBSnGPppMjYqjoK7wyzOeYykRqabK7WifWk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e6bPizjj5BaX77lmWqk4SAjxCEGMacJS68RQkVHAsnALPuoLjKBoaSIe/T2iet3wu
	 YfB4inW0wlUqT4HtLuA8wu9lu6p40Agka54ftUJZEsT8hsU71TCegezDTo7u3eVKle
	 O8DRzM30PYTNrrESjVbbvsGPWVdpK66h3LoGYO5yFLlrJeT3kiZwGN5jTUTeiATuBz
	 PDSV8Ta5DWPWzNXZVDppd70v0U16CjV1arP3jMXfbV2j/7Nw+M78k2BbHQ2T/62jrR
	 SxEMMUK6j7pR544al83/9TCprK2FOx0KsxXc0Cn5J/BDoNw4Gtd7Xdlpk0MNf7pc1g
	 PNa8uIadyUWSQ==
Date: Sun, 31 Dec 2023 16:56:56 +9900
Subject: [PATCH 16/17] common/xfs: capture realtime devices during
 metadump/mdrestore
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030547.1826350.12488301162005381994.stgit@frogsfrogsfrogs>
In-Reply-To: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
References: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If xfs_metadump supports the -r switch to capture the contents of
realtime devices and there is a realtime device, add the option to the
command line to enable preservation.

Similarly, if xfs_mdrestore supports the -r switch and there's an
external scratch rtdev, pass the option so that we can restore rtdev
contents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy    |    6 ++++-
 common/populate |   12 ++++++++--
 common/xfs      |   65 +++++++++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 71 insertions(+), 12 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index b72ee3f67f..d504f0854e 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -309,7 +309,11 @@ __scratch_xfs_fuzz_mdrestore()
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 		logdev=$SCRATCH_LOGDEV
 
-	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" "${logdev}" || \
+	local rtdev=none
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+		rtdev=$SCRATCH_RTDEV
+
+	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" "${logdev}" "${rtdev}" || \
 		_fail "${POPULATE_METADUMP}: Could not find metadump to restore?"
 }
 
diff --git a/common/populate b/common/populate
index 450b024bfc..dc89eee70e 100644
--- a/common/populate
+++ b/common/populate
@@ -1017,7 +1017,11 @@ _scratch_populate_restore_cached() {
 
 	case "${FSTYP}" in
 	"xfs")
-		_xfs_mdrestore "${metadump}" "${SCRATCH_DEV}" "${logdev}"
+		local rtdev=none
+		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+			rtdev=$SCRATCH_RTDEV
+
+		_xfs_mdrestore "${metadump}" "${SCRATCH_DEV}" "${logdev}" "${rtdev}"
 		return $?
 		;;
 	"ext2"|"ext3"|"ext4")
@@ -1039,8 +1043,12 @@ _scratch_populate_save_metadump()
 		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 			logdev=$SCRATCH_LOGDEV
 
+		local rtdev=none
+		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+			rtdev=$SCRATCH_RTDEV
+
 		_xfs_metadump "$metadump_file" "$SCRATCH_DEV" "$logdev" \
-				compress
+				"$rtdev" compress
 		res=$?
 		;;
 	"ext2"|"ext3"|"ext4")
diff --git a/common/xfs b/common/xfs
index 1136d685e7..1ff81f4cc2 100644
--- a/common/xfs
+++ b/common/xfs
@@ -681,11 +681,17 @@ _xfs_metadump() {
 	local metadump="$1"
 	local device="$2"
 	local logdev="$3"
-	local compressopt="$4"
-	shift; shift; shift; shift
+	local rtdev="$4"
+	local compressopt="$5"
+	shift; shift; shift; shift; shift
 	local options="$@"
 	test -z "$options" && options="-a -o"
 	local metadump_has_dash_x
+	local metadump_has_dash_r
+
+	# Does metadump support capturing realtime devices?
+	$XFS_METADUMP_PROG --help 2>&1 | grep -q -- '-r rtdev' && \
+			metadump_has_dash_r=1
 
 	# Use metadump v2 format unless the user gave us a specific version
 	$XFS_METADUMP_PROG --help 2>&1 | grep -q -- '-v version' && \
@@ -699,6 +705,10 @@ _xfs_metadump() {
 		options="$options -l $logdev"
 	fi
 
+	if [ "$rtdev" != "none" ] && [ -n "$metadump_has_dash_r" ]; then
+		options="$options -r $rtdev"
+	fi
+
 	$XFS_METADUMP_PROG $options "$device" "$metadump"
 	res=$?
 	[ "$compressopt" = "compress" ] && [ -n "$DUMP_COMPRESSOR" ] &&
@@ -710,14 +720,19 @@ _xfs_mdrestore() {
 	local metadump="$1"
 	local device="$2"
 	local logdev="$3"
-	shift; shift; shift
+	local rtdev="$4"
+	shift; shift; shift; shift
 	local options="$@"
 	local need_repair
 	local mdrestore_has_dash_l
+	local mdrestore_has_dash_r
 
 	# Does mdrestore support restoring to external devices?
 	$XFS_MDRESTORE_PROG --help 2>&1 | grep -q -- '-l logdev' &&
 			mdrestore_has_dash_l=1
+	# Does mdrestore support restoring to realtime devices?
+	$XFS_MDRESTORE_PROG --help 2>&1 | grep -q -- '-r rtdev' &&
+			mdrestore_has_dash_r=1
 
 	# If we're configured for compressed dumps and there isn't already an
 	# uncompressed dump, see if we can use DUMP_COMPRESSOR to decompress
@@ -743,6 +758,20 @@ _xfs_mdrestore() {
 		$XFS_IO_PROG -d -c 'pwrite -S 0 -q 0 1m' "$logdev"
 	fi
 
+	if [ "$rtdev" != "none" ]; then
+		# We have a realtime device.  If mdrestore supports restoring
+		# to it, configure ourselves to do that.
+		if [ -n "$mdrestore_has_dash_r" ]; then
+			options="$options -r $rtdev"
+		fi
+
+		# Wipe the realtime device.  If mdrestore doesn't support
+		# restoring to realtime devices or the metadump file doesn't
+		# capture the realtime group headers, this is our only chance
+		# to signal that the log header needs to be rewritten.
+		$XFS_IO_PROG -d -c 'pwrite -S 0 -q 0 1m' "$rtdev"
+	fi
+
 	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
 	res=$?
 	test $res -ne 0 && return $res
@@ -757,6 +786,16 @@ _xfs_mdrestore() {
 		fi
 	fi
 
+	# If there's a realtime device, check to see if the restore rewrote the
+	# rt group headers.  If not, we need to run xfs_repair to format new
+	# group headers onto the realtime device.
+	if [ "$rtdev" != "none" ] && [ -z "$need_repair" ]; then
+		magic="$($XFS_IO_PROG -c 'pread -q -v 0 4' "$rtdev")"
+		if [ "$magic" = "00000000:  00 00 00 00  ...." ]; then
+			need_repair=1
+		fi
+	fi
+
 	test -z "$need_repair" && return 0
 
 	echo "repairing fs to fix uncaptured parts of fs." >> $seqres.full
@@ -768,12 +807,16 @@ _scratch_xfs_metadump()
 {
 	local metadump=$1
 	shift
+
 	local logdev=none
-
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 		logdev=$SCRATCH_LOGDEV
 
-	_xfs_metadump "$metadump" "$SCRATCH_DEV" "$logdev" nocompress "$@"
+	local rtdev=none
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+		rtdev=$SCRATCH_RTDEV
+
+	_xfs_metadump "$metadump" "$SCRATCH_DEV" "$logdev" "$rtdev" nocompress "$@"
 }
 
 # Restore snapshotted metadata on the scratch device
@@ -786,7 +829,11 @@ _scratch_xfs_mdrestore()
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 		logdev=$SCRATCH_LOGDEV
 
-	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$logdev" "$@"
+	local rtdev=none
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+		rtdev=$SCRATCH_RTDEV
+
+	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$logdev" "$rtdev" "$@"
 }
 
 # Do not use xfs_repair (offline fsck) to rebuild the filesystem
@@ -923,7 +970,7 @@ _check_xfs_filesystem()
 	if [ "$ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
 		local flatdev="$(basename "$device")"
 		_xfs_metadump "$seqres.$flatdev.check.md" "$device" "$logdev" \
-			compress >> $seqres.full
+			"$rtdev" compress >> $seqres.full
 	fi
 
 	# Optionally test the index rebuilding behavior.
@@ -956,7 +1003,7 @@ _check_xfs_filesystem()
 		if [ "$rebuild_ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
 			local flatdev="$(basename "$device")"
 			_xfs_metadump "$seqres.$flatdev.rebuild.md" "$device" \
-				"$logdev" compress >> $seqres.full
+				"$logdev" "$rtdev" compress >> $seqres.full
 		fi
 	fi
 
@@ -1040,7 +1087,7 @@ _check_xfs_filesystem()
 		if [ "$orebuild_ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
 			local flatdev="$(basename "$device")"
 			_xfs_metadump "$seqres.$flatdev.orebuild.md" "$device" \
-				"$logdev" compress >> $seqres.full
+				"$logdev" "$rtdev" compress >> $seqres.full
 		fi
 	fi
 


