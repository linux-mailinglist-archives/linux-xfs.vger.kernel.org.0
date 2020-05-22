Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB07E1DDD7B
	for <lists+linux-xfs@lfdr.de>; Fri, 22 May 2020 04:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgEVCxq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 21 May 2020 22:53:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37898 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727936AbgEVCxp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 22:53:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2mpjH081792;
        Fri, 22 May 2020 02:53:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=sGxp9LOk3Jd/cjqVuEgizKIsLSWeFE5yib27rtr45GI=;
 b=bDKs4Q18Wykp3fss6YYgDB4QzmR0InM6YH71Fw3RjfTaUvn8VEFvMgwe8sBEkPcmIVIh
 e0xM8HIGWQKyEYJZV4BxCnIjzmuoXtLcU0cQF67MGOG1CLVBCze2lYK5WJpQm4ToCTPa
 xX1uInKtb15C5J9WLGfNhfU/ITj+9Zd7DKyyX8qVQ3k+uL1Xutw/t5ymXxY7Ha28P1fp
 /OW7DZNUFM01qCQEj8HNqzYjd83mHk9nZH6MApXjYO29SNsUFVtyBIC/VcF+8IBf1248
 bi6HpOWigfVumb9UZ+I9CJARpK0wNISTnRYC65Rm+cmkHIlZ+EqPRUSY3IiPUPrUEeRb qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31501rj2k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 02:53:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2mXDC186056;
        Fri, 22 May 2020 02:53:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 314gmaavqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 02:53:42 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04M2rfWs029999;
        Fri, 22 May 2020 02:53:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 19:53:41 -0700
Subject: [PATCH 02/12] xfs: replace open-coded XFS_ICI_NO_TAG
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@lst.de
Date:   Thu, 21 May 2020 19:53:40 -0700
Message-ID: <159011602013.77079.11614147766663587976.stgit@magnolia>
In-Reply-To: <159011600616.77079.14748275956667624732.stgit@magnolia>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=936
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=969 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220021
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use XFS_ICI_NO_TAG instead of -1 when appropriate.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0ed904c2aa12..b1e2541810be 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -815,7 +815,7 @@ xfs_inode_ag_walk(
 
 		rcu_read_lock();
 
-		if (tag == -1)
+		if (tag == XFS_ICI_NO_TAG)
 			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
 					(void **)batch, first_index,
 					XFS_LOOKUP_BATCH);
@@ -973,8 +973,8 @@ xfs_inode_ag_iterator_flags(
 	ag = 0;
 	while ((pag = xfs_perag_get(mp, ag))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_ag_walk(mp, pag, execute, flags, args, -1,
-					  iter_flags);
+		error = xfs_inode_ag_walk(mp, pag, execute, flags, args,
+				XFS_ICI_NO_TAG, iter_flags);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;

