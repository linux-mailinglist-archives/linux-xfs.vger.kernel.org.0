Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA0FD4D43B
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 18:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfFTQvk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 12:51:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44368 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfFTQvk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:51:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGnFdY069745;
        Thu, 20 Jun 2019 16:51:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=81Pr0Cg9EYUl+9RPdf5KWHlPWW65BofaKve5+r3wEmE=;
 b=Vga31mrgeG+Yt14C3CofAZBJPs+p1N/+mYEavfdMlll18HPDLdWdktqfIG0Nn/8klrJX
 1+t5WihVz6FgHMfs1ZO47sqnD8IxlZeyBgJTU05yrF1Mr8Y1gvJ3MgqJJz7t/+ligRfv
 EyuN8GdkVPCzcn/Rm5VVc8BS/xHKDb6xZ4eYPV4YfxQ1WgpYhyURRTywEnwNv8Rz8lW7
 dt929SLEJy7YbIpi5UBPHtbKL+v0WNwDXM6eVG7SAlo1yhlbpIdIAHDWEpd/PLEIeuda
 Ll13NMC0cWrPEOfivXKrRo2/xxnFMTKEcxDz6CFAT5sMQtIyAsaJYmFkdaiPW8Q6eWD4 nQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t7809j9vx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:51:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGnCIS121147;
        Thu, 20 Jun 2019 16:49:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2t77ynqqat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:49:37 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5KGnbg6024274;
        Thu, 20 Jun 2019 16:49:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 09:49:37 -0700
Subject: [PATCH 01/12] libfrog: don't set negative errno in conversion
 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 20 Jun 2019 09:49:36 -0700
Message-ID: <156104937602.1172531.10936665245404210667.stgit@magnolia>
In-Reply-To: <156104936953.1172531.2121427277342917243.stgit@magnolia>
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=758
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906200122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=799 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906200122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't set errno to a negative value when we're converting integers.
That's a kernel thing; this is userspace.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/convert.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)


diff --git a/libfrog/convert.c b/libfrog/convert.c
index ed4cae7f..62397507 100644
--- a/libfrog/convert.c
+++ b/libfrog/convert.c
@@ -47,7 +47,7 @@ cvt_s64(
 		return i;
 
 	/* Not all the input was consumed, return error. */
-	errno = -ERANGE;
+	errno = ERANGE;
 	return INT64_MIN;
 }
 
@@ -68,7 +68,7 @@ cvt_s32(
 	if (errno)
 		return i;
 	if (i > INT32_MAX || i < INT32_MIN) {
-		errno = -ERANGE;
+		errno = ERANGE;
 		return INT32_MIN;
 	}
 	return i;
@@ -91,7 +91,7 @@ cvt_s16(
 	if (errno)
 		return i;
 	if (i > INT16_MAX || i < INT16_MIN) {
-		errno = -ERANGE;
+		errno = ERANGE;
 		return INT16_MIN;
 	}
 	return i;
@@ -123,7 +123,7 @@ cvt_u64(
 		return i;
 
 	/* Not all the input was consumed, return error. */
-	errno = -ERANGE;
+	errno = ERANGE;
 	return UINT64_MAX;
 }
 
@@ -144,7 +144,7 @@ cvt_u32(
 	if (errno)
 		return i;
 	if (i > UINT32_MAX) {
-		errno = -ERANGE;
+		errno = ERANGE;
 		return UINT32_MAX;
 	}
 	return i;
@@ -167,7 +167,7 @@ cvt_u16(
 	if (errno)
 		return i;
 	if (i > UINT16_MAX) {
-		errno = -ERANGE;
+		errno = ERANGE;
 		return UINT16_MAX;
 	}
 	return i;

