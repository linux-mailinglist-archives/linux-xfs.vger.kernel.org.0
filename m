Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1480D4D426
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 18:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfFTQts (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 12:49:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54120 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfFTQts (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:49:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGnFZI173765;
        Thu, 20 Jun 2019 16:49:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=P8bM2e67km9mk4q5PmFJltCJHwVkP2NctkGQilyNVLs=;
 b=hmqwVg7PqlWs33JqqunfEJxxX3++JAUrXrbaUFotQOdhKtOPPblNyUIlfFPgF7oQlF42
 ZPL+4PhCAacPyg49UcH1zNOYN8FXqXtCt+zKakPfemYbiqHWjP2dgzCGoihd/Uf3DN8v
 92iwtu+WAKYkzZ887JkGjlL9cvHsruw8BAr4WY2g9E5+fMZCogtGvg8nRkQIRxzujyvK
 jtr3SepuTp3TtRqq6HE/UlPAjezM3lOPm1P86hcz5fcmrGy1VyXC6z7OjrIcaG+U+i1w
 o6f0IIzcoxGewzKu22hBf0RljNNqfabSL7I6ntGMb4ZY4NFYAfFcYZ0JjGCpFX9Aj6Mj HQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2t7809j75t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:49:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGneaO057714;
        Thu, 20 Jun 2019 16:49:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2t77ynqp09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:49:44 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5KGnhpv019565;
        Thu, 20 Jun 2019 16:49:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 09:49:43 -0700
Subject: [PATCH 02/12] libfrog: cvt_u64 should use strtoull, not strtoll
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 20 Jun 2019 09:49:42 -0700
Message-ID: <156104938235.1172531.7192571581132527840.stgit@magnolia>
In-Reply-To: <156104936953.1172531.2121427277342917243.stgit@magnolia>
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906200122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906200122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

cvt_u64 converts a string to an unsigned 64-bit number, so it should use
strtoull, not strtoll because we don't want negative numbers here.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/convert.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/libfrog/convert.c b/libfrog/convert.c
index 62397507..8d4d4077 100644
--- a/libfrog/convert.c
+++ b/libfrog/convert.c
@@ -105,14 +105,14 @@ cvt_s16(
  */
 uint64_t
 cvt_u64(
-	char		*s,
-	int		base)
+	char			*s,
+	int			base)
 {
-	long long	i;
-	char		*sp;
+	unsigned long long	i;
+	char			*sp;
 
 	errno = 0;
-	i = strtoll(s, &sp, base);
+	i = strtoull(s, &sp, base);
 	/*
 	 * If the input would over or underflow, return the clamped
 	 * value and let the user check errno.  If we went all the

