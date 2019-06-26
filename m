Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058BE572DE
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 22:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfFZUos (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 16:44:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48416 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfFZUos (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:44:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKhrJH012161;
        Wed, 26 Jun 2019 20:44:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=1BDF7T7KZaU28xWnh4iDEpdJXFFXePNgZ05hmVAkUIw=;
 b=If0A6ukzw9vOHlJLEpQuzgZ9XsEmg1X7WCXgCe99Ru3Kqjwd0bh8K7mFMKHmKfTDnEgt
 cFp87jlS0fTFE4Ij0oWv0knk5Yf2ZNu0qkMWIShubJhu1jqqoVKSNdGpHdDdH7rwmHTj
 d6J88pAYq/+b06919qGr82/QYvxVchtmFJPAuwkaWc0hQHr8iQHo30XZl7+4N+NgxP94
 AB5JmvToLNb5D1J7WLYI/L4GwUCdYs0zXv9Qwxi/emdkEPBZEpDK1xVbGwARE4tY/2nq
 l+vWPzbaHQxje13khKNvUGUTy60x5hI0qsm9kHoJwbQp0C5g064HOQeOGrvzXPTYOoe5 WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2t9brtcmms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 20:44:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKhQmH008028;
        Wed, 26 Jun 2019 20:44:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2t9p6uyxre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 20:44:30 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5QKiTvf002729;
        Wed, 26 Jun 2019 20:44:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 13:44:29 -0700
Subject: [PATCH 05/15] xfs: remove unnecessary includes of xfs_itable.h
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Wed, 26 Jun 2019 13:44:28 -0700
Message-ID: <156158186815.495087.10995970602986192086.stgit@magnolia>
In-Reply-To: <156158183697.495087.5371839759804528321.stgit@magnolia>
References: <156158183697.495087.5371839759804528321.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260240
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260240
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't include xfs_itable.h in files that don't need it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/scrub/common.c |    1 -
 fs/xfs/scrub/dir.c    |    1 -
 fs/xfs/scrub/scrub.c  |    1 -
 fs/xfs/xfs_trace.c    |    1 -
 4 files changed, 4 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 973aa59975e3..561d7e818e8b 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -17,7 +17,6 @@
 #include "xfs_sb.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
-#include "xfs_itable.h"
 #include "xfs_alloc.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_bmap.h"
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index a38a22785a1a..9018ca4aba64 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -17,7 +17,6 @@
 #include "xfs_sb.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
-#include "xfs_itable.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2.h"
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index f630389ee176..5689a33e999c 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -17,7 +17,6 @@
 #include "xfs_sb.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
-#include "xfs_itable.h"
 #include "xfs_alloc.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_bmap.h"
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index cb6489c22cad..f555a3c560b9 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -16,7 +16,6 @@
 #include "xfs_btree.h"
 #include "xfs_da_btree.h"
 #include "xfs_ialloc.h"
-#include "xfs_itable.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_attr.h"

