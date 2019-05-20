Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD66243FC
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 01:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfETXQ7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 19:16:59 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36684 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfETXQ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:16:59 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNDd3l149416;
        Mon, 20 May 2019 23:16:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=U6aZPRA1tcsHj/SJco3N1TpoUoLMGsBC0uwqQ1AWdH4=;
 b=3/nFtTDiDX/r2tyAvA5TTFCoq5DMEq02yYflYIG2I+rb8HLp8dBt+XrIX+FISTQD0MQd
 iiulcql4TdaaldLx9bV5D1P6YH/CFo58lXWwI7CNG79GrFmkOi2Em382lK8JC+gdn1Wd
 SQyTj7WZRxcEuxa3o0Ct3M3ikuPWEsmxZ/fk7HN2H7f3TO7jiUZUlsKQZgT1P9Vbf7qg
 XQqTkQ7XDYBKDOSJaZ+NSJMKRLrGc/WBxRqEAJ+zh8kXnsqjwlGakMcaCclJGb2NOxMM
 mkU4IEcw39PMohxpZdV/XEoRs0iui/Svaq4NaxWZVQAIQAP0PjAtqA5OAh2GLuRXooDn 1w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2sj7jdj5hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:16:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNFSqc118605;
        Mon, 20 May 2019 23:16:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2sks1xv86g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:16:56 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4KNGtk6021844;
        Mon, 20 May 2019 23:16:55 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 23:16:54 +0000
Subject: [PATCH 02/12] libxfs: set m_finobt_nores when initializing library
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 20 May 2019 16:16:53 -0700
Message-ID: <155839421389.68606.12844536360638603273.stgit@magnolia>
In-Reply-To: <155839420081.68606.4573219764134939943.stgit@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200142
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We don't generally set up per-ag reservations in userspace, so set this
flag to true to force transactions to set up block reservations.  This
isn't necessary for userspace (since we never touch the finobt) but we
shouldn't leave a logic bomb.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/init.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/libxfs/init.c b/libxfs/init.c
index 2f6decc8..1baccb31 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -640,6 +640,7 @@ libxfs_mount(
 
 	libxfs_buftarg_init(mp, dev, logdev, rtdev);
 
+	mp->m_finobt_nores = true;
 	mp->m_flags = (LIBXFS_MOUNT_32BITINODES|LIBXFS_MOUNT_32BITINOOPT);
 	mp->m_sb = *sb;
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);

