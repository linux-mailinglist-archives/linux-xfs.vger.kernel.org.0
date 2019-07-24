Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA3873335
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jul 2019 17:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387449AbfGXP5B (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jul 2019 11:57:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45734 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387438AbfGXP5B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 11:57:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6OFnCRL147076;
        Wed, 24 Jul 2019 15:56:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=eeOdLjJGv7S/rDnuCeHmtRrCDAgXepfj6hBfpcUZXWA=;
 b=yTnKuXiFxPpafXy931rOKuHPba8UzHM9BN/oZCZeBjYh0PnAG1VpLf2se7omQngz/9cJ
 eersgTl9OxTnTHQDLWZZMtAR/XHeqh5WuEIVO6uHH4fK7z/P9e6ziM+Qq2EUxFtQVYHF
 yCaXoYVI7WHFLnRDrxbLrn1M83zVHGLQ9VhiAxyIZJbUP8nymWHhvBxE9JYanQk0pJ77
 VQ/WsZOnuDb/qyFC88CBws5YOf2fHp84CI4nZSmyxatTThpglArQZEkM6Koo221kxxFg
 jPHGgKAHIXv3ZY3zjJ0O866RhEELrvTXGBvoyPHfiu7Sqxs2/6LdAGfLoZx2ffFp77YK jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2tx61bxde4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 15:56:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6OFr7Fv054066;
        Wed, 24 Jul 2019 15:56:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2tx60y61dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 15:56:58 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6OFuvGV015495;
        Wed, 24 Jul 2019 15:56:57 GMT
Received: from localhost (/50.206.22.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Jul 2019 08:56:57 -0700
Date:   Wed, 24 Jul 2019 08:56:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 7/3] xfs/194: unmount forced v4 fs during cleanup
Message-ID: <20190724155656.GH7084@magnolia>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156394156831.1850719.2997473679130010771.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907240172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907240172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Unmount the V4 filesystem we forcibly created to run this test during
test cleanup so that the post-test wrapup checks won't try to remount
the filesystem with different MOUNT_OPTIONS (specifically, the ones
that get screened out by _force_xfsv4_mount_options) and fail.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/194 |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/xfs/194 b/tests/xfs/194
index 3e186528..1f46d403 100755
--- a/tests/xfs/194
+++ b/tests/xfs/194
@@ -18,6 +18,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
+    _scratch_unmount
     rm -f $tmp.*
 }
 
