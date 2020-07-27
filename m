Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96B422F9CF
	for <lists+linux-xfs@lfdr.de>; Mon, 27 Jul 2020 22:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgG0UHI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 27 Jul 2020 16:07:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51686 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgG0UHH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jul 2020 16:07:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RK6k0Y028177
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 20:07:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=UzXI3Noj9pnKJEjFLS36aQ3SARmIU6l3FG44lMV7nh0=;
 b=Jg4NZagthL+DlZMW2jLYndnfOKFPpEQKmlYEXLrFCIx79IukhAJcciaRTKvk1OT8k1hN
 0MIQGI1kYJyF0nNbREohvcqTflDrgC4Gex+XCr/5yfzwuIQOVGUsKyV9t7moo73kY1+P
 0mYucz10n8VYvH5xgDlcT4krLNY2YEe2tBvFUGu3MZyb23fcs4e68s10YWHdUlRLa5En
 DfFftjktbXMxneCyvjB916WKVBxceQDTJcCacZMk8JIUsaRFzVghWC2EWZEFrUpjgWQg
 ZfXSiepqeGsOL4VbJxFl3e8qhlvAvXukvySyWWyLba6xvEO7meNdBVupLESImuZw4xUy 5A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32hu1j3meb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 20:07:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RK3I7d152380
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 20:07:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32hu5rc8ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 20:07:06 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06RK75a7006169
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 20:07:05 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jul 2020 13:07:04 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 2/2] xfs: Fix compiler warning in xfs_attr_shortform_add
Date:   Mon, 27 Jul 2020 13:06:56 -0700
Message-Id: <20200727200656.6318-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200727200656.6318-1-allison.henderson@oracle.com>
References: <20200727200656.6318-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=1 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 malwarescore=0 spamscore=0 suspectscore=1 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270134
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix compiler warning warning: variable 'error' set but not used in
xfs_attr_shortform_add. error is used only in an ASSERT so only declare
error when DEBUG is set.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index ad7b351..db985b8 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -715,7 +715,10 @@ xfs_attr_shortform_add(
 {
 	struct xfs_attr_shortform	*sf;
 	struct xfs_attr_sf_entry	*sfe;
-	int				offset, size, error;
+	int				offset, size;
+#if DEBUG
+	int				error;
+#endif
 	struct xfs_mount		*mp;
 	struct xfs_inode		*dp;
 	struct xfs_ifork		*ifp;
-- 
2.7.4

