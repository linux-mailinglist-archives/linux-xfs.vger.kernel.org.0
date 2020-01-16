Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB84B13D382
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Jan 2020 06:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgAPFNS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Jan 2020 00:13:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49042 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbgAPFNS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 00:13:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G5DGwD173217;
        Thu, 16 Jan 2020 05:13:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=yOZnlwLQ+XwcbxlaSPkShBDrXRd3qOTQ05ftAdkM+0w=;
 b=g1P+AzQ8OaB4MmoC+pRkXX8Sh6EUsyIbyJ1wmNFZMhJh9iPMu3PprAIxVEOvQsOiCCu2
 WAEb5zjIiDDUN574fM3qJa9gJBcfyNKYEC4tyF/okISsFJykb89tcN6trkla6EGSTLsy
 NvOhfDJwyYCosRTdPtkHn4e7woFKkzHedV+XrwI3RyQJmk1nBuNzpBgNPJaS1CxWHbuI
 LMlUpgTUuDJ68xGLTFBt25jxGkwxBjfDbCqTAp76jEKgomQuYv+52asMoJZXZW0kmiPl
 YoA3KgbLPF1aDRWKcw8M7kspmNmjbB3aisWZugma8EZNXoO/NY///AWhbkRxF4fHUVWu Rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xf73yr7fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:13:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G59MGX097041;
        Thu, 16 Jan 2020 05:11:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xhy22mrku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:11:15 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G5BEfw000776;
        Thu, 16 Jan 2020 05:11:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 21:11:14 -0800
Subject: [PATCH 6/7] generic/108: skip test if we can't initialize scsi_debug
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Wed, 15 Jan 2020 21:11:13 -0800
Message-ID: <157915147326.2374854.964133120890777930.stgit@magnolia>
In-Reply-To: <157915143549.2374854.7759901526137960493.stgit@magnolia>
References: <157915143549.2374854.7759901526137960493.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160043
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Correct the logic in this test that detects failed scsi_debug
initializations.  Downgrade the reaction to _notrun since the filesystem
under test did not fail, just our mockup disk.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/108 |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)


diff --git a/tests/generic/108 b/tests/generic/108
index 9b4fe60f..ab6101f2 100755
--- a/tests/generic/108
+++ b/tests/generic/108
@@ -49,9 +49,7 @@ rm -f $seqres.full
 
 # _get_scsi_debug_dev returns a scsi debug device with 128M in size by default
 SCSI_DEBUG_DEV=`_get_scsi_debug_dev 512 512 0 300`
-if [ "$SCSI_DEBUG_DEV" == "/dev/" ]; then
-	_fail "Failed to initialize scsi debug device"
-fi
+test -b "$SCSI_DEBUG_DEV" || _notrun "Failed to initialize scsi debug device"
 echo "SCSI debug device $SCSI_DEBUG_DEV" >>$seqres.full
 
 # create striped volume with 4MB stripe size

