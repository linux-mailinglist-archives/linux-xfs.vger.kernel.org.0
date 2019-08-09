Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A660884EF
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfHIVi2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:38:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56466 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728261AbfHIVi2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:38:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYWqm092774
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=xURqKnw2AYzfxDgonRr9LQ/sDi3OLcUYAZzffx4nSec=;
 b=DiXLxDdmacX/1rEwCoeABxOQ+zsLym9m4qhWNICOKJYVDvFHrXFS1HxnAMJ/W6xONT/O
 Crca4aH7o+CZz6PsHTzTv/gXaTIHZZCJtj5uBJNeE5FDh0mbLfgqDWttsC1Pin0bPayP
 9/NGsO9qkkjzgWS57w8bhxoHewrnvlvLrg+ebcEa/UTVLRdN3R8PY86VFlm6GUwBk9tO
 fYbJBzfErQykqKLicHqSBtIFH3dP47WHOc0zQvziVBDz8Y/wskPROewIuuxY20UqupR6
 AS3wDVdN4WpRKYnP/5kBI6imfad3dTTSNFH6rZHLJxnL1mtBsJTOi5xBR5FiEZ/2cOgO Ug== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=xURqKnw2AYzfxDgonRr9LQ/sDi3OLcUYAZzffx4nSec=;
 b=a6rdv0p8oPtcHqsaTE9CVSxSzFVvWpxUaJO6gfHYaCYnzJ+jx7bwWTWxR5k+KuonM9j8
 ucDNcul1qbZqDvVD11EO3dfSMDHMlORqFMwyWDpCOx5DL2t/3weM299tBzOBRfSBtdsf
 m/roHVt0xWtqMYZsT5nobCXLgR3REPYU/Csk/V4OsHqGpTNL3Coez9acbJRhXen9628L
 +jhGFx6nYm8rKhOMhq+UqV9vwd5eb3bB/D7to1V0oNwP7sw4Q1m0Nfd7P4Vho6O28X9K
 uAFFf0ngMtwcZlQrQi0WwBNOqBLbWL01z5KfBvU4aGNL/iKW0VXVvrnhEmrihBsZLh+M Tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2u8hasj9a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LcP8D110088
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2u90t814hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:25 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x79LcLh1005171
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:21 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:38:20 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 13/19] xfsprogs: Factor up trans roll in xfs_attr3_leaf_clearflag
Date:   Fri,  9 Aug 2019 14:37:58 -0700
Message-Id: <20190809213804.32628-14-allison.henderson@oracle.com>
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

New delayed allocation routines cannot be handling
transactions so factor them up into the calling functions

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c      | 12 ++++++++++++
 libxfs/xfs_attr_leaf.c |  5 +----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 8e63377..8e8d058 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -824,6 +824,12 @@ xfs_attr_leaf_addname(struct xfs_da_args	*args)
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
@@ -1181,6 +1187,12 @@ restart:
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
 
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 049c786..c3e064a 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -2721,10 +2721,7 @@ xfs_attr3_leaf_clearflag(
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

