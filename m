Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD018851E
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbfHIVj3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:39:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51742 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbfHIVj3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:39:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYVpK071907
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:39:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=0SVpzReianaXB3oHVhgH6Z9u7I5pknKA+l6i4Z50CHU=;
 b=QSbHyPvjy0ljqS7QQZ5h58Qg1AQqdFW3VJdXonold3BY0eiEBxNi4FGNV6Et+ZRpEq/P
 twxWL4RmewDxyyjdJiV6UnQVsSmRbfQt4XUCYF02BtrdRJggHW+F6T2iOWeCoMWCTs64
 XsGLCjZ2bz5nm+HQTE4fw+4SdI1Cn7AHb4R/+cGXoOtcgfuXLmARJvzvESgPyomgna8l
 pljlqIGEMoBLYAWxehvWBebDZ+xmXAkW91D3WFCTvPRqZF1qRiQFbddKlxMLN6Y1xYMC
 dKES6d2V9BZU4TI3vNcyh/ThT74QHhd6VhoWFuQZ8Z7hc6pTvObEQAjuFA78UiQ0t6MQ vQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=0SVpzReianaXB3oHVhgH6Z9u7I5pknKA+l6i4Z50CHU=;
 b=VnMXfK3xpqHo7pUNy6h/mz8vjJfe7dpsdnaiyOGy/MNS5tVFh3L+8tQqT4kw0mcEu2h/
 2RnO6fpL3hQYu864sck/vS1ts9796w6/VGgzFD0smEj5KuiFouJLjaZyvWg9FWAg2VSa
 cs5N6XW+GD8gHH3qAKpuXyajXMfpH6+Zn8+hcYtZMswCFrM9OWlsW9ACizkm0kRBsAi3
 GJfimgWJWCuMzW5B0sphpoMr/3HKSxWko20CviHVygqsBOtC/stkkmhmf+zu0EUhsqRu
 uc4bRQVYlsBdK+q7jl67ye1DO0r8oCTaquvrGq6flp34PMDjeJFL2NZrmg+zn7B756fP vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2u8hpsa529-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:39:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LdJC2048096
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:39:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2u8x1h6w34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:39:27 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LcJRF019389
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:20 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:38:19 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 10/19] xfsprogs: Factor up trans roll from xfs_attr3_leaf_setflag
Date:   Fri,  9 Aug 2019 14:37:55 -0700
Message-Id: <20190809213804.32628-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190809213804.32628-1-allison.henderson@oracle.com>
References: <20190809213804.32628-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=883
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090208
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=948 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908090208
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

New delayed allocation routines cannot be handling
transactions so factor them up into the calling functions

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c      | 5 +++++
 libxfs/xfs_attr_leaf.c | 5 +----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 6245afb..8e63377 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1240,6 +1240,11 @@ xfs_attr_node_removename(
 		error = xfs_attr3_leaf_setflag(args);
 		if (error)
 			goto out;
+
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		if (error)
+			goto out;
+
 		error = xfs_attr_rmtval_remove(args);
 		if (error)
 			goto out;
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 1ac64dd..524e37a 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -2772,10 +2772,7 @@ xfs_attr3_leaf_setflag(
 			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
 	}
 
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	return xfs_trans_roll_inode(&args->trans, args->dp);
+	return error;
 }
 
 /*
-- 
2.7.4

