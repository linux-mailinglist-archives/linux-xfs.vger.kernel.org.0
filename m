Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F078EF32
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Aug 2019 17:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbfHOPTR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Aug 2019 11:19:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53108 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfHOPTR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 11:19:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FF3ksj111430;
        Thu, 15 Aug 2019 15:19:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ourzXUDMMpuZvpmW1Fu6y1Zt3dWUs4Md/06gL8yoOLI=;
 b=NJFx/BOOgODHxwRNv/73uGVeQx8oNtMsL6RkUTk0dGn/gj/+4Qgq92Ui+rrsVr3erw8l
 4NAQTEIIr6PKqa7vXEJITO3oaS7Qrgl39VBSSPKLT35rQXm99g6HcIsUuT/QqAITPAdR
 /QGGW8YSjvKHn3EDKMBHrVm5kc8huD6e5SaVY9JUZwOKSuNflwnrGCwFZTa0T5cdcUa2
 2LgfZQ4BhssS6JRNslDcjZcS+d7Sf/kgYELpP3kTStjpCEpz8pfFF9s3g5HtN9BhVrEl
 s5leaxt3Jkdi22cdO65a3bp3NqJmnLnjHZgHxHa5CGysfKPQGgXuT4jCtYqpltQPfIJS EA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbtub2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 15:19:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FFI6Dt096901;
        Thu, 15 Aug 2019 15:19:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ucgf144qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 15:19:14 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7FFJEqh014659;
        Thu, 15 Aug 2019 15:19:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Aug 2019 08:19:13 -0700
Subject: [PATCH 3/3] common: filter aiodio dmesg after fs/iomap.c to
 fs/iomap/ move
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Thu, 15 Aug 2019 08:19:12 -0700
Message-ID: <156588235283.24775.17750563527287824640.stgit@magnolia>
In-Reply-To: <156588233330.24775.15183725500886844319.stgit@magnolia>
References: <156588233330.24775.15183725500886844319.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908150152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908150151
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since the iomap code are moving to fs/iomap/ we have to add new entries
to the aiodio dmesg filter to reflect this.  It's still possible for
filesystems using iomap for directio to cough up WARNings when a direct
write collides with a buffered write, since in some cases we catch that
early enough to have the direct write return EIO.

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

