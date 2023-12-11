Return-Path: <linux-xfs+bounces-601-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 72AAB80D20C
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Dec 2023 17:38:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 02FF6B20E0A
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Dec 2023 16:38:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0FB03B785;
	Mon, 11 Dec 2023 16:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gVBLDFwm"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C971C8E
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=t1kw9Z/CzAaj4e3nEA0OcWjpVg8bPg4M0PWQkg1kwxo=; b=gVBLDFwmTuHiRCyp5hW6qPGtre
	StHvYXzXPNd+1Z+SjApZtIFfBy1WMgOMO16vk7ilOwDTSRKUGvaGHnK4zDWWBTg59ArJ87Suhl1o2
	5lgIxl2fH4Mdisyt82ZC9xdwTeYatK6GX9XO0oG9pCFBxGDxS+k5gOUa75WlXRqU6xiFamuL5akKB
	il2XV432gSOSg5mJRYff2Wj0oV6OAlFs25LL/TCzx6kOkOCpq/Qt8omvFVlWKhTHVttEjKnvZ2ObJ
	kr9cmR399dlU5hLDanmJWnJ8hiJ/V+pLrgwOfMWslIKCaL273m/Cx9PZjqYiIa6k6QHnq/VEwF9hq
	WLWE8ogA==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjHz-005ssK-37;
	Mon, 11 Dec 2023 16:37:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 02/23] libxfs: remove the dead {d,log,rt}path variables in libxfs_init
Date: Mon, 11 Dec 2023 17:37:21 +0100
Message-Id: <20231211163742.837427-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231211163742.837427-1-hch@lst.de>
References: <20231211163742.837427-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

These variables are only initialized, and then unlink is called if they
were changed from the initial value, which can't happen.  Remove the
variables and the conditional unlink calls.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index ce6e62cde..a8603e2fb 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -307,17 +307,13 @@ libxfs_init(libxfs_init_t *a)
 {
 	char		*blockfile;
 	char		*dname;
-	char		dpath[25];
 	int		fd;
 	char		*logname;
-	char		logpath[25];
 	char		*rawfile;
 	char		*rtname;
-	char		rtpath[25];
 	int		rval = 0;
 	int		flags;
 
-	dpath[0] = logpath[0] = rtpath[0] = '\0';
 	dname = a->dname;
 	logname = a->logname;
 	rtname = a->rtname;
@@ -418,12 +414,6 @@ libxfs_init(libxfs_init_t *a)
 	init_caches();
 	rval = 1;
 done:
-	if (dpath[0])
-		unlink(dpath);
-	if (logpath[0])
-		unlink(logpath);
-	if (rtpath[0])
-		unlink(rtpath);
 	if (fd >= 0)
 		close(fd);
 	if (!rval) {
-- 
2.39.2


