Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1476C75686
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Jul 2019 20:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfGYSES (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Jul 2019 14:04:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43456 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfGYSER (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 14:04:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PI3MXN061975;
        Thu, 25 Jul 2019 18:04:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=O0W5UP8LkRe3Gi+iFatt/31kNtgmrjLmdhWsXIXVAyM=;
 b=DU0mtd/CikkDWMh1O6mBO5ZmAGpLkkmkW9afYFGc1fA9wm13F+IM2K2RDXr036zywH8q
 aZYX7c6Ksri7xZLeSjUlVX9rExhqywON445BWEIqu3AXYdlldlpPpxI2MGogH2I2pERj
 tx70Rvo2ypaFRgql6fx/CnhuxejOe4r8pVmJImzPQxobg/GCSeY/6u/97DiZDGNEIluA
 Itcr2/x7/5pGNgs6cObgkGU+mS92c2ctpckATBJJY0sjIAzefB/ZCRkIPdamgMxStOMU
 c5hPSY7/kD+rLbFDZd9kk/04YLtvutHNxUmYz5nN5cq2B+zRjE2Hz6D6rIWmISFUl9LK qQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2tx61c5prq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 18:04:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PI3D3i050017;
        Thu, 25 Jul 2019 18:04:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tycv725n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 18:04:14 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6PI4E5n024543;
        Thu, 25 Jul 2019 18:04:14 GMT
Received: from localhost (/10.144.111.83)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jul 2019 11:04:14 -0700
Date:   Thu, 25 Jul 2019 11:04:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 7/3] xfs/194: unmount forced v4 fs during cleanup
Message-ID: <20190725180413.GJ1561054@magnolia>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
 <20190724155656.GH7084@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724155656.GH7084@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907250213
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907250213
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
v2: add a comment explaining why we unmount the scratch device
---
 tests/xfs/194 |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tests/xfs/194 b/tests/xfs/194
index 3e186528..9001a146 100755
--- a/tests/xfs/194
+++ b/tests/xfs/194
@@ -18,6 +18,11 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
+    # Unmount the V4 filesystem we forcibly created to run this test so that
+    # the post-test wrapup checks won't try to remount the filesystem with
+    # different MOUNT_OPTIONS (specifically, the ones that get screened out by
+    # _force_xfsv4_mount_options) and fail.
+    _scratch_unmount
     rm -f $tmp.*
 }
 
