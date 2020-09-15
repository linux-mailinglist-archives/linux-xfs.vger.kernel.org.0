Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC264269B7F
	for <lists+linux-xfs@lfdr.de>; Tue, 15 Sep 2020 03:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgIOBpf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 14 Sep 2020 21:45:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46244 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgIOBp0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:45:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1hkw4147281;
        Tue, 15 Sep 2020 01:45:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0KJQL+rMZcad1L1L6dmzQBU6KxLdHJR9CCKNoVJSzv8=;
 b=SMh7szOdu1yWIjEvLW6WiAW8nyDosagcvUfy1MYcHDgXT9tQdHAfTHOeAvqEbaZIFK3u
 jOkKLf/cCo062AgFk4QwfN+5hbn3PKAKdnjTspDPGMr+My98reyIThM1hQnZL/qBib0d
 2RtR/IC418V8Yqsn2kYh32L+7Bmehz6Ox2FD+tDBv+PIs42yBtSFbox/balnUdTeoGjE
 zXn6Otp4jjzBROTrVRuvrqzgP8X9Fu3ZdMLVcsBOq0R6QXbNxtCuxbWtYdrqZMeIFHre
 SaDLu3KA2knmcK5zJsmx3nTEaWtGAj/q2Ea5gEL9uSa/68muWioUL0j40QzqfChcxhOG BA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33gnrqsxxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:45:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1jNFW116705;
        Tue, 15 Sep 2020 01:45:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33h88382mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:45:23 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08F1jNl7004759;
        Tue, 15 Sep 2020 01:45:23 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:45:22 +0000
Subject: [PATCH 23/24] generic/204: sync before scrub hits EIO
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:45:21 -0700
Message-ID: <160013432161.2923511.669329888874845585.stgit@magnolia>
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=913
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=941 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Let's see if we can prevent fs corruption warnings by flushing dirty
data to disk before the test ends.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/204 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/generic/204 b/tests/generic/204
index 7250c00a..22d6fed5 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -18,6 +18,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
 	rm -f $tmp.*
+	sync
 }
 
 # get standard environment, filters and checks

