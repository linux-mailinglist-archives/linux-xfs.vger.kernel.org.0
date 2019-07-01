Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFC9F57305
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 22:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfFZUrB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 16:47:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51646 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfFZUrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:47:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKi6xi018490
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:47:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=S50tDyqLUkQjEVg2HmJz2p2kFBrysjguFVOYvgSeK+M=;
 b=MoHRSeJuyIfjY15vJyuiH3Z1tSX0rTPd3gNoV2lYkFYP19XxLMVx4SCw6neufDfV1v2h
 BvJ5pExlDRDYyWmi+yvOg6csx3D9S78IVvsidf2v1VQoaOrmUUd2cxZlsJ5xippV7eON
 KxNjqGuPJcp/CWJoY+07YFbenaJ5yesrT58jTtmUbMC0zn/+3XTHP9TIrBTiXIsME+4A
 ebuRILDkyFEUlT0BFFKXDnNRMepI30p2+K7RPWGhfm10HkAtT6jzOmSiavDvwljfeRWC
 JyoVU597ui9EPCPJ4dx+7dvWOBnDYFyor6G8Xjmd88r+CThSLkoD6rAhE4bYQHDawicM WQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2t9cyqmh6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:47:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKk9Ld016685
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2t99f4nwfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:59 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5QKkxHL004315
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 13:46:58 -0700
Subject: [PATCH 4/6] xfs: refactor attr scrub memory allocation function
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 26 Jun 2019 13:46:58 -0700
Message-ID: <156158201810.495944.4418480612524937333.stgit@magnolia>
In-Reply-To: <156158199378.495944.4088787757066517679.stgit@magnolia>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260240
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260240
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
index 88bb5e29c60c..27e879aeaafc 100644
--- a/fs/xfs/scrub/attr.h
+++ b/fs/xfs/scrub/attr.h
@@ -62,4 +62,6 @@ xchk_xattr_dstmap(
 			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
 }
 
+int xchk_setup_xattr_buf(struct xfs_scrub *sc, size_t value_size);
+
 #endif	/* __XFS_SCRUB_ATTR_H__ */

