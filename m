Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2627563A49
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jul 2019 19:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfGIRtp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Jul 2019 13:49:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45132 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbfGIRtp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 13:49:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69Hn1FN129261;
        Tue, 9 Jul 2019 17:49:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Ez3wo8ihzwo3kk6ftyQi1XBL8iA2gvo9EuemyOL6Wfc=;
 b=ezLN4+vT2CkQ+1Gf8+7qKYVqRZuPsFmmRzemdkxQv35KFOZsS+//x2VZVeS2UB6Hubv+
 j+3lMC8u7avOTySpiEROhUSf/qQkfMCdV+Z24z/y579fq/NXQyAvW97lKnqPXKlpIS3l
 DVg0wHshAv16E3MD1NyrTiuRSJ70nKkHgGh5QciwX9wk5PKVqXnqlmLFCeaTza9c7eo3
 NCE/wuyZ7A7PU5xppVJlKfqmwNTmcpUcFAxTXdYHjGmopcnSa9d+jt2tsFeCJ9h8Klz2
 +dWVAH2XAU0krQacInBPrrlRKB6DecpQ1vwnd2hazNDsRQ2THD9U3Q0V0bkm2jNrsiJy hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2tjm9qns3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 17:49:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69Hm4Op092713;
        Tue, 9 Jul 2019 17:49:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tjjykxkm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 17:49:42 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x69HngpS015762;
        Tue, 9 Jul 2019 17:49:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 10:49:42 -0700
Subject: [PATCH 1/3] xfs: rework min log size helper
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 09 Jul 2019 10:49:41 -0700
Message-ID: <156269458116.3039184.6080699668311209553.stgit@magnolia>
In-Reply-To: <156269457497.3039184.4886490143800432410.stgit@magnolia>
References: <156269457497.3039184.4886490143800432410.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907090210
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907090210
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The recent _scratch_find_xfs_min_logblocks helper has a major thinko in
it -- it relies on feeding a too-small size to _scratch_do_mkfs so that
mkfs will tell us the minimum log size.  Unfortunately, _scratch_do_mkfs
will see that first failure and retry the mkfs without MKFS_OPTIONS,
which means that we return the minimum log size for the default mkfs
settings without MKFS_OPTIONS.

This is a problem if someone's running fstests with a set of
MKFS_OPTIONS that affects the minimum log size.  To fix this, open-code
the _scratch_do_mkfs retry behavior so that we only do the "retry
without MKFS_OPTIONS" behavior if the mkfs failed for a reason other
than the minimum log size check.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)


diff --git a/common/xfs b/common/xfs
index f8dafc6c..2b38e94b 100644
--- a/common/xfs
+++ b/common/xfs
@@ -87,16 +87,35 @@ _scratch_find_xfs_min_logblocks()
 	# minimum log size.
 	local XFS_MIN_LOG_BYTES=2097152
 
-	_scratch_do_mkfs "$mkfs_cmd" "cat" $* -N -l size=$XFS_MIN_LOG_BYTES \
+	# Try formatting the filesystem with all the options given and the
+	# minimum log size.  We hope either that this succeeds or that mkfs
+	# tells us the required minimum log size for the feature set.
+	#
+	# We cannot use _scratch_do_mkfs because it will retry /any/ failed
+	# mkfs with MKFS_OPTIONS removed even if the only "failure" was that
+	# the log was too small.
+	local extra_mkfs_options="$* -N -l size=$XFS_MIN_LOG_BYTES"
+	eval "$mkfs_cmd $MKFS_OPTIONS $extra_mkfs_options $SCRATCH_DEV" \
 		2>$tmp.mkfserr 1>$tmp.mkfsstd
 	local mkfs_status=$?
 
+	# If the format fails for a reason other than the log being too small,
+	# try again without MKFS_OPTIONS because that's what _scratch_do_mkfs
+	# will do if we pass in the log size option.
+	if [ $mkfs_status -ne 0 ] &&
+	   ! grep -q 'log size.*too small, minimum' $tmp.mkfserr; then
+		eval "$mkfs_cmd $extra_mkfs_options $SCRATCH_DEV" \
+			2>$tmp.mkfserr 1>$tmp.mkfsstd
+		mkfs_status=$?
+	fi
+
 	# mkfs suceeded, so we must pick out the log block size to do the
 	# unit conversion
 	if [ $mkfs_status -eq 0 ]; then
-		local blksz="$(grep '^log.*bsize' $tmp.mkfsstd | \
+		blksz="$(grep '^log.*bsize' $tmp.mkfsstd | \
 			sed -e 's/log.*bsize=\([0-9]*\).*$/\1/g')"
 		echo $((XFS_MIN_LOG_BYTES / blksz))
+		rm -f $tmp.mkfsstd $tmp.mkfserr
 		return
 	fi
 
@@ -104,6 +123,7 @@ _scratch_find_xfs_min_logblocks()
 	if grep -q 'minimum size is' $tmp.mkfserr; then
 		grep 'minimum size is' $tmp.mkfserr | \
 			sed -e 's/^.*minimum size is \([0-9]*\) blocks/\1/g'
+		rm -f $tmp.mkfsstd $tmp.mkfserr
 		return
 	fi
 
@@ -111,6 +131,7 @@ _scratch_find_xfs_min_logblocks()
 	echo "Cannot determine minimum log size" >&2
 	cat $tmp.mkfsstd >> $seqres.full
 	cat $tmp.mkfserr >> $seqres.full
+	rm -f $tmp.mkfsstd $tmp.mkfserr
 }
 
 _scratch_mkfs_xfs()

