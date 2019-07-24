Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6158D725C0
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jul 2019 06:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725829AbfGXENk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jul 2019 00:13:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51492 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfGXENk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 00:13:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O48km4009123;
        Wed, 24 Jul 2019 04:13:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=cgltOG6gOHDKeLlhC84oqt2hlGh9axRPsnfutl0lFBU=;
 b=jJeCqmTPVz1EfjVH5t+67tYlLVLNrS+JbtsUFJyD4iYqS5FPfhZ3DaqX04T+Xt3NxljC
 9nosRu2AeWPDxtMY5Q0zTpPYOs8o87euJd2KZViV2YuVI9tiZe568Cys3wLGtroit0ID
 kQqayBXjAnj6f3nroFmg/uEHGHzagalTyGD9upGBe9WK8ri8KzRvlIc0rddlnHsRITrn
 zuev9kEQrdTXgGzDT8CXhgPCfhkPIVEEyGcqDIjEUWXF/i5RbeKhGy2BkBnoZoRzcZjM
 HwriSxkAEpEaaI+vfUY0XkUdjaeTTrkjpKS26aupL03YaNyZfTYS2F0wzoUFM0Bzf5GU YA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2tx61btjr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 04:13:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O4DLH6140177;
        Wed, 24 Jul 2019 04:13:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2tx60xg8rx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 04:13:35 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6O4DXBo013041;
        Wed, 24 Jul 2019 04:13:33 GMT
Received: from localhost (/50.206.22.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jul 2019 21:13:33 -0700
Subject: [PATCH 3/4] xfs/122: add the new v5 bulkstat/inumbers ioctl
 structures
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 23 Jul 2019 21:13:32 -0700
Message-ID: <156394161274.1850833.4300015313269610610.stgit@magnolia>
In-Reply-To: <156394159426.1850833.16316913520596851191.stgit@magnolia>
References: <156394159426.1850833.16316913520596851191.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=969
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907240046
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907240045
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The new v5 bulkstat and inumbers structures are correctly padded so that
no format changes are necessary across platforms, so add them to the
output.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122.out |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index cf9ac9e2..e2f346eb 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -66,6 +66,10 @@ sizeof(struct xfs_btree_block_lhdr) = 64
 sizeof(struct xfs_btree_block_shdr) = 48
 sizeof(struct xfs_bud_log_format) = 16
 sizeof(struct xfs_bui_log_format) = 16
+sizeof(struct xfs_bulk_ireq) = 64
+sizeof(struct xfs_bulkstat) = 192
+sizeof(struct xfs_bulkstat_req) = 64
+sizeof(struct xfs_bulkstat_single_req) = 224
 sizeof(struct xfs_clone_args) = 32
 sizeof(struct xfs_cud_log_format) = 16
 sizeof(struct xfs_cui_log_format) = 16
@@ -89,6 +93,9 @@ sizeof(struct xfs_fsop_geom_v4) = 112
 sizeof(struct xfs_icreate_log) = 28
 sizeof(struct xfs_inode_log_format) = 56
 sizeof(struct xfs_inode_log_format_32) = 52
+sizeof(struct xfs_inumbers) = 24
+sizeof(struct xfs_inumbers_req) = 64
+sizeof(struct xfs_ireq) = 32
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_map_extent) = 32
 sizeof(struct xfs_phys_extent) = 16

