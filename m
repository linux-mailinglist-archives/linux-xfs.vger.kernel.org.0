Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDBF7D2F6
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Aug 2019 03:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfHABnN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 31 Jul 2019 21:43:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43372 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfHABnN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 21:43:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x711YF84073908;
        Thu, 1 Aug 2019 01:43:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Av7O1H2c5HTAjkGwCwww+rrRWVyHRJOli72e1cGOcuc=;
 b=FjucyxvKAb080Mntugck0Qn28bmustNt8FdG4r1H21LiqI2vcif1ueP+VAoAtwWj42Ze
 b0QQKLpy8rPWNH5qTaYAkczni3egc+fV/SzrOwKWgeA12n6LMaG8JFoshtCmGjgq7Yfn
 txPaidYGjkjboUekW8wvB+vS1olJ1AtNcEseRN6NyyRJpEMGPHoU39CULVNXxCrCXSvI
 WWLXx5eA0hoyern8tPhQbIFcCuM+0+HlxbEHi1gcakeWC2dfcENbkABUdjwUMAAYbgP2
 D3rMXvW5K8l/ux0xk7EtD2HCf3O71LyzSpcOf0nLqMR7LJ5UL+5x9/nGJ9nxYjPLAyh2 ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u0e1u0qtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 01:43:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x711WvEx103796;
        Thu, 1 Aug 2019 01:43:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2u2jp5nuds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 01:43:00 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x711gxrK023105;
        Thu, 1 Aug 2019 01:42:59 GMT
Received: from localhost (/10.159.254.175)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 31 Jul 2019 18:42:58 -0700
Subject: [PATCH 3/5] xfs/122: add the new v5 bulkstat/inumbers ioctl
 structures
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com,
        fstests@vger.kernel.org
Date:   Wed, 31 Jul 2019 18:42:57 -0700
Message-ID: <156462377790.2945299.5915136628365061851.stgit@magnolia>
In-Reply-To: <156462375516.2945299.16564635037236083118.stgit@magnolia>
References: <156462375516.2945299.16564635037236083118.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=985
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908010012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908010012
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
 tests/xfs/122.out |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index cf9ac9e2..d2d5a184 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -66,6 +66,9 @@ sizeof(struct xfs_btree_block_lhdr) = 64
 sizeof(struct xfs_btree_block_shdr) = 48
 sizeof(struct xfs_bud_log_format) = 16
 sizeof(struct xfs_bui_log_format) = 16
+sizeof(struct xfs_bulk_ireq) = 64
+sizeof(struct xfs_bulkstat) = 192
+sizeof(struct xfs_bulkstat_req) = 64
 sizeof(struct xfs_clone_args) = 32
 sizeof(struct xfs_cud_log_format) = 16
 sizeof(struct xfs_cui_log_format) = 16
@@ -89,6 +92,8 @@ sizeof(struct xfs_fsop_geom_v4) = 112
 sizeof(struct xfs_icreate_log) = 28
 sizeof(struct xfs_inode_log_format) = 56
 sizeof(struct xfs_inode_log_format_32) = 52
+sizeof(struct xfs_inumbers) = 24
+sizeof(struct xfs_inumbers_req) = 64
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_map_extent) = 32
 sizeof(struct xfs_phys_extent) = 16

