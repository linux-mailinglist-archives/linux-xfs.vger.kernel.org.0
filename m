Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7F702440E
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 01:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfETXSk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 19:18:40 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38224 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfETXSk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:18:40 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNIcLq153033;
        Mon, 20 May 2019 23:18:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=iqJ16Eb3/L52jFwmrY/lvYSYqOo0HT2TwofgmWwsRtU=;
 b=d7ksOof9e4yjX+MFqJwurmhsGtMBMSC+rUoBjPghfYfj8k9buvo2bz8Aes7SOPKqye8R
 U2JaU5bCwNFYuHzr7FAM6HAp+pvNzKUhLbB/Q18rUEUzBcUJBfTMWPxIdYgRrvomjJDX
 RFa/qytZ2M8iu4BJ2NBCArCldZSQcVDZVQvb02q5Rf8CEwIXfKkIa3Uck39hzB062lJo
 FFM0//mjMDtDjfvzfUT8jMWOwJC80Krfc7RE07DLsOASFP2SZk20vn+fV37Jp6rvusgT
 UInkhHWhtcVMw9Uh7HXYnq/ySdxN1eoUJg38fNMdwZgh0VT0w1pNxfd0d/eHzjQKkhRc 8A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2sj7jdj5qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:18:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNIIfw079665;
        Mon, 20 May 2019 23:18:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2skudb298j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:18:35 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KNIYhD008725;
        Mon, 20 May 2019 23:18:34 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 23:18:34 +0000
Subject: [PATCH 4/8] libxfs: link to the scrub ioctl from xfsctl.3
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 20 May 2019 16:18:33 -0700
Message-ID: <155839431352.68923.1725339674504868925.stgit@magnolia>
In-Reply-To: <155839428721.68923.11962490742479847985.stgit@magnolia>
References: <155839428721.68923.11962490742479847985.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=813
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200143
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=865 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Link to the scrub ioctl documentation from xfsctl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man3/xfsctl.3 |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 7437246a..1e98b2a4 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -411,6 +411,12 @@ See
 .BR ioctl_xfs_fsbulkstat (2)
 for more information.
 
+.TP
+.B XFS_IOC_SCRUB_METADATA
+See
+.BR ioctl_xfs_scrub_metadata (2)
+for more information.
+
 .PP
 .nf
 .B XFS_IOC_THAW

