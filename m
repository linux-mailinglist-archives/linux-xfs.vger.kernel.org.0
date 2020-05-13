Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7921D0EFA
	for <lists+linux-xfs@lfdr.de>; Wed, 13 May 2020 12:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733026AbgEMJsO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 May 2020 05:48:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40022 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733024AbgEMJsN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 05:48:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04D9h8LY021476;
        Wed, 13 May 2020 09:48:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=M9f22pix6sGmZGJQEzn4zeCqKpeE34MvPJzVQ1yF3Ik=;
 b=ILTZ4qex3Htk/PwyQdKGLoJrbbHslJiC+rty0LUtcUnRzBjHSk8hlQZGJjcDNcP32hkc
 QHrFnxVKDudP2i/FSZ+gs8zh8LAzQGU3z4UvFfVFzWm449tQDWed7oWUO5Fg5YbRFddN
 dg7gQrYrKrLEGojewxXABbaTBHmOUtug4NwSCi7mt0QCDzRTD43IwWp5ydGdMw426hsY
 qweIIchvAG6KhIFL1KRFLrBHPqPs/NB9EhtYE1DtHCHEKIXhgulXI8zSkhdyq77i7ZhF
 H4o+SE/244Heov/5PTMPpY3505twCUOsl2Hy3apNqF9t01s/iMw2krIM38JEloJgPOz3 0Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3100xwb6er-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 13 May 2020 09:48:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04D9gcVT116320;
        Wed, 13 May 2020 09:48:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3100yr1fes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 09:48:10 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04D9m9lm026506;
        Wed, 13 May 2020 09:48:09 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 May 2020 02:48:09 -0700
Date:   Wed, 13 May 2020 12:48:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] xfs: fix error code in xfs_iflush_cluster()
Message-ID: <20200513094803.GF347693@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005130088
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1011 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130088
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Originally this function used to always return -EFSCORRUPTED on error
but now we're trying to return more informative error codes.
Unfortunately, there was one error path missed.  If this kmem_alloc()
allocation fails then we need to return -ENOMEM instead of success.

Fixes: f20192991d79 ("xfs: simplify inode flush error handling")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/xfs/xfs_inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ab31a5dec7aab..63aeda7cbafb0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3505,8 +3505,10 @@ xfs_iflush_cluster(
 
 	cilist_size = igeo->inodes_per_cluster * sizeof(struct xfs_inode *);
 	cilist = kmem_alloc(cilist_size, KM_MAYFAIL|KM_NOFS);
-	if (!cilist)
+	if (!cilist) {
+		error = -ENOMEM;
 		goto out_put;
+	}
 
 	mask = ~(igeo->inodes_per_cluster - 1);
 	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
-- 
2.26.2

