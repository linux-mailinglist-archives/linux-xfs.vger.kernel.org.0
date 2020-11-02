Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67BF2A2294
	for <lists+linux-xfs@lfdr.de>; Mon,  2 Nov 2020 01:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgKBAew (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 1 Nov 2020 19:34:52 -0500
Received: from m15111.mail.126.com ([220.181.15.111]:32806 "EHLO
        m15111.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbgKBAew (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Nov 2020 19:34:52 -0500
X-Greylist: delayed 1885 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Nov 2020 19:34:51 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=RIrWh638uBEKYF3A2h
        R0szq8nONGR2032LXrtbL5g3I=; b=g0sNa4FKdrrpnC5GTXurjGP7HBPV7ee32y
        WZRp0pxxR2RmeUUv0yrPcwpGkJ8xnXE1ICCtW0zNCQvby3du061YHdlBkUvNLRZE
        Tnq4N8OZq31xScsp0xCXfCZqw4b3hInchQYSTj/1Fba2MmxCmffUjTX0VcJgm42I
        kaXVnWDjQ=
Received: from localhost.localdomain (unknown [112.17.240.93])
        by smtp1 (Coremail) with SMTP id C8mowAA3uljFTJ9fgGG+Kw--.39873S2;
        Mon, 02 Nov 2020 08:03:18 +0800 (CST)
From:   Fengfei Xi <fengfei_xi@126.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengfei Xi <fengfei_xi@126.com>
Subject: [PATCH] xfs: Drop useless comments
Date:   Mon,  2 Nov 2020 08:03:16 +0800
Message-Id: <1604275396-4565-1-git-send-email-fengfei_xi@126.com>
X-Mailer: git-send-email 1.9.1
X-CM-TRANSID: C8mowAA3uljFTJ9fgGG+Kw--.39873S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruFykKF4xAw1fAr4xGr43trb_yoWxZFb_Ga
        17tF4Ikw4UJFy7ta1UurnYyFyUW39rKrs7uanIqFyaq3W8Xan7ArykJF4YgwnrWrs3ZFn5
        Jwn5Gry5tr9ayjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUYcNVDUUUUU==
X-Originating-IP: [112.17.240.93]
X-CM-SenderInfo: pihqwwxhlb5xa6rslhhfrp/1tbi1wbQkl53U+6zvgAAsK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The names of functions xfs_buf_get_maps and _xfs_buf_free_pages
can fully express their roles. So their comments are redundant.
We could drop them entirely.

Signed-off-by: Fengfei Xi <fengfei_xi@126.com>
---
 fs/xfs/xfs_buf.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4e4cf91..2aeed30 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -197,9 +197,6 @@
 	return 0;
 }
 
-/*
- *	Frees b_pages if it was allocated.
- */
 static void
 xfs_buf_free_maps(
 	struct xfs_buf	*bp)
@@ -297,9 +294,6 @@
 	return 0;
 }
 
-/*
- *	Frees b_pages if it was allocated.
- */
 STATIC void
 _xfs_buf_free_pages(
 	xfs_buf_t	*bp)
-- 
1.9.1

