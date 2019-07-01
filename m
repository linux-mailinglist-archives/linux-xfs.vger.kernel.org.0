Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC905C20E
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jul 2019 19:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727625AbfGARfr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Jul 2019 13:35:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34318 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbfGARfr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 13:35:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61HYLKs025255
        for <linux-xfs@vger.kernel.org>; Mon, 1 Jul 2019 17:35:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=rKYwCiNtViSmWrvdT2XCP6oOoMvEFhnMIxKte/az0Vs=;
 b=ECH7121sxoc1OlNpNcxJQTtB2hJSUAIvQpTWKYk9sN07sriiQA4cg6IbGCct+f/V+iem
 AJSu157sI1KjUPgoBZ8atauqKcnj/DVA4XYa/exgVl3crdFikprd0V+HxoKSUZtPaOGr
 OvgiC9lgQqj3GJ9xiwynSbA160BImZk++epbMEafUg4BlQxeWKZ0A/VycVn1/+ogWIvp
 ba4Ev3JMLSosfhQDwqvn69yXXi83rbanSRDYQbZxuMNZwxxhmsuyt7itUksSUo3rz7PT
 ZsNIXtMj1BppMhlYdFDb5hcc18VgkDCPXfU063HhwhjbRUphoDD/Nf7wwGkHlpkz4hUQ 9A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2te61dy0rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 01 Jul 2019 17:35:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61HXE8f076599
        for <linux-xfs@vger.kernel.org>; Mon, 1 Jul 2019 17:35:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2tebqg24hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 01 Jul 2019 17:35:45 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x61HZiR4020847
        for <linux-xfs@vger.kernel.org>; Mon, 1 Jul 2019 17:35:44 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 10:35:44 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/1] xfsprogs: Fix uninitialized cfg->lsunit
Date:   Mon,  1 Jul 2019 10:35:38 -0700
Message-Id: <20190701173538.29710-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=772
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=818 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

While investigating another mkfs bug, noticed that cfg->lsunit is sometimes
left uninitialized when it should not.  This is because calc_stripe_factors
in some cases needs cfg->loginternal to be set first.  This is done in
validate_logdev. So move calc_stripe_factors below validate_logdev while
parsing configs.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

---
 mkfs/xfs_mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index ddb25ec..f4a5e4b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3995,7 +3995,6 @@ main(
 	cfg.rtblocks = calc_dev_size(cli.rtsize, &cfg, &ropts, R_SIZE, "rt");
 
 	validate_rtextsize(&cfg, &cli, &ft);
-	calc_stripe_factors(&cfg, &cli, &ft);
 
 	/*
 	 * Open and validate the device configurations
@@ -4005,6 +4004,7 @@ main(
 	validate_datadev(&cfg, &cli);
 	validate_logdev(&cfg, &cli, &logfile);
 	validate_rtdev(&cfg, &cli, &rtfile);
+	calc_stripe_factors(&cfg, &cli, &ft);
 
 	/*
 	 * At this point when know exactly what size all the devices are,
-- 
2.7.4

