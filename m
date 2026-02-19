Return-Path: <linux-xfs+bounces-31132-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wO9eD22gl2m/3QIAu9opvQ
	(envelope-from <linux-xfs+bounces-31132-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 00:44:45 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 52C15163A29
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 00:44:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6616C3007292
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 23:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30F4931A813;
	Thu, 19 Feb 2026 23:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BeYlXck2"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5AB31B108
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544642; cv=none; b=tdi9R0ytpXsK2mfLAmdEXm5N4cuzJtV522yiXkktH6PaIkj7tVvoJ8ldovdaKJmZ0E22rl8pw9trIo7taKfbWQJik0eBV1gDJX6vTMWS9ulXpNcMOiw0rLpDPL3EgVz7LWqSw93IUJ/9QgOuWFWvwWjA54o4c8hlAEq1waeYYaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544642; c=relaxed/simple;
	bh=DmpuaTqRUB1wM8v9mS5Vt4PhPqoZb1gvsokZJkLKZZw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CC6kf681722QTTWgDYy/zSwrGrWPQ137GYVV45K3Sm8rNNGuPpSGTZyqVWbwLzdJbmzfU3DJxP6IG1yy4re/bLe2wnt+A2QpJoVaBHwV/WcQoaUVIiKR5wr4YVr1PDNqFHIBUW+EU0AIkyuIIgrTPVDq7jm/41URnqqs3XnU5LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BeYlXck2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE517C4CEF7;
	Thu, 19 Feb 2026 23:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544641;
	bh=DmpuaTqRUB1wM8v9mS5Vt4PhPqoZb1gvsokZJkLKZZw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BeYlXck2TImGr5H+OFZySeDdbiS78cDddQuuKeVvjlg9vndoQUZp75ndOOGvxZrN9
	 FlS6rNHfeYSHC9W+UaWRFNANwwDVfcT2AR+g7tiY5bdGXOJQvy+M8JNf72dh9vnZuJ
	 mgFPPigM89ZUJFOtA+DsQSpKX+UroLFjQkJQLKR/SQDN9n0hAlbx0XRHLWPMmCUPKI
	 CQekLBk7J9niDHre/55ViGsA/o5L0PS8q23wHmwQMt909GGlILZQ49lgvGNxZu1d6z
	 sbSLBWViKnAPAVqqE4qVCbINFfKwl+5p1wG9IVAAGWa47fB6nb1uITckaeIaN0a7EW
	 ClG1/aw839Apg==
Date: Thu, 19 Feb 2026 15:44:00 -0800
Subject: [PATCH 02/12] xfs: use blkdev_report_zones_cached()
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: axboe@kernel.dk, dlemoal@kernel.org, martin.petersen@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <177154456766.1285810.14453766592409357328.stgit@frogsfrogsfrogs>
In-Reply-To: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
References: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31132-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: 52C15163A29
X-Rspamd-Action: no action

From: Damien Le Moal <dlemoal@kernel.org>

Source kernel commit: e04ccfc28252f181ea8d469d834b48e7dece65b2

Modify xfs_mount_zones() to replace the call to blkdev_report_zones()
with blkdev_report_zones_cached() to speed-up mount operations.
Since this causes xfs_zone_validate_seq() to see zones with the
BLK_ZONE_COND_ACTIVE condition, this function is also modified to acept
this condition as valid.

With this change, mounting a freshly formatted large capacity (30 TB)
SMR HDD completes under 2s compared to over 4.7s before.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 configure.ac          |    1 +
 include/builddefs.in  |    1 +
 libxfs/Makefile       |    4 ++++
 libxfs/xfs_zones.c    |    1 +
 m4/package_libcdev.m4 |   18 ++++++++++++++++++
 5 files changed, 25 insertions(+)


diff --git a/configure.ac b/configure.ac
index a8b8f7d5066fb6..076098ae025093 100644
--- a/configure.ac
+++ b/configure.ac
@@ -182,6 +182,7 @@ AC_CONFIG_UDEV_RULE_DIR
 AC_HAVE_BLKID_TOPO
 AC_HAVE_TRIVIAL_AUTO_VAR_INIT
 AC_STRERROR_R_RETURNS_STRING
+AC_HAVE_BLK_ZONE_COND_ACTIVE
 
 if test "$enable_ubsan" = "yes" || test "$enable_ubsan" = "probe"; then
         AC_PACKAGE_CHECK_UBSAN
diff --git a/include/builddefs.in b/include/builddefs.in
index b38a099b7d525a..f598343abb50b4 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -118,6 +118,7 @@ HAVE_UDEV = @have_udev@
 UDEV_RULE_DIR = @udev_rule_dir@
 HAVE_LIBURCU_ATOMIC64 = @have_liburcu_atomic64@
 STRERROR_R_RETURNS_STRING = @strerror_r_returns_string@
+HAVE_BLK_ZONE_COND_ACTIVE = @have_blk_zone_cond_active@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 61c43529b532b6..eed37a21be24ed 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -167,6 +167,10 @@ ifeq ($(HAVE_GETRANDOM_NONBLOCK),yes)
 LCFLAGS += -DHAVE_GETRANDOM_NONBLOCK
 endif
 
+ifneq ($(HAVE_BLK_ZONE_COND_ACTIVE),yes)
+LCFLAGS += -DBLK_ZONE_COND_ACTIVE=0xff
+endif
+
 FCFLAGS = -I.
 
 LTLIBS = $(LIBPTHREAD) $(LIBRT)
diff --git a/libxfs/xfs_zones.c b/libxfs/xfs_zones.c
index 7a81d83f5b3ef7..99ae05ce7473e3 100644
--- a/libxfs/xfs_zones.c
+++ b/libxfs/xfs_zones.c
@@ -97,6 +97,7 @@ xfs_zone_validate_seq(
 	case BLK_ZONE_COND_IMP_OPEN:
 	case BLK_ZONE_COND_EXP_OPEN:
 	case BLK_ZONE_COND_CLOSED:
+	case BLK_ZONE_COND_ACTIVE:
 		return xfs_zone_validate_wp(zone, rtg, write_pointer);
 	case BLK_ZONE_COND_FULL:
 		return xfs_zone_validate_full(zone, rtg, write_pointer);
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index c5538c30d2518a..83233ec2ad4d5e 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -347,3 +347,21 @@ puts(strerror_r(0, buf, sizeof(buf)));
     CFLAGS="$OLD_CFLAGS"
     AC_SUBST(strerror_r_returns_string)
   ])
+
+#
+# Check if blkzoned.h defines BLK_ZONE_COND_ACTIVE
+#
+AC_DEFUN([AC_HAVE_BLK_ZONE_COND_ACTIVE],
+  [AC_MSG_CHECKING([for BLK_ZONE_COND_ACTIVE])
+    AC_LINK_IFELSE(
+    [AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <linux/blkzoned.h>
+  ]], [[
+int foo = BLK_ZONE_COND_ACTIVE;
+  ]])
+    ], have_blk_zone_cond_active=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_blk_zone_cond_active)
+  ])


