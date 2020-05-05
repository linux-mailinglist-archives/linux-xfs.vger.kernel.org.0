Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E181C4B65
	for <lists+linux-xfs@lfdr.de>; Tue,  5 May 2020 03:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgEEBNb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 May 2020 21:13:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50896 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbgEEBNa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:13:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04514Isl143393;
        Tue, 5 May 2020 01:13:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=lrFM+dWYfUj18h0RKz6cP6S9M3Sbqvnzu6OqWsmQfIU=;
 b=K6LD8wqYqfJtwGzUmxZ40aWy4BeQF3t8AwkNxWuAgjk8SIP2xOCUGH11PEZKcPzhDu/I
 th54oj8Hm/yM8jDan8dulLq3/u8KHflYIGxcQE8V81Nq7HwWEPNXpX0xhzxWkuyxNcNZ
 4p0tHQ/dwHVLMUjKwyJCHW8hU4a6Th6wG9taZiC6aCtV5mof37Y1Qb0M0yXl1TmCNmLN
 S6Dy5uOOobMuk3u/iibWEhWhvq82kgs506IvXwTJORJUQCTYkge0fAzD57sMJ2XWKW5v
 p9QewWAyI/ir32vPx47aT6YAycPL9gVB45y1VUr06o0es3rh77U5borFXLwh71MSHsK8 nA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30s09r236x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 01:13:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04515Sdr145394;
        Tue, 5 May 2020 01:13:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30sjncm29q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 01:13:26 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451DPLD015484;
        Tue, 5 May 2020 01:13:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:13:25 -0700
Subject: [PATCH 27/28] xfs: remove unnecessary includes from xfs_log_recover.c
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:13:24 -0700
Message-ID: <158864120453.182683.5638021226977031304.stgit@magnolia>
In-Reply-To: <158864103195.182683.2056162574447133617.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=1
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove unnecessary includes from the log recovery code.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c |    8 --------
 1 file changed, 8 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0c8a1f4bf4ad..a9cc546535e0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -18,21 +18,13 @@
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
-#include "xfs_inode_item.h"
-#include "xfs_extfree_item.h"
 #include "xfs_trans_priv.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
-#include "xfs_quota.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_error.h"
-#include "xfs_dir2.h"
-#include "xfs_rmap_item.h"
 #include "xfs_buf_item.h"
-#include "xfs_refcount_item.h"
-#include "xfs_bmap_item.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 

