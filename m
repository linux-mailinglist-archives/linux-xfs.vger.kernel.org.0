Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E464157303
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 22:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfFZUqu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 16:46:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41822 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfFZUqt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:46:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKiMIS126544
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=a3xg1+wZpOqFv/iMzj/+5hIx2uktLy2qTojiJiu9LS4=;
 b=C4LhNovP8T4flRhGLxIuCbaBUtLLfkXXQoe47SCieJsFsZC03/Tc6rVVu4vFe3PNTvKa
 aoQxJejkOmRW4yTLK+SPGUjr2iFs00JfFdKISyAN4dwc71eD/PgpclnAmT1FD8TCzzFp
 5O3jm4iICSM0ZZbvop1JzxoxUFYp2oSf9Gwfg+ORbLSTIbFhgwb0Bsoy/f+0/xUB/5Qt
 5xFjCCItTl7ts1n7FDYkxQqeS6ePC6caF4r9ZsRlV3lGT148kOQnd+GdIk08ePkmzdwm
 TJ1UklfkMjFSdI5tH3MGm/wpAkcv32QyGSZtzhK9JX9i7NXk/P8fzcVnYca3XoSEYoPA Nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2t9c9pvkcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKjtXM016150
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2t99f4nwd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:47 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5QKklhj008019
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 13:46:46 -0700
Subject: [PATCH 2/6] xfs: attribute scrub should use seen_enough to pass
 error values
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 26 Jun 2019 13:46:45 -0700
Message-ID: <156158200593.495944.1612838829393872431.stgit@magnolia>
In-Reply-To: <156158199378.495944.4088787757066517679.stgit@magnolia>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260240
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260240
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're iterating all the attributes using the built-in xattr
iterator, we can use the seen_enough variable to pass error codes back
to the main scrub function instead of flattening them into 0/1.  This
will be used in a more exciting fashion in upcoming patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/attr.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index dce74ec57038..f0fd26abd39d 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -83,7 +83,7 @@ xchk_xattr_listent(
 	sx = container_of(context, struct xchk_xattr, context);
 
 	if (xchk_should_terminate(sx->sc, &error)) {
-		context->seen_enough = 1;
+		context->seen_enough = error;
 		return;
 	}
 
@@ -125,7 +125,7 @@ xchk_xattr_listent(
 					     args.blkno);
 fail_xref:
 	if (sx->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		context->seen_enough = 1;
+		context->seen_enough = XFS_ITER_ABORT;
 	return;
 }
 
@@ -464,6 +464,10 @@ xchk_xattr(
 	error = xfs_attr_list_int_ilocked(&sx.context);
 	if (!xchk_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
 		goto out;
+
+	/* Did our listent function try to return any errors? */
+	if (sx.context.seen_enough < 0)
+		error = sx.context.seen_enough;
 out:
 	return error;
 }

