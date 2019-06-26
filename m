Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2846A55F08
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 04:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfFZCho (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 22:37:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59886 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfFZCho (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 22:37:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5Q2Z0rF120735;
        Wed, 26 Jun 2019 02:37:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=M0cHfUb71N8ECjgb3Km3UFRTxw3bWthiqzd/BgJUMtU=;
 b=BwE7tKNLy71/ljNFRshWk5EhSrkEMDhx0h0Wf+4y+OZvISAWTl9DxTT1UooVOE5IncrI
 AW/mplPnUuyn3QS/HTMtqB67Ns2i2FyrTGb97f4VQe3f0zIsXLanLWSV0PwsvY7lQ9U7
 xr1RTHClm0iDHuRwxkklk2oaIPJj7ObVcblJ5X02XrQFg7ii3obYAbArkaGpwWoOUnRF
 d2b1u9feR8uFM2lnMMAGEPkWw53Twl1cM1kw4frHSObawL+RXf/1s7npIJqJYOAzopkd
 E5B4TxdhvEMPfMfO8ltRqj0SKjHKG4a0BDB5YwbDVhoVuC3RjRU2xtRXEWbQuXvzJDJR 5w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2t9brt7mx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 02:37:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5Q2bYUu029261;
        Wed, 26 Jun 2019 02:37:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2t9p6uh3t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 02:37:41 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5Q2bfGc023146;
        Wed, 26 Jun 2019 02:37:41 GMT
Received: from localhost (/10.159.230.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Jun 2019 19:37:40 -0700
Subject: [PATCH 08/10] xfs_db: remove db/convert.h
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 25 Jun 2019 19:37:40 -0700
Message-ID: <156151666004.2286979.13481028354802408933.stgit@magnolia>
In-Reply-To: <156151660523.2286979.13694849827562044045.stgit@magnolia>
References: <156151660523.2286979.13694849827562044045.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260028
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

db/convert.h conflicts with include/convert.h and since the former only
has one declaration in it anyway, just get rid of it.  We'll need this
in the next patch to avoid an ugly include mess.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/Makefile  |    4 ++--
 db/command.c |    1 -
 db/command.h |    1 +
 db/convert.c |    1 -
 db/convert.h |    7 -------
 5 files changed, 3 insertions(+), 11 deletions(-)
 delete mode 100644 db/convert.h


diff --git a/db/Makefile b/db/Makefile
index 8fecfc1c..0941b32e 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -8,13 +8,13 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_db
 
 HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
-	btblock.h bmroot.h check.h command.h convert.h crc.h debug.h \
+	btblock.h bmroot.h check.h command.h crc.h debug.h \
 	dir2.h dir2sf.h dquot.h echo.h faddr.h field.h \
 	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
 	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
 	sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h \
 	fuzz.h
-CFILES = $(HFILES:.h=.c) btdump.c info.c
+CFILES = $(HFILES:.h=.c) btdump.c convert.c info.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
diff --git a/db/command.c b/db/command.c
index c7c52342..89a78f03 100644
--- a/db/command.c
+++ b/db/command.c
@@ -11,7 +11,6 @@
 #include "bmap.h"
 #include "check.h"
 #include "command.h"
-#include "convert.h"
 #include "debug.h"
 #include "type.h"
 #include "echo.h"
diff --git a/db/command.h b/db/command.h
index eacfd465..2f9a7e16 100644
--- a/db/command.h
+++ b/db/command.h
@@ -28,5 +28,6 @@ extern int		command(int argc, char **argv);
 extern const cmdinfo_t	*find_command(const char *cmd);
 extern void		init_commands(void);
 
+extern void		convert_init(void);
 extern void		btdump_init(void);
 extern void		info_init(void);
diff --git a/db/convert.c b/db/convert.c
index 01a08823..e1466057 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -6,7 +6,6 @@
 
 #include "libxfs.h"
 #include "command.h"
-#include "convert.h"
 #include "output.h"
 #include "init.h"
 
diff --git a/db/convert.h b/db/convert.h
deleted file mode 100644
index 3660cabe..00000000
--- a/db/convert.h
+++ /dev/null
@@ -1,7 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-
-extern void	convert_init(void);

