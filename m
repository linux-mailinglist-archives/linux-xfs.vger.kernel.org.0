Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA541687E
	for <lists+linux-xfs@lfdr.de>; Tue,  7 May 2019 18:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfEGQ5N (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 7 May 2019 12:57:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59296 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbfEGQ5N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 May 2019 12:57:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x47Ghck6183690;
        Tue, 7 May 2019 16:57:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=RM8799B0CEK6QOlagumfjozdrzMqZX7QpuAhC0GxiIQ=;
 b=vYEhGUy5nN4bt8rp+jZzEI7CAwUccq5VOLtCR5+KZsCVgkKyaAezq87UUv05JgaQWyZf
 IllvOdfOU1SBQj/QfOo55k1yaB/YX04DMIpU3+OZyVG9HFtcVLE6ma62j+4zA80ElWkt
 BR+G9BfOW5uIlP83qsYa1jljeukhHvm8hji5BeBCOxYX8EfFEWkJIEauHbOPr4rnKzsr
 vA5ASYS46dYp2XQ2htTn1HMvqtuRqV1doaISRnNNEkTRg3cnfgT/8u2T3Kq1KfjThe4v
 ZB3FMRqRjI0iVgMDJm/5KG4EKYtB24neSsf6oN1VlER3PbypYIYuBQ19eTKHD74+G5g1 XQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2s94b0prur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 May 2019 16:57:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x47Gv09A193856;
        Tue, 7 May 2019 16:57:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2s94b9kmbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 May 2019 16:57:05 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x47Gv47k028398;
        Tue, 7 May 2019 16:57:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 May 2019 09:57:04 -0700
Subject: [PATCH 2/3] xfs/216: always disable rmap and reflink when creating
 log size test fs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, xuyang2018.jy@cn.fujitsu.com,
        fstests@vger.kernel.org
Date:   Tue, 07 May 2019 09:57:03 -0700
Message-ID: <155724822301.2624631.12786681370099485635.stgit@magnolia>
In-Reply-To: <155724821034.2624631.4172554705843296757.stgit@magnolia>
References: <155724821034.2624631.4172554705843296757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9250 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=983
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905070109
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9250 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905070109
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This test seems to check that log sizes scale up properly with the size
of the filesystem, given a carefully controlled set of mkfs parameters.
Since turning on reflink or rmap will change the minimum log size,
change the test to detect their presence and ensure they're disabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/216 |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/216 b/tests/xfs/216
index b1fd8ecc..15ff9ae1 100755
--- a/tests/xfs/216
+++ b/tests/xfs/216
@@ -37,12 +37,18 @@ _require_loop
 LOOP_DEV=$SCRATCH_MNT/test_fs
 LOOP_MNT=$SCRATCH_MNT/test_fs_dir
 
+loop_mkfs_opts=
+$MKFS_XFS_PROG 2>&1 | grep -q rmapbt && \
+	loop_mkfs_opts="$loop_mkfs_opts -m rmapbt=0"
+$MKFS_XFS_PROG 2>&1 | grep -q reflink && \
+	loop_mkfs_opts="$loop_mkfs_opts -m reflink=0"
+
 _do_mkfs()
 {
 	for i in $*; do
 		echo -n "fssize=${i}g "
 		$MKFS_XFS_PROG -f -b size=4096 -l version=2 \
-			-d name=$LOOP_DEV,size=${i}g |grep log
+			-d name=$LOOP_DEV,size=${i}g $loop_mkfs_opts |grep log
 		mount -o loop -t xfs $LOOP_DEV $LOOP_MNT
 		echo "test write" > $LOOP_MNT/test
 		umount $LOOP_MNT > /dev/null 2>&1

