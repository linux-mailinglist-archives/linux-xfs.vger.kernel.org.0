Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A4122CE16
	for <lists+linux-xfs@lfdr.de>; Fri, 24 Jul 2020 20:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgGXSpZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 24 Jul 2020 14:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbgGXSpS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 14:45:18 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BC1C03CA41
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 11:45:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u189so11464761ybg.17
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 11:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ak9b1MetrNwz8tkXgMNDeTUR8YoZBpQh5jjz0bYRY0M=;
        b=ITpDF03zh4gAXQ80IgtXYXSVSudg/gU9rVN57XZQKro+oG5FczxsGGWDIk19KaZUlG
         Hkjz42c4BcWVc7yDHolMXgpncUUqKjalZEP7MuFByMe4pNel/xhE7ghREp4QClDZsKCO
         Ephfn9OUfGkQ4PQc3FpjFY9Q1OGvIPi/WWbgtYnXgbmI+ypPpmWm4E1cZWktwV5WV/Hk
         1r6DAzau+34Tj4JZDNQ+kk85DecV+mTqhpQFF3eVxMwgJIAB1/H/e1XTzvZ6sLHGhsNn
         MhBrQ+GdgjovyQoTISpziTf1X9MqGb/stJUXrK9lxtfQ2BpP77C5c3tsRK5M0QJCJHHC
         0gLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ak9b1MetrNwz8tkXgMNDeTUR8YoZBpQh5jjz0bYRY0M=;
        b=cryLtVZw5u0qj4Xj0HCXlfiIDMonuAiCIhrD7D9w1myzjGLginuRBHxq1u2AtCgxE8
         Pqqp50E0JVPX21aoTdujG2w5D68qErtDwcc4V/Yvkd2k+2ZvfH0MvvizGVRPHupd9wrx
         wvri80lCd8pYown2aZ3yEYJ4NmeWyA0Sq/V3vTJER+mcanYzArri5mRpAs8a5vT7C2LT
         lMkKBS+xSHmc6qvM2v07bKHKEynzGyXWn60Y3FoHrfCqwjND/TaK2fM4OxRX6VSSM+Cp
         BuCiWW3V5Ddbqhlry0G88gvwHO6W8AL6a2upO0YjUgOpi+K8Ud1T2M3LDMczurd6rn7Q
         jonA==
X-Gm-Message-State: AOAM530oXxLGXRM46qXUX1gpJjpZKWCn+KGSUjQEzZzWODIiNpokSDmv
        RO7dk/W2yAnL/5nDm7S9aki9+Fnzi4g=
X-Google-Smtp-Source: ABdhPJwseKqiZHZW7R0lAN2FfflJ1727vAQQkCjVmAbzoVzFBnjTpAAyolnIjYFGGURfVI9rNc5tdpoHwlY=
X-Received: by 2002:a25:2b89:: with SMTP id r131mr16541745ybr.131.1595616316063;
 Fri, 24 Jul 2020 11:45:16 -0700 (PDT)
Date:   Fri, 24 Jul 2020 18:45:00 +0000
In-Reply-To: <20200724184501.1651378-1-satyat@google.com>
Message-Id: <20200724184501.1651378-7-satyat@google.com>
Mime-Version: 1.0
References: <20200724184501.1651378-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v6 6/7] fscrypt: document inline encryption support
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

Update the fscrypt documentation file for inline encryption support.

Signed-off-by: Satya Tangirala <satyat@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 Documentation/filesystems/fscrypt.rst | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 1a6ad6f736b5..423c5a0daf45 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -1204,6 +1204,18 @@ buffer.  Some filesystems, such as UBIFS, already use temporary
 buffers regardless of encryption.  Other filesystems, such as ext4 and
 F2FS, have to allocate bounce pages specially for encryption.
 
+Fscrypt is also able to use inline encryption hardware instead of the
+kernel crypto API for en/decryption of file contents.  When possible,
+and if directed to do so (by specifying the 'inlinecrypt' mount option
+for an ext4/F2FS filesystem), it adds encryption contexts to bios and
+uses blk-crypto to perform the en/decryption instead of making use of
+the above read/write path changes.  Of course, even if directed to
+make use of inline encryption, fscrypt will only be able to do so if
+either hardware inline encryption support is available for the
+selected encryption algorithm or CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK
+is selected.  If neither is the case, fscrypt will fall back to using
+the above mentioned read/write path changes for en/decryption.
+
 Filename hashing and encoding
 -----------------------------
 
@@ -1250,7 +1262,9 @@ Tests
 
 To test fscrypt, use xfstests, which is Linux's de facto standard
 filesystem test suite.  First, run all the tests in the "encrypt"
-group on the relevant filesystem(s).  For example, to test ext4 and
+group on the relevant filesystem(s).  One can also run the tests
+with the 'inlinecrypt' mount option to test the implementation for
+inline encryption support.  For example, to test ext4 and
 f2fs encryption using `kvm-xfstests
 <https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md>`_::
 
-- 
2.28.0.rc0.142.g3c755180ce-goog

