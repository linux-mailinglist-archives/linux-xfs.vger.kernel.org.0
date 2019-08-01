Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 798787D2F4
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Aug 2019 03:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbfHABmu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 31 Jul 2019 21:42:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42390 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfHABmu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 21:42:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x711Y7wO077000;
        Thu, 1 Aug 2019 01:42:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=mxD+S2pjBUXiq4hrP1gUUp9ZxwyAZ8rSHU5LeZW83n4=;
 b=BNiEuHu/dBgnd67Ec50oDmoWSHx/pYkwXB65L5yXIu3FOSHCLathmaXPQ5RbGpoJGiYb
 rEOFe/gnonzuZvkIPCPmZuIfe09cmhMowb1e8H96uu79ocyG6Sc+jdx7/RzJBf5RC7IH
 CLyihb+0mD7uGSL6u8eiTq5CNo2ytLpuVlHuJeGqBMNr+qDhQQypz7bTNe/bD2ggmjzB
 12GsiZs+QnkkLlse0JFkH5ZWhWFmHLtelpsd3lMvTun9ON0O7PDflcWU5Hz71KqBUKss
 rjjkjnGLcZoX8TZMIJDZBfCHd+bwHvBPaB2fZ2zwLVnpblRg90F6kxLkvqR4ZOuoHQs6 aA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u0f8r8ghn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 01:42:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x711Wvnp145589;
        Thu, 1 Aug 2019 01:42:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2u349df6c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 01:42:43 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x711ggYM001317;
        Thu, 1 Aug 2019 01:42:42 GMT
Received: from localhost (/10.159.254.175)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Aug 2019 01:42:42 +0000
Subject: [PATCH 1/5] xfs/122: ignore inode geometry structure
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com,
        fstests@vger.kernel.org
Date:   Wed, 31 Jul 2019 18:42:41 -0700
Message-ID: <156462376150.2945299.17354409699083869260.stgit@magnolia>
In-Reply-To: <156462375516.2945299.16564635037236083118.stgit@magnolia>
References: <156462375516.2945299.16564635037236083118.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
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

