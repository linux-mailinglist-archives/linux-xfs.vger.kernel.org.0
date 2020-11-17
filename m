Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2972B66DE
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Nov 2020 15:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgKQOH3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Nov 2020 09:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387918AbgKQOH3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 09:07:29 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D517BC08E85E
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 06:07:24 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id c20so3293771pls.12
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 06:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=R5CBswLlpIQJapBKDpTXO8RLcdpazdMLHFE+h8xz3Es=;
        b=A1VqI+LMloxuA0/HprdxN9YHfC55pEdsHf9BWLtT4qqvVhKEvzYgxNkj+PEH42zjXI
         OeoVgtNcR3CaOyVZPb0/+EZGu6RDYd31W6zu2oEy2+C+HnSD+jn7TyQ7D+HZa8IjozkG
         4hAqocgyLQCoHqVkyG8GyLQLIaRU2/fq6uT/ZkAsK9xFCvgEfNnS4Hongmf7BNJPyj8x
         UbUJ9UUgodrohuPK1/l/tCv4x6Xms0f/fdtBrte0iHuY0WAnhEc6rzUTBxXXLvNrFyIl
         IaO2TCGhJ4uq4s+QPe2kWWVsyJGVNENdgx1rzkljewjoPQlOzUEgn/9ZvFhUmL7E+Gll
         5Oig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=R5CBswLlpIQJapBKDpTXO8RLcdpazdMLHFE+h8xz3Es=;
        b=NFV3MF0D/1l25xVsKLfd2dP2EP/Rq7I3cUSw5iNoXxuYih5Up5JMcjR2T/PYK5eFM3
         Oa/rGWJOttTp6s6/p1wz269KnZOfX+rj17ZDH1YOQ3pQ3OIgDCt0v8z9yfWxsgyt6yxz
         8h/ketkSj8Zm6CdLCY2PozHd4Qi2knfaMm0gFqSvHnM/H7esh93KyHft7z8UQJTmpAtD
         lcYy/3vFo8zOA7Mv2SyZY6GKGb/6pF2jy8x42q2jHGaedToTN4TCJFLW6igDTPKqy4eK
         MwvJb73T8F30j5XjvCp+6pm5nhLs9MNdpwxzSYnfjOX/jp1cDhlhTCX+U6jm+LexDxW0
         8U2w==
X-Gm-Message-State: AOAM531RBapXGTFnBHBzPHH1J5qfcb4AAXj/EdXhJ9nK5qf38C+R1enH
        qBPKB2hWcUIAlyMlGRrb7FgKvnWt4DI=
X-Google-Smtp-Source: ABdhPJyWmh3Iv+b4cPEzHM54qrtBxKCx9Mi+c3ZCqdPzBuuo/b+Pkvkr7t7Q1Y5hP7E1a6CpiFyWdFgF074=
Sender: "satyat via sendgmr" <satyat@satyaprateek.c.googlers.com>
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a62:17c8:0:b029:18b:5a97:a8d1 with SMTP id
 191-20020a6217c80000b029018b5a97a8d1mr18265685pfx.15.1605622044271; Tue, 17
 Nov 2020 06:07:24 -0800 (PST)
Date:   Tue, 17 Nov 2020 14:07:06 +0000
In-Reply-To: <20201117140708.1068688-1-satyat@google.com>
Message-Id: <20201117140708.1068688-7-satyat@google.com>
Mime-Version: 1.0
References: <20201117140708.1068688-1-satyat@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [PATCH v7 6/8] ext4: support direct I/O with fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Wire up ext4 with fscrypt direct I/O support. Direct I/O with fscrypt is
only supported through blk-crypto (i.e. CONFIG_BLK_INLINE_ENCRYPTION must
have been enabled, the 'inlinecrypt' mount option must have been specified,
and either hardware inline encryption support must be present or
CONFIG_BLK_INLINE_ENCYRPTION_FALLBACK must have been enabled). Further,
direct I/O on encrypted files is only supported when the *length* of the
I/O is aligned to the filesystem block size (which is *not* necessarily the
same as the block device's block size).

fscrypt_limit_io_blocks() is called before setting up the iomap to ensure
that the blocks of each bio that iomap will submit will have contiguous
DUNs. Note that fscrypt_limit_io_blocks() is normally a no-op, as normally
the DUNs simply increment along with the logical blocks. But it's needed
to handle an edge case in one of the fscrypt IV generation methods.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
Reviewed-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/ext4/file.c  | 10 ++++++----
 fs/ext4/inode.c |  7 +++++++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 3ed8c048fb12..be77b7732c8e 100644
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
@@ -495,7 +497,7 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	/* Fallback to buffered I/O if the inode does not support direct I/O. */
-	if (!ext4_dio_supported(inode)) {
+	if (!ext4_dio_supported(iocb, from)) {
 		if (ilock_shared)
 			inode_unlock_shared(inode);
 		else
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0d8385aea898..0ef3d805bb8c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3473,6 +3473,13 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	if (ret < 0)
 		return ret;
 out:
+	/*
+	 * When inline encryption is enabled, sometimes I/O to an encrypted file
+	 * has to be broken up to guarantee DUN contiguity. Handle this by
+	 * limiting the length of the mapping returned.
+	 */
+	map.m_len = fscrypt_limit_io_blocks(inode, map.m_lblk, map.m_len);
+
 	ext4_set_iomap(inode, iomap, &map, offset, length);
 
 	return 0;
-- 
2.29.2.299.gdc1121823c-goog

