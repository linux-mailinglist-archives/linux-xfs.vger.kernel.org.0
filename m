Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9D9E186E9C
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Mar 2020 16:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731483AbgCPPcC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Mar 2020 11:32:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39078 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731545AbgCPPcB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 11:32:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GFSpRf187571;
        Mon, 16 Mar 2020 15:31:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=SKJ6mA6OOfszmh1Pgl0Yaa0luTrL3Y6sY4uxi29Y8VY=;
 b=wYWd9gBF+i0If11UNSPZpLyjmLnnvfPZnwza3oV6vt/G7abXgIDPzPHf2a/R3bESEb5Q
 spkACnTDfcQbjxAq6TbYJMnNIThckzBQMVbO1nCAxLLQbxcXD86PMZkFtXkgbeoHVb2z
 2ZP2RuwuhJ/K1fTmpAquwhAAgXRss5sQoohGV7dOAkSsrmH64VLjPY/zrickIXUMSksY
 1gRBhRS6mWFQBEJvHfzcQDYEiONQ+JEi1vGdmvdAHGSC70/0OksSIASlLVc7NgMLvsLg
 Uo7TgHDx0t4kf+UvlcFSn7q9ZvVIDPNGSUa1HBnuMhIqiXrQMq8AUj/ElONJ3aKQOaER pA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yrq7kqke6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 15:31:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GFRjMc195069;
        Mon, 16 Mar 2020 15:31:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ys929xasa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 15:31:58 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02GFVut9017103;
        Mon, 16 Mar 2020 15:31:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 08:31:56 -0700
Date:   Mon, 16 Mar 2020 08:31:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix incorrect test in xfs_alloc_ag_vextent_lastblock
Message-ID: <20200316153155.GE256767@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9561 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160074
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9561 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160074
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When I lifted the code in xfs_alloc_ag_vextent_lastblock out of a loop,
I forgot to convert all the accesses to len to be pointer dereferences.

Coverity-id: 1457918
Fixes: 5113f8ec3753ed ("xfs: clean up weird while loop in xfs_alloc_ag_vextent_near")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 337822115bbc..203e74fa64aa 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1514,7 +1514,7 @@ xfs_alloc_ag_vextent_lastblock(
 	 * maxlen, go to the start of this block, and skip all those smaller
 	 * than minlen.
 	 */
-	if (len || args->alignment > 1) {
+	if (*len || args->alignment > 1) {
 		acur->cnt->bc_ptrs[0] = 1;
 		do {
 			error = xfs_alloc_get_rec(acur->cnt, bno, len, &i);
