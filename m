Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C41580FC5
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Aug 2019 02:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfHEAgO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 4 Aug 2019 20:36:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44306 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfHEAgN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 20:36:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750OhL4098946
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:36:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=hEVpRjD3f2chC7ZFbhaKmwH7hZijZxyc1SDV0/imFYU=;
 b=HgWq0dWeLbclPdUpBbL7RTjdy6+QJDqWq998rS+bEbKrz9neCsimDsPtXW+9GJ2Xs8OD
 TWBSIQhnMyIf8TClDnSRsBlhkfZwV9zdp8q20opuBYTX649DojRtvqxua73xdBHJ8cAd
 6wDwuI/kVrqZkW5K9SzUeyol20b7ZcSX8JXj8ZKbxmXfabO2Ziq9Lm4GOYnxd03NQDeE
 PXyypHjEWH3oLyc8cF4OPmV0wY/ooPiQ/x2N9XiIfsTbT6Fd+o2s7KcNV4Kyi+r56Z5S
 DuLf3/E/9xzTl5cX46phnHN5y+ob5leFADjbR94Vejkn8byOQTcxjC2xKwiIEl5LdN3R dQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2u527pc79g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:36:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750MxhM195486
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:36:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2u51kkttjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:36:11 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x750aAnP012951
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:36:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 04 Aug 2019 17:36:10 -0700
Subject: [PATCH 13/18] xfs: remove unnecessary inode-transaction roll
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 04 Aug 2019 17:36:09 -0700
Message-ID: <156496536963.804304.1971930056894196437.stgit@magnolia>
In-Reply-To: <156496528310.804304.8105015456378794397.stgit@magnolia>
References: <156496528310.804304.8105015456378794397.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9339 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9339 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908050001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the transaction roll at the end of the loop in
xfs_itruncate_extents_flags.  xfs_defer_finish takes care of rolling the
transaction as needed and reattaching the inode, which means we already
start each loop with a clean transaction.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |    4 ----
 1 file changed, 4 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5fa9e49ccb87..acb9335e6306 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1560,10 +1560,6 @@ xfs_itruncate_extents_flags(
 		error = xfs_defer_finish(&tp);
 		if (error)
 			goto out;
-
-		error = xfs_trans_roll_inode(&tp, ip);
-		if (error)
-			goto out;
 	}
 
 	if (whichfork == XFS_DATA_FORK) {

