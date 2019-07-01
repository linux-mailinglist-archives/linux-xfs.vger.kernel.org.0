Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6A704DC8A
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 23:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbfFTV3l (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 17:29:41 -0400
Received: from sandeen.net ([63.231.237.45]:55576 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726286AbfFTV3k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 17:29:40 -0400
Received: by sandeen.net (Postfix, from userid 500)
        id EB8FC479AE4; Thu, 20 Jun 2019 16:29:37 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/11] xfs_spaceman: remove unneeded includes
Date:   Thu, 20 Jun 2019 16:29:34 -0500
Message-Id: <1561066174-13144-12-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
References: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 spaceman/file.c     | 3 ---
 spaceman/freesp.c   | 1 -
 spaceman/init.c     | 2 --
 spaceman/prealloc.c | 1 -
 4 files changed, 7 deletions(-)

diff --git a/spaceman/file.c b/spaceman/file.c
index 7e33e07..edc52b8 100644
--- a/spaceman/file.c
+++ b/spaceman/file.c
@@ -6,10 +6,7 @@
  */
 
 #include "libxfs.h"
-#include <sys/mman.h>
 #include "command.h"
-#include "input.h"
-#include "init.h"
 #include "path.h"
 #include "space.h"
 
diff --git a/spaceman/freesp.c b/spaceman/freesp.c
index 11d0aaf..bfc4793 100644
--- a/spaceman/freesp.c
+++ b/spaceman/freesp.c
@@ -7,7 +7,6 @@
  */
 
 #include "libxfs.h"
-#include <linux/fiemap.h>
 #include "command.h"
 #include "init.h"
 #include "path.h"
diff --git a/spaceman/init.c b/spaceman/init.c
index c845f92..ec0c22b 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -6,8 +6,6 @@
 
 #include "libxfs.h"
 #include "command.h"
-#include "input.h"
-#include "init.h"
 #include "path.h"
 #include "space.h"
 
diff --git a/spaceman/prealloc.c b/spaceman/prealloc.c
index 85dfc9e..c8aa5bd 100644
--- a/spaceman/prealloc.c
+++ b/spaceman/prealloc.c
@@ -7,7 +7,6 @@
 #include "libxfs.h"
 #include "command.h"
 #include "input.h"
-#include "init.h"
 #include "path.h"
 #include "space.h"
 
-- 
1.8.3.1

