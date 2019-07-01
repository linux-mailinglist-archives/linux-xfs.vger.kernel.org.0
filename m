Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0514FFFF
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 05:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfFXDHo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 23 Jun 2019 23:07:44 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:33246
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726323AbfFXDHo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jun 2019 23:07:44 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Jun 2019 23:07:42 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BbAACVOxBd/3Gu0HYNVx0BAQUBBwU?=
 =?us-ascii?q?BgVYFAQsBgWeCRYQWk0kGgRGJeIUXi3cJAQEBAQEBAQEBNwEBAYQ6AwKDAzc?=
 =?us-ascii?q?GDgEDAQEBBAEBAQEEAZB9J1YoDQImAkkWE4UZoklxgTEaihGBDCgBgWGKE3i?=
 =?us-ascii?q?BB4ERM4MdhB0BC4MlglgEjkqFHFs/lQkJghaTfQyNIAOKGIQQoieBek0uCoM?=
 =?us-ascii?q?ngk0Xji1ljWABglEBAQ?=
X-IPAS-Result: =?us-ascii?q?A2BbAACVOxBd/3Gu0HYNVx0BAQUBBwUBgVYFAQsBgWeCR?=
 =?us-ascii?q?YQWk0kGgRGJeIUXi3cJAQEBAQEBAQEBNwEBAYQ6AwKDAzcGDgEDAQEBBAEBA?=
 =?us-ascii?q?QEEAZB9J1YoDQImAkkWE4UZoklxgTEaihGBDCgBgWGKE3iBB4ERM4MdhB0BC?=
 =?us-ascii?q?4MlglgEjkqFHFs/lQkJghaTfQyNIAOKGIQQoieBek0uCoMngk0Xji1ljWABg?=
 =?us-ascii?q?lEBAQ?=
X-IronPort-AV: E=Sophos;i="5.63,410,1557158400"; 
   d="scan'208";a="221015566"
Received: from unknown (HELO [192.168.1.222]) ([118.208.174.113])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Jun 2019 10:58:23 +0800
Subject: [PATCH 01/10] xfs: mount-api - add fs parameter description
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Mon, 24 Jun 2019 10:58:22 +0800
Message-ID: <156134510205.2519.16185588460828778620.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The new mount-api uses an array of struct fs_parameter_spec for
parameter parsing, create this table populated with the xfs mount
parameters.

The new mount-api table definition is wider than the token based
parameter table and interleaving the option description comments
between each table line is much less readable than adding them to
the end of each table entry. So add the option description comment
to each entry line even though it causes quite a few of the entries
to be longer than 80 characters.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   48 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a14d11d78bd8..ab8145bf6fff 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -51,6 +51,8 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/parser.h>
+#include <linux/fs_context.h>
+#include <linux/fs_parser.h>
 
 static const struct super_operations xfs_super_operations;
 struct bio_set xfs_ioend_bioset;
@@ -60,9 +62,6 @@ static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
 static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
 #endif
 
-/*
- * Table driven mount option parser.
- */
 enum {
 	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev, Opt_biosize,
 	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth, Opt_nouuid,
@@ -122,6 +121,49 @@ static const match_table_t tokens = {
 	{Opt_err,	NULL},
 };
 
+static const struct fs_parameter_spec xfs_param_specs[] = {
+ fsparam_u32	("logbufs",    Opt_logbufs),   /* number of XFS log buffers */
+ fsparam_string ("logbsize",   Opt_logbsize),  /* size of XFS log buffers */
+ fsparam_string ("logdev",     Opt_logdev),    /* log device */
+ fsparam_string ("rtdev",      Opt_rtdev),     /* realtime I/O device */
+ fsparam_u32	("biosize",    Opt_biosize),   /* log2 of preferred buffered io size */
+ fsparam_flag	("wsync",      Opt_wsync),     /* safe-mode nfs compatible mount */
+ fsparam_flag	("noalign",    Opt_noalign),   /* turn off stripe alignment */
+ fsparam_flag	("swalloc",    Opt_swalloc),   /* turn on stripe width allocation */
+ fsparam_u32	("sunit",      Opt_sunit),     /* data volume stripe unit */
+ fsparam_u32	("swidth",     Opt_swidth),    /* data volume stripe width */
+ fsparam_flag	("nouuid",     Opt_nouuid),    /* ignore filesystem UUID */
+ fsparam_flag_no("grpid",      Opt_grpid),     /* group-ID from parent directory (or not) */
+ fsparam_flag	("bsdgroups",  Opt_bsdgroups), /* group-ID from parent directory */
+ fsparam_flag	("sysvgroups", Opt_sysvgroups),/* group-ID from current process */
+ fsparam_string ("allocsize",  Opt_allocsize), /* preferred allocation size */
+ fsparam_flag	("norecovery", Opt_norecovery),/* don't run XFS recovery */
+ fsparam_flag	("inode64",    Opt_inode64),   /* inodes can be allocated anywhere */
+ fsparam_flag	("inode32",    Opt_inode32),   /* inode allocation limited to XFS_MAXINUMBER_32 */
+ fsparam_flag_no("ikeep",      Opt_ikeep),     /* do not free (or keep) empty inode clusters */
+ fsparam_flag_no("largeio",    Opt_largeio),   /* report (or do not report) large I/O sizes in stat() */
+ fsparam_flag_no("attr2",      Opt_attr2),     /* do (or do not) use attr2 attribute format */
+ fsparam_flag	("filestreams",Opt_filestreams), /* use filestreams allocator */
+ fsparam_flag_no("quota",      Opt_quota),     /* disk quotas (user) */
+ fsparam_flag	("usrquota",   Opt_usrquota),  /* user quota enabled */
+ fsparam_flag	("grpquota",   Opt_grpquota),  /* group quota enabled */
+ fsparam_flag	("prjquota",   Opt_prjquota),  /* project quota enabled */
+ fsparam_flag	("uquota",     Opt_uquota),    /* user quota (IRIX variant) */
+ fsparam_flag	("gquota",     Opt_gquota),    /* group quota (IRIX variant) */
+ fsparam_flag	("pquota",     Opt_pquota),    /* project quota (IRIX variant) */
+ fsparam_flag	("uqnoenforce",Opt_uqnoenforce), /* user quota limit enforcement */
+ fsparam_flag	("gqnoenforce",Opt_gqnoenforce), /* group quota limit enforcement */
+ fsparam_flag	("pqnoenforce",Opt_pqnoenforce), /* project quota limit enforcement */
+ fsparam_flag	("qnoenforce", Opt_qnoenforce),  /* same as uqnoenforce */
+ fsparam_flag_no("discard",    Opt_discard),   /* Do (or do not) not discard unused blocks */
+ fsparam_flag	("dax",	       Opt_dax),       /* Enable direct access to bdev pages */
+ {}
+};
+
+static const struct fs_parameter_description xfs_fs_parameters = {
+	.name		= "xfs",
+	.specs		= xfs_param_specs,
+};
 
 STATIC int
 suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)

