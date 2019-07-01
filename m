Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E555B4DC86
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 23:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbfFTV3k (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 17:29:40 -0400
Received: from sandeen.net ([63.231.237.45]:55566 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfFTV3j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 17:29:39 -0400
Received: by sandeen.net (Postfix, from userid 500)
        id 8C49E335058; Thu, 20 Jun 2019 16:29:37 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/11] xfs_quota: remove unneeded includes
Date:   Thu, 20 Jun 2019 16:29:31 -0500
Message-Id: <1561066174-13144-9-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
References: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 quota/edit.c   | 3 ---
 quota/quot.c   | 3 ---
 quota/quota.c  | 1 -
 quota/report.c | 1 -
 quota/util.c   | 1 -
 5 files changed, 9 deletions(-)

diff --git a/quota/edit.c b/quota/edit.c
index f9938b8..d86503c 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -4,9 +4,6 @@
  * All Rights Reserved.
  */
 
-#include <pwd.h>
-#include <grp.h>
-#include <ctype.h>
 #include "input.h"
 #include "command.h"
 #include "init.h"
diff --git a/quota/quot.c b/quota/quot.c
index d60cf4a..518b266 100644
--- a/quota/quot.c
+++ b/quota/quot.c
@@ -6,9 +6,6 @@
 
 #include <stdbool.h>
 #include "command.h"
-#include <ctype.h>
-#include <pwd.h>
-#include <grp.h>
 #include "init.h"
 #include "quota.h"
 
diff --git a/quota/quota.c b/quota/quota.c
index 9545cc4..7ef4829 100644
--- a/quota/quota.c
+++ b/quota/quota.c
@@ -6,7 +6,6 @@
 
 #include <stdbool.h>
 #include "command.h"
-#include <ctype.h>
 #include <pwd.h>
 #include <grp.h>
 #include "init.h"
diff --git a/quota/report.c b/quota/report.c
index e6def91..2ad12d7 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -8,7 +8,6 @@
 #include <sys/types.h>
 #include <pwd.h>
 #include <grp.h>
-#include <utmp.h>
 #include "init.h"
 #include "quota.h"
 
diff --git a/quota/util.c b/quota/util.c
index 50470ab..4bcdd9d 100644
--- a/quota/util.c
+++ b/quota/util.c
@@ -8,7 +8,6 @@
 #include <stdbool.h>
 #include <pwd.h>
 #include <grp.h>
-#include <utmp.h>
 #include "init.h"
 #include "quota.h"
 
-- 
1.8.3.1

