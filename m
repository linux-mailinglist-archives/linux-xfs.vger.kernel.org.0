Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F7D725BE
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jul 2019 06:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbfGXEN0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jul 2019 00:13:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53496 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfGXEN0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 00:13:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O48mRp121233;
        Wed, 24 Jul 2019 04:13:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=mxD+S2pjBUXiq4hrP1gUUp9ZxwyAZ8rSHU5LeZW83n4=;
 b=geTQv2IHefsREfRj/QM0F2MTp08dzxax1yVCVTe3jqKqsMtL7C3MB+on7Sd2yGFl1QVl
 ae6gKymuEGeDur7b05u5zLnB+b3ESUh6p5o/voNza22bFpKxLxgp5ZLqpNw78UoHXeaA
 JlJ/0pY/q14Z6qL2ZeytGCYj88iDsAmvzoKvqA7JUcrelePS5AK4i8LsH/r6YU7Yckv8
 Y8Fj0r8aVwmnQ39V3DsSF7IA5CO8pYvnJMfyarMtfhAQR3uHDJHGTWx25ijIa+JnvMUg
 vyhnpbLWk303icAkiRN6W3FzA7vDNtgYWZthhov5JRkrL4zDXjCyMb7EdA4i25Sz/1aE UQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2tx61btjjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 04:13:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O4DLTr060077;
        Wed, 24 Jul 2019 04:13:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2tx60x08p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 04:13:22 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6O4DLd3018455;
        Wed, 24 Jul 2019 04:13:21 GMT
Received: from localhost (/50.206.22.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jul 2019 21:13:21 -0700
Subject: [PATCH 1/4] xfs/122: ignore inode geometry structure
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 23 Jul 2019 21:13:20 -0700
Message-ID: <156394160033.1850833.3353358773089273571.stgit@magnolia>
In-Reply-To: <156394159426.1850833.16316913520596851191.stgit@magnolia>
References: <156394159426.1850833.16316913520596851191.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=984
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

Ignore new in-core structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/122 b/tests/xfs/122
index b66b78a6..89a39a23 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -177,6 +177,7 @@ xfs_dirent_t
 xfs_fsop_getparents_handlereq_t
 xfs_dinode_core_t
 struct xfs_iext_cursor
+struct xfs_ino_geometry
 EOF
 
 echo 'int main(int argc, char *argv[]) {' >>$cprog

