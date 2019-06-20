Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF6AD4D437
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 18:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfFTQvS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 12:51:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44014 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFTQvS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:51:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGnGgE077957;
        Thu, 20 Jun 2019 16:51:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=qyfCHTsbncxlfUfF7s2eYhK+6IagBY4eqr2PrMcqCkQ=;
 b=Sgi7bg/83DASxG0cBBIxUOIhZsBPztdpA3DeBBuPu321siNMIvYXiMX9CJ5nu11p4WPs
 GRf3XVsUm2+WmQPBTHIQwQubBfpQWn1IPI/f0O6zl5cdhcyQtbmIOqN8ufZflZ8ifyDG
 a3RoOaiU7tnIf72P2oFwcBjyI1ih4Qw7Knunpl3ttULoRDwui320IuKcyR3ISFM0pIlc
 6IBQCTRy6VQhIVSBvnx6L4+QcNUPLjISort97P+PIMoB3tS1/VMTWjIfY2yRsdWGgPh+
 adewZOY3RQzLiuPczArVxyhzOyk5kQoWzhXsxxkZBfBiVGgJr85U3exojT1jPKUAX63g nQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t7809j8sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:51:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGoWvw057346;
        Thu, 20 Jun 2019 16:51:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2t77ypfs7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:51:15 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5KGpEgr020508;
        Thu, 20 Jun 2019 16:51:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 09:51:14 -0700
Subject: [PATCH 4/9] man: link to the SCRUB_METADATA ioctl manpage from
 xfsctl.3
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 20 Jun 2019 09:51:13 -0700
Message-ID: <156104947386.1174403.3374265373047115552.stgit@magnolia>
In-Reply-To: <156104944877.1174403.14568482035189263260.stgit@magnolia>
References: <156104944877.1174403.14568482035189263260.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=879
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906200122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=923 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906200122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Link to the scrub ioctl documentation from xfsctl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man3/xfsctl.3 |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 94a6ad4b..78fad975 100644
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
@@ -436,6 +442,7 @@ as they are not of general use to applications.
 .BR ioctl_xfs_fsgetxattr (2),
 .BR ioctl_xfs_fsop_geometry (2),
 .BR ioctl_xfs_fsbulkstat (2),
+.BR ioctl_xfs_scrub_metadata (2),
 .BR fstatfs (2),
 .BR statfs (2),
 .BR xfs (5),

