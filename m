Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F4837DC0
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Jun 2019 21:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbfFFT5g (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 6 Jun 2019 15:57:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46346 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727082AbfFFT5g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jun 2019 15:57:36 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56Jm2qQ004400
        for <linux-xfs@vger.kernel.org>; Thu, 6 Jun 2019 12:57:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=24MHLLGqYZxaQd4lPGtfDBv8bEUygL+chwiIq5mhvro=;
 b=ms2nyxb0HQPnK1XC1du2FAEJH0sAvzlmjJpWWVNxj+RskS9nzG8Q1AA9eDTzN8KpKq7C
 fth4bV3scJEqgPAq2MnCQwr8ER9KV87qC88zBZVf1rNnZvhL/x8wWZ8q6cPVboF6Qj+L
 RFn8ibDlq61kx1sJNP52jsLVzUbGBya+dFg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sy5hk11ug-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 06 Jun 2019 12:57:34 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 6 Jun 2019 12:57:32 -0700
Received: by devvm4715.prn2.facebook.com (Postfix, from userid 136023)
        id 2D34536C65B4; Thu,  6 Jun 2019 12:57:31 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Sheena Artrip <sheenobu@fb.com>
Smtp-Origin-Hostname: devvm4715.prn2.facebook.com
To:     Eric Sandeen <sandeen@sandeen.net>
CC:     <sheena.artrip@gmail.com>, <linux-xfs@vger.kernel.org>,
        Sheena Artrip <sheenobu@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2] xfs_restore: detect rtinherit on destination
Date:   Thu, 6 Jun 2019 12:57:24 -0700
Message-ID: <20190606195724.2975689-1-sheenobu@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <e6968aa2-a5ad-4964-2966-589486e4a251@sandeen.net>
References: <e6968aa2-a5ad-4964-2966-589486e4a251@sandeen.net>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060133
X-FB-Internal: deliver
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When running xfs_restore with a non-rtdev dump,
it will ignore any rtinherit flags on the destination
and send I/O to the metadata region.

Instead, detect rtinherit on the destination XFS fileystem root inode
and use that to override the incoming inode flags.

Original version of this patch missed some branches so multiple
invocations of xfsrestore onto the same fs caused
the rtinherit bit to get re-removed. There could be some
additional edge cases in non-realtime to realtime workflows so
the outstanding question would be: is it worth supporting?

Changes in v2:
* Changed root inode bulkstat to just ioctl to the destdir inode

Signed-off-by: Sheena Artrip <sheenobu@fb.com>
---
 restore/content.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/restore/content.c b/restore/content.c
index 6b22965..4822d1c 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -670,6 +670,9 @@ struct tran {
 		/* to establish critical regions while updating pers
 		 * inventory
 		 */
+	bool_t t_dstisrealtime;
+		/* to force the realtime flag on incoming inodes
+		 */
 };
 
 typedef struct tran tran_t;
@@ -1803,6 +1806,37 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		free_handle(fshanp, fshlen);
 	}
 
+	/* determine if destination root inode has rtinherit.
+	 * If so, we should force XFS_REALTIME on the incoming inodes.
+	 */
+	if (persp->a.dstdirisxfspr) {
+		struct fsxattr dstxattr;
+
+		int dstfd = open(persp->a.dstdir, O_RDONLY);
+		if (dstfd < 0) {
+			mlog(MLOG_NORMAL | MLOG_WARNING,
+					_("open of %s failed: %s\n"),
+					persp->a.dstdir,
+					strerror(errno));
+			return BOOL_FALSE;
+		}
+
+		/* Get the xattr details for the destination folder */
+		if (ioctl(dstfd, XFS_IOC_FSGETXATTR, &dstxattr) < 0) {
+			(void)close(dstfd);
+			mlog(MLOG_ERROR,
+			      _("failed to get xattr information for dst inode\n"));
+			return BOOL_FALSE;
+		}
+
+		(void)close(dstfd);
+
+		/* test against rtinherit */
+		if((dstxattr.fsx_xflags & XFS_XFLAG_RTINHERIT) != 0) {
+			tranp->t_dstisrealtime = true;
+		}
+	}
+
 	/* map in pers. inv. descriptors, if any. NOTE: this ptr is to be
 	 * referenced ONLY via the macros provided; the descriptors will be
 	 * occasionally remapped, causing the ptr to change.
@@ -7270,6 +7304,10 @@ restore_file_cb(void *cp, bool_t linkpr, char *path1, char *path2)
 	bool_t ahcs = contextp->cb_ahcs;
 	stream_context_t *strctxp = (stream_context_t *)drivep->d_strmcontextp;
 
+	if (tranp->t_dstisrealtime) {
+		bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
+	}
+
 	int rval;
 	bool_t ok;
 
@@ -7480,6 +7518,10 @@ restore_reg(drive_t *drivep,
 	if (tranp->t_toconlypr)
 		return BOOL_TRUE;
 
+	if (tranp->t_dstisrealtime) {
+	      bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
+	}
+
 	oflags = O_CREAT | O_RDWR;
 	if (persp->a.dstdirisxfspr && bstatp->bs_xflags & XFS_XFLAG_REALTIME)
 		oflags |= O_DIRECT;
@@ -8470,6 +8512,11 @@ restore_extent(filehdr_t *fhdrp,
 		}
 		assert(new_off == off);
 	}
+
+	if (tranp->t_dstisrealtime) {
+	      bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
+	}
+
 	if ((fd != -1) && (bstatp->bs_xflags & XFS_XFLAG_REALTIME)) {
 		if ((ioctl(fd, XFS_IOC_DIOINFO, &da) < 0)) {
 			mlog(MLOG_NORMAL | MLOG_WARNING, _(
@@ -8729,6 +8776,10 @@ restore_extattr(drive_t *drivep,
 
 	assert(extattrbufp);
 
+	if (tranp->t_dstisrealtime) {
+		bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
+	}
+
 	if (!isdirpr)
 		isfilerestored = partial_check(bstatp->bs_ino,  bstatp->bs_size);
 
-- 
2.17.1

