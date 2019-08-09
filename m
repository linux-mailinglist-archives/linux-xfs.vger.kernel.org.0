Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7E4A884CB
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfHIVhr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:37:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55580 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728188AbfHIVhq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:37:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LZavH093683
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=mc3KN1iwBp3jK/08dhmWtzFOEOBAxlMF7ckvMJPMGnE=;
 b=P4nr3BuVtzkxTtMJi9BAcAPxRux18STOOdmIfmfeYpxXFW1UryiHE9XkN/9pckwvGfIR
 flS5z/rciB0DYoejyCo4Q7BCd4WoiYcR1IbnXRPjqgHC82oDdbzqtsQGRQJhXB7QZrbw
 nPx8CqRWlUBG1vUxRI0s1PeylV8afABkYKhQhPlN0RHSclKHkysGHpPypcVPjQky8ezG
 svfQ82DbUUoYt9R0J/6AkmC5SxrzYmUJ8eJeYmHbpNoV7PxqW8WMcV86twPWmr2ge5rx
 Bjn1ApNgVBoHwsL0f5U63ZuiE9Y6ZVb00RumK+ORJYwzllUF2koPq+rHVPDyiQh1TJQ0 cw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=mc3KN1iwBp3jK/08dhmWtzFOEOBAxlMF7ckvMJPMGnE=;
 b=wvk6gPd+Q5hlcIj4qDolNDP5aeSoYuvE6o6oLPvWynBba85CzGsQ6dDbWukA9IZdflwz
 //sKiWOF9tp1io0xBcLsDLheiylJrvSJcAyyIlmANhAMembfgIwnG57UeH8FZHsNQ7kK
 8cRJVkda1RK6aYuE8R5wnhKPeUkPoD1rApLN7fy6LCggA/R1nVM9x3OuVMGDg12eAjDj
 CaihzhzfoIRwBGKfzBe8X1UNam3Iev8yZ3cGeC48igNktckpuElcKnziRIeOyqnFBepJ
 /rjQ4avEWPxN10edz6ESd3JVjVo88/NzGaqMzdEig2tdU0FbJqjX+YObyccLFs4SroBy Hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2u8hasj982-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LNTb8056360
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2u8pj9m41r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:44 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x79LbhIo010361
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:43 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:37:36 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 13/18] xfs: Factor up trans roll in xfs_attr3_leaf_clearflag
Date:   Fri,  9 Aug 2019 14:37:21 -0700
Message-Id: <20190809213726.32336-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190809213726.32336-1-allison.henderson@oracle.com>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
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

New delayed allocation routines cannot be handling
transactions so factor them up into the calling functions

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 12 ++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c |  5 +----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 7648ceb..ca57202 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -823,6 +823,12 @@ xfs_attr_leaf_addname(struct xfs_da_args	*args)
 		 * Added a "remote" value, just clear the incomplete flag.
 		 */
 		error = xfs_attr3_leaf_clearflag(args);
+
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
 	}
 	return error;
 }
@@ -1180,6 +1186,12 @@ xfs_attr_node_addname(
 		error = xfs_attr3_leaf_clearflag(args);
 		if (error)
 			goto out;
+
+		 /*
+		  * Commit the flag value change and start the next trans in
+		  * series.
+		  */
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
 	}
 	retval = error = 0;
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index b2d5f62..e3604b9 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2722,10 +2722,7 @@ xfs_attr3_leaf_clearflag(
 			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
 	}
 
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	return xfs_trans_roll_inode(&args->trans, args->dp);
+	return error;
 }
 
 /*
-- 
2.7.4

