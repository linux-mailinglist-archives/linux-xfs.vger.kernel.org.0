Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2344DC8E
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 23:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfFTV3k (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 17:29:40 -0400
Received: from sandeen.net ([63.231.237.45]:55562 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbfFTV3j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 17:29:39 -0400
Received: by sandeen.net (Postfix, from userid 500)
        id 7937E325414; Thu, 20 Jun 2019 16:29:37 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/11] xfs_logprint: remove unneeded includes
Date:   Thu, 20 Jun 2019 16:29:30 -0500
Message-Id: <1561066174-13144-8-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
References: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 logprint/log_print_trans.c | 1 -
 logprint/log_redo.c        | 1 -
 2 files changed, 2 deletions(-)

diff --git a/logprint/log_print_trans.c b/logprint/log_print_trans.c
index 08e44a3..28c83a9 100644
--- a/logprint/log_print_trans.c
+++ b/logprint/log_print_trans.c
@@ -6,7 +6,6 @@
 #include "libxfs.h"
 #include "libxlog.h"
 
-#include "logprint.h"
 
 void
 xlog_recover_print_trans_head(
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index f1f690e..acc7067 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -7,7 +7,6 @@
 #include "libxfs.h"
 #include "libxlog.h"
 
-#include "logprint.h"
 
 /* Extent Free Items */
 
-- 
1.8.3.1

