Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B61829E22F
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Oct 2020 03:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgJ1VhD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Oct 2020 17:37:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46328 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgJ1Vg6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:36:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09S19u5x170416
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 01:10:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=dMEyMUSIW2K+KlaaW8RYL84IRpYtJbo0iljZ2E8Y72s=;
 b=fWBAXZCCVT5i0X2SuO7xhs5TrVI2K4SIG5IEs9NuYdADXgKJiO3+Qt/3gP80tDq9LViC
 U3ZXbaItMz2lp0VMSwyMb5SXJnCHD7LqZlYMxtFeSWtwJS/VMdSKqPZgohkOLxZEMvXc
 eKlhtjzoyjFivYFPEFDdJAMaOUOLPPqxSxm8TTw2Acb2z88f/aS8mRElRNeQuVpQo1Qp
 OsN+EJ9V8bLjZq40kJLBtgxHOPXDjVSBtheJvH9GHB1yxWCtDSV5ivGrrmBn1gQuRTkK
 ezoXykXZPxh5LebLHQJ9nGSAqw83nUXfXEDsLhVGdUw2H2vLqg02xpWO9Odmtaec7Rsi 0g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7kvxac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 01:10:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09S15MhH007783
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 01:10:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34cx6wmnwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 01:10:20 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09S1AJ6e015739
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 01:10:19 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 18:10:19 -0700
Subject: [PATCH 1/2] design: document the new inode btree counter feature
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 27 Oct 2020 18:10:18 -0700
Message-ID: <160384741848.1365004.5354796889293226533.stgit@magnolia>
In-Reply-To: <160384741244.1365004.6341029408891306870.stgit@magnolia>
References: <160384741244.1365004.6341029408891306870.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010280002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=3
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280002
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Update the ondisk format documentation to discuss the inode btree
counter feature.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../allocation_groups.asciidoc                     |   21 ++++++++++++++++++++
 1 file changed, 21 insertions(+)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 992615d..2e78f56 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -405,6 +405,13 @@ reference counts of AG blocks.  This enables files to share data blocks safely.
 See the section about xref:Reflink_Deduplication[reflink and deduplication] for
 more details.
 
+| +XFS_SB_FEAT_RO_COMPAT_INOBTCNT+ |
+Inode B+tree block counters.  Each allocation group's inode (AGI) header
+tracks the number of blocks in each of the inode B+trees.  This allows us
+to have a slightly higher level of redundancy over the shape of the inode
+btrees, and decreases the amount of time to compute the metadata B+tree
+preallocations at mount time.
+
 |=====
 
 *sb_features_incompat*::
@@ -928,6 +935,10 @@ struct xfs_agi {
 
      __be32              agi_free_root;
      __be32              agi_free_level;
+
+     __be32              agi_iblocks;
+     __be32              agi_fblocks;
+
 }
 ----
 *agi_magicnum*::
@@ -984,6 +995,16 @@ B+tree.
 *agi_free_level*::
 Specifies the number of levels in the free inode B+tree.
 
+*agi_iblocks*::
+The number of blocks in the inode B+tree, including the root.
+This field is zero if the +XFS_SB_FEAT_RO_COMPAT_INOBTCNT+ feature is not
+enabled.
+
+*agi_fblocks*::
+The number of blocks in the free inode B+tree, including the root.
+This field is zero if the +XFS_SB_FEAT_RO_COMPAT_INOBTCNT+ feature is not
+enabled.
+
 [[Inode_Btrees]]
 == Inode B+trees
 

