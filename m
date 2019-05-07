Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 285911687F
	for <lists+linux-xfs@lfdr.de>; Tue,  7 May 2019 18:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfEGQ5S (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 7 May 2019 12:57:18 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60018 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbfEGQ5S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 May 2019 12:57:18 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x47GhpIT178078;
        Tue, 7 May 2019 16:57:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=ex6EY1rjgH/SYnmAoJp7fkPANLKzJdi+4DciAFX6N2s=;
 b=E6DiFqQgkNxQwtOIJau4Q5ufQ6ADnxL51Zq/KkqO9FY8F7sFa9QC+f9HLsakOLxDSwpP
 HtlaS/s6BNl0AmykcNQR4T3u5eaZTKYroRj2Onh7SUoMvJia+oXpJ72bXqVX0WTR++BM
 yZBD6dZC5PVzlVNBnqWjlr0R6sGjnTa+E82mcXwVGkdth3lMjyRmDqCYpU+3zxpUCLTp
 GRMTFQZEXYR+3Ho+hi4s+vqqpE2g1nSd8YerujGrXa8gVeS9CSr01YDwQ8+1fnC0qorO
 E/sslsHbE7XgP6cvDuRRDTRnc7ueKDteCzMfUESxbrpJ8gZgM276TIbbNeQDFST4jMWV LQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2s94b5xtbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 May 2019 16:57:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x47Gv24d042554;
        Tue, 7 May 2019 16:57:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2s9ayf0gd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 May 2019 16:57:12 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x47GvA1s015267;
        Tue, 7 May 2019 16:57:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 May 2019 09:57:10 -0700
Subject: [PATCH 3/3] xfs/294: calculate space to reserve for fragmentation
 test
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, xuyang2018.jy@cn.fujitsu.com,
        fstests@vger.kernel.org
Date:   Tue, 07 May 2019 09:57:09 -0700
Message-ID: <155724822935.2624631.18285317888168151966.stgit@magnolia>
In-Reply-To: <155724821034.2624631.4172554705843296757.stgit@magnolia>
References: <155724821034.2624631.4172554705843296757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9250 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905070109
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9250 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905070109
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This test requires us to fragment free space, and in part accomplishes
this by fallocating 400M of a 512M filesystem, then fallocating another
70M, and then using dd to eat remaining space.  However, it's risky to
assume the 400M figure because new features such as reflink and rmap
have per-ag metadata reservations which add to overhead.  Therefore,
reserve the 70M fragment file first, then try to fallocate 95% of the
remaining free space.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/294 |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)


diff --git a/tests/xfs/294 b/tests/xfs/294
index bce4d07b..af0fc124 100755
--- a/tests/xfs/294
+++ b/tests/xfs/294
@@ -70,15 +70,16 @@ for I in `seq 1 100`; do
 	touch $SCRATCH_MNT/testdir/12345678901234567890$I;
 done
 
-# Now completely fragment freespace.
-# Consume most of it:
-$XFS_IO_PROG -f -c "falloc 0 400m" $SCRATCH_MNT/fillfile ||
-	_fail "Could not allocate space"
-
 # File to fragment:
 $XFS_IO_PROG -f -c "falloc 0 70m" $SCRATCH_MNT/fragfile ||
 	_fail "Could not allocate space"
 
+# Now completely fragment freespace.
+# Consume most of it:
+space=$(stat -f -c '%f * %S * 95 / 100' $SCRATCH_MNT | $BC_PROG)
+$XFS_IO_PROG -f -c "falloc 0 $space" $SCRATCH_MNT/fillfile ||
+	_fail "Could not allocate space"
+
 df -h $SCRATCH_MNT >> $seqres.full 2>&1
 
 # Fill remaining space; let this run to failure

