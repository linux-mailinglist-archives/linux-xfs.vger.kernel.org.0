Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6E1B2E82E
	for <lists+linux-xfs@lfdr.de>; Thu, 30 May 2019 00:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbfE2W1J (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 May 2019 18:27:09 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36524 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfE2W1I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 18:27:08 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TM40xj041560
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=S4Mt6ha56eeYo4OT3O7XlM+woF6oHnhnL91Yer0vYjI=;
 b=R4X5AWh5Xlo1PxnxZe6//mZ4sA5OCwkgljhrsm8ncCQ7+gtu0IhGm9S+hh5c8K3VP0pj
 QQpy2HTo+OOSJRuNGhj6wLDN6B+xUnuGxLbLhUCYXwI1cBNF5nuyrVrbRxSto+XcWEUJ
 SjK2nhvWG8M+I0L3YTw+AevonpjUwQKCnsLayEAAqPqsQbpPnvKyPH9Orbjl7OVwinNK
 Uc7FcJqunki9sltwiUNONkd9O7K+Mn4SdxFUTOqKTFlE2mmtTIjPgCkLNmvDtkbM8iUf
 dtlnXKAu1MmpmSsVCvZDZI+XD/KE7Ncyz1n5xp4kTVNv7skQzHF3DTO+poaXzYS8PJDN cQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2spu7dn16m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TMQ20T164430
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2sr31vh8uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:06 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4TMR5S4013979
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 May 2019 15:27:05 -0700
Subject: [PATCH 08/11] xfs: clean up long conditionals in xfs_iwalk_ichunk_ra
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 May 2019 15:27:04 -0700
Message-ID: <155916882448.757870.7872177617055446316.stgit@magnolia>
In-Reply-To: <155916877311.757870.11060347556535201032.stgit@magnolia>
References: <155916877311.757870.11060347556535201032.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=882
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905290138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=917 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor xfs_iwalk_ichunk_ra to avoid long conditionals.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iwalk.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 8e7881e95674..3c523afdcfa0 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -76,8 +76,10 @@ xfs_iwalk_ichunk_ra(
 	     i < XFS_INODES_PER_CHUNK;
 	     i += igeo->ig_inodes_per_cluster,
 			agbno += igeo->ig_blocks_per_cluster) {
-		if (xfs_inobt_maskn(i, igeo->ig_inodes_per_cluster) &
-		    ~irec->ir_free) {
+		xfs_inofree_t	imask;
+
+		imask = xfs_inobt_maskn(i, igeo->ig_inodes_per_cluster);
+		if (imask & ~irec->ir_free) {
 			xfs_btree_reada_bufs(mp, agno, agbno,
 					igeo->ig_blocks_per_cluster,
 					&xfs_inode_buf_ops);

