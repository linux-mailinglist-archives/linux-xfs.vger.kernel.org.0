Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D977125E1
	for <lists+linux-xfs@lfdr.de>; Fri,  3 May 2019 02:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfECA5e (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 2 May 2019 20:57:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48736 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfECA5e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 May 2019 20:57:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x430sZUC006529;
        Fri, 3 May 2019 00:57:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=DRyvLT2PeZ3hfE8s0nvHWeyuh2JIb5bZicY9z92SMfg=;
 b=Pe9UWzG7InxoLtM/gDUCVrnGc9RJlPjuGy6NZiYmbcrvI7zN6MJZws+FVAnwU3QX/tKd
 OUYPGBesuiT40mT3ZWQ3DmUvX/X7QT679TSgA23vShVM9Umcw5yOUDfiOkQ/pSM95u2R
 fAdbnFZNmTtUQpyLroo78W8WGKNzJTsxA1vm1AKxZ/3oDSqto6b+DDwlPg6cuniw4/TB
 lWOAdTCHWBc3fTUIbtFQEPLo9LX5kEaXtsM77/YZN8sMlKLcJvCcZcLxRnH174KHO6Ct
 fTfzZO6JclLU/lhVKfDi3JkZZU9SlcstQWhhir2jZA2r7QUaaSkv8ewODpKAea5FZDpX /w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2s6xhyv1fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 00:57:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x430tf4J093718;
        Fri, 3 May 2019 00:57:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2s7p8a2ux4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 00:57:22 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x430vLAw006241;
        Fri, 3 May 2019 00:57:21 GMT
Received: from localhost (/10.145.179.89)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 May 2019 17:57:21 -0700
Date:   Thu, 2 May 2019 17:57:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] mkfs: enable reflink and rmap by default
Message-ID: <20190503005717.GO5207@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905030004
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905030004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable reflink and reverse mapping by default.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0862621a..3874f7dd 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2021,14 +2021,14 @@ _("sparse inodes not supported without CRC support\n"));
 		}
 		cli->sb_feat.spinodes = false;
 
-		if (cli->sb_feat.rmapbt) {
+		if (cli->sb_feat.rmapbt && cli_opt_set(&mopts, M_RMAPBT)) {
 			fprintf(stderr,
 _("rmapbt not supported without CRC support\n"));
 			usage();
 		}
 		cli->sb_feat.rmapbt = false;
 
-		if (cli->sb_feat.reflink) {
+		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
 			fprintf(stderr,
 _("reflink not supported without CRC support\n"));
 			usage();
@@ -3934,8 +3934,8 @@ main(
 			.dirftype = true,
 			.finobt = true,
 			.spinodes = true,
-			.rmapbt = false,
-			.reflink = false,
+			.rmapbt = true,
+			.reflink = true,
 			.parent_pointers = false,
 			.nodalign = false,
 			.nortalign = false,
