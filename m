Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816F4203DA6
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Jun 2020 19:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729808AbgFVRRR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Jun 2020 13:17:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43250 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729309AbgFVRRR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 13:17:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05MHBjMI020518
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 17:17:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=NK5Q6Hq+XJpfmjeEhKh3Lxwqpje2RNstw9bcoRQl8W0=;
 b=wHb3yTx6iMp4HALnzQrTMiSvLXbKmrlIkDaf3fAAeycLku9TbG77gBUVjrHg8UFMbFxs
 ZrTzYq+dbDuDAMyP3Xyf9ZFx7208NmNM9Y8PcQvUts3tmP5eJdCwUQb4TvFzqWkoKvm3
 ENYO3SZ7YrqG0kPOTOpoYRfEF+8fvlxJGMdlYRxaDNGR3jBGWr2hIwLVmwiZYDCKs+J6
 uleeFiRkWpoDTLyFaXj1yCrofYCUmsykStZqVP/9rDmxQbHrx+PKc1997XRXDfV/gykJ
 dHjKTzdSL9pNpaDhoHav57W/K3TBqHD6OMVaNXMDC9M0qNkKGvOXsi46R8QXCm84J57V Xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31sebbgnax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 17:17:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05MHDbBZ033954
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 17:17:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31sv1m3cs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 17:17:15 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05MHHEsg013100
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 17:17:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 22 Jun 2020 17:17:14 +0000
Date:   Mon, 22 Jun 2020 10:17:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: don't eat an EIO/ENOSPC writeback error when scrubbing
 data fork
Message-ID: <20200622171713.GG11245@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=1 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006220120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 adultscore=0 impostorscore=0 cotscore=-2147483648 mlxscore=0
 suspectscore=1 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006220120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The data fork scrubber calls filemap_write_and_wait to flush dirty pages
and delalloc reservations out to disk prior to checking the data fork's
extent mappings.  Unfortunately, this means that scrub can consume the
EIO/ENOSPC errors that would otherwise have stayed around in the address
space until (we hope) the writer application calls fsync to persist data
and collect errors.  The end result is that programs that wrote to a
file might never see the error code and proceed as if nothing were
wrong.

xfs_scrub is not in a position to notify file writers about the
writeback failure, and it's only here to check metadata, not file
contents.  Therefore, if writeback fails, we should stuff the error code
back into the address space so that an fsync by the writer application
can pick that up.

Fixes: 99d9d8d05da2 ("xfs: scrub inode block mappings")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/bmap.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 7badd6dfe544..03be7cf3fe5a 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -47,7 +47,15 @@ xchk_setup_inode_bmap(
 	    sc->sm->sm_type == XFS_SCRUB_TYPE_BMBTD) {
 		inode_dio_wait(VFS_I(sc->ip));
 		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
-		if (error)
+		if (error == -ENOSPC || error == -EIO) {
+			/*
+			 * If writeback hits EIO or ENOSPC, reflect it back
+			 * into the address space mapping so that a writer
+			 * program calling fsync to look for errors will still
+			 * capture the error.
+			 */
+			mapping_set_error(VFS_I(sc->ip)->i_mapping, error);
+		} else if (error)
 			goto out;
 	}
 
