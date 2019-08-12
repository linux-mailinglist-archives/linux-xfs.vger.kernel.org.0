Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8848A504
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 19:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfHLR5P (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 13:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbfHLR5P (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Aug 2019 13:57:15 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE78C206C2;
        Mon, 12 Aug 2019 17:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565632633;
        bh=VnVK7IcJS4ndc+hgxpNrZS63vpaG3tfeZ5Om1UeZ63o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0moHkGY1gIf0j4X0xerJmasJNtvIYTpirICNTBIzbIyEAxVwICJAd4Ps6M8S6iS/y
         hF4iOmDtcP4KH48bqLcYHtqTyLILbnuKXrha8JsrmpFdeZFiGcLo3L7zzm+24d2Igc
         fHROgfL8pk4vNboDJnXclWTJ7huWR+EiHSzJuI1w=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 1/8] xfs_io/encrypt: remove unimplemented encryption modes
Date:   Mon, 12 Aug 2019 10:56:27 -0700
Message-Id: <20190812175635.34186-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
In-Reply-To: <20190812175635.34186-1-ebiggers@kernel.org>
References: <20190812175635.34186-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Although mode numbers were originally reserved for AES-256-GCM and
AES-256-CBC, these were never implemented in the kernel, and there are
no plans to do so anymore.  These mode numbers may be used for something
else in the future.  Also, xfstests (the only known user of the xfs_io
encryption commands) doesn't try to use them.  Finally, most of the
fscrypt constants have been given new names in the UAPI header, but the
unused constants have not been given new names since userspace should
just stop referencing them instead.

So remove them from xfs_io.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 io/encrypt.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/io/encrypt.c b/io/encrypt.c
index 8db35259..e8766dc1 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -49,8 +49,6 @@ struct fscrypt_policy {
 
 #define FS_ENCRYPTION_MODE_INVALID	0
 #define FS_ENCRYPTION_MODE_AES_256_XTS	1
-#define FS_ENCRYPTION_MODE_AES_256_GCM	2
-#define FS_ENCRYPTION_MODE_AES_256_CBC	3
 #define FS_ENCRYPTION_MODE_AES_256_CTS	4
 #endif /* FS_ENCRYPTION_MODE_AES_256_XTS */
 
@@ -74,7 +72,7 @@ set_encpolicy_help(void)
 " -v VERSION -- version of policy structure\n"
 "\n"
 " MODE can be numeric or one of the following predefined values:\n"
-"    AES-256-XTS, AES-256-CTS, AES-256-GCM, AES-256-CBC\n"
+"    AES-256-XTS, AES-256-CTS\n"
 " FLAGS and VERSION must be numeric.\n"
 "\n"
 " Note that it's only possible to set an encryption policy on an empty\n"
@@ -88,8 +86,6 @@ static const struct {
 } available_modes[] = {
 	{FS_ENCRYPTION_MODE_AES_256_XTS, "AES-256-XTS"},
 	{FS_ENCRYPTION_MODE_AES_256_CTS, "AES-256-CTS"},
-	{FS_ENCRYPTION_MODE_AES_256_GCM, "AES-256-GCM"},
-	{FS_ENCRYPTION_MODE_AES_256_CBC, "AES-256-CBC"},
 };
 
 static bool
-- 
2.23.0.rc1.153.gdeed80330f-goog

