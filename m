Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B1222003D
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jul 2020 23:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgGNVqZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Jul 2020 17:46:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37318 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGNVqZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 17:46:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELc5hj065569;
        Tue, 14 Jul 2020 21:46:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9PGjj14JllFYbNj8E3NwAnEJ4KTGh5s68I+j+JrKdQo=;
 b=xatYazoXFP8B3fOo/b1q9U81YdkmaEgsnben9hzOxNoLNxzWdQJHvnFI9dXop+LFJ00m
 WW2GSTTZDkpGCfz68DkznCgnjwSvT3sRxMn61ev+hLfzZ1EKxg0G/A8S0nA+xzkucAm5
 amnCnHuc2zq3yuzPORb+r/OHUq1SfJ/GymLG6CSkVAO2FwIqK12WkIjB5WfmHV6FFmb7
 lALHytxKMqAimPRoMOp02Pa07cPNPiDoyO3rfPqUFSVEPZX/FSN/OMuW8U6srcgzGBZZ
 IaxwHKl54409e6ekEQSWXop05gw7s8/lsJcTRmhKXaNwpaiIQ84UdxoRjXZITVKOuyfX xQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3274ur82tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 21:46:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELhcG8146638;
        Tue, 14 Jul 2020 21:46:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 327q0q0wj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 21:46:22 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06ELkLC9024804;
        Tue, 14 Jul 2020 21:46:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 14:46:20 -0700
Subject: [PATCH 2/4] xfs_repair: fix clearing of quota CHKD flags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 14:46:19 -0700
Message-ID: <159476317959.3156699.12804674592240361133.stgit@magnolia>
In-Reply-To: <159476316511.3156699.17998319555266568403.stgit@magnolia>
References: <159476316511.3156699.17998319555266568403.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

XFS_ALL_QUOTA_CHKD, being a OR of [UGP]QUOTA_CHKD, is a bitset of the
possible *incore* quota checked flags.  This means that it cannot be
used in a comparison with the *ondisk* quota checked flags because V4
filesystems set OQUOTA_CHKD, not the [GU]QUOTA_CHKD flags (which are V5
flags).

If you have a V4 filesystem with user quotas disabled but either group
or project quotas enabled, xfs_repair will /not/ claim that the quota
info will be regenerated on the next mount like it does in any other
situation.  This is because the ondisk qflags field has OQUOTA_CHKD set
but repair fails to notice.

Worse, if you have a V4 filesystem with user and group quotas enabled
and mild corruption, repair will claim that the quota info will be
regenerated.  If you then mount the fs with only group quotas enabled,
quotacheck will not run to correct the data because repair failed to
clear OQUOTA_CHKD properly.

These are fairly benign and unlikely scenarios, but when we add
quotacheck capabilities to xfs_repair, it will complain about the
incorrect quota counts, which causes regressions in xfs/278.

Fixes: 342aef1ec0ec ("xfsprogs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/xfs_repair.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 3bfc8311..1a51abd1 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1100,10 +1100,13 @@ _("Warning:  project quota information would be cleared.\n"
 
 	dsb = sbp->b_addr;
 
-	if (be16_to_cpu(dsb->sb_qflags) & XFS_ALL_QUOTA_CHKD) {
+	if (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD) {
 		do_warn(_("Note - quota info will be regenerated on next "
 			"quota mount.\n"));
-		dsb->sb_qflags &= cpu_to_be16(~XFS_ALL_QUOTA_CHKD);
+		dsb->sb_qflags &= cpu_to_be16(~(XFS_UQUOTA_CHKD |
+						XFS_GQUOTA_CHKD |
+						XFS_PQUOTA_CHKD |
+						XFS_OQUOTA_CHKD));
 	}
 
 	if (copied_sunit) {

