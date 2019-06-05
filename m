Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66CC336697
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 23:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfFEVQi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 17:16:38 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:41761 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfFEVQi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 17:16:38 -0400
Received: by mail-yw1-f68.google.com with SMTP id y185so21418ywy.8
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jun 2019 14:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=OOptkgQD2zGsJ9Gnejdg82CpUc2QMSCM6k/yJiyxqQw=;
        b=IeWFZ6wm99ImkUrNTlOE98hOBvyyPgscgyEJXee/V/Fq/MxGCN5oeGc09A414wNar0
         53mCG06uUCTdXSA17LwR/HJgVjEue25wDDa6mw4iV/HiD61mGDvZz15PJhfxchgqEnx/
         txkHXe4yanKE1LKAV179zC/tHp36B7i1Wz6d1vIfosaJb8UzusP6froEsGxA+j9mzhpg
         SFYpjd3aPpzYY35ltceq4TrbU8i+qiL0CUxXqZWnfk55Wo6n8FRrlOm5OsktD/ez2+fp
         1sM9aU3hVzhrBIkCV1bJkV6lBra8B4+JOXrYajFnDJkWd9fJyora5SqeiPiGyWJunEX7
         YKvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=OOptkgQD2zGsJ9Gnejdg82CpUc2QMSCM6k/yJiyxqQw=;
        b=YOlb0BwPSUPGjz71Q/m5J/zJIEDQSA0hvpPsziXjoWxVeLpYoL09LUOqa6nEMRB1YD
         3Lh+5x/aTawcuttGaqZ4HYxbkPHdl4FNUxAQ94c5l9bo6Czpl8pEreiqajbzimcBkrPR
         53/x6x33Gm+nnkL455P/hbjtob0r4M7hz53iDpaCawX8yg3kHdVkO7z+GddrvLG8UuAw
         vPfdzdxWqsn+qn49uJE/fAi5m1p+rGe0pFUNOX9o+BKcqZRaPO1zwkEPUtz4h3hejqvs
         jE1H21gDHxwf6Sg0vlF5CO9lcBwTd+3EcFMVEQAFsUIbHhiHaCVUHWpj+kXS9Zu660jX
         2F+Q==
X-Gm-Message-State: APjAAAWIamTMrBF7RbXS4K3Pj+tVaj01yBToZtTfF0MQXEYT1XChl53e
        fEsemOzbQG39j++/PSms2f12mK9AsysvsKOCPS3lakoEzlo=
X-Google-Smtp-Source: APXvYqxNobgIyPTm6ig5vQrMKv86VrX91pW2bfCNUqSPf8dilFsdzSdP7NwAVkAygXr2R5jZArK8xgDcYyV6rb0fXtY=
X-Received: by 2002:a81:a848:: with SMTP id f69mr15703729ywh.360.1559769396809;
 Wed, 05 Jun 2019 14:16:36 -0700 (PDT)
MIME-Version: 1.0
From:   Sheena Artrip <sheena.artrip@gmail.com>
Date:   Wed, 5 Jun 2019 14:16:25 -0700
Message-ID: <CABeZSNmcmL3_VvDVvbcneDd3f2jCiu7Pn8YQ7y7mJH8BizaWXw@mail.gmail.com>
Subject: [RFC][PATCH] xfs_restore: detect rtinherit on destination
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

Signed-off-by: Sheena Artrip <sheena.artrip@gmail.com>
---
 restore/content.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/restore/content.c b/restore/content.c
index 6b22965..96dd698 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -670,6 +670,9 @@ struct tran {
                 /* to establish critical regions while updating pers
                  * inventory
                  */
+       bool_t t_dstisrealtime;
+               /* to force the realtime flag on incoming inodes
+                */
 };

 typedef struct tran tran_t;
@@ -1803,6 +1806,51 @@ content_init(int argc, char *argv[], size64_t vmsz)
                 free_handle(fshanp, fshlen);
         }

+       /* determine if destination root inode has rtinherit.
+        * If so, we should force XFS_REALTIME on the incoming inodes.
+        */
+       if (persp->a.dstdirisxfspr) {
+               stat64_t rootstat;
+               xfs_fsop_bulkreq_t bulkreq;
+               int ocount = 0;
+               xfs_bstat_t *sc_rootxfsstatp;
+
+               int rootfd = open(persp->a.dstdir, O_RDONLY);
+
+               sc_rootxfsstatp =
+                       (xfs_bstat_t *)calloc(1, sizeof(xfs_bstat_t));
+               assert(sc_rootxfsstatp);
+
+               /* Get the inode of the destination folder */
+               int rval = fstat64(rootfd, &rootstat);
+               if (rval) {
+                       (void)close(rootfd);
+                       mlog(MLOG_NORMAL, _(
+                         "could not stat %s\n"),
+                         persp->a.dstdir);
+                       return BOOL_FALSE;
+               }
+
+               /* Get the first valid (i.e. root) inode in this fs */
+               bulkreq.lastip = (__u64 *)&rootstat.st_ino;
+               bulkreq.icount = 1;
+               bulkreq.ubuffer = sc_rootxfsstatp;
+               bulkreq.ocount = &ocount;
+               if (ioctl(rootfd, XFS_IOC_FSBULKSTAT, &bulkreq) < 0) {
+                       (void)close(rootfd);
+                       mlog(MLOG_ERROR,
+                             _("failed to get bulkstat information
for root inode\n"));
+                       return BOOL_FALSE;
+               }
+
+               (void)close(rootfd);
+
+               /* test against rtinherit */
+               if((sc_rootxfsstatp->bs_xflags & XFS_XFLAG_RTINHERIT) != 0) {
+                       tranp->t_dstisrealtime = true;
+               }
+       }
+
         /* map in pers. inv. descriptors, if any. NOTE: this ptr is to be
          * referenced ONLY via the macros provided; the descriptors will be
          * occasionally remapped, causing the ptr to change.
@@ -7270,6 +7318,10 @@ restore_file_cb(void *cp, bool_t linkpr, char
*path1, char *path2)
         bool_t ahcs = contextp->cb_ahcs;
         stream_context_t *strctxp = (stream_context_t *)drivep->d_strmcontextp;

+       if (tranp->t_dstisrealtime) {
+               bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
+       }
+
         int rval;
         bool_t ok;

@@ -7480,6 +7532,10 @@ restore_reg(drive_t *drivep,
         if (tranp->t_toconlypr)
                 return BOOL_TRUE;

+       if (tranp->t_dstisrealtime) {
+             bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
+       }
+
         oflags = O_CREAT | O_RDWR;
         if (persp->a.dstdirisxfspr && bstatp->bs_xflags & XFS_XFLAG_REALTIME)
                 oflags |= O_DIRECT;
@@ -8470,6 +8526,11 @@ restore_extent(filehdr_t *fhdrp,
                 }
                 assert(new_off == off);
         }
+
+       if (tranp->t_dstisrealtime) {
+             bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
+       }
+
         if ((fd != -1) && (bstatp->bs_xflags & XFS_XFLAG_REALTIME)) {
                 if ((ioctl(fd, XFS_IOC_DIOINFO, &da) < 0)) {
                         mlog(MLOG_NORMAL | MLOG_WARNING, _(
@@ -8729,6 +8790,10 @@ restore_extattr(drive_t *drivep,

         assert(extattrbufp);

+       if (tranp->t_dstisrealtime) {
+               bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
+       }
+
         if (!isdirpr)
                 isfilerestored = partial_check(bstatp->bs_ino,
bstatp->bs_size);

--
2.17.1
