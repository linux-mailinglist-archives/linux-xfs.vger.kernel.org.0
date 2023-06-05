Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39955722B4B
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Jun 2023 17:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbjFEPh1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 5 Jun 2023 11:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234636AbjFEPhR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:37:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EE111A
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:37:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AEAB61539
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E73C433D2;
        Mon,  5 Jun 2023 15:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979430;
        bh=yEKokYvrwuwPuF0aOC9FdYRFi/CjHsjHmPOMZ5EpRB4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=guym79tnlaE3DNA31yrzSZ9ZBL3uQfIXF44cydma0GE90a9iLQ4TUWi9iYESdYKly
         CPWbiVsZd/055h4pemKST3IcxFOGfiU97bSDSB/x8PwBfSHukc7RRnvjtS2eTYphKv
         AFBFl+USor4EvUGPC2NjCGS3ZCBe2U815dn3C+bv0MGHyUv0C+BCzLA9TSu4pwo4I8
         qxvg7TqxpLryiHUxfeldQ2CICg71P8Quu3V5YRouN3xfdU2117pu/HhRUP4eahzRlB
         jOvv/pAnFl4HR7U9a2gofBceTzpyEQXTsQLPT/P62UZ92YFfH3RLIIAZG1t9cekTbW
         Vwe6Qd54FiAtA==
Subject: [PATCH 2/3] xfs_db: create dirents and xattrs with colliding names
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 05 Jun 2023 08:37:09 -0700
Message-ID: <168597942996.1226265.4909168279377490281.stgit@frogsfrogsfrogs>
In-Reply-To: <168597941869.1226265.3314805710581551617.stgit@frogsfrogsfrogs>
References: <168597941869.1226265.3314805710581551617.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new debugger command that will create dirent and xattr names
that induce dahash collisions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/hash.c         |  376 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |   31 ++++
 2 files changed, 407 insertions(+)


diff --git a/db/hash.c b/db/hash.c
index 68c53e7f9bc..79a250526e9 100644
--- a/db/hash.c
+++ b/db/hash.c
@@ -5,12 +5,15 @@
  */
 
 #include "libxfs.h"
+#include "init.h"
 #include "addr.h"
 #include "command.h"
 #include "type.h"
 #include "io.h"
 #include "output.h"
 #include "hash.h"
+#include "obfuscate.h"
+#include <sys/xattr.h>
 
 static int hash_f(int argc, char **argv);
 static void hash_help(void);
@@ -46,8 +49,381 @@ hash_f(
 	return 0;
 }
 
