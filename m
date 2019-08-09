Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B269884DC
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbfHIViS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:38:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59318 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727910AbfHIViS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:38:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYSj7084525
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=BQdkRfR7XA5ybXiZTwxA+GZzQL2qLjg1xzj1gYK3j0E=;
 b=MBtaHnr3O5JuAR30omIAj5VQuPO9t1iYwrjo/6ogWpoG1ql1kxO3g2Qth4CE0Zqzc4bB
 cRfVFNsVqnyWM8VoCx5bygblh0shUghkxOJhYkM6mlKr1uowOf5jaX87AsqpIOcLFw83
 pAprGSEFJ7zop8mzlFvPzdEY7KzLV4UaoLgMV6irp8CAUKRj87OYWs0wE5OS2gdT6z58
 3ybgYqCbkLeVAUQN6qxvWZVAYmV38oRKjOXgF/bbtgi8QPl9XxzVQdCbkEszTfUFYG4+
 uTD1JzobCdyc2Twk62iNsJJ8jz/hcAUxLxkG6HB8YTiscRAx3S8N45UPey06Vr8fkiQ/ Yg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=BQdkRfR7XA5ybXiZTwxA+GZzQL2qLjg1xzj1gYK3j0E=;
 b=AXIdrYn0l69V4ScaNNrDg2jUGcbS/ne1bVEtyvp4aLh8WGzSRWgFTalhzmhbsZGrDCkY
 si5CPV2afPT7jBnl/w6/tTbOjsssOVeVByzvVuHE7gFeD7JMEs20M5+/P+yXWf8Hc0ZI
 BO6zSOGwrV+G5t/rZeD1g4wAh3lZS5/ftpcPqdcYOt4zuMWVwThMv4s50LD7ykYyT8sV
 ibJ6BY3cYE0QxF/vdxlP5psR0KYIMdVdlwjhWYfEZirq0mdHfAmsy1t85744bPvh4OYQ
 4yj5KwDN4Cgfk4R8PP7X9E+VcaqQ4oZ0Yd3Az9LZBvnX7d4oMc07RCNoH9zsBVu/wIEt 2g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u8hgpa7y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LNcwU067993
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2u90t814ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:16 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x79LcFmf010585
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:15 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:38:15 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 02/19] xfsprog: Replace attribute parameters with struct xfs_name
Date:   Fri,  9 Aug 2019 14:37:47 -0700
Message-Id: <20190809213804.32628-3-allison.henderson@oracle.com>
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

