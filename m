Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BA722CE0E
	for <lists+linux-xfs@lfdr.de>; Fri, 24 Jul 2020 20:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgGXSpU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 24 Jul 2020 14:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgGXSpT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 14:45:19 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6B7C08C5DB
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 11:45:18 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id k4so6623094pjs.1
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 11:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xyIxbqTzEFkSiRwtwQaLWA16wfxvhvC5m78qlSH1ff0=;
        b=mBULbubnOs99wcWvCkuB8DaDJihSO0xMIW84PX5bW6WTDj309RqVaJPHsyAy2kaKCY
         sOD/egWqVHLZ7OUz7656r6qh6CE0O+9+ekoTB8ggySlZKOVBPFRyQhOpz3iP8O3KzA66
         TlNycAcYS2Bt5YOOhe3NHBNfRzmIluIfVqVEZaOTBNsFH2DN2tFUJgfwzvHk+Cfu4ktE
         Ux2qbNoUcHcJSGpYoyJrtPpZVCLD/G+F6TaLMtwwue8ZozjlRyZ5Pqd2SCUqaAjZRuwa
         2twdFk1AzPx/nwa4i8eqkv4wxZlZ4QpFLnVvKFEWArFlrDNn6OdFdOF+0n5c6jitoG4w
         V/dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xyIxbqTzEFkSiRwtwQaLWA16wfxvhvC5m78qlSH1ff0=;
        b=NC+5L8maI87deI2DlOa1ygyR/kPHFUrNkzIvKFt1nzSCMsMSifogXzRYBze2HQ7BuG
         qjs97IuuRggOaK7zUmvXQFo3BvNcUBGbG1oXaq5Vseywb4Aexx5W0g2RGEkmVQks6odd
         dNWPnet2r/7JTbKAso8s/EPE6I3FxW4FJtuSILZ5FY4JWYBaa9/QdhirlHciAL2G6/dZ
         HvjvRJL0m+7V4/eqK/J2U1WYLjAD8xAK6qgz5CQ3C1gjZHGdbcQKO3aXIM3ZCJhGjk1f
         S6kBwgIIEAYbwqjzSE59Pqt5PixuoPC9Vvw2SdC3lSBJOmTYUXePT7XVDhqUxpzwKR1K
         NBvA==
X-Gm-Message-State: AOAM530OqAo+WsDeX7JRcJLJwr4dF/nc2j8Wi0gZNgJVIaUXC4Egp7vW
        czfGXBvYhwTO04D/2We4ktWVFzD+mPw=
X-Google-Smtp-Source: ABdhPJzkqIhgfmuH4Tw2HNitGStx6+I2VoJ2h2ZcDf2nCz9kSOHpDDkKAQY+0hH0A++BUEd5FyALMx/aU4Y=
X-Received: by 2002:a17:90a:1fcb:: with SMTP id z11mr1970016pjz.1.1595616317802;
 Fri, 24 Jul 2020 11:45:17 -0700 (PDT)
Date:   Fri, 24 Jul 2020 18:45:01 +0000
In-Reply-To: <20200724184501.1651378-1-satyat@google.com>
Message-Id: <20200724184501.1651378-8-satyat@google.com>
Mime-Version: 1.0
References: <20200724184501.1651378-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v6 7/7] fscrypt: update documentation for direct I/O support
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Update fscrypt documentation to reflect the addition of direct I/O support
and document the necessary conditions for direct I/O on encrypted files.

Signed-off-by: Satya Tangirala <satyat@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 Documentation/filesystems/fscrypt.rst | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 423c5a0daf45..b9bbd6c612ff 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -1049,8 +1049,10 @@ astute users may notice some differences in behavior:
   may be used to overwrite the source files but isn't guaranteed to be
   effective on all filesystems and storage devices.
 
-- Direct I/O is not supported on encrypted files.  Attempts to use
-  direct I/O on such files will fall back to buffered I/O.
+- Direct I/O is supported on encrypted files only under some
+  circumstances (see `Direct I/O support`_ for details). When these
+  circumstances are not met, attempts to use direct I/O on encrypted
+  files will fall back to buffered I/O.
 
 - The fallocate operations FALLOC_FL_COLLAPSE_RANGE and
   FALLOC_FL_INSERT_RANGE are not supported on encrypted files and will
@@ -1123,6 +1125,20 @@ It is not currently possible to backup and restore encrypted files
 without the encryption key.  This would require special APIs which
 have not yet been implemented.
 
+Direct I/O support
+==================
+
+Direct I/O on encrypted files is supported through blk-crypto. In
+particular, this means the kernel must have CONFIG_BLK_INLINE_ENCRYPTION
+enabled, the filesystem must have had the 'inlinecrypt' mount option
+specified, and either hardware inline encryption must be present, or
+CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK must have been enabled. Further,
+any I/O must be aligned to the filesystem block size (*not* necessarily
+the same as the block device's block size) - in particular, any userspace
+buffer into which data is read/written from must also be aligned to the
+filesystem block size. If any of these conditions isn't met, attempts to do
+direct I/O on an encrypted file will fall back to buffered I/O.
+
 Encryption policy enforcement
 =============================
 
-- 
2.28.0.rc0.142.g3c755180ce-goog

