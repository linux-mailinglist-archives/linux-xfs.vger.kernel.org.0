Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E25D1884FF
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbfHIVil (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:38:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50806 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbfHIVil (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:38:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYPlM071865
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=IOh6SCxVx7U1AVW5joIZZXxUMAAlMIp1cIDfxjggra4=;
 b=R1BvmodTQ7vYPpg1Ni8GtHSOMFMPV7P47wbW67Cmh90G3RROBCb+L7hJqoHDCbyqiuC8
 PNRAGabJmzwVoneZg+d+uKRWEDSlWa5bVupLiCfxSzeN07Sl7suqjfXo9g58z6c/JyRm
 jXrYsMYTLUxwm1iThRZ3fImbT8AZcOv0E8jqsjzFJ/3zdcKyek5S2b1EXbb4PaOxbYqr
 Cp/HmS9Ll/Uv9klE9AIsZK6uZkmGp7nm2dEKU6c3V7MZBXCkKKwJMVVIWn/++CK0VS/B
 RiHpbFL/obd5kGw7XYslbuYmz5N9tVtTXRY0c5jfXc8gbeJtmIo/YWa9FZvY5WjRqRpR bQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=IOh6SCxVx7U1AVW5joIZZXxUMAAlMIp1cIDfxjggra4=;
 b=IDSH3405RgiB92oUbX4xWP5pH0XiynwBZp8fa0vhOSKEM/Dl2fCZwG4qwKl4sflrlFo5
 oPogB/eUA4i+Z5iZ635XjzimUgLnzxXmmSuYBi8qv4fPKmLVnOVpgnHB5tYbdpyqBnJw
 UZcMrbHdlyQVHhcxWRNgVAoh30Sk220SfueR3Y2V/UfjLhiWIZKR7WWyNUNL8B4EJDPK
 XqwWfnQZo3eNGKv+IsV7oZ5gYPbVdhbJu0bSfxAaxgEf41IPugF2irvQqH7LCVTC3tbS
 2oSj9MjqOMe7m29SIkCPph5NCGjolvK/11EqqOEDRkS08zlyXT9X0MZEgc6lSz47MxyM 3g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u8hpsa506-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LcZiq097333
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2u8pj9m4k3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:39 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LcK0f002213
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:20 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:38:20 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 11/19] xfsprogs: Add xfs_attr3_leaf helper functions
Date:   Fri,  9 Aug 2019 14:37:56 -0700
Message-Id: <20190809213804.32628-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190809213804.32628-1-allison.henderson@oracle.com>
References: <20190809213804.32628-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090208
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

And new helper functions xfs_attr3_leaf_flag_is_set and
xfs_attr3_leaf_flagsflipped.  These routines check to see
if xfs_attr3_leaf_setflag or xfs_attr3_leaf_flipflags have
already been run.  We will need this later for delayed
attributes since routines may be recalled several times
when -EAGAIN is returned.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr_leaf.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_attr_leaf.h |  2 ++
 2 files changed, 80 insertions(+)

diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 524e37a..049c786 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -2728,6 +2728,34 @@ xfs_attr3_leaf_clearflag(
 }
 
 /*
+ * Check if the INCOMPLETE flag on an entry in a leaf block is set.
+ */
+int
+xfs_attr3_leaf_flag_is_set(
+	struct xfs_da_args		*args)
+{
+	struct xfs_attr_leafblock	*leaf;
+	struct xfs_attr_leaf_entry	*entry;
+	struct xfs_buf			*bp;
+	struct xfs_inode		*dp = args->dp;
+	int				error = 0;
+
+	trace_xfs_attr_leaf_setflag(args);
+
+	/*
+	 * Set up the operation.
+	 */
+	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno, -1, &bp);
+	if (error)
+		return error;
+
+	leaf = bp->b_addr;
+	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
+
+	return ((entry->flags & XFS_ATTR_INCOMPLETE) != 0);
+}
+
+/*
  * Set the INCOMPLETE flag on an entry in a leaf block.
  */
 int
@@ -2889,3 +2917,53 @@ xfs_attr3_leaf_flipflags(
 
 	return error;
 }
+
+/*
+ * On a leaf entry, check to see if the INCOMPLETE flag is cleared
+ * in args->blkno/index and set in args->blkno2/index2.
+ *
+ * Note that they could be in different blocks, or in the same block.
+ */
+int
+xfs_attr3_leaf_flagsflipped(
+	struct xfs_da_args		*args)
+{
+	struct xfs_attr_leafblock	*leaf1;
+	struct xfs_attr_leafblock	*leaf2;
+	struct xfs_attr_leaf_entry	*entry1;
+	struct xfs_attr_leaf_entry	*entry2;
+	struct xfs_buf			*bp1;
+	struct xfs_buf			*bp2;
+	struct xfs_inode		*dp = args->dp;
+	int				error = 0;
+
+	trace_xfs_attr_leaf_flipflags(args);
+
+	/*
+	 * Read the block containing the "old" attr
+	 */
+	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno, -1, &bp1);
+	if (error)
+		return error;
+
+	/*
+	 * Read the block containing the "new" attr, if it is different
+	 */
+	if (args->blkno2 != args->blkno) {
+		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno2,
+					   -1, &bp2);
+		if (error)
+			return error;
+	} else {
+		bp2 = bp1;
+	}
+
+	leaf1 = bp1->b_addr;
+	entry1 = &xfs_attr3_leaf_entryp(leaf1)[args->index];
+
+	leaf2 = bp2->b_addr;
+	entry2 = &xfs_attr3_leaf_entryp(leaf2)[args->index2];
+
+	return (((entry1->flags & XFS_ATTR_INCOMPLETE) == 0) &&
+		 (entry2->flags & XFS_ATTR_INCOMPLETE));
+}
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index be1f636..d6afe23 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -54,7 +54,9 @@ int	xfs_attr3_leaf_to_shortform(struct xfs_buf *bp,
 				   struct xfs_da_args *args, int forkoff);
 int	xfs_attr3_leaf_clearflag(struct xfs_da_args *args);
 int	xfs_attr3_leaf_setflag(struct xfs_da_args *args);
+int	xfs_attr3_leaf_flag_is_set(struct xfs_da_args *args);
 int	xfs_attr3_leaf_flipflags(struct xfs_da_args *args);
+int	xfs_attr3_leaf_flagsflipped(struct xfs_da_args *args);
 
 /*
  * Routines used for growing the Btree.
-- 
2.7.4

