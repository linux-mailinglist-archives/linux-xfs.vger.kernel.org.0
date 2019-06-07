Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E02223958F
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 21:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbfFGT25 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 7 Jun 2019 15:28:57 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45142 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729625AbfFGT25 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 15:28:57 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57JSqQx101191;
        Fri, 7 Jun 2019 19:28:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=1FcslxisFxBOaiidtuYlqyFtIGtX9q7PywYIx7GRbXQ=;
 b=KwBo+SPQ0YGc0pgwuQ4omcGYlRfUedCZaDSSjeKggu2UeSfsfQvINhUaO9RZewbMifQz
 PYHkUBKAaYx/jIyUn2+PCewH7xbJkH3F68k7tA9Vq0BxpxeEPWDuNmZYlHk6JYB6QIzu
 ToX8UAWZPvaOAUMps35vePoJ2/6Ye0WgrmudjFuAb7u4TiDcTOG8qYCry7UQ6OYI/4vr
 xk0ojmcKwavsSpFhgWwtg9XXIt+eBUSlypN2Du3/ekkL/vRkHXsbexpbDj5CYkW1f6dl
 7v/FRaqTnOOtMlclllYlwYBKCwjUAM1OcLUIw9ChkDKN/WnqZwnwGhsir+vJ6P51vT6O HA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2sueve0eby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 19:28:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57JSGR5169014;
        Fri, 7 Jun 2019 19:28:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2swngn8a43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 19:28:53 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x57JSrED005022;
        Fri, 7 Jun 2019 19:28:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Jun 2019 12:28:52 -0700
Subject: [PATCH 5/6] xfs_io: repair_f should use its own name
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 07 Jun 2019 12:28:51 -0700
Message-ID: <155993573179.2343365.6485890004354925274.stgit@magnolia>
In-Reply-To: <155993569512.2343365.15510991248022865602.stgit@magnolia>
References: <155993569512.2343365.15510991248022865602.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906070130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906070130
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

