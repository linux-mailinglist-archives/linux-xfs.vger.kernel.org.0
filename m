Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A08351B9
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 23:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFDVRE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 17:17:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58576 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfFDVRD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:17:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54KwWKo014968;
        Tue, 4 Jun 2019 21:16:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=3Hgyl8NttdgXyFlFIsE84/I1i+5edQaw/F/1MLNDLgs=;
 b=e3eg+THKrwQaaPpQm+wfdVqHvIm9kwqK+l/SMqaFHOMXfOC+pY8NFU2qttawdrvQJ5+J
 qao2zxHogoOQj1abGb1ICF/SDzI3HNAovwHXZm+CkihrqTq9GZEu82urimsWIhKZ2N+Q
 CQ4UIpyxkyIh1U7qKJFoalXh1xMFIBq7Bky5dRva97Adw0erj0dh/49EfUlnvJgOJN6S
 LoFCLXvFBw5bmpm9ZP3nBNkh+bG6CeTC5naUs8Lt7fvfHEuz+niwbR97Kz7nCHzfKpQg
 j09LFprdBG/otUHikCcAI5c2DowuIOw5GF7alN5urP2y+m7XG7Z1jqqh94RzKFMCtcKj 6g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2sugstfjja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 21:16:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54LFqct143307;
        Tue, 4 Jun 2019 21:16:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2swnghjyus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 21:16:58 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x54LGvL7026299;
        Tue, 4 Jun 2019 21:16:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Jun 2019 14:16:56 -0700
Subject: [PATCH 2/3] xfs/122: add new ioctl structures
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 04 Jun 2019 14:16:55 -0700
Message-ID: <155968301540.1646947.7830716613133171656.stgit@magnolia>
In-Reply-To: <155968300283.1646947.2586545304045786757.stgit@magnolia>
References: <155968300283.1646947.2586545304045786757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=969
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906040133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906040133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add some new ioctls that are being introduced in 5.2.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122.out |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 92fb46ae..cf9ac9e2 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -57,6 +57,7 @@ offsetof(xfs_sb_t, sb_versionnum) = 100
 offsetof(xfs_sb_t, sb_width) = 188
 sizeof(struct xfs_acl) = 4
 sizeof(struct xfs_acl_entry) = 12
+sizeof(struct xfs_ag_geometry) = 128
 sizeof(struct xfs_attr3_leaf_hdr) = 80
 sizeof(struct xfs_attr3_leafblock) = 88
 sizeof(struct xfs_attr3_rmt_hdr) = 56
@@ -82,6 +83,9 @@ sizeof(struct xfs_extent_data) = 24
 sizeof(struct xfs_extent_data_info) = 32
 sizeof(struct xfs_fs_eofblocks) = 128
 sizeof(struct xfs_fsop_ag_resblks) = 64
+sizeof(struct xfs_fsop_geom) = 256
+sizeof(struct xfs_fsop_geom_v1) = 112
+sizeof(struct xfs_fsop_geom_v4) = 112
 sizeof(struct xfs_icreate_log) = 28
 sizeof(struct xfs_inode_log_format) = 56
 sizeof(struct xfs_inode_log_format_32) = 52