+static void
+hashcoll_help(void)
+{
+	printf(_(
+"\n"
+" Generate obfuscated variants of the provided name.  Each variant will have\n"
+" the same dahash value.  Names are written to stdout with a NULL separating\n"
+" each name.\n"
+"\n"
+" -a -- create extended attributes.\n"
+" -i -- read standard input for the name, up to %d bytes.\n"
+" -n -- create this many names.\n"
+" -p -- create directory entries or extended attributes in this file.\n"
+" -s -- seed the rng with this value.\n"
+"\n"),
+			MAXNAMELEN - 1);
+}
+
+struct name_dup {
+	struct name_dup	*next;
+	uint32_t	crc;
+	uint8_t		namelen;
+	uint8_t		name[];
+};
+
+static inline size_t
+name_dup_sizeof(
+	unsigned int	namelen)
+{
+	return sizeof(struct name_dup) + namelen;
+}
+
+#define MAX_DUP_TABLE_BUCKETS	(1048575)
+
+struct dup_table {
+	unsigned int	nr_buckets;
+	struct name_dup	*buckets[];
+};
+
+static inline size_t
+dup_table_sizeof(
+	unsigned int	nr_buckets)
+{
+	return sizeof(struct dup_table) +
+				(nr_buckets * sizeof(struct name_dup *));
+}
+
+static int
+dup_table_alloc(
+	unsigned long		nr_names,
+	struct dup_table	**tabp)
+{
+	struct dup_table	*t;
+
+	*tabp = NULL;
+
+	if (nr_names == 1)
+		return 0;
+
+	nr_names = min(MAX_DUP_TABLE_BUCKETS, nr_names);
+	t = calloc(1, dup_table_sizeof(nr_names));
+	if (!t)
+		return ENOMEM;
+
+	t->nr_buckets = nr_names;
+	*tabp = t;
+	return 0;
+}
+
+static void
+dup_table_free(
+	struct dup_table	*tab)
+{
+	struct name_dup		*ent, *next;
+	unsigned int		i;
+
+	if (!tab)
+		return;
+
+	for (i = 0; i < tab->nr_buckets; i++) {
+		ent = tab->buckets[i];
+
+		while (ent) {
+			next = ent->next;
+			free(ent);
+			ent = next;
+		}
+	}
+	free(tab);
+}
+
+static struct name_dup *
+dup_table_find(
+	struct dup_table	*tab,
+	unsigned char		*name,
+	size_t			namelen)
+{
+	struct name_dup		*ent;
+	uint32_t		crc = crc32c(~0, name, namelen);
+
+	ent = tab->buckets[crc % tab->nr_buckets];
+	while (ent) {
+		if (ent->crc == crc &&
+		    ent->namelen == namelen &&
+		    !memcmp(ent->name, name, namelen))
+			return ent;
+
+		ent = ent->next;
+	}
+
+	return NULL;
+}
+
+static int
+dup_table_store(
+	struct dup_table	*tab,
+	unsigned char		*name,
+	size_t			namelen)
+{
+	struct name_dup		*dup;
+	uint32_t		seq = 1;
+
+	ASSERT(namelen < MAXNAMELEN);
+
+	while ((dup = dup_table_find(tab, name, namelen)) != NULL) {
+		int		ret;
+
+		do {
+			ret = find_alternate(namelen, name, seq++);
+		} while (ret == 0);
+		if (ret < 0)
+			return EEXIST;
+	}
+
+	dup = malloc(name_dup_sizeof(namelen));
+	if (!dup)
+		return ENOMEM;
+
+	dup->crc = crc32c(~0, name, namelen);
+	dup->namelen = namelen;
+	memcpy(dup->name, name, namelen);
+	dup->next = tab->buckets[dup->crc % tab->nr_buckets];
+
+	tab->buckets[dup->crc % tab->nr_buckets] = dup;
+	return 0;
+}
+
+static int
+collide_dirents(
+	unsigned long		nr,
+	const unsigned char	*name,
+	size_t			namelen,
+	int			fd)
+{
+	struct xfs_name		dname = {
+		.name		= name,
+		.len		= namelen,
+	};
+	unsigned char		direntname[MAXNAMELEN + 1];
+	struct dup_table	*tab = NULL;
+	xfs_dahash_t		old_hash;
+	unsigned long		i;
+	int			error = 0;
+
+	old_hash = libxfs_dir2_hashname(mp, &dname);
+
+	if (fd >= 0) {
+		int		newfd;
+
+		/*
+		 * User passed in a fd, so we'll use the directory to detect
+		 * duplicate names.  First create the name that we are passed
+		 * in; the new names will be hardlinks to the first file.
+		 */
+		newfd = openat(fd, name, O_CREAT, 0600);
+		if (newfd < 0)
+			return errno;
+		close(newfd);
+	} else if (nr > 1) {
+		/*
+		 * Track every name we create so that we don't emit duplicates.
+		 */
+		error = dup_table_alloc(nr, &tab);
+		if (error)
+			return error;
+	}
+
+	dname.name = direntname;
+	for (i = 0; i < nr; i++) {
+		strncpy(direntname, name, MAXNAMELEN);
+		obfuscate_name(old_hash, namelen, direntname, true);
+		ASSERT(old_hash == libxfs_dir2_hashname(mp, &dname));
+
+		if (fd >= 0) {
+			error = linkat(fd, name, fd, direntname, 0);
+			if (error && errno != EEXIST)
+				return errno;
+
+			/* don't print names to stdout */
+			continue;
+		} else if (tab) {
+			error = dup_table_store(tab, direntname, namelen);
+			if (error)
+				break;
+		}
+
+		printf("%s%c", direntname, 0);
+	}
+
+	dup_table_free(tab);
+	return error;
+}
+
+static int
+collide_xattrs(
+	unsigned long		nr,
+	const unsigned char	*name,
+	size_t			namelen,
+	int			fd)
+{
+	unsigned char		xattrname[MAXNAMELEN + 5];
+	struct dup_table	*tab = NULL;
+	xfs_dahash_t		old_hash;
+	unsigned long		i;
+	int			error;
+
+	old_hash = libxfs_da_hashname(name, namelen);
+
+	if (fd >= 0) {
+		/*
+		 * User passed in a fd, so we'll use the xattr structure to
+		 * detect duplicate names.  First create the attribute that we
+		 * are passed in.
+		 */
+		snprintf(xattrname, MAXNAMELEN + 5, "user.%s", name);
+		error = fsetxattr(fd, xattrname, "1", 1, 0);
+		if (error)
+			return errno;
+	} else if (nr > 1) {
+		/*
+		 * Track every name we create so that we don't emit duplicates.
+		 */
+		error = dup_table_alloc(nr, &tab);
+		if (error)
+			return error;
+	}
+
+	for (i = 0; i < nr; i++) {
+		snprintf(xattrname, MAXNAMELEN + 5, "user.%s", name);
+		obfuscate_name(old_hash, namelen, xattrname + 5, false);
+		ASSERT(old_hash == libxfs_da_hashname(xattrname + 5, namelen));
+
+		if (fd >= 0) {
+			error = fsetxattr(fd, xattrname, "1", 1, 0);
+			if (error)
+				return errno;
+
+			/* don't print names to stdout */
+			continue;
+		} else if (tab) {
+			error = dup_table_store(tab, xattrname, namelen + 5);
+			if (error)
+				break;
+		}
+
+		printf("%s%c", xattrname, 0);
+	}
+
+	dup_table_free(tab);
+	return error;
+}
+
+static int
+hashcoll_f(
+	int		argc,
+	char		**argv)
+{
+	const char	*path = NULL;
+	bool		read_stdin = false;
+	bool		create_xattr = false;
+	unsigned long	nr = 1, seed = 0;
+	int		fd = -1;
+	int		c;
+	int		error;
+
+	while ((c = getopt(argc, argv, "ain:p:s:")) != EOF) {
+		switch (c) {
+		case 'a':
+			create_xattr = true;
+			break;
+		case 'i':
+			read_stdin = true;
+			break;
+		case 'n':
+			nr = strtoul(optarg, NULL, 10);
+			break;
+		case 'p':
+			path = optarg;
+			break;
+		case 's':
+			seed = strtoul(optarg, NULL, 10);
+			break;
+		default:
+			exitcode = 1;
+			hashcoll_help();
+			return 0;
+		}
+	}
+
+	if (path) {
+		int	oflags = O_RDWR;
+
+		if (!create_xattr)
+			oflags = O_RDONLY | O_DIRECTORY;
+
+		fd = open(path, oflags);
+		if (fd < 0) {
+			perror(path);
+			exitcode = 1;
+			return 0;
+		}
+	}
+
+	if (seed)
+		srandom(seed);
+
+	if (read_stdin) {
+		char	buf[MAXNAMELEN];
+		size_t	len;
+
+		len = fread(buf, 1, MAXNAMELEN - 1, stdin);
+
+		if (create_xattr)
+			error = collide_xattrs(nr, buf, len, fd);
+		else
+			error = collide_dirents(nr, buf, len, fd);
+		if (error) {
+			printf(_("hashcoll: %s\n"), strerror(error));
+			exitcode = 1;
+		}
+		goto done;
+	}
+
+	for (c = optind; c < argc; c++) {
+		size_t	len = strlen(argv[c]);
+
+		if (create_xattr)
+			error = collide_xattrs(nr, argv[c], len, fd);
+		else
+			error = collide_dirents(nr, argv[c], len, fd);
+		if (error) {
+			printf(_("hashcoll: %s\n"), strerror(error));
+			exitcode = 1;
+		}
+	}
+
+done:
+	if (fd >= 0)
+		close(fd);
+	return 0;
+}
+
+static cmdinfo_t	hashcoll_cmd = {
+	.name		= "hashcoll",
+	.cfunc		= hashcoll_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.args		= N_("[-a] [-s seed] [-n nr] [-p path] -i|names..."),
+	.oneline	= N_("create names that produce dahash collisions"),
+	.help		= hashcoll_help,
+};
+
 void
 hash_init(void)
 {
 	add_command(&hash_cmd);
+	add_command(&hashcoll_cmd);
 }
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 1a2bb7e98fb..fde1c5c6c69 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -768,6 +768,37 @@ Prints the hash value of
 .I string
 using the hash function of the XFS directory and attribute implementation.
 .TP
+.BI "hashcoll [-a] [-s seed] [-n " nr "] [-p " path "] -i | " names...
+Create directory entries or extended attributes names that all have the same
+hash value.
+The metadump name obfuscation algorithm is used here.
+Names are written to standard output, with a NULL between each name for use
+with xargs -0.
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.TP 0.4i
+.B \-a
+Create extended attribute names.
+.TP 0.4i
+.B \-i
+Read the first name to create from standard input.
+Up to 255 bytes are read.
+If this option is not specified, first names are taken from the command line.
+.TP 0.4i
+.BI \-n " nr"
+Create this many duplicated names.
+The default is to create one name.
+.TP 0.4i
+.BI \-p " path"
+Create directory entries or extended attributes in this file instead of
+writing the names to standard output.
+.TP 0.4i
+.BI \-s " seed"
+Seed the random number generator with this value.
+.PD
+.RE
+.TP
 .BI "help [" command ]
 Print help for one or all commands.
 .TP

