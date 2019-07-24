Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D399725BF
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jul 2019 06:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbfGXENb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jul 2019 00:13:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53562 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfGXENb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 00:13:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O497rJ121331;
        Wed, 24 Jul 2019 04:13:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=dj2cUoNeoGCN5tGmPKKeh+Fl0a9HZKDVwjhHyFxRk+U=;
 b=IXkFLyXWks3fEDiRXGUB8dYG9RdRhjZZ58k0ZKWpHitJMpNUQc8QS/rY+171YG/rCeEk
 FAWIr3JGyfsUATLWCp24cDxEAgEvFQk7p/KlO0luww2lZwDJuAMTNBzadAPfLlRKfu0L
 Rcis7eJ9dxID6QG/BaUGn8HGhbYrv1gVzx0VNCJX4xdLzS/DIAEPgjdAYRooeeKp/3n4
 6JtlUGfGUJ0rbcYvPRxUtYewjhwaaKBRlXMUoEkl8TXGmUiS2BRpPYXqghrDjyFkIgtQ
 aAMPKX8/ekZxj4St1AbgFlErUtk/O+njTzWLCqXIFQc2Jk1aVE4lCPQ9rmO4eb1AhMYO pA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2tx61btjkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 04:13:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O4DJF9151912;
        Wed, 24 Jul 2019 04:13:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tx60xexcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 04:13:28 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6O4DRJD014322;
        Wed, 24 Jul 2019 04:13:27 GMT
Received: from localhost (/50.206.22.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jul 2019 21:13:27 -0700
Subject: [PATCH 2/4] xfs/122: mask wonky ioctls
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 23 Jul 2019 21:13:26 -0700
Message-ID: <156394160665.1850833.14349327556274532970.stgit@magnolia>
In-Reply-To: <156394159426.1850833.16316913520596851191.stgit@magnolia>
References: <156394159426.1850833.16316913520596851191.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=861
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907240046
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=916 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907240045
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't check the structure size of the inogrp/bstat/fsop_bulkreq
structures because they're incorrectly padded.  When we remove the
old typdefs the old filter stops working.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122 |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/tests/xfs/122 b/tests/xfs/122
index 89a39a23..64b63cb1 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -148,12 +148,15 @@ xfs_growfs_data_t
 xfs_growfs_rt_t
 xfs_bstime_t
 xfs_bstat_t
+struct xfs_bstat
 xfs_fsop_bulkreq_t
+struct xfs_fsop_bulkreq
 xfs_icsb_cnts_t
 xfs_icdinode_t
 xfs_ictimestamp_t
 xfs_inobt_rec_incore_t
 xfs_inogrp_t
+struct xfs_inogrp
 xfs_fid2_t
 xfs_fsop_handlereq_t
 xfs_fsop_setdm_handlereq_t

