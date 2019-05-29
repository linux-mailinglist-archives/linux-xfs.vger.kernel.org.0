Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBE32D2D6
	for <lists+linux-xfs@lfdr.de>; Wed, 29 May 2019 02:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfE2A0B (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 28 May 2019 20:26:01 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:34428 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfE2A0A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 May 2019 20:26:00 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4T0JGps160337;
        Wed, 29 May 2019 00:25:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=SSArIKnW+cJfykaFt9TNspkNzZlUiObF3rAPpBu2Dj4=;
 b=N99IGjb5YajIv38iWXH1hfWGHRP519k6/jTNpRq0+pRTgpQ10DS4n8Y4oEKYYA/vUdoT
 I6xEdcS6tw9Z91zJfJOgSm+8ok/xTJaJcKvbIBqQft2PfF84+CPHz6snmUexqngbh+Ka
 jZaZHB3lNQhofA9dKAR8rKKJYvCXjcwXHj6+5u3tBNZPX/oaZYuKbPbZfJCez/2QUwtQ
 uVtsQtd25eEFm5iVm4ct6GiiWjUGN4EOzY7xxPVJhFJh3ldAFZPUh2ZZVx+F3xFOaUOg
 dsFuzzkooKipWWWtMTUxMKVHqfHIAaro4/HF6zQclpR6x2S6f+ETNjIr+o2iirTArP1q 3A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2spu7deqey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 00:25:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4T0PobI015279;
        Wed, 29 May 2019 00:25:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2srbdx38ex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 00:25:50 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4T0PkKh008478;
        Wed, 29 May 2019 00:25:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 May 2019 17:25:46 -0700
Date:   Tue, 28 May 2019 17:25:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: inode btree scrubber should calculate im_boffset
 correctly
Message-ID: <20190529002545.GB5231@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9271 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905290000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9271 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The im_boffset field is in units of bytes, whereas XFS_INO_OFFSET
returns a value in units of inodes.  Convert the units so that scrub on
a 64k-block filesystem works correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 693eb51f5efb..9b47117180cb 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -252,7 +252,8 @@ xchk_iallocbt_check_cluster(
 	ir_holemask = (irec->ir_holemask & cluster_mask);
 	imap.im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
 	imap.im_len = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
-	imap.im_boffset = XFS_INO_TO_OFFSET(mp, irec->ir_startino);
+	imap.im_boffset = XFS_INO_TO_OFFSET(mp, irec->ir_startino) <<
+			mp->m_sb.sb_inodelog;
 
 	if (imap.im_boffset != 0 && cluster_base != 0) {
 		ASSERT(imap.im_boffset == 0 || cluster_base == 0);
