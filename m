Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E337841C8B
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 08:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731275AbfFLGs1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Jun 2019 02:48:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33090 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731273AbfFLGs1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:48:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6i1X2044251;
        Wed, 12 Jun 2019 06:48:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=oSwwtnFdsTIqCLYcUbz+JPdHWOIlyS6m3Whhhyhvq60=;
 b=LDjc34ITwTexavWE/Jo9i8ShuLRZEO/do6TiVD8MlXJI46OeVq+/LK58hBVTWi4xrGp0
 p/b8k5lDkzITXL9U+8tQIsXBWaeYsIXRunPG8a59J/k5H8JhS48AK6hz0ISG43KTMoRx
 DDUfklRwypggbJFE2+hlvTOufhdhfli+AXJS6Ir8C4VYxco5wMYIRAskLrFEy4bfKxP4
 T+w78oTQaG+4dOPydsh47fmpWi6Vs5KyY6hoRlyWo34LHLZ9DwRzbh+L9+0Fq6PfIxFJ
 vAmjuwIGlPjoOy3RB/r1L6HSXxQamqdauvai0J1D6X07BkMKuhLGYYV2RT2pc+MbKDpt Jw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2t04etsfrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 06:48:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6kucU045866;
        Wed, 12 Jun 2019 06:48:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2t04hyrwe9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 06:48:04 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5C6m4gM017349;
        Wed, 12 Jun 2019 06:48:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Jun 2019 23:48:04 -0700
Subject: [PATCH 05/14] xfs: remove unnecessary includes of xfs_itable.h
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Tue, 11 Jun 2019 23:48:03 -0700
Message-ID: <156032208315.3774243.12030637267920512012.stgit@magnolia>
In-Reply-To: <156032205136.3774243.15725828509940520561.stgit@magnolia>
References: <156032205136.3774243.15725828509940520561.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906120046
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906120046
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't include xfs_itable.h in files that don't need it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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

