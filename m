Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5E2D4D431
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 18:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfFTQuw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 12:50:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43614 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFTQuw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:50:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGnd0c078099;
        Thu, 20 Jun 2019 16:50:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=BO+yJGT/Ybpuh8IFhvGtNeFt7Q4yDOgTFhunsPY8j4s=;
 b=4wlY/48Xq2FTdA7LZdOXVfoAbJot76clqXBib/CKhQGYhsSRh4lxVk/aDKpfmJrPShzI
 ZZfAN+GheCASybBV2LqQJxs7JYhorp7gp2dHALK07t/cgPrp4kfj2WZwrWi6QnGeTKO1
 Y98cljOQil1+vtmoHzzrYWs1FB7eY19DRlVIdTutnebkB3Mf4CPa4rUX0XwNgMXQ62Kt
 9wxcsB+yONFwo+fir/668kZIaq8EUQm3r7/uROLjT2dG8njl1s0aP4ZecOVBRW4bYDgc
 JPZnHUGFK5vzZZsc7iHxJW3ECgDFF0z0hHI9y0TbsdEaZQZOy+lXF/fVvKGjZOfN9bH+ Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2t7809j8pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:50:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGnItk182250;
        Thu, 20 Jun 2019 16:50:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2t7rdx930j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:50:48 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5KGomlx020283;
        Thu, 20 Jun 2019 16:50:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 09:50:47 -0700
Subject: [PATCH 12/12] xfs_db: add a function to compute btree geometry
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 20 Jun 2019 09:50:46 -0700
Message-ID: <156104944679.1172531.1206025865676357729.stgit@magnolia>
In-Reply-To: <156104936953.1172531.2121427277342917243.stgit@magnolia>
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906200122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906200122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new command to xfs_db that uses a btree type and a record count
to report the best and worst case height and level size.  This can be
used to estimate how overhead a metadata index will add to a filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/Makefile              |    2 
 db/btheight.c            |  307 ++++++++++++++++++++++++++++++++++++++++++++++
 db/command.c             |    1 
 db/command.h             |    1 
 libxfs/libxfs_api_defs.h |    2 
 5 files changed, 312 insertions(+), 1 deletion(-)
 create mode 100644 db/btheight.c


diff --git a/db/Makefile b/db/Makefile
index 8fecfc1c..ceedbebd 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -14,7 +14,7 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
 	sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h \
 	fuzz.h
