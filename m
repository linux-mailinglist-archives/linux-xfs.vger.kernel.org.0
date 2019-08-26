Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAFD79D84A
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Aug 2019 23:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbfHZVan (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 26 Aug 2019 17:30:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52298 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbfHZVan (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:30:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLQuMk003368;
        Mon, 26 Aug 2019 21:30:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=OYdXw+TsXOiJKJwE+vinik4Ds/Orja/ERK4rSUl3XLo=;
 b=q2i337P+eI86jHg3zM+TJbEPB+xUYAIxK8XxWEv2KWnY8y7ImdcrUuhUJgxMq3V52iQu
 OE7cNOuKPbELXlr8Nn6RQR9fgqJuacz8pHT+ELtvpePS1dKFNQCJASQb1olUPKB/KgLU
 sBBQpChBFGMnIpk/IOi5G8QJOfFFO8ZG31JMCs9T1nO4qq2qktWOJ3Vat10iczmPjeS1
 acN7adThi3N/vt9WrwRPd2kcgluE8rdYpiKwQ9zBKyoNQZL4AhSatls+p64/PQr6jxmW
 DZQRYU/AvR9RJetuv5PVahmImTdGZC59ZTynC6uMFrUgt01zln8YTmsgVoJmbgKN7OE8 3Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2umqbe80h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:30:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLItqT184976;
        Mon, 26 Aug 2019 21:30:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2umj2xvxyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:30:39 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLUcs2029105;
        Mon, 26 Aug 2019 21:30:39 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:30:38 -0700
Subject: [PATCH 07/11] xfs_scrub: record disk LBA size
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:30:37 -0700
Message-ID: <156685503753.2841898.8227493950009379521.stgit@magnolia>
In-Reply-To: <156685499099.2841898.18430382226915450537.stgit@magnolia>
References: <156685499099.2841898.18430382226915450537.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remember the size (in bytes) of a logical block on the disk.  We'll use
this in subsequent patches to improve the ability of media scans to
report on which files are corrupt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/disk.c |    7 +++----
 scrub/disk.h |    3 ++-
 2 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/scrub/disk.c b/scrub/disk.c
index dd109533..b728d1c7 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -193,7 +193,6 @@ disk_open(
 #endif
 	struct disk		*disk;
 	bool			suspicious_disk = false;
-	int			lba_sz;
 	int			error;
 
 	disk = calloc(1, sizeof(struct disk));
@@ -205,10 +204,10 @@ disk_open(
 		goto out_free;
 
 	/* Try to get LBA size. */
-	error = ioctl(disk->d_fd, BLKSSZGET, &lba_sz);
+	error = ioctl(disk->d_fd, BLKSSZGET, &disk->d_lbasize);
 	if (error)
-		lba_sz = 512;
-	disk->d_lbalog = log2_roundup(lba_sz);
+		disk->d_lbasize = 512;
+	disk->d_lbalog = log2_roundup(disk->d_lbasize);
 
 	/* Obtain disk's stat info. */
 	error = fstat(disk->d_fd, &disk->d_sb);
diff --git a/scrub/disk.h b/scrub/disk.h
index 74a26d98..36bfb826 100644
--- a/scrub/disk.h
+++ b/scrub/disk.h
@@ -10,7 +10,8 @@
 struct disk {
 	struct stat	d_sb;
 	int		d_fd;
-	int		d_lbalog;
+	unsigned int	d_lbalog;
+	unsigned int	d_lbasize;	/* bytes */
 	unsigned int	d_flags;
 	unsigned int	d_blksize;	/* bytes */
 	uint64_t	d_size;		/* bytes */

