Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD284DC82
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 23:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfFTV3j (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 17:29:39 -0400
Received: from sandeen.net ([63.231.237.45]:55550 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbfFTV3i (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 17:29:38 -0400
Received: by sandeen.net (Postfix, from userid 500)
        id A7622325414; Thu, 20 Jun 2019 16:29:36 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/11] xfs_estimate: remove unneeded includes
Date:   Thu, 20 Jun 2019 16:29:24 -0500
Message-Id: <1561066174-13144-2-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
References: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 estimate/xfs_estimate.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/estimate/xfs_estimate.c b/estimate/xfs_estimate.c
index 9e01cce..189bb6c 100644
--- a/estimate/xfs_estimate.c
+++ b/estimate/xfs_estimate.c
@@ -10,7 +10,6 @@
  * XXX: assumes dirv1 format.
  */
 #include "libxfs.h"
-#include <sys/stat.h>
 #include <ftw.h>
 
 static unsigned long long
-- 
1.8.3.1

