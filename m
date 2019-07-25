Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2EFA75684
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Jul 2019 20:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfGYSDf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Jul 2019 14:03:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42502 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfGYSDf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 14:03:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PI3KSg061655;
        Thu, 25 Jul 2019 18:03:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=O2sI8PSdkIdfCF1L4rce61W3bDdPL0hg56RCNMX3CXM=;
 b=n67D5ABTCMVAmy/SfC5qPj77TMx46qeazTeJBVG7vq4D/cs+g/rne2XkqdZxR53Ijc4B
 4R+nZnEkNkYxhNT+FMZDEh3I0IQPUFtnMJt/aepm7U5BKwxRsKc1j5hi2tDI8mzlToln
 977SJfLi2a3GN7vLvOfaFC6IgMZSmMBupxF4OihpVGRenTcDlTPquF8Bw8H76CdPu4XK
 hFl+ocv8wvPVpdktLEPxxu+WgAGT+K+QG3Mev6Boc0gekMjwcRO9vm60ckIa5t7VP7kU
 n7dnuvz1RjWOyi+j2qA5jtnAzxbBvpXcNk2tItxEZkhHzW+cJldJLYTb1cnoKODKC51C KA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2tx61c5pn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 18:03:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PI3AOF195056;
        Thu, 25 Jul 2019 18:03:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2tyd3nqt4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 18:03:32 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6PI3V3T018606;
        Thu, 25 Jul 2019 18:03:31 GMT
Received: from localhost (/10.144.111.83)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jul 2019 11:03:31 -0700
Date:   Thu, 25 Jul 2019 11:03:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 1/3] common: filter aiodio dmesg after fs/iomap.c to
 fs/iomap/ move
Message-ID: <20190725180330.GH1561054@magnolia>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
 <156394157450.1850719.464315342783936237.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156394157450.1850719.464315342783936237.stgit@magnolia>
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

Since the iomap code are moving to fs/iomap/ we have to add new entries
to the aiodio dmesg filter to reflect this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: fix all the iomap regexes
---
 common/filter |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/common/filter b/common/filter
index ed082d24..2e32ab10 100644
--- a/common/filter
+++ b/common/filter
@@ -550,10 +550,10 @@ _filter_aiodio_dmesg()
 	local warn2="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_dio_aio_read.*"
 	local warn3="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_read_iter.*"
 	local warn4="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_aio_read.*"
-	local warn5="WARNING:.*fs/iomap\.c:.*iomap_dio_rw.*"
+	local warn5="WARNING:.*fs/iomap.*:.*iomap_dio_rw.*"
 	local warn6="WARNING:.*fs/xfs/xfs_aops\.c:.*__xfs_get_blocks.*"
-	local warn7="WARNING:.*fs/iomap\.c:.*iomap_dio_actor.*"
-	local warn8="WARNING:.*fs/iomap\.c:.*iomap_dio_complete.*"
+	local warn7="WARNING:.*fs/iomap.*:.*iomap_dio_actor.*"
+	local warn8="WARNING:.*fs/iomap.*:.*iomap_dio_complete.*"
 	local warn9="WARNING:.*fs/direct-io\.c:.*dio_complete.*"
 	sed -e "s#$warn1#Intentional warnings in xfs_file_dio_aio_write#" \
 	    -e "s#$warn2#Intentional warnings in xfs_file_dio_aio_read#" \
@@ -563,7 +563,8 @@ _filter_aiodio_dmesg()
 	    -e "s#$warn6#Intentional warnings in __xfs_get_blocks#" \
 	    -e "s#$warn7#Intentional warnings in iomap_dio_actor#" \
 	    -e "s#$warn8#Intentional warnings in iomap_dio_complete#" \
-	    -e "s#$warn9#Intentional warnings in dio_complete#"
+	    -e "s#$warn9#Intentional warnings in dio_complete#" \
+	    -e "s#$warn10#Intentional warnings in iomap_dio_actor#"
 }
 
 # We generate assert related WARNINGs on purpose and make sure test doesn't fail