-CFILES = $(HFILES:.h=.c) btdump.c info.c
+CFILES = $(HFILES:.h=.c) btdump.c btheight.c info.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
diff --git a/db/btheight.c b/db/btheight.c
new file mode 100644
index 00000000..df11b347
--- /dev/null
+++ b/db/btheight.c
@@ -0,0 +1,307 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "libxfs.h"
+#include "command.h"
+#include "output.h"
+#include "init.h"
+#include "io.h"
+#include "type.h"
+#include "input.h"
+#include "../include/convert.h"
+
+static int refc_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
+{
+	return libxfs_refcountbt_maxrecs(blocklen, leaf != 0);
+}
+
+static int rmap_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
+{
+	return libxfs_rmapbt_maxrecs(blocklen, leaf);
+}
+
+struct btmap {
+	const char	*tag;
+	int		(*maxrecs)(struct xfs_mount *mp, int blocklen,
+				   int leaf);
+} maps[] = {
+	{"bnobt", libxfs_allocbt_maxrecs},
+	{"cntbt", libxfs_allocbt_maxrecs},
+	{"inobt", libxfs_inobt_maxrecs},
+	{"finobt", libxfs_inobt_maxrecs},
+	{"bmapbt", libxfs_bmbt_maxrecs},
+	{"refcountbt", refc_maxrecs},
+	{"rmapbt", rmap_maxrecs},
+};
+
+static void
+btheight_help(void)
+{
+	struct btmap	*m;
+	int		i;
+
+	dbprintf(_(
+"\n"
+" For a given number of btree records and a btree type, report the number of\n"
+" records and blocks for each level of the btree, and the total btree size.\n"
+" The btree type must be given after the options.  A raw btree geometry can\n"
+" be provided in the format \"record_bytes:key_bytes:ptr_bytes:header_type\"\n"
+" where header_type is one of \"short\", \"long\", \"shortcrc\", or \"longcrc\".\n"
+"\n"
+" Options:\n"
+"   -b -- Override the btree block size.\n"
+"   -n -- Number of records we want to store.\n"
+"   -w max -- Show only the best case scenario.\n"
+"   -w min -- Show only the worst case scenario.\n"
+"\n"
+" Supported btree types:\n"
+"   "
+));
+	for (i = 0, m = maps; i < ARRAY_SIZE(maps); i++, m++)
+		printf("%s ", m->tag);
+	printf("\n");
+}
+
+static void
+calc_height(
+	unsigned long long	nr_records,
+	uint			*records_per_block)
+{
+	unsigned int		level = 0;
+	unsigned long long	total_blocks = 0;
+	unsigned long long	blocks;
+	char			*levels_suffix = "s";
+	char			*totblocks_suffix = "s";
+
+	while (nr_records) {
+		unsigned int	level_rpb = records_per_block[level != 0];
+		char		*recs_suffix = "s";
+		char		*blocks_suffix = "s";
+
+		blocks = (nr_records + level_rpb - 1) / level_rpb;
+
+		if (nr_records == 1)
+			recs_suffix = "";
+		if (blocks == 1)
+			blocks_suffix = "";
+
+		printf(_("level %u: %llu record%s, %llu block%s\n"),
+				level, nr_records, recs_suffix, blocks,
+				blocks_suffix);
+
+		total_blocks += blocks;
+		nr_records = blocks == 1 ? 0 : blocks;
+		level++;
+	}
+
+	if (level == 1)
+		levels_suffix = "";
+	if (total_blocks == 1)
+		totblocks_suffix = "";
+
+	printf(_("%u level%s, %llu block%s total\n"), level, levels_suffix,
+			total_blocks, totblocks_suffix);
+}
+
+static int
+construct_records_per_block(
+	char		*tag,
+	int		blocksize,
+	unsigned int	*records_per_block)
+{
+	char		*toktag;
+	struct btmap	*m;
+	unsigned int	record_size, key_size, ptr_size;
+	char		*p;
+	int		i, ret;
+
+	for (i = 0, m = maps; i < ARRAY_SIZE(maps); i++, m++) {
+		if (!strcmp(m->tag, tag)) {
+			records_per_block[0] = m->maxrecs(mp, blocksize, 1);
+			records_per_block[1] = m->maxrecs(mp, blocksize, 0);
+			return 0;
+		}
+	}
+
+	toktag = strdup(tag);
+	ret = -1;
+
+	p = strtok(toktag, ":");
+	if (!p) {
+		fprintf(stderr, _("%s: record size not found.\n"), tag);
+		goto out;
+	}
+	record_size = cvt_u16(p, 0);
+	if (errno) {
+		perror(p);
+		goto out;
+	}
+
+	p = strtok(NULL, ":");
+	if (!p) {
+		fprintf(stderr, _("%s: key size not found.\n"), tag);
+		goto out;
+	}
+	key_size = cvt_u16(p, 0);
+	if (errno) {
+		perror(p);
+		goto out;
+	}
+
+	p = strtok(NULL, ":");
+	if (!p) {
+		fprintf(stderr, _("%s: pointer size not found.\n"), tag);
+		goto out;
+	}
+	ptr_size = cvt_u16(p, 0);
+	if (errno) {
+		perror(p);
+		goto out;
+	}
+
+	p = strtok(NULL, ":");
+	if (!p) {
+		fprintf(stderr, _("%s: header type not found.\n"), tag);
+		goto out;
+	}
+	if (!strcmp(p, "short"))
+		blocksize -= XFS_BTREE_SBLOCK_LEN;
+	else if (!strcmp(p, "shortcrc"))
+		blocksize -= XFS_BTREE_SBLOCK_CRC_LEN;
+	else if (!strcmp(p, "long"))
+		blocksize -= XFS_BTREE_LBLOCK_LEN;
+	else if (!strcmp(p, "longcrc"))
+		blocksize -= XFS_BTREE_LBLOCK_CRC_LEN;
+	else {
+		fprintf(stderr, _("%s: unrecognized btree header type."),
+				p);
+		goto out;
+	}
+
+	p = strtok(NULL, ":");
+	if (p) {
+		fprintf(stderr,
+			_("%s: unrecognized raw btree geometry."),
+				tag);
+		goto out;
+	}
+
+	records_per_block[0] = blocksize / record_size;
+	records_per_block[1] = blocksize / (key_size + ptr_size);
+	ret = 0;
+out:
+	free(toktag);
+	return ret;
+}
+
+#define REPORT_DEFAULT	(-1U)
+#define REPORT_MAX	(1 << 0)
+#define REPORT_MIN	(1 << 1)
+
+static void
+report(
+	char			*tag,
+	unsigned int		report_what,
+	unsigned long long	nr_records,
+	unsigned int		blocksize)
+{
+	unsigned int		records_per_block[2];
+	int			ret;
+
+	ret = construct_records_per_block(tag, blocksize, records_per_block);
+	if (ret) {
+		printf(_("%s: Unable to determine records per block.\n"),
+				tag);
+		return;
+	}
+
+	if (report_what & REPORT_MAX) {
+		printf(
+_("%s: best case per %u-byte block: %u records (leaf) / %u keyptrs (node)\n"),
+				tag, blocksize, records_per_block[0],
+				records_per_block[1]);
+
+		calc_height(nr_records, records_per_block);
+	}
+
+	if (report_what & REPORT_MIN) {
+		records_per_block[0] /= 2;
+		records_per_block[1] /= 2;
+
+		printf(
+_("%s: worst case per %u-byte block: %u records (leaf) / %u keyptrs (node)\n"),
+				tag, blocksize, records_per_block[0],
+				records_per_block[1]);
+
+		calc_height(nr_records, records_per_block);
+	}
+}
+
+static int
+btheight_f(
+	int		argc,
+	char		**argv)
+{
+	long long	blocksize = mp->m_sb.sb_blocksize;
+	uint64_t	nr_records = 0;
+	int		report_what = REPORT_DEFAULT;
+	int		i, c;
+
+	while ((c = getopt(argc, argv, "b:n:w:")) != -1) {
+		switch (c) {
+		case 'b':
+			errno = 0;
+			blocksize = cvtnum(mp->m_sb.sb_blocksize,
+					mp->m_sb.sb_sectsize,
+					optarg);
+			if (errno) {
+				perror(optarg);
+				return 0;
+			}
+			break;
+		case 'n':
+			nr_records = cvt_u64(optarg, 0);
+			if (errno) {
+				perror(optarg);
+				return 0;
+			}
+			break;
+		case 'w':
+			if (!strcmp(optarg, "min"))
+				report_what = REPORT_MIN;
+			else if (!strcmp(optarg, "max"))
+				report_what = REPORT_MAX;
+			else {
+				btheight_help();
+				return 0;
+			}
+			break;
+		default:
+			btheight_help();
+			return 0;
+		}
+	}
+
+	if (argc == optind || blocksize <= 0 || blocksize > INT_MAX ||
+	    nr_records == 0) {
+		btheight_help();
+		return 0;
+	}
+
+	for (i = optind; i < argc; i++)
+		report(argv[i], report_what, nr_records, blocksize);
+
+	return 0;
+}
+
+static const cmdinfo_t btheight_cmd =
+	{ "btheight", "b", btheight_f, 1, -1, 0, "[-a] [-i]",
+	  N_("compute btree heights"), btheight_help };
+
+void
+btheight_init(void)
+{
+	add_command(&btheight_cmd);
+}
diff --git a/db/command.c b/db/command.c
index c7c52342..cb9012c2 100644
--- a/db/command.c
+++ b/db/command.c
@@ -114,6 +114,7 @@ init_commands(void)
 	block_init();
 	bmap_init();
 	btdump_init();
+	btheight_init();
 	check_init();
 	convert_init();
 	crc_init();
diff --git a/db/command.h b/db/command.h
index eacfd465..d7c5bbd4 100644
--- a/db/command.h
+++ b/db/command.h
@@ -30,3 +30,4 @@ extern void		init_commands(void);
 
 extern void		btdump_init(void);
 extern void		info_init(void);
+extern void		btheight_init(void);
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 71a7ef53..fff160ef 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -124,6 +124,8 @@
 #define xfs_dir_ino_validate		libxfs_dir_ino_validate
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
 #define xfs_inobt_maxrecs		libxfs_inobt_maxrecs
+#define xfs_rmapbt_maxrecs		libxfs_rmapbt_maxrecs
+#define xfs_refcountbt_maxrecs		libxfs_refcountbt_maxrecs
 #define xfs_iread_extents		libxfs_iread_extents
 #define xfs_log_calc_minimum_size	libxfs_log_calc_minimum_size
 #define xfs_perag_get			libxfs_perag_get

