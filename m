Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1B4D39595
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 21:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730227AbfFGT3a (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 7 Jun 2019 15:29:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55240 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729625AbfFGT3a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 15:29:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57JSTlP086194;
        Fri, 7 Jun 2019 19:29:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=cLUYR7lR7dAoVeRRK8hDuf+smYdvAWE5jnOA5xuLS2M=;
 b=4x6dBO7Jm/aRFk4HRSJqPefbtDUUl+eYctj1cNm9aTkG2c5G5ZdpxI8GFMsSRC1gPusr
 3t+qUA+OuUFUWmmbdHdOQ6q//4Jthqiqus77NwiaZL79fSSvDCs52joxM6mEX1vPfauW
 T3Dm2FmvWPgemTCeSacx8iGPZvVg3sShuuY8aj/UcWkvZXXER9nFRUgS/CyvaK6E6DwR
 pFeDo1ZVikK1wEC/rDPyWUI85eQG99ChE38LMEMUo5VCeCwETJO4U8c3JI5brztrSck8
 cqTlf/cUmJwSYhDetz7fvMxsN4k5CIB/QXWcgbxnVxqN9AStMdnBr+hd7Ix57MtgSD9Y Xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2suj0r0314-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 19:29:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57JSi3Y129251;
        Fri, 7 Jun 2019 19:29:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2swnhde7dk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 19:29:27 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x57JTRXw005231;
        Fri, 7 Jun 2019 19:29:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Jun 2019 12:29:27 -0700
Subject: [PATCH 4/9] libxfs: link to the scrub ioctl from xfsctl.3
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 07 Jun 2019 12:29:26 -0700
Message-ID: <155993576618.2343530.17591105410246159765.stgit@magnolia>
In-Reply-To: <155993574034.2343530.12919951702156931143.stgit@magnolia>
References: <155993574034.2343530.12919951702156931143.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=789
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906070130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=853 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906070130
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
index 94a6ad4b..cdf0fcfc 100644
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

