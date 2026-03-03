Return-Path: <linux-xfs+bounces-31709-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mECSJnYupmkrLwAAu9opvQ
	(envelope-from <linux-xfs+bounces-31709-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 01:42:30 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 86F0B1E74C8
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 01:42:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7374A3005AB6
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 00:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84C54220698;
	Tue,  3 Mar 2026 00:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cUme7gih"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619A021D3E2;
	Tue,  3 Mar 2026 00:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498546; cv=none; b=j39dSl4XItGDpqsY8wJqNtxEWj1cw2ibl6O/bY9dqACCqSRnLDSMOpcsaK2JajQl6pfpCgGpEhVbFOTQeVa6DHUAS0K01OTRJSG4YwuaVsVZHFRVk8sGH6SjS8cNYBbjJpqT2hS1PxbwmQ6QqYMq8QpuMb/B98+kkT8wxX94yfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498546; c=relaxed/simple;
	bh=hhr1TxoteWvL/GC6vNAPz8m7PDQCt3f+Exm+b8hNvJg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xd6P+ySzaGua/uULQPVIAq3kVRVIpCYPlv+x5jK5JJ5dI94Mwt2f6cWAkzW08CYVVp6u0gHXHI2PWLebH62VIzHj0qJaGv5jQ3pOf+K/fM0htmh5qiuS+iiBlVo41/UOrod7rVFUq4bAL4AGbMwLUOl1Nitm3jqWObwWpEubihw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cUme7gih; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3EAC19423;
	Tue,  3 Mar 2026 00:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498546;
	bh=hhr1TxoteWvL/GC6vNAPz8m7PDQCt3f+Exm+b8hNvJg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cUme7gih2ORktaMKICg75XTbkfDWfiRPudOonXIhokrCtZBUARRPbE1dXfYZqYJXb
	 /QBljoKHU82skIhMVWCnjdUiU4cLL0XptFr3FZpdkFXUQ29BDQanUg4cMrGPphX/j4
	 Y435vdL2RbC0W7gfjayN9JYHBjgpaBGodSrjyHMvDdAcCuKYG6CTgx4FWIGaLnB+B2
	 bV1qTN3yeStNxyJpSVbMbORLarBve8DpJH8PmkP44FsscHGWViO4L5Z4miIyp4CbLL
	 jixA06w2PuT/CSk3PLV90Zg6po6NhTch22kYXzZjcvBeKWJgHPmMn0KzMaCaYu5l6S
	 YnS58a0g18b/Q==
Date: Mon, 02 Mar 2026 16:42:25 -0800
Subject: [PATCH 06/13] xfs: test xfs_healer can fix a filesystem
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177249785879.483507.2272544645849479779.stgit@frogsfrogsfrogs>
In-Reply-To: <177249785709.483507.8373602184765043420.stgit@frogsfrogsfrogs>
References: <177249785709.483507.8373602184765043420.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 86F0B1E74C8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31709-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: Darrick J. Wong <djwong@kernel.org>

Make sure that xfs_healer can actually fix an injected metadata corruption.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1884     |   89 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1884.out |    2 +
 2 files changed, 91 insertions(+)
 create mode 100755 tests/xfs/1884
 create mode 100644 tests/xfs/1884.out


diff --git a/tests/xfs/1884 b/tests/xfs/1884
new file mode 100755
index 00000000000000..1fa6457ad25203
--- /dev/null
+++ b/tests/xfs/1884
@@ -0,0 +1,89 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1884
+#
+# Ensure that autonomous self healing fixes the filesystem correctly.
+#
+. ./common/preamble
+_begin_fstest auto selfhealing
+
+. ./common/filter
+. ./common/fuzzy
+. ./common/systemd
+
+_require_scrub
+_require_xfs_io_command "repair"	# online repair support
+_require_xfs_db_command "blocktrash"
+_require_command "$XFS_HEALER_PROG" "xfs_healer"
+_require_command "$XFS_PROPERTY_PROG" "xfs_property"
+_require_scratch
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+_xfs_has_feature $SCRATCH_MNT rmapbt || \
+	_notrun "reverse mapping required to test directory auto-repair"
+_xfs_has_feature $SCRATCH_MNT parent || \
+	_notrun "parent pointers required to test directory auto-repair"
+_require_xfs_healer $SCRATCH_MNT --repair
+
+# Configure the filesystem for automatic repair of the filesystem.
+$XFS_PROPERTY_PROG $SCRATCH_MNT set autofsck=repair >> $seqres.full
+
+# Create a largeish directory
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
+echo testdata > $SCRATCH_MNT/a
+mkdir -p "$SCRATCH_MNT/some/victimdir"
+for ((i = 0; i < (dblksz / 255); i++)); do
+	fname="$(printf "%0255d" "$i")"
+	ln $SCRATCH_MNT/a $SCRATCH_MNT/some/victimdir/$fname
+done
+
+# Did we get at least two dir blocks?
+dirsize=$(stat -c '%s' $SCRATCH_MNT/some/victimdir)
+test "$dirsize" -gt "$dblksz" || echo "failed to create two-block directory"
+
+# Break the directory, remount filesystem
+_scratch_unmount
+_scratch_xfs_db -x \
+	-c 'path /some/victimdir' \
+	-c 'bmap' \
+	-c 'dblock 1' \
+	-c 'blocktrash -z -0 -o 0 -x 2048 -y 2048 -n 2048' >> $seqres.full
+_scratch_mount
+
+_scratch_invoke_xfs_healer "$tmp.healer" --repair
+
+# Access the broken directory to trigger a repair, then poll the directory
+# for 5 seconds to see if it gets fixed without us needing to intervene.
+ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
+_filter_scratch < $tmp.err
+try=0
+while [ $try -lt 50 ] && grep -q 'Structure needs cleaning' $tmp.err; do
+	echo "try $try saw corruption" >> $seqres.full
+	sleep 0.1
+	ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
+	try=$((try + 1))
+done
+echo "try $try no longer saw corruption or gave up" >> $seqres.full
+_filter_scratch < $tmp.err
+
+# List the dirents of /victimdir to see if it stops reporting corruption
+ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
+try=0
+while [ $try -lt 50 ] && grep -q 'Structure needs cleaning' $tmp.err; do
+	echo "retry $try still saw corruption" >> $seqres.full
+	sleep 0.1
+	ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
+	try=$((try + 1))
+done
+echo "retry $try no longer saw corruption or gave up" >> $seqres.full
+
+# Unmount to kill the healer
+_scratch_kill_xfs_healer
+cat $tmp.healer >> $seqres.full
+
+status=0
+exit
diff --git a/tests/xfs/1884.out b/tests/xfs/1884.out
new file mode 100644
index 00000000000000..929e33da01f92c
--- /dev/null
+++ b/tests/xfs/1884.out
@@ -0,0 +1,2 @@
+QA output created by 1884
+ls: reading directory 'SCRATCH_MNT/some/victimdir': Structure needs cleaning


