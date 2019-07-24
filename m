Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DACA725B9
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jul 2019 06:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbfGXEM7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jul 2019 00:12:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43780 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfGXEM7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 00:12:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O48wYT119451;
        Wed, 24 Jul 2019 04:12:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=p5N3jmsd1XBGf1W6rpxSCIADVFvWEV7FE4zThCBxGKo=;
 b=IOa3SOKcOtZ+vht05tZ64pf1S0ey0/zpYef0JnNUp9HRcB+my3CinrEJUAZWnHMDV81I
 7RvcJ8eJ/tA8xwL2btIabGutNS0kZH1kISzq44FApMV3vBTPa2DKK8VGQPGtuqawnN+Y
 IQM8hn7aMLmsoNMGUQVYXd+GXKjLkgJZDG11K8jf/+jDn56YBAeBPJIkE9h74wTQRwqd
 Ni/NIfhXE3WDCdOcXt3krtBmam/mvwvocXWtaD6i9IwzWCKmALiPb+5Jxje05pb7g8Do
 bbYSgC9baW9rWjlPG5aG+WkvlcpdkTmnJ0ASkPKNcYfB7smXJPvZo4YOX6wQAyNR082T ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2tx61btjsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 04:12:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O47l2x129559;
        Wed, 24 Jul 2019 04:12:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2tx60xg8hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 04:12:56 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6O4CteP012802;
        Wed, 24 Jul 2019 04:12:55 GMT
Received: from localhost (/50.206.22.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jul 2019 21:12:55 -0700
Subject: [PATCH 1/3] common: filter aiodio dmesg after fs/iomap.c to
 fs/iomap/ move
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 23 Jul 2019 21:12:54 -0700
Message-ID: <156394157450.1850719.464315342783936237.stgit@magnolia>
In-Reply-To: <156394156831.1850719.2997473679130010771.stgit@magnolia>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907240045
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

Since the iomap code are moving to fs/iomap/ we have to add new entries
to the aiodio dmesg filter to reflect this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/filter |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/common/filter b/common/filter
index ed082d24..26fc2132 100644
--- a/common/filter
+++ b/common/filter
@@ -555,6 +555,7 @@ _filter_aiodio_dmesg()
 	local warn7="WARNING:.*fs/iomap\.c:.*iomap_dio_actor.*"
 	local warn8="WARNING:.*fs/iomap\.c:.*iomap_dio_complete.*"
 	local warn9="WARNING:.*fs/direct-io\.c:.*dio_complete.*"
+	local warn10="WARNING:.*fs/iomap/direct-io\.c:.*iomap_dio_actor.*"
 	sed -e "s#$warn1#Intentional warnings in xfs_file_dio_aio_write#" \
 	    -e "s#$warn2#Intentional warnings in xfs_file_dio_aio_read#" \
 	    -e "s#$warn3#Intentional warnings in xfs_file_read_iter#" \
@@ -563,7 +564,8 @@ _filter_aiodio_dmesg()
 	    -e "s#$warn6#Intentional warnings in __xfs_get_blocks#" \
 	    -e "s#$warn7#Intentional warnings in iomap_dio_actor#" \
 	    -e "s#$warn8#Intentional warnings in iomap_dio_complete#" \
-	    -e "s#$warn9#Intentional warnings in dio_complete#"
+	    -e "s#$warn9#Intentional warnings in dio_complete#" \
+	    -e "s#$warn10#Intentional warnings in iomap_dio_actor#"
 }
 
 # We generate assert related WARNINGs on purpose and make sure test doesn't fail

