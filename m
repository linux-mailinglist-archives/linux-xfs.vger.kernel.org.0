Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C49F6EA2D0
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Oct 2019 18:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfJ3RxX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 30 Oct 2019 13:53:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39612 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727267AbfJ3RxX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 13:53:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9UHinLS151840;
        Wed, 30 Oct 2019 17:53:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=HE5QkdAmxs7Z+z7ZJyEx5nes3udKJgzaiTF8sp2+SEI=;
 b=detE2UPdhVBQYtXF3iFf8/KYIbSCTEOcyxpb7b5ItCxQ4eabujcTeSw2K3Pes5vVmiIl
 wQT2CPNYwfQHl23+V4pELn5cTTTd64BWZ+GlEVeJVkuScieL0GEwiYKU0pBKNpB+j3h6
 AkVEB/112fqaEHJYMp666HB7NhcmENL/mGCtEYBYWSKDda9YBVg3xL2Nb0bxflQr0/O4
 pz2XAzhFqcNOg3YYh8zU53I0eOZDVgXEATi+clDuyi9CWwU+DWmIO7xmZ3dQH+ZNuaOV
 20UT2YG10YAIp+F3p319hBk8NkqaQ47QV6gIrFd0mCZ5VL0bN+aVXo5bCUme0jKnptv/ 8Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vxwhfe0ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 17:53:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9UHjWVh182482;
        Wed, 30 Oct 2019 17:53:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vxwhwh62p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 17:53:18 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9UHrGPQ006461;
        Wed, 30 Oct 2019 17:53:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Oct 2019 10:53:16 -0700
Date:   Wed, 30 Oct 2019 10:53:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/5] libxfs: fix typo in message about write verifier
Message-ID: <20191030175315.GQ15222@magnolia>
References: <157176999124.1458930.5678023201951458107.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <157176999124.1458930.5678023201951458107.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910300155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910300155
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix a silly typo.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/rdwr.c |    2 +-
 po/pl.po      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 0d3e6089..7080cd9c 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1117,7 +1117,7 @@ libxfs_writebufr(xfs_buf_t *bp)
 		bp->b_ops->verify_write(bp);
 		if (bp->b_error) {
 			fprintf(stderr,
-	_("%s: write verifer failed on %s bno 0x%llx/0x%x\n"),
+	_("%s: write verifier failed on %s bno 0x%llx/0x%x\n"),
 				__func__, bp->b_ops->name,
 				(long long)bp->b_bn, bp->b_bcount);
 			return bp->b_error;
diff --git a/po/pl.po b/po/pl.po
index ab5b11da..87109f6b 100644
--- a/po/pl.po
+++ b/po/pl.po
@@ -7466,7 +7466,7 @@ msgstr "%s: błąd - wykonano pwrite tylko %d z %d bajtów\n"
 
 #: .././libxfs/rdwr.c:1138
 #, c-format
-msgid "%s: write verifer failed on %s bno 0x%llx/0x%x\n"
+msgid "%s: write verifier failed on %s bno 0x%llx/0x%x\n"
 msgstr "%s: weryfikacja zapisu nie powiodła się na %s bno 0x%llx/0x%x\n"
 
 #: .././libxfs/trans.c:733
