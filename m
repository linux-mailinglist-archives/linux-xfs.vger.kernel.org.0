Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF6250000
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 05:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbfFXDHs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 23 Jun 2019 23:07:48 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:33246
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726323AbfFXDHs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jun 2019 23:07:48 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Jun 2019 23:07:42 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AKAQCVOxBd/3Gu0HYNVxwBAQEEAQE?=
 =?us-ascii?q?HBAEBgWeELYQWk0kGgRGJeIUXhF+FMYFnCQEBAQEBAQEBATcBAQGEOgMCAoM?=
 =?us-ascii?q?BOBMBAwEBAQQBAQEBBAGQewIBAyMEUhAYDQImAgJHEAYThRmiSXF+MxqKEYE?=
 =?us-ascii?q?MKIFiihN4gQeBRIMdhCyDIoJYBI5KhXc/lQkJghaTfQyCHIsEAxCKCC2DY6I?=
 =?us-ascii?q?ogXlNLgqDJ5ERZZAyAQE?=
X-IPAS-Result: =?us-ascii?q?A2AKAQCVOxBd/3Gu0HYNVxwBAQEEAQEHBAEBgWeELYQWk?=
 =?us-ascii?q?0kGgRGJeIUXhF+FMYFnCQEBAQEBAQEBATcBAQGEOgMCAoMBOBMBAwEBAQQBA?=
 =?us-ascii?q?QEBBAGQewIBAyMEUhAYDQImAgJHEAYThRmiSXF+MxqKEYEMKIFiihN4gQeBR?=
 =?us-ascii?q?IMdhCyDIoJYBI5KhXc/lQkJghaTfQyCHIsEAxCKCC2DY6IogXlNLgqDJ5ERZ?=
 =?us-ascii?q?ZAyAQE?=
X-IronPort-AV: E=Sophos;i="5.63,410,1557158400"; 
   d="scan'208";a="221015621"
Received: from unknown (HELO [192.168.1.222]) ([118.208.174.113])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Jun 2019 10:58:31 +0800
Subject: [PATCH 02/10] xfs: mount-api - refactor suffix_kstrtoint()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Mon, 24 Jun 2019 10:58:30 +0800
Message-ID: <156134510851.2519.2387740442257250106.stgit@fedora-28>
In-Reply-To: <156134510205.2519.16185588460828778620.stgit@fedora-28>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The mount-api doesn't have a "human unit" parse type yet so
the options that have values like "10k" etc. still need to
be converted by the fs.

But the value comes to the fs as a string (not a substring_t
type) so there's a need to change the conversion function to
take a character string instead.

After switching to use the new mount-api match_kstrtoint()
will no longer be called and will be removed.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ab8145bf6fff..14c2a775786c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -166,13 +166,13 @@ static const struct fs_parameter_description xfs_fs_parameters = {
 };
 
 STATIC int
-suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
+suffix_kstrtoint(const char *s, unsigned int base, int *res)
 {
 	int	last, shift_left_factor = 0, _res;
 	char	*value;
 	int	ret = 0;
 
-	value = match_strdup(s);
+	value = kstrdup(s, GFP_KERNEL);
 	if (!value)
 		return -ENOMEM;
 
@@ -197,6 +197,20 @@ suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
 	return ret;
 }
 
+STATIC int
+match_kstrtoint(const substring_t *s, unsigned int base, int *res)
+{
+	const char	*value;
+	int ret;
+
+	value = match_strdup(s);
+	if (!value)
+		return -ENOMEM;
+	ret = suffix_kstrtoint(value, base, res);
+	kfree(value);
+	return ret;
+}
+
 /*
  * This function fills in xfs_mount_t fields based on mount args.
  * Note: the superblock has _not_ yet been read in.
@@ -268,7 +282,7 @@ xfs_parseargs(
 				return -EINVAL;
 			break;
 		case Opt_logbsize:
-			if (suffix_kstrtoint(args, 10, &mp->m_logbsize))
+			if (match_kstrtoint(args, 10, &mp->m_logbsize))
 				return -EINVAL;
 			break;
 		case Opt_logdev:
@@ -285,7 +299,7 @@ xfs_parseargs(
 			break;
 		case Opt_allocsize:
 		case Opt_biosize:
-			if (suffix_kstrtoint(args, 10, &iosize))
+			if (match_kstrtoint(args, 10, &iosize))
 				return -EINVAL;
 			iosizelog = ffs(iosize) - 1;
 			break;

