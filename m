Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E91D520D3
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 05:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730666AbfFYDCy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 23:02:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42028 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730665AbfFYDCy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 23:02:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5P2xQku183579
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Qcm49xuqYxuAQUvWYVAo0UTv82DSL+pfwwbLRVqh0aY=;
 b=q8KL1+HJ72FWpOp52Mmru75AZhicXggAQSttYFWHOYe4IRDHN6EMshdjMMgh6Ms2rPtK
 tdWaqmBCHeI9IPZTVin36xbPyMNlBGTpeQQP0dAZYKdNLUHwm59Kiceu4P6KU5c/VItQ
 D2lUidGZq6wGHcdbr5FrlKdx82p5ZXcN7/vvEdywDZxSVLEwI+R8v3jfkA3B5U1qLHoP
 8GFnXQo3IGysKfH63wozlUz+YB4yBp+sDmQ1dAtRe9bQZwnups3P2LdJRvILSRit6TlZ
 Hiljwo1FF7J087D7vLDhjZE1DBEyAof5HIiybYgTEYFBxUBi8ojgSFUm9zhJgwJqu0ph Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t9brt1ha7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5P31NIk163426
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tat7bys0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:52 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5P32qae016179
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 20:02:51 -0700
Subject: [PATCH 3/5] xfs: refactor attr scrub memory allocation function
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Jun 2019 20:02:51 -0700
Message-ID: <156143177110.2221192.12144130344450670626.stgit@magnolia>
In-Reply-To: <156143175282.2221192.3546713622107331271.stgit@magnolia>
References: <156143175282.2221192.3546713622107331271.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906250022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906250023
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the code that allocates memory buffers for the extended attribute
scrub code into a separate function so we can reduce memory allocations
in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/attr.c |   33 ++++++++++++++++++++++++---------
 fs/xfs/scrub/attr.h |    2 ++
 2 files changed, 26 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index fd16eb3fa003..c20b6da1db84 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -31,26 +31,41 @@
 #include <linux/posix_acl_xattr.h>
 #include <linux/xattr.h>
 
-/* Set us up to scrub an inode's extended attributes. */
+/* Allocate enough memory to hold an attr value and attr block bitmaps. */
 int
-xchk_setup_xattr(
+xchk_setup_xattr_buf(
 	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip)
+	size_t			value_size)
 {
 	size_t			sz;
 
 	/*
-	 * Allocate the buffer without the inode lock held.  We need enough
-	 * space to read every xattr value in the file or enough space to
-	 * hold three copies of the xattr free space bitmap.  (Not both at
-	 * the same time.)
+	 * We need enough space to read an xattr value from the file or enough
+	 * space to hold three copies of the xattr free space bitmap.  We don't
+	 * need the buffer space for both purposes at the same time.
 	 */
-	sz = max_t(size_t, XATTR_SIZE_MAX, 3 * sizeof(long) *
-			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize));
+	sz = 3 * sizeof(long) * BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
+	sz = max_t(size_t, sz, value_size);
+
 	sc->buf = kmem_zalloc_large(sz, KM_SLEEP);
 	if (!sc->buf)
 		return -ENOMEM;
 
+	return 0;
+}
+
+/* Set us up to scrub an inode's extended attributes. */
+int
+xchk_setup_xattr(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip)
+{
+	int			error;
+
+	error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX);
+	if (error)
+		return error;
+
 	return xchk_setup_inode_contents(sc, ip, 0);
 }
 
diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
index baa92f34f790..919adff24447 100644
--- a/fs/xfs/scrub/attr.h
+++ b/fs/xfs/scrub/attr.h
@@ -62,4 +62,6 @@ xchk_xattr_dstmap(
 			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
 }
 
+int xchk_setup_xattr_buf(struct xfs_scrub *sc, size_t value_size);
+
 #endif	/* __XFS_SCRUB_ATTR_H__ */

