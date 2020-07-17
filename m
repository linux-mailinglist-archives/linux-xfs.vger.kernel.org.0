Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEA82230A2
	for <lists+linux-xfs@lfdr.de>; Fri, 17 Jul 2020 03:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgGQBp4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Jul 2020 21:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgGQBpv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 21:45:51 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B910C08C5C0
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 18:45:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p22so9530482ybg.21
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 18:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=E/vVSGidxRNqfgFvT7W0V9puYBqKI9SZ+5JR8j0m+58=;
        b=rXOnRzGGSVHFJDvjXi4FvAGiqdTyNugg4+H0mP1UFF0jhZqf9ep56wXd9XJvPMyF9T
         xoS911Id97Dol9EvPK1vd9h8gYYCgaetjB+K7vw/2qAXsNebgviKIpgSa8h1ymO/I+8I
         YIvRJ/hkbtBJWlgnuyDv5HV2cXOcz+N4IrAcNQRZxLAp4EnHNbfG5YnAhJhBgTy+Pigv
         4dn1Nyu0E43LGnaBzxcuj3jII3vy8x6cX2YbN3ZtFyf4Ma6kXhDkX1GxK6J3lUHQ4QI1
         hToBCY+cUvVQkmT2ab6aVu8YcYHCBu/i3YrB2ksRrALG3q7k+9hHw+zgqJFmE7H4rTqX
         0wTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=E/vVSGidxRNqfgFvT7W0V9puYBqKI9SZ+5JR8j0m+58=;
        b=ep/eCjI0mOoxk0gVzmsACvP3MhbcnaasHTjf3dVojZvCmqP3ZPmhrAoCZXSVVr3PkF
         PnLm10f5bHVz6+kxe14WUeV9R+ioss1YZzhDKHKwm5n00hhC9o437sbFhXLuVhTy0ceU
         Gh65jf0mHtQQlr5tTbMB2ry9E2BRPKgb1Axt3dTOC2TESiH77tpKYxVS8TTvUuso3phl
         mVOqaPb31r4ebzYKlwsoAUaSjehyHulB6n7PBWQF+rAIl7unIzTx4ormjZl8VftGhUUO
         B0eN/+82Q/gUmTqeJkGUnJAraKzPAv6cQDuf4k5yic8SWYI9JIZOEnUIU+B4Nq6l5/U4
         g0ZQ==
X-Gm-Message-State: AOAM533SxOB2go+t6gz146eOdSrNSt6IBZTv9EFMyjmwEcjZ+HNQRxK/
        Qf3EkQgBVqJw0rYmU5I4VBwmRpgs0PY=
X-Google-Smtp-Source: ABdhPJz7acZLc4vxa6IsZoed6dq0Yjbsxw2KarLtYNUW50n+ZIWBzgAyIfxQtErgMIINdMcscSoivVp9TXA=
X-Received: by 2002:a25:7d41:: with SMTP id y62mr10756670ybc.95.1594950350852;
 Thu, 16 Jul 2020 18:45:50 -0700 (PDT)
Date:   Fri, 17 Jul 2020 01:45:37 +0000
In-Reply-To: <20200717014540.71515-1-satyat@google.com>
Message-Id: <20200717014540.71515-5-satyat@google.com>
Mime-Version: 1.0
References: <20200717014540.71515-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v3 4/7] ext4: support direct I/O with fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Wire up ext4 with fscrypt direct I/O support. direct I/O with fscrypt is
only supported through blk-crypto (i.e. CONFIG_BLK_INLINE_ENCRYPTION must
have been enabled, the 'inlinecrypt' mount option must have been specified,
and either hardware inline encryption support must be present or
CONFIG_BLK_INLINE_ENCYRPTION_FALLBACK must have been enabled). Further,
direct I/O on encrypted files is only supported when I/O is aligned
to the filesystem block size (which is *not* necessarily the same as the
block device's block size).

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
---
 fs/ext4/file.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 2a01e31a032c..d534f72675d9 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -36,9 +36,11 @@
 #include "acl.h"
 #include "truncate.h"
 
-static bool ext4_dio_supported(struct inode *inode)
+static bool ext4_dio_supported(struct kiocb *iocb, struct iov_iter *iter)
 {
-	if (IS_ENABLED(CONFIG_FS_ENCRYPTION) && IS_ENCRYPTED(inode))
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	if (!fscrypt_dio_supported(iocb, iter))
 		return false;
 	if (fsverity_active(inode))
 		return false;
@@ -61,7 +63,7 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		inode_lock_shared(inode);
 	}
 
-	if (!ext4_dio_supported(inode)) {
+	if (!ext4_dio_supported(iocb, to)) {
 		inode_unlock_shared(inode);
 		/*
 		 * Fallback to buffered I/O if the operation being performed on
@@ -490,7 +492,7 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	/* Fallback to buffered I/O if the inode does not support direct I/O. */
-	if (!ext4_dio_supported(inode)) {
+	if (!ext4_dio_supported(iocb, from)) {
 		if (ilock_shared)
 			inode_unlock_shared(inode);
 		else
-- 
2.28.0.rc0.105.gf9edc3c819-goog

