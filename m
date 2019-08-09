Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAFA884DA
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfHIViR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:38:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50216 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfHIViR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:38:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYfht071958
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=G4+YSYsSLjUbhScCf0fS+eLFs7mypafCCi1jO610Q64=;
 b=jwi33uWVnFvCaM01R1xRTQ4ypOx506AQkbrnfWWPnmdEHLcxtjnV3kxOn6svBUUr3eA9
 GVJOSMGWXaPY0umcsZUQdp2kn1lwlxZ0EKMGsVpYAblfrtPp8noT/9eOKRq+epMA455y
 0U4BJctjoH4KvIJYncMHDchUCwayAA8WgoDTfOnF8oH+tsDgWsuot52ulB4c50wymJku
 bT9PNW7n0hwzgUsoWMigS9VFLu1RyaHTN1HEpw23QWt0lmDSCDOiu52C9/VYWBgPozmp
 aYheedMeUD+JycnswnGOiNtCpp4vJFocsEOwCk/z/Q/WGnL86Tw1sODWN96Yna1ujhbj nw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=G4+YSYsSLjUbhScCf0fS+eLFs7mypafCCi1jO610Q64=;
 b=NQNjdtz2saGZgu+DfZybOZXXpelxIhqxgLBfh59cPTFadN4kznKW/RUbdBIP/UEQLgl3
 0sI9zVXMJuaeNpCkioDT66Y/1mBnAF2ajNz83ZrDpdhZtVcAkfToiD7tgDbEXxIWbCJ5
 BjbDhFCavmXBxiUk695jbTOL6lETiMsRl7cfhEPnleC94FdMm9K4nPlOl4rH5IG74yqz
 0XyaUYf3wpKo35Y3XC9EAV7+gAyDi29F/FtAEbkVVrzUR+SSPQ/ZyL+JXkZM82o6bE2U
 /IXppsO5XhRJMrF6HeziERjavvN2Fd+lS8Xv+/v7bZAWOkvTA6Tt1hQZCTGPlmRFhq81 WQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u8hpsa4y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LNS4c056351
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2u8pj9m4g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:15 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LcFrU019305
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:15 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:38:14 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 01/19] xfsprogs: Remove all strlen in all xfs_attr_* functions for attr names.
Date:   Fri,  9 Aug 2019 14:37:46 -0700
Message-Id: <20190809213804.32628-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190809213804.32628-1-allison.henderson@oracle.com>
References: <20190809213804.32628-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908090208
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This helps to pre-simplify the extra handling of the null terminator in
delayed operations which use memcpy rather than strlen.  Later
when we introduce parent pointers, attribute names will become binary,
so strlen will not work at all.  Removing uses of strlen now will
help reduce complexities later

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 db/attrset.c         |  5 +++--
 libxfs/libxfs_priv.h |  9 ++++++---
 libxfs/xfs_attr.c    | 12 ++++++++----
 libxfs/xfs_attr.h    |  8 +++++---
 4 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index 5697250..dcedbb9 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -146,7 +146,7 @@ attr_set_f(
 		goto out;
 	}
 
-	if (libxfs_attr_set(ip, (unsigned char *)name,
+	if (libxfs_attr_set(ip, (unsigned char *)name, strlen(name),
 				(unsigned char *)value, valuelen, flags)) {
 		dbprintf(_("failed to set attr %s on inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
@@ -222,7 +222,8 @@ attr_remove_f(
 		goto out;
 	}
 
-	if (libxfs_attr_remove(ip, (unsigned char *)name, flags)) {
+	if (libxfs_attr_remove(ip, (unsigned char *)name,
+			       strlen(name), flags)) {
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
 		goto out;
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index c014b28..ef82699 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -614,10 +614,13 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-                unsigned char *value, int *valuelenp, int flags);
+		 size_t namelen, unsigned char *value, int *valuelenp,
+		 int flags);
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-                 unsigned char *value, int valuelen, int flags);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
+		 size_t namelen, unsigned char *value, int valuelen,
+		 int flags);
+int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
+		    size_t namelen, int flags);
 
 int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
 		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 41956e5..d730482 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -63,6 +63,7 @@ xfs_attr_args_init(
 	struct xfs_da_args	*args,
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
+	size_t			namelen,
 	int			flags)
 {
 
@@ -75,7 +76,7 @@ xfs_attr_args_init(
 	args->dp = dp;
 	args->flags = flags;
 	args->name = name;
-	args->namelen = strlen((const char *)name);
+	args->namelen = namelen;
 	if (args->namelen >= MAXNAMELEN)
 		return -EFAULT;		/* match IRIX behaviour */
 
@@ -121,6 +122,7 @@ int
 xfs_attr_get(
 	struct xfs_inode	*ip,
 	const unsigned char	*name,
+	size_t			namelen,
 	unsigned char		*value,
 	int			*valuelenp,
 	int			flags)
@@ -134,7 +136,7 @@ xfs_attr_get(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, ip, name, flags);
+	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
 	if (error)
 		return error;
 
@@ -306,6 +308,7 @@ int
 xfs_attr_set(
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
+	size_t			namelen,
 	unsigned char		*value,
 	int			valuelen,
 	int			flags)
@@ -321,7 +324,7 @@ xfs_attr_set(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, flags);
+	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
 	if (error)
 		return error;
 
@@ -410,6 +413,7 @@ int
 xfs_attr_remove(
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
+	size_t			namelen,
 	int			flags)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -421,7 +425,7 @@ xfs_attr_remove(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, flags);
+	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 3b0dce0..e677fb0 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -137,11 +137,13 @@ int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 unsigned char *value, int *valuelenp, int flags);
+		 size_t namelen, unsigned char *value, int *valuelenp,
+		 int flags);
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 unsigned char *value, int valuelen, int flags);
+		 size_t namelen, unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
+int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
+		    size_t namelen, int flags);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
-- 
2.7.4