This patch replaces the attribute name, length and flags parameters with a
single struct xfs_name parameter.  This helps to clean up the numbers of
parameters being passed around and pre-simplifies the code some.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 db/attrset.c         | 14 ++++++++++----
 libxfs/libxfs_priv.h | 14 +++++---------
 libxfs/xfs_attr.c    | 40 ++++++++++++++++------------------------
 libxfs/xfs_attr.h    | 12 +++++-------
 4 files changed, 36 insertions(+), 44 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index dcedbb9..62d5448 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -69,6 +69,7 @@ attr_set_f(
 	xfs_inode_t	*ip = NULL;
 	char		*name, *value, *sp;
 	int		c, valuelen = 0, flags = 0;
+	struct xfs_name	namep;
 
 	if (cur_typ == NULL) {
 		dbprintf(_("no current type\n"));
@@ -146,8 +147,10 @@ attr_set_f(
 		goto out;
 	}
 
-	if (libxfs_attr_set(ip, (unsigned char *)name, strlen(name),
-				(unsigned char *)value, valuelen, flags)) {
+	namep.name = (unsigned char *)name;
+	namep.len = strlen(name);
+	namep.type = flags;
+	if (libxfs_attr_set(ip, &namep, (unsigned char *)value, valuelen)) {
 		dbprintf(_("failed to set attr %s on inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
 		goto out;
@@ -173,6 +176,7 @@ attr_remove_f(
 	xfs_inode_t	*ip = NULL;
 	char		*name;
 	int		c, flags = 0;
+	struct xfs_name	namep;
 
 	if (cur_typ == NULL) {
 		dbprintf(_("no current type\n"));
@@ -222,8 +226,10 @@ attr_remove_f(
 		goto out;
 	}
 
-	if (libxfs_attr_remove(ip, (unsigned char *)name,
-			       strlen(name), flags)) {
+	namep.name = (unsigned char *)name;
+	namep.len = strlen(name);
+	namep.type = flags;
+	if (libxfs_attr_remove(ip, &namep)) {
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
 		goto out;
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index ef82699..31fb406 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -613,15 +613,11 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 /* Keep static checkers quiet about nonstatic functions by exporting */
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
-int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int *valuelenp,
-		 int flags);
-int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int valuelen,
-		 int flags);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
-		    size_t namelen, int flags);
-
+int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
+		 unsigned char *value, int *valuelenp);
+int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
+		 unsigned char *value, int valuelen);
+int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name);
 int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
 		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
 int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index d730482..780cc0d 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -62,9 +62,7 @@ STATIC int
 xfs_attr_args_init(
 	struct xfs_da_args	*args,
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
-	int			flags)
+	struct xfs_name		*name)
 {
 
 	if (!name)
@@ -74,9 +72,9 @@ xfs_attr_args_init(
 	args->geo = dp->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
 	args->dp = dp;
-	args->flags = flags;
-	args->name = name;
-	args->namelen = namelen;
+	args->flags = name->type;
+	args->name = name->name;
+	args->namelen = name->len;
 	if (args->namelen >= MAXNAMELEN)
 		return -EFAULT;		/* match IRIX behaviour */
 
@@ -121,11 +119,9 @@ xfs_attr_get_ilocked(
 int
 xfs_attr_get(
 	struct xfs_inode	*ip,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	unsigned char		*value,
-	int			*valuelenp,
-	int			flags)
+	int			*valuelenp)
 {
 	struct xfs_da_args	args;
 	uint			lock_mode;
@@ -136,7 +132,7 @@ xfs_attr_get(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
+	error = xfs_attr_args_init(&args, ip, name);
 	if (error)
 		return error;
 
@@ -307,16 +303,14 @@ xfs_attr_remove_args(
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	unsigned char		*value,
-	int			valuelen,
-	int			flags)
+	int			valuelen)
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_args	args;
 	struct xfs_trans_res	tres;
-	int			rsvd = (flags & ATTR_ROOT) != 0;
+	int			rsvd = (name->type & ATTR_ROOT) != 0;
 	int			error, local;
 
 	XFS_STATS_INC(mp, xs_attr_set);
@@ -324,7 +318,7 @@ xfs_attr_set(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
+	error = xfs_attr_args_init(&args, dp, name);
 	if (error)
 		return error;
 
@@ -387,7 +381,7 @@ xfs_attr_set(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args.trans);
 
-	if ((flags & ATTR_KERNOTIME) == 0)
+	if ((name->type & ATTR_KERNOTIME) == 0)
 		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
 
 	/*
@@ -412,9 +406,7 @@ out_trans_cancel:
 int
 xfs_attr_remove(
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
-	int			flags)
+	struct xfs_name		*name)
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_args	args;
@@ -425,7 +417,7 @@ xfs_attr_remove(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
+	error = xfs_attr_args_init(&args, dp, name);
 	if (error)
 		return error;
 
@@ -446,7 +438,7 @@ xfs_attr_remove(
 	 */
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrrm,
 			XFS_ATTRRM_SPACE_RES(mp), 0,
-			(flags & ATTR_ROOT) ? XFS_TRANS_RESERVE : 0,
+			(name->type & ATTR_ROOT) ? XFS_TRANS_RESERVE : 0,
 			&args.trans);
 	if (error)
 		return error;
@@ -469,7 +461,7 @@ xfs_attr_remove(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args.trans);
 
-	if ((flags & ATTR_KERNOTIME) == 0)
+	if ((name->type & ATTR_KERNOTIME) == 0)
 		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
 
 	/*
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index e677fb0..764db97 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -136,14 +136,12 @@ int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
-int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int *valuelenp,
-		 int flags);
-int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int valuelen, int flags);
+int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
+		 unsigned char *value, int *valuelenp);
+int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
+		 unsigned char *value, int valuelen);
 int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
-		    size_t namelen, int flags);
+int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
-- 
2.7.4

