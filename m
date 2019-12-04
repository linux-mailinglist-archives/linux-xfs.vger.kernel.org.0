Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A06011306F
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Dec 2019 18:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbfLDREm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Dec 2019 12:04:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35466 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728883AbfLDREm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Dec 2019 12:04:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB4H4XL1195486;
        Wed, 4 Dec 2019 17:04:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=6gt62kkPD3orwE60G7BPgXZBLdwbSZlpcjm6VJ7bNr4=;
 b=e1Pgfqsx8Knxc2m9aetyd0MVgIBXqTGqVquijaD/1DlMD6wQSZfwvvPVzWD+mUc96YQ2
 N7Zpokvfmkac3NLfbgpm34n35MssLTAnRHeWozBLR728/7z5LAVawg9XSdAkFiFxLUVJ
 elTvfdKo5b/Rkyg/r4pCWNHNhzqnccJvUph62nGJ22e7c9D2X+6X/yNKNUhoWuRiMlwX
 HmBdbTUDiRK1cJ8NYfSlshR9Hu95XclvpTjuh950rokFDLv34L+Wpy528Lqw4SbbzaHz
 ndzkEXEo+5nXh1NmN3fS03UnfubuhqsxIwteQ4eSUDTqd28+ZxVZTF6c++YhMmFnJzxY mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wkh2rfm26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 17:04:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB4GwrqQ040584;
        Wed, 4 Dec 2019 17:04:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2wnvr098w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 17:04:39 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB4H4ciE004941;
        Wed, 4 Dec 2019 17:04:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Dec 2019 09:04:38 -0800
Subject: [PATCH 2/6] mkfs: check root inode location
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Wed, 04 Dec 2019 09:04:35 -0800
Message-ID: <157547907575.974712.18261328888206083261.stgit@magnolia>
In-Reply-To: <157547906289.974712.8933333382010386076.stgit@magnolia>
References: <157547906289.974712.8933333382010386076.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9461 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912040137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9461 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912040138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure the root inode gets created where repair thinks it should be
created.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 +
 mkfs/xfs_mkfs.c          |   39 +++++++++++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 6 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 645c9b1b..f8e7d82d 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -156,5 +156,6 @@
 
 #define xfs_ag_init_headers		libxfs_ag_init_headers
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
+#define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
 
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 18338a61..71be033d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3521,6 +3521,38 @@ rewrite_secondary_superblocks(
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 }
 
+static void
+check_root_ino(
+	struct xfs_mount	*mp)
+{
+	xfs_ino_t		ino;
+
+	if (XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino) != 0) {
+		fprintf(stderr,
+			_("%s: root inode created in AG %u, not AG 0\n"),
+			progname, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino));
+		exit(1);
+	}
+
+	/*
+	 * The superblock points to the root directory inode, but xfs_repair
+	 * expects to find the root inode in a very specific location computed
+	 * from the filesystem geometry for an extra level of verification.
+	 *
+	 * Fail the format immediately if those assumptions ever break, because
+	 * repair will toss the root directory.
+	 */
+	ino = libxfs_ialloc_calc_rootino(mp, -1);
+	if (mp->m_sb.sb_rootino != ino) {
+		fprintf(stderr,
+	_("%s: root inode (%llu) not allocated in expected location (%llu)\n"),
+			progname,
+			(unsigned long long)mp->m_sb.sb_rootino,
+			(unsigned long long)ino);
+		exit(1);
+	}
+}
+
 int
 main(
 	int			argc,
@@ -3807,12 +3839,7 @@ main(
 	/*
 	 * Protect ourselves against possible stupidity
 	 */
-	if (XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino) != 0) {
-		fprintf(stderr,
-			_("%s: root inode created in AG %u, not AG 0\n"),
-			progname, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino));
-		exit(1);
-	}
+	check_root_ino(mp);
 
 	/*
 	 * Re-write multiple secondary superblocks with rootinode field set

