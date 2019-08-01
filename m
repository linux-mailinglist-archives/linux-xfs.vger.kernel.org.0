Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F50F7D2F5
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Aug 2019 03:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbfHABnF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 31 Jul 2019 21:43:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42630 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfHABnF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 21:43:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x711Y7Hv076893;
        Thu, 1 Aug 2019 01:42:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=dj2cUoNeoGCN5tGmPKKeh+Fl0a9HZKDVwjhHyFxRk+U=;
 b=FQf+ZFl/cHI7YtVx8seXxfjI0jjSvV3yE28MENKX7415niwST7PxuroEXOp1S8OykJSM
 oerf+mxtHu9VmjCKgVpvLo9bGOj80F1SkM0pKg5VornSDIPAJ9hGwDn7cwd5ZKHI7okK
 OZ1WTjgN7t0YwSs3NL2sYo0V2CuxoLpy6yLKqYFv16cjq+jUG0hh03QU8jkCIXXLH2wg
 L3cRRLniu0KbI7HMT3FgGzRkaIpDBifxrJzXUXibJ85N+rV9hfedavTB/9ce9/3a1EJ2
 +OyJXLZw5Mf9vtk1DH4qCP8LKk27vp2HEovBTHNAmZfN59YHDYbZzeLkyV0Yhhgp2kBd qA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u0f8r8gj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 01:42:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x711WqcC145432;
        Thu, 1 Aug 2019 01:42:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2u349df6eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 01:42:53 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x711gqtr001437;
        Thu, 1 Aug 2019 01:42:52 GMT
Received: from localhost (/10.159.254.175)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 31 Jul 2019 18:42:51 -0700
Subject: [PATCH 2/5] xfs/122: mask wonky ioctls
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com,
        fstests@vger.kernel.org
Date:   Wed, 31 Jul 2019 18:42:47 -0700
Message-ID: <156462376770.2945299.14876549345616514182.stgit@magnolia>
In-Reply-To: <156462375516.2945299.16564635037236083118.stgit@magnolia>
References: <156462375516.2945299.16564635037236083118.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=880
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908010012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=937 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908010012
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

