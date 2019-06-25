Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C86C520D7
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 05:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbfFYDEp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 23:04:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51088 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728088AbfFYDEp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 23:04:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5P2xIbF093268
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:04:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=a3xg1+wZpOqFv/iMzj/+5hIx2uktLy2qTojiJiu9LS4=;
 b=AzVNfj4/k5vKQ2mnHQgzsVexSMgaKUCioeoLN6f7webd0VTrbboTdWH4nGy17cVvv14y
 m1AmasUVttKzpi6sVxYpeShHVpqjbJH/9qeBue7ljNMCKP6jgIoYUQ3pUwWjR16vd5V+
 n4b7ye09ZtC+XGMM0Mmpclp+Rtq/jbFoNTqCM2Q2el6XRn5w/D37iJsxjSKWCOOzk5sE
 AIiPaGReFG8WBe4SwyUYGKgAXn+dUy5WlwSy1vsJp/X2OFga15/4wrwPmbrNY7z3Lin8
 iUldsD57hf66r7AozIqn3dCvwhOCwRP24i3znZYne5pOqzKwfPhaplka55uFYuWuE0BI 5g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2t9c9phf7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:04:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5P32hg3098162
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2t9p6tx1wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:43 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5P32eqH013497
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 20:02:39 -0700
Subject: [PATCH 1/5] xfs: attribute scrub should use seen_enough to pass
 error values
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Jun 2019 20:02:39 -0700
Message-ID: <156143175903.2221192.5580755117803210207.stgit@magnolia>
In-Reply-To: <156143175282.2221192.3546713622107331271.stgit@magnolia>
References: <156143175282.2221192.3546713622107331271.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906250022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906250023
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

