Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 086D84DC84
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 23:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfFTV3j (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 17:29:39 -0400
Received: from sandeen.net ([63.231.237.45]:55552 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfFTV3j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 17:29:39 -0400
Received: by sandeen.net (Postfix, from userid 500)
        id C308E335058; Thu, 20 Jun 2019 16:29:36 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/11] xfs_fsr: remove unneeded includes
Date:   Thu, 20 Jun 2019 16:29:25 -0500
Message-Id: <1561066174-13144-3-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
References: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fsr/xfs_fsr.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index fef6262..c6c1f1f 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -5,22 +5,15 @@
  */
 
 #include "libxfs.h"
-#include "xfs.h"
-#include "xfs_types.h"
 #include "jdm.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_attr_sf.h"
 #include "path.h"
 
 #include <fcntl.h>
-#include <errno.h>
 #include <syslog.h>
 #include <signal.h>
-#include <sys/ioctl.h>
 #include <sys/wait.h>
 #include <sys/statvfs.h>
 #include <sys/xattr.h>
-#include <paths.h>
 
 #define _PATH_FSRLAST		"/var/tmp/.fsrlast_xfs"
 #define _PATH_PROC_MOUNTS	"/proc/mounts"
-- 
1.8.3.1

