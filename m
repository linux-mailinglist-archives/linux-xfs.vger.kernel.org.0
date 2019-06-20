Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33BAE4D42F
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 18:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfFTQui (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 12:50:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43450 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFTQui (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:50:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGnBoR077911;
        Thu, 20 Jun 2019 16:50:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=1FcslxisFxBOaiidtuYlqyFtIGtX9q7PywYIx7GRbXQ=;
 b=lxBVPg9aKcEzmoo3Y3Dw+DUlroL3dpcvfuT39jPQBbrcbCqTQTxJZL6mydyP2wIOuXjW
 vb1NhhMur/FIUZdZ/rAXFEYzu5uubya1HKdjdxtg/2aUSvSEvRKZxxuyaj4bT81HlUwd
 1ONw5907TrDQ8Lx3mz3uq89su2ZBezB4CsYiq9wXz9CiscDh47qVqR6tGglVqD1joMW0
 1GYZHH1UUEtXKOfebTdrK2YCyJ3EN9a7HhhklA+dxfjkXgPq3hLh4TWU3T+8zkzhM147
 paS3OD+xhb8Zxnz+p4XaBFir9NTswTR+aa7fIO9479YgppPoM+1F1ihfm1WA+eQupP4y 6A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2t7809j8p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:50:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGneJN057729;
        Thu, 20 Jun 2019 16:50:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2t77ynqpgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:50:36 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5KGoZdY020127;
        Thu, 20 Jun 2019 16:50:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 09:50:34 -0700
Subject: [PATCH 10/12] xfs_io: repair_f should use its own name
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 20 Jun 2019 09:50:33 -0700
Message-ID: <156104943322.1172531.14877921651268434165.stgit@magnolia>
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

If the repair command fails, it should tag the error message with its
own name ("repair").

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/scrub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/io/scrub.c b/io/scrub.c
index 2ff1a6af..052497be 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -293,7 +293,7 @@ repair_ioctl(
 
 	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
 	if (error)
-		perror("scrub");
+		perror("repair");
 	if (meta.sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		printf(_("Corruption remains.\n"));
 	if (meta.sm_flags & XFS_SCRUB_OFLAG_PREEN)

