Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A972820F
	for <lists+linux-xfs@lfdr.de>; Thu, 23 May 2019 18:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730893AbfEWQCY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 May 2019 12:02:24 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44052 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730790AbfEWQCY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 12:02:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4NFsN2Q100412
        for <linux-xfs@vger.kernel.org>; Thu, 23 May 2019 16:02:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=NXvjJ7OjLTvCuNIxptap90g7tkM21yMZBZ7dHScoIbg=;
 b=4fJmxUqHBQ70LHaXaiVoYmSiyzGAYRx5TMDdHfWMozWi0t9GyDi9S0CFB/snDSSH2YrX
 gF/Lak0OF/73fhN6e3Bpnwm6WAvYF1GuVk0kNynUPsApHj1B/kN+y6fM2L9vM+K+9iU5
 3t4okspf8miRoZ3wCDIMKiIs2aHYAVK0TXCf7aAgko4sJxAWMLw8s20C9Vxhh9tdx6pI
 CgrHJyp5v6K73sClIIhta+9ZLXJNlm6/tWF3CbnCRPaEwmzhJTkMwuCFlW5lUqXixzk/
 SfBmlHVLRn/tiaZ8W1f31Mi3jViIFcnH2kMiGm822ti9dOTDbA/Fni/7akWy3IqFKQEL 4w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2smsk5kdg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 23 May 2019 16:02:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4NG1kV8082924
        for <linux-xfs@vger.kernel.org>; Thu, 23 May 2019 16:02:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2smsgvk0kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 23 May 2019 16:02:21 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4NG2Kxh010766
        for <linux-xfs@vger.kernel.org>; Thu, 23 May 2019 16:02:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 May 2019 16:02:20 +0000
Date:   Thu, 23 May 2019 09:02:19 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix broken log reservation debugging
Message-ID: <20190523160219.GH5141@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9265 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905230108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9265 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905230108
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xlog_print_tic_res() is supposed to print a human readable string for
each element of the log ticket reservation array.  Unfortunately, I
forgot to update the string array when we added rmap & reflink support,
so the debug message prints "region[3]: (null) - 352 bytes" which isn't
useful at all.  Add the missing elements and add a build check so that
we don't forget again to add a string when adding a new XLOG_REG_TYPE.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 457ced3ee3e1..2466b0f5b6c4 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2069,7 +2069,7 @@ xlog_print_tic_res(
 
 	/* match with XLOG_REG_TYPE_* in xfs_log.h */
 #define REG_TYPE_STR(type, str)	[XLOG_REG_TYPE_##type] = str
-	static char *res_type_str[XLOG_REG_TYPE_MAX + 1] = {
+	static char *res_type_str[] = {
 	    REG_TYPE_STR(BFORMAT, "bformat"),
 	    REG_TYPE_STR(BCHUNK, "bchunk"),
 	    REG_TYPE_STR(EFI_FORMAT, "efi_format"),
@@ -2089,8 +2089,15 @@ xlog_print_tic_res(
 	    REG_TYPE_STR(UNMOUNT, "unmount"),
 	    REG_TYPE_STR(COMMIT, "commit"),
 	    REG_TYPE_STR(TRANSHDR, "trans header"),
-	    REG_TYPE_STR(ICREATE, "inode create")
+	    REG_TYPE_STR(ICREATE, "inode create"),
+	    REG_TYPE_STR(RUI_FORMAT, "rui_format"),
+	    REG_TYPE_STR(RUD_FORMAT, "rud_format"),
+	    REG_TYPE_STR(CUI_FORMAT, "cui_format"),
+	    REG_TYPE_STR(CUD_FORMAT, "cud_format"),
+	    REG_TYPE_STR(BUI_FORMAT, "bui_format"),
+	    REG_TYPE_STR(BUD_FORMAT, "bud_format"),
 	};
+	BUILD_BUG_ON(ARRAY_SIZE(res_type_str) != XLOG_REG_TYPE_MAX + 1);
 #undef REG_TYPE_STR
 
 	xfs_warn(mp, "ticket reservation summary:");
