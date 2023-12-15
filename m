Return-Path: <linux-xfs+bounces-823-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6224813ED7
	for <lists+linux-xfs@lfdr.de>; Fri, 15 Dec 2023 01:50:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B68D283EBD
	for <lists+linux-xfs@lfdr.de>; Fri, 15 Dec 2023 00:50:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 748B7110F;
	Fri, 15 Dec 2023 00:50:03 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC91ED6
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 00:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Sam James <sam@gentoo.org>
To: linux-xfs@vger.kernel.org
Cc: Sam James <sam@gentoo.org>,
	Felix Janda <felix.janda@posteo.de>
Subject: [PATCH v2 2/4] io: Assert we have a sensible off_t
Date: Fri, 15 Dec 2023 00:42:11 +0000
Message-ID: <20231215004333.860034-3-sam@gentoo.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231215004333.860034-1-sam@gentoo.org>
References: <20231215004333.860034-1-sam@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Suggested by Darrick during review of the first LFSization patch. Assert
we have an off_t capable of handling >=4GiB as a failsafe against the macros
not doing the right thing.

This is not the first time we've been on this adventure in XFS:
* 5c0599b721d1d232d2e400f357abdf2736f24a97 ('Fix building xfsprogs on 32-bit platforms')
* 65b4f302b7a1ddc14684ffbf8690227a67362586 ('platform: remove use of off64_t')
* 7fda99a0c2970f7da2661118b438e64dec1751b4 ('xfs.h: require transparent LFS for all users')
* ebe750ed747cbc59a5675193cdcbc3459ebda107 ('configure: error out when LFS does not work')
* 69268aaec5fb39ad71674336c0f6f75ca9f57999 ('configure: use AC_SYS_LARGEFILE')

Cc: Felix Janda <felix.janda@posteo.de>
Signed-off-by: Sam James <sam@gentoo.org>
---
 io/init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io/init.c b/io/init.c
index 104cd2c1..2fb598ac 100644
--- a/io/init.c
+++ b/io/init.c
@@ -44,6 +44,9 @@ init_cvtnum(
 static void
 init_commands(void)
 {
+	/* We're only interested in supporting an off_t which can handle >=4GiB. */
+	BUILD_BUG_ON(sizeof(off_t) < 8);
+
 	attr_init();
 	bmap_init();
 	bulkstat_init();
-- 
2.43.0


