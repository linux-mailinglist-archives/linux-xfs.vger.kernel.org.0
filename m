Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47BB363763
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jul 2019 16:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfGIOA1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Jul 2019 10:00:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45394 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfGIOA1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 10:00:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69Dx4kV123361;
        Tue, 9 Jul 2019 13:59:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=Z5wB35sw+tOLaSeBbctmeZJ/BsBuw/TkoSb9bk1dE0E=;
 b=idRX1bKK/K9qkluebluVfh9KNzbQil4YH7NKNy4zff9dy20XoFGHhKJrWlwBydWEWgyS
 bfFzD6KO96zC5JIbg9Iwzqmq0ogxOs7kHMZkSgGHrRX+EZjB3GaWLkfjNlxaEb2fIv2+
 +MPuRB+UjlIaOFalhCivUe+LrCPk3uC0XeFJ344C8UymWDT1sv7Rkn7UFckfq2DIoAHC
 sJrewZX3VOC37Y908y8/CRgLEmzcVxW7mNClsjScd1YCR9HFSBzwwpIDe7oCdF9B+2NC
 etKH2kEdUyM6h9+j9R9bFaPWm6w/tq+MNDHRy2mjo7uVugZBk0J8xKaIdKZPl4e+q22o YA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2tjm9qmf6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 13:59:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69Dw0dB071183;
        Tue, 9 Jul 2019 13:59:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2tmmh2yv3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 13:59:43 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x69Dxhqi024598;
        Tue, 9 Jul 2019 13:59:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 06:59:43 -0700
Date:   Tue, 9 Jul 2019 06:59:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: bump INUMBERS cursor correctly in xfs_inumbers_walk
Message-ID: <20190709135943.GF5167@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9312 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907090166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9312 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907090167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

There's a subtle unit conversion error when we increment the INUMBERS
cursor at the end of xfs_inumbers_walk.  If there's an inode chunk at
the very end of the AG /and/ the AG size is a perfect power of two, that
means we can have inodes, that means that the startino of that last
chunk (which is in units of AG inodes) will be 63 less than (1 <<
agino_log).  If we add XFS_INODES_PER_CHUNK to the startino, we end up
with a startino that's larger than (1 << agino_log) and when we convert
that back to fs inode units we'll rip off that upper bit and wind up
back at the start of the AG.

Fix this by converting to units of fs inodes before adding
XFS_INODES_PER_CHUNK so that we'll harmlessly end up pointing to the
next AG.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_itable.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index cda8ae94480c..a8a06bb78ea8 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -338,15 +338,14 @@ xfs_inumbers_walk(
 		.xi_version	= XFS_INUMBERS_VERSION_V5,
 	};
 	struct xfs_inumbers_chunk *ic = data;
-	xfs_agino_t		agino;
 	int			error;
 
 	error = ic->formatter(ic->breq, &inogrp);
 	if (error && error != XFS_IBULK_ABORT)
 		return error;
 
-	agino = irec->ir_startino + XFS_INODES_PER_CHUNK;
-	ic->breq->startino = XFS_AGINO_TO_INO(mp, agno, agino);
+	ic->breq->startino = XFS_AGINO_TO_INO(mp, agno, irec->ir_startino) +
+			XFS_INODES_PER_CHUNK;
 	return error;
 }
 
