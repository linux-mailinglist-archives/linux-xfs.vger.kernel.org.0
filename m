Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4444DC8D
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 23:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfFTV3k (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 17:29:40 -0400
Received: from sandeen.net ([63.231.237.45]:55558 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbfFTV3j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 17:29:39 -0400
Received: by sandeen.net (Postfix, from userid 500)
        id 2AADE452090; Thu, 20 Jun 2019 16:29:37 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/11] libxcmd: remove unneeded includes
Date:   Thu, 20 Jun 2019 16:29:28 -0500
Message-Id: <1561066174-13144-6-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
References: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxcmd/command.c | 1 -
 libxcmd/help.c    | 1 -
 libxcmd/input.c   | 2 --
 libxcmd/quit.c    | 1 -
 4 files changed, 5 deletions(-)

diff --git a/libxcmd/command.c b/libxcmd/command.c
index a76d151..9cb90ec 100644
--- a/libxcmd/command.c
+++ b/libxcmd/command.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 
-#include "platform_defs.h"
 #include "command.h"
 #include "input.h"
 
diff --git a/libxcmd/help.c b/libxcmd/help.c
index b7e0207..16a114d 100644
--- a/libxcmd/help.c
+++ b/libxcmd/help.c
@@ -6,7 +6,6 @@
 
 #include "platform_defs.h"
 #include "command.h"
-#include "../quota/init.h"
 
 static cmdinfo_t help_cmd;
 static void help_onecmd(const char *cmd, const cmdinfo_t *ct);
diff --git a/libxcmd/input.c b/libxcmd/input.c
index d232d4f..d058f2a 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -4,10 +4,8 @@
  * All Rights Reserved.
  */
 
-#include "platform_defs.h"
 #include "input.h"
 #include <ctype.h>
-#include <stdbool.h>
 
 #if defined(ENABLE_READLINE)
 # include <readline/history.h>
diff --git a/libxcmd/quit.c b/libxcmd/quit.c
index 7c2d04f..4014980 100644
--- a/libxcmd/quit.c
+++ b/libxcmd/quit.c
@@ -6,7 +6,6 @@
 
 #include "platform_defs.h"
 #include "command.h"
-#include "../quota/init.h"
 
 static cmdinfo_t quit_cmd;
 
-- 
1.8.3.1

