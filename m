Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 684A515243B
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Feb 2020 01:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgBEArC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Feb 2020 19:47:02 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45482 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727619AbgBEArC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:47:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150dQQA123829;
        Wed, 5 Feb 2020 00:47:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=GpHvEWcZReaWylEgfeiVILojJZeJJoOInPnYwY6LYPU=;
 b=As7PagEn16Op65FLaofADeQxtmNFkGhx07+znrQJxxmlwsAGuxVTP4ILnI+c0E6dDzpw
 ppJbLF0kvrbg1NynZf1mqCpopD9t1TBDqwrxefgUvbIvuh9cv3vRn1GXBVEpLxnkRLcA
 HM728F6+PwXPHkraJ+ZLqDeDbIMm1qxKVdC1r3RMgKdtyFIpPSBV3ZKnFlKZp+S12DNM
 /zzMqXTo2HPB/1s0W/O7Xte1hUaswz3xNBbXzhIAKA/wWBxnmMN4He6rw0vj8pINTZNO
 WCYiJYV0SbO4GvfBp1YdFCwwN0d8ALpXZsAlkyW80ZhS0rjXSJUkTys22pd2Z7YB5IF3 qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xykbp00jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:46:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150e5B3115820;
        Wed, 5 Feb 2020 00:46:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xykc30y2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:46:59 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0150kvnN010320;
        Wed, 5 Feb 2020 00:46:57 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:46:57 -0800
Subject: [PATCH 3/7] xfs_repair: enforce that inode btree chunks can't point
 to AG headers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Tue, 04 Feb 2020 16:46:56 -0800
Message-ID: <158086361666.2079685.8451949513769071894.stgit@magnolia>
In-Reply-To: <158086359783.2079685.9581209719946834913.stgit@magnolia>
References: <158086359783.2079685.9581209719946834913.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_repair has a very old check that evidently excuses the AG 0 inode
btrees pointing to blocks that are already marked XR_E_INUSE_FS* (e.g.
AG headers).  mkfs never formats filesystems that way and it looks like
an error, so purge the check.  After this, we always complain if inodes
overlap with AG headers because that should never happen.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/globals.c    |    1 -
 repair/globals.h    |    1 -
 repair/scan.c       |   19 -------------------
 repair/xfs_repair.c |    7 -------
 4 files changed, 28 deletions(-)


diff --git a/repair/globals.c b/repair/globals.c
index dcd79ea4..8a60e706 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -73,7 +73,6 @@ int	lost_gquotino;
 int	lost_pquotino;
 
 xfs_agino_t	first_prealloc_ino;
-xfs_agino_t	last_prealloc_ino;
 xfs_agblock_t	bnobt_root;
 xfs_agblock_t	bcntbt_root;
 xfs_agblock_t	inobt_root;
diff --git a/repair/globals.h b/repair/globals.h
index 008bdd90..2ed5c894 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -114,7 +114,6 @@ extern int		lost_gquotino;
 extern int		lost_pquotino;
 
 extern xfs_agino_t	first_prealloc_ino;
-extern xfs_agino_t	last_prealloc_ino;
 extern xfs_agblock_t	bnobt_root;
 extern xfs_agblock_t	bcntbt_root;
 extern xfs_agblock_t	inobt_root;
diff --git a/repair/scan.c b/repair/scan.c
index c383f3aa..05707dd2 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1645,13 +1645,6 @@ scan_single_ino_chunk(
 				break;
 			case XR_E_INUSE_FS:
 			case XR_E_INUSE_FS1:
-				if (agno == 0 &&
-				    ino + j >= first_prealloc_ino &&
-				    ino + j < last_prealloc_ino) {
-					set_bmap(agno, agbno, XR_E_INO);
-					break;
-				}
-				/* fall through */
 			default:
 				/* XXX - maybe should mark block a duplicate */
 				do_warn(
@@ -1782,18 +1775,6 @@ _("inode chunk claims untracked block, finobt block - agno %d, bno %d, inopb %d\
 				break;
 			case XR_E_INUSE_FS:
 			case XR_E_INUSE_FS1:
-				if (agno == 0 &&
-				    ino + j >= first_prealloc_ino &&
-				    ino + j < last_prealloc_ino) {
-					do_warn(
-_("inode chunk claims untracked block, finobt block - agno %d, bno %d, inopb %d\n"),
-						agno, agbno, mp->m_sb.sb_inopblock);
-
-					set_bmap(agno, agbno, XR_E_INO);
-					suspect++;
-					break;
-				}
-				/* fall through */
 			default:
 				do_warn(
 _("inode chunk claims used block, finobt block - agno %d, bno %d, inopb %d\n"),
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9295673d..3e9059f3 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -460,13 +460,6 @@ calc_mkfs(xfs_mount_t *mp)
 		first_prealloc_ino = XFS_AGB_TO_AGINO(mp, fino_bno);
 	}
 
-	ASSERT(M_IGEO(mp)->ialloc_blks > 0);
-
-	if (M_IGEO(mp)->ialloc_blks > 1)
-		last_prealloc_ino = first_prealloc_ino + XFS_INODES_PER_CHUNK;
-	else
-		last_prealloc_ino = XFS_AGB_TO_AGINO(mp, fino_bno + 1);
-
 	/*
 	 * now the first 3 inodes in the system
 	 */

