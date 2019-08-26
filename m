Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0066B9D8AE
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Aug 2019 23:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfHZVtQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 26 Aug 2019 17:49:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45102 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfHZVtQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:49:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLiVeW017363;
        Mon, 26 Aug 2019 21:49:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=c0m+5yLjf1FUMDIGZh1YWPOQ24dInwRXlgjTvHzE/+k=;
 b=UblGBYsSbXnp7YvyP6WCuY8b5AKtqDS2mE/hv/dTXAeWbrOzCq9ZztoLCbVbcgOytfcT
 QTk+cHrDOSCaKnTjBPSNDn6bCxyQEiiOZWdf4fctuA3LAygFspuzevHd7EJvILAu/Qxc
 zh98MVYOyDOfx//KWeerKCPiGMgsNKmou3RojC8rrMWb8uG6SAhzorBGmTrDfUO4IDoq
 BzplFkZFGavgDg9a828yihzQVhkstd1f89s7OpQ13D1VWj6GVNlah9me8DIRdtT0e/HB
 8HaVrXgTjyQIQdoLHbJQMrXba/RTj1azYgVP3vXFy81O4r9uv1etz1N03EwoxJcp6r3T 5g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2umqbe8333-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:49:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLmVIY041956;
        Mon, 26 Aug 2019 21:49:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2umj278r87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:49:05 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLn4nQ016966;
        Mon, 26 Aug 2019 21:49:04 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:49:04 -0700
Subject: [PATCH 3/4] xfs: don't return _QUERY_ABORT from
 xfs_rmap_has_other_keys
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 26 Aug 2019 14:49:02 -0700
Message-ID: <156685614244.2853532.3739810624053899109.stgit@magnolia>
In-Reply-To: <156685612356.2853532.10960947509015722027.stgit@magnolia>
References: <156685612356.2853532.10960947509015722027.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=959
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260202
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260201
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The xfs_rmap_has_other_keys helper aborts the iteration as soon as it
has an answer.  Don't let this abort leak out to callers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index e6aeb390b2fb..819693ef852c 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2540,8 +2540,11 @@ xfs_rmap_has_other_keys(
 
 	error = xfs_rmap_query_range(cur, &low, &high,
 			xfs_rmap_has_other_keys_helper, &rks);
+	if (error < 0)
+		return error;
+
 	*has_rmap = rks.has_rmap;
-	return error;
+	return 0;
 }
 
 const struct xfs_owner_info XFS_RMAP_OINFO_SKIP_UPDATE = {

