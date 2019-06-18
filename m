Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63DAC4ACE7
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 23:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbfFRVHT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 17:07:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38140 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731068AbfFRVHN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 17:07:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IL4Fge045604;
        Tue, 18 Jun 2019 21:07:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=R7eHZdFo5VpeykbIJ+fHXXz1JWICxA6vjXnC+u8sv8M=;
 b=D4qdrMqWo1kOAL/Go0lcpeO/iK1USHAi8c/sgV+W6ybWpTVIjtXxf9InuwGblM90qf56
 lkF7J1TS8/sPlNFuRMNvePpgG98w+xtkKfNwpm7VVm2jvmmZaGjG+K4krEfcpUw/HxwC
 pftpZ7V/tUppBaFdnCs7pIYciB7DT/jCuHNmfrhNPlFmeG7FnD2d0/XlwALI+6PC8dNn
 H+AIZlmIXe973BJRNXVNkUEYl0LB1WajOfAt8TsrjjXnClpSjcoiXDShpQbG8H2/8bR2
 BQbdeCnWnPvokvzfNd9dAzzsIfdV8nyh/twUelyRttPtjm9Tv1/VFY5QlxHc/tB0dMcy FA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t4saqertb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 21:07:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IL6R7i061269;
        Tue, 18 Jun 2019 21:07:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2t5mgc6mku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 21:07:10 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5IL7APT000793;
        Tue, 18 Jun 2019 21:07:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 14:07:09 -0700
Subject: [PATCH 1/4] dump: _cleanup_dump should only check the scratch fs if
 the test required it
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 18 Jun 2019 14:07:08 -0700
Message-ID: <156089202883.345809.17656192140244878661.stgit@magnolia>
In-Reply-To: <156089201978.345809.17444450351199726553.stgit@magnolia>
References: <156089201978.345809.17444450351199726553.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

_cleanup_dump always tries to check the scratch fs, even if the caller
didn't actually _require_scratch.  If a previous test wrote garbage to
the scratch device then the dump test will fail here when repair
stumbles over the garbage.

This was observed by running xfs/016 and xfs/036 in succession.  xfs/016
writes 0xc6 to the scratch device and tries to format a small log.  If
the log is too small the format fails and the test will _notrun.  The
subsequent xfs/036 will _notrun and then _cleanup_dump if no tape device
is set, at which point we try to check the scratch device and logprint
aborts due to the abnormal log size (0xc6c6c6c6).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/dump |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/dump b/common/dump
index 7c4c9cd8..2b8e0893 100644
--- a/common/dump
+++ b/common/dump
@@ -250,7 +250,7 @@ _cleanup_dump()
 	mv $dir.$seq $dir
     done
 
-    if [ $status -ne $NOTRUNSTS ]; then
+    if [ -f ${RESULT_DIR}/require_scratch ] && [ $status -ne $NOTRUNSTS ]; then
 	# Sleep added to stop _check_scratch_fs from complaining that the
 	# scratch_dev is still busy
 	sleep 10

