Return-Path: <linux-xfs+bounces-2345-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 656A382128A
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 01:55:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B12D1C20B28
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 00:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 369021FB0;
	Mon,  1 Jan 2024 00:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U6zl2LFJ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D441871;
	Mon,  1 Jan 2024 00:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63415C433C8;
	Mon,  1 Jan 2024 00:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070476;
	bh=9jAnSOIqQu29C0AAMA66mRn2pUBSA6wv6/vXucWwKZE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U6zl2LFJDg9Cr3CmRI7EmtpwegaRJ6EOMNACJ3TvWR5WoISoIOtpf71+VEhqq49zu
	 zY+ktYvq7fsQGNN/CK/grRaGmErQxstEbWD++Xg3y4NAarPX7lLdK96K9hu8bPRroG
	 3KgLnY/CJw/sXUStFbFr5OHYBV3QsZI1mExG9PMGxkUvKU1ozrE4cvm82dxic5WC7O
	 j/kBsvbAoucuwKp27O2f+2vWNGzBVoWmTp1CtUHIF3B2YF51yK5ev046+nWrfPbgAI
	 Gg/bhpKci9wHi6yFFfFy/GqSeoHUNw9M/yMW4iyclk3CsxtDzKDRdzn17wXbTNCadc
	 u0euGEfUZg0mA==
Date: Sun, 31 Dec 2023 16:54:35 +9900
Subject: [PATCH 07/17] punch-alternating: detect xfs realtime files with large
 allocation units
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030429.1826350.15575708588863398953.stgit@frogsfrogsfrogs>
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

For files on the XFS realtime volume, it's possible that the file
allocation unit (aka the minimum size we have to punch to deallocate
file blocks) could be greater than a single fs block.  This utility
assumed that it's always possible to punch a single fs block, but for
these types of files, all that does is zeroes the page cache.  While
that's what most *user applications* want, fstests uses punching to
fragment file mapping metadata and/or fragment free space, so adapt this
test for that purpose by detecting realtime files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 src/punch-alternating.c |   28 +++++++++++++++++++++++++++-
 tests/xfs/114           |    4 ++++
 tests/xfs/146           |    2 +-
 tests/xfs/187           |    3 ++-
 tests/xfs/341           |    4 ++--
 5 files changed, 36 insertions(+), 5 deletions(-)


diff --git a/src/punch-alternating.c b/src/punch-alternating.c
index 18dd215197..d2bb4b6a22 100644
--- a/src/punch-alternating.c
+++ b/src/punch-alternating.c
@@ -20,6 +20,28 @@ void usage(char *cmd)
 	exit(1);
 }
 
+/* Compute the file allocation unit size for an XFS file. */
+static int detect_xfs_alloc_unit(int fd)
+{
+	struct fsxattr fsx;
+	struct xfs_fsop_geom fsgeom;
+	int ret;
+
+	ret = ioctl(fd, XFS_IOC_FSGEOMETRY, &fsgeom);
+	if (ret)
+		return -1;
+
+	ret = ioctl(fd, XFS_IOC_FSGETXATTR, &fsx);
+	if (ret)
+		return -1;
+
+	ret = fsgeom.blocksize;
+	if (fsx.fsx_xflags & XFS_XFLAG_REALTIME)
+		ret *= fsgeom.rtextsize;
+
+	return ret;
+}
+
 int main(int argc, char *argv[])
 {
 	struct stat	s;
@@ -82,7 +104,11 @@ int main(int argc, char *argv[])
 		goto err;
 
 	sz = s.st_size;
-	blksz = sf.f_bsize;
+	c = detect_xfs_alloc_unit(fd);
+	if (c > 0)
+		blksz = c;
+	else
+		blksz = sf.f_bsize;
 
 	mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
 	for (offset = start_offset * blksz;
diff --git a/tests/xfs/114 b/tests/xfs/114
index 0e8a0529ab..7ecb4d217c 100755
--- a/tests/xfs/114
+++ b/tests/xfs/114
@@ -49,6 +49,10 @@ $XFS_IO_PROG -f \
 	-c "pwrite -S 0x68 -b 1048576 0 $len2" \
 	$SCRATCH_MNT/f2 >> $seqres.full
 
+# The arguments to punch-alternating must be specified in units of file
+# allocation units, so we divide the argument by $file_blksz.  We already
+# verified that $blksz is congruent with $file_blksz, so the fpunch parameters
+# will always align with the file allocation unit.
 $here/src/punch-alternating -o $((16 * blksz / file_blksz)) \
 	-s $((blksz / file_blksz)) \
 	-i $((blksz * 2 / file_blksz)) \
diff --git a/tests/xfs/146 b/tests/xfs/146
index 5090435976..5d30cd8123 100755
--- a/tests/xfs/146
+++ b/tests/xfs/146
@@ -69,7 +69,7 @@ _xfs_force_bdev realtime $SCRATCH_MNT
 # Allocate some stuff at the start, to force the first falloc of the ouch file
 # to happen somewhere in the middle of the rt volume
 $XFS_IO_PROG -f -c 'falloc 0 64m' "$SCRATCH_MNT/b"
-$here/src/punch-alternating -i $((rextblks * 2)) -s $((rextblks)) "$SCRATCH_MNT/b"
+$here/src/punch-alternating "$SCRATCH_MNT/b"
 
 avail="$(df -P "$SCRATCH_MNT" | awk 'END {print $4}')"1
 toobig="$((avail * 2))"
diff --git a/tests/xfs/187 b/tests/xfs/187
index 7c34d8e630..14c3b37670 100755
--- a/tests/xfs/187
+++ b/tests/xfs/187
@@ -132,7 +132,8 @@ $XFS_IO_PROG -f -c "truncate $required_sz" -c "falloc 0 $remap_sz" $SCRATCH_MNT/
 # Punch out every other extent of the last two sections, to fragment free space.
 frag_sz=$((remap_sz * 3))
 punch_off=$((bigfile_sz - frag_sz))
-$here/src/punch-alternating $SCRATCH_MNT/bigfile -o $((punch_off / fsbsize)) -i $((rtextsize_blks * 2)) -s $rtextsize_blks
+rtextsize_bytes=$((fsbsize * rtextsize_blks))
+$here/src/punch-alternating $SCRATCH_MNT/bigfile -o $((punch_off / rtextsize_bytes))
 
 # Make sure we have some free rtextents.
 free_rtx=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep statfs.f_bavail | awk '{print $3}')
diff --git a/tests/xfs/341 b/tests/xfs/341
index 1f734c9015..7d2842b579 100755
--- a/tests/xfs/341
+++ b/tests/xfs/341
@@ -43,8 +43,8 @@ len=$((blocks * rtextsz))
 echo "Create some files"
 $XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f1 >> $seqres.full
 $XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f2 >> $seqres.full
-$here/src/punch-alternating -i $((2 * rtextsz_blks)) -s $rtextsz_blks $SCRATCH_MNT/f1 >> "$seqres.full"
-$here/src/punch-alternating -i $((2 * rtextsz_blks)) -s $rtextsz_blks $SCRATCH_MNT/f2 >> "$seqres.full"
+$here/src/punch-alternating $SCRATCH_MNT/f1 >> "$seqres.full"
+$here/src/punch-alternating $SCRATCH_MNT/f2 >> "$seqres.full"
 echo garbage > $SCRATCH_MNT/f3
 ino=$(stat -c '%i' $SCRATCH_MNT/f3)
 _scratch_unmount


