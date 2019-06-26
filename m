Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E95D57304
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 22:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfFZUq4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 16:46:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51550 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfFZUqz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:46:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKi4oG018479
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=A3/TeDYfSK825Dw8jDhCJzJGVidWXUceE66hodq76gs=;
 b=GHWizxb+bVZK2oiVqPhZq+VDVPRPG4gGGMej0qgjjMFHcvYX5sxBVU6zqEzOOwgGDAkt
 MZPA6vYbRQm8NcfJKYyNNNU5CWxDS2dQLbp+xewav2ODqidirBcwGlKBZlP7378d/zf3
 1p4tTmZ9bZ35iHG6lkTZIaS51C7LGjHqQExrRQf9sxHKrnWFlDWuvLRId6Gz9vWn8qtl
 FsSzey3uftjXnNSe8KsGIm75+xo9RCLBTRDNv1B0iSzZFgIKtuImtHWU8zsxNHQcxDX5
 K1YLtnk/HaJcQl9PXTq431t2AhIlg8NQ+qvp9rDOmBktkKzsGMbOLWXxBVcm76Mcg4QS YA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t9cyqmh60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKjRlX069136
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2tat7d1h47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:53 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5QKkrng005177
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 13:46:52 -0700
Subject: [PATCH 3/6] xfs: refactor extended attribute buffer pointer
 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 26 Jun 2019 13:46:52 -0700
Message-ID: <156158201207.495944.13195054394247388623.stgit@magnolia>
In-Reply-To: <156158199378.495944.4088787757066517679.stgit@magnolia>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260240
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260240
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the open-coded attribute buffer pointer calculations with helper
functions to make it more obvious what we're doing with our freeform
memory allocation w.r.t. either storing xattr values or computing btree
block free space.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/attr.c |   15 +++++-------
 fs/xfs/scrub/attr.h |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+), 8 deletions(-)
 create mode 100644 fs/xfs/scrub/attr.h


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index f0fd26abd39d..fd16eb3fa003 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -26,6 +26,7 @@
 #include "scrub/common.h"
 #include "scrub/dabtree.h"
 #include "scrub/trace.h"
+#include "scrub/attr.h"
 
 #include <linux/posix_acl_xattr.h>
 #include <linux/xattr.h>
@@ -111,7 +112,7 @@ xchk_xattr_listent(
 	args.namelen = namelen;
 	args.hashval = xfs_da_hashname(args.name, args.namelen);
 	args.trans = context->tp;
-	args.value = sx->sc->buf;
+	args.value = xchk_xattr_valuebuf(sx->sc);
 	args.valuelen = XATTR_SIZE_MAX;
 
 	error = xfs_attr_get_ilocked(context->dp, &args);
@@ -170,13 +171,12 @@ xchk_xattr_check_freemap(
 	unsigned long			*map,
 	struct xfs_attr3_icleaf_hdr	*leafhdr)
 {
-	unsigned long			*freemap;
-	unsigned long			*dstmap;
+	unsigned long			*freemap = xchk_xattr_freemap(sc);
+	unsigned long			*dstmap = xchk_xattr_dstmap(sc);
 	unsigned int			mapsize = sc->mp->m_attr_geo->blksize;
 	int				i;
 
 	/* Construct bitmap of freemap contents. */
-	freemap = (unsigned long *)sc->buf + BITS_TO_LONGS(mapsize);
 	bitmap_zero(freemap, mapsize);
 	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
 		if (!xchk_xattr_set_map(sc, freemap,
@@ -186,7 +186,6 @@ xchk_xattr_check_freemap(
 	}
 
 	/* Look for bits that are set in freemap and are marked in use. */
-	dstmap = freemap + BITS_TO_LONGS(mapsize);
 	return bitmap_and(dstmap, freemap, map, mapsize) == 0;
 }
 
@@ -201,13 +200,13 @@ xchk_xattr_entry(
 	char				*buf_end,
 	struct xfs_attr_leafblock	*leaf,
 	struct xfs_attr3_icleaf_hdr	*leafhdr,
-	unsigned long			*usedmap,
 	struct xfs_attr_leaf_entry	*ent,
 	int				idx,
 	unsigned int			*usedbytes,
 	__u32				*last_hashval)
 {
 	struct xfs_mount		*mp = ds->state->mp;
+	unsigned long			*usedmap = xchk_xattr_usedmap(ds->sc);
 	char				*name_end;
 	struct xfs_attr_leaf_name_local	*lentry;
 	struct xfs_attr_leaf_name_remote *rentry;
@@ -267,7 +266,7 @@ xchk_xattr_block(
 	struct xfs_attr_leafblock	*leaf = bp->b_addr;
 	struct xfs_attr_leaf_entry	*ent;
 	struct xfs_attr_leaf_entry	*entries;
-	unsigned long			*usedmap = ds->sc->buf;
+	unsigned long			*usedmap = xchk_xattr_usedmap(ds->sc);
 	char				*buf_end;
 	size_t				off;
 	__u32				last_hashval = 0;
@@ -324,7 +323,7 @@ xchk_xattr_block(
 
 		/* Check the entry and nameval. */
 		xchk_xattr_entry(ds, level, buf_end, leaf, &leafhdr,
-				usedmap, ent, i, &usedbytes, &last_hashval);
+				ent, i, &usedbytes, &last_hashval);
 
 		if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 			goto out;
diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
new file mode 100644
index 000000000000..88bb5e29c60c
--- /dev/null
+++ b/fs/xfs/scrub/attr.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_SCRUB_ATTR_H__
+#define __XFS_SCRUB_ATTR_H__
+
+/*
+ * Temporary storage for online scrub and repair of extended attributes.
+ */
+struct xchk_xattr_buf {
+	/*
+	 * Memory buffer -- either used for extracting attr values while
+	 * walking the attributes; or for computing attr block bitmaps when
+	 * checking the attribute tree.
+	 *
+	 * Each bitmap contains enough bits to track every byte in an attr
+	 * block (rounded up to the size of an unsigned long).  The attr block
+	 * used space bitmap starts at the beginning of the buffer; the free
+	 * space bitmap follows immediately after; and we have a third buffer
+	 * for storing intermediate bitmap results.
+	 */
+	uint8_t			buf[0];
+};
+
+/* A place to store attribute values. */
+static inline uint8_t *
+xchk_xattr_valuebuf(
+	struct xfs_scrub	*sc)
+{
+	struct xchk_xattr_buf	*ab = sc->buf;
+
+	return ab->buf;
+}
+
+/* A bitmap of space usage computed by walking an attr leaf block. */
+static inline unsigned long *
+xchk_xattr_usedmap(
+	struct xfs_scrub	*sc)
+{
+	struct xchk_xattr_buf	*ab = sc->buf;
+
+	return (unsigned long *)ab->buf;
+}
+
+/* A bitmap of free space computed by walking attr leaf block free info. */
+static inline unsigned long *
+xchk_xattr_freemap(
+	struct xfs_scrub	*sc)
+{
+	return xchk_xattr_usedmap(sc) +
+			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
+}
+
+/* A bitmap used to hold temporary results. */
+static inline unsigned long *
+xchk_xattr_dstmap(
+	struct xfs_scrub	*sc)
+{
+	return xchk_xattr_freemap(sc) +
+			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
+}
+
+#endif	/* __XFS_SCRUB_ATTR_H__ */

