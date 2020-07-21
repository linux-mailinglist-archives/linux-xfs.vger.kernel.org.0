Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67CC227328
	for <lists+linux-xfs@lfdr.de>; Tue, 21 Jul 2020 01:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgGTXiA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 Jul 2020 19:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbgGTXhv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 19:37:51 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18211C0619D6
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2020 16:37:51 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id o15so14889177pgn.15
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2020 16:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ORAQciKgJGVxLPMl88O8FRaS7Y2vfgBBYDIN8L834Cw=;
        b=lw5TetxAIlCI7U6av5shkKyjO6ThYv7yDbySa3SgWcGSwSgPPaWjP++XkjFPG4OI6Z
         zWsLpvD626keD3tI0jFOivGvaW9+0l5eZ4l7hYSrpPYOPlwsi9MGB5ODpbI/7AA04Zb6
         tCC6woja7XRBkrAJHy6DcRwqP6vgX9nv2QZPhmI0hiNoTeqEbeuJdvn+TgYDZ0U60y3g
         wohrCT9NyZKibcZkl+RWiaSOHqiofv/sVgqViMF4tlhAtCQWBZ6HI7L1fDpq7bbcky5t
         iAtFFwrxXVO/FU54Nfq5i3XKHkcF5DMzbZKLz73/s51/PlZliyzBh0FjxR+L3S2QGwsQ
         HjDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ORAQciKgJGVxLPMl88O8FRaS7Y2vfgBBYDIN8L834Cw=;
        b=iMNpSJPzlIyhSDdtIaweQQEPSBqzd4/W+L6XhYHprpRqi9Tj53cke3b5lCyxbD6j5Q
         jd7c/pocs8vR1wyotzoncMYnAcaXJpo3jWXzvVhBzdq92hJ9ynz7fQmKhgBMCOnTgRds
         EqHNDb3lz2G5TZEmX00tzqmMFdp23EdcJ5ci0n1lf8F0twcQxZO/15PmI+tnylDeefpU
         zDkkqi/qp8YOhI2Bcc/TJVYz7NH97FbOPzBPTSTOUH0+fbnTvP7TsB5dYm9i8ITrx3M1
         zQSZYoCQNW8CMA1n7NZ7/AErJSIGGalzgUOdATls2gp/FpbnD7Hllio4VFopcV0d+L00
         erdg==
X-Gm-Message-State: AOAM531mT/gEoV68bjsu7bnjjdYQe2LzSmtptYe7UNrhHcc+dDGgzfiQ
        nWVTrm5F3ve32H1CXlMVI1x0lNq8r6M=
X-Google-Smtp-Source: ABdhPJzbpOkXCUZlTjezDtyNTQJ78cDjswr6o9ZRsmmCMJPX/pJ7vOwFhl9AcEfTreNpJVDB8ZhoYLeMtXM=
X-Received: by 2002:a17:90b:358e:: with SMTP id mm14mr1889035pjb.54.1595288270643;
 Mon, 20 Jul 2020 16:37:50 -0700 (PDT)
Date:   Mon, 20 Jul 2020 23:37:37 +0000
In-Reply-To: <20200720233739.824943-1-satyat@google.com>
Message-Id: <20200720233739.824943-6-satyat@google.com>
Mime-Version: 1.0
References: <20200720233739.824943-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v4 5/7] f2fs: support direct I/O with fscrypt using blk-crypto
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

Wire up f2fs with fscrypt direct I/O support. direct I/O with fscrypt is
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
 fs/f2fs/f2fs.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index b35a50f4953c..978130b5a195 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4082,7 +4082,11 @@ static inline bool f2fs_force_buffered_io(struct inode *inode,
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	int rw = iov_iter_rw(iter);
 
-	if (f2fs_post_read_required(inode))
+	if (!fscrypt_dio_supported(iocb, iter))
+		return true;
+	if (fsverity_active(inode))
+		return true;
+	if (f2fs_compressed_file(inode))
 		return true;
 	if (f2fs_is_multi_device(sbi))
 		return true;
-- 
2.28.0.rc0.105.gf9edc3c819-goog

