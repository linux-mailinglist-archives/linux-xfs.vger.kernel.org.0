Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0872D54F4F5
	for <lists+linux-xfs@lfdr.de>; Fri, 17 Jun 2022 12:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381568AbiFQKHf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 Jun 2022 06:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381643AbiFQKHU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 06:07:20 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B860269CEC;
        Fri, 17 Jun 2022 03:06:56 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id x17so5098505wrg.6;
        Fri, 17 Jun 2022 03:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=47jpAIOuXq9C8yduL/rogZSE3IT97eVSEXgeU3hQDGc=;
        b=E8LEjur6pUGNeqET9KBTyDi2DDGKJwsVxRgcjPe+MV7DLr6TRNnDUKQjhYI4jlrSw2
         4FNvYDWWiZWuNE5sliJEhKO3uQmyekI4foZh+7G2zJ4r6i0keI2utSFvMwClQXnBIRv/
         XkRedZDDa8r9xbyYzpjd10+U+5BAwQE9FY9UOrmedNIEijJjhCoNPij/WiFY8bHLLzGA
         G4TP5dNCd84d+YLNfMqyIFWpfEeoSbqvQCI+UG5Kh3Z00kisfVh0Mogj7qH7t8TpGBkM
         aKyN8SXzj8UEW8lQI3G8ubHMWBlBqlCr4BAs7qOT3EG73HGRiVmyTISR3AIPflkc+28w
         gS/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=47jpAIOuXq9C8yduL/rogZSE3IT97eVSEXgeU3hQDGc=;
        b=gLUmCQLlgABUlV7zkVmHMp0JKteTwf5gQ3hYioxer74xCqd2S6/FKMMeVMSHmwgGan
         Ql+5k9nMpoCwfVBzfE50QG6tZy8Fnbqd56oE+wN9aKkvq57/1gUR0ulI/lLApxRexvYe
         WL23SACgD1OuazVSO+Hq1hTuQa6k04CQO5dFaogVaZCF/PGQL0s5XzXNWWM0Bye1q8Jb
         hP/5Nl6A35hLpiNBGaCsWJ0KXRodU1Uc0CLgbXA25y0pB4hDJuNZSeAInM0fjgyijgUb
         V63k3Am5TBKtFrqsk5Fdpdn/aY/QIwzJ69l3r3iB6yTxLhVfJw7zPYeEtEKIRp0Nd/2W
         uuLw==
X-Gm-Message-State: AJIora+K0yjwoI3Ls1mcMDrfS6J/Mt/J/NG3/XOLZCTMHe0mHJEpAU39
        ZLzK+8vlxJNjfH+LuMHpjWs=
X-Google-Smtp-Source: AGRyM1upm3iDDnzGgTzFpwshxYvWBSHaWUDPJPc2blLKHU1q/2yuBwIf7bfTm8BA+PwflkL1RxRgRw==
X-Received: by 2002:adf:eb4d:0:b0:218:45b6:8fdb with SMTP id u13-20020adfeb4d000000b0021845b68fdbmr8959402wrn.77.1655460415283;
        Fri, 17 Jun 2022 03:06:55 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id m42-20020a05600c3b2a00b003973435c517sm5265534wms.0.2022.06.17.03.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:06:54 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 05/11] xfs: check sb_meta_uuid for dabuf buffer recovery
Date:   Fri, 17 Jun 2022 13:06:35 +0300
Message-Id: <20220617100641.1653164-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220617100641.1653164-1-amir73il@gmail.com>
References: <20220617100641.1653164-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 09654ed8a18cfd45027a67d6cbca45c9ea54feab upstream.

Got a report that a repeated crash test of a container host would
eventually fail with a log recovery error preventing the system from
mounting the root filesystem. It manifested as a directory leaf node
corruption on writeback like so:

 XFS (loop0): Mounting V5 Filesystem
 XFS (loop0): Starting recovery (logdev: internal)
 XFS (loop0): Metadata corruption detected at xfs_dir3_leaf_check_int+0x99/0xf0, xfs_dir3_leaf1 block 0x12faa158
 XFS (loop0): Unmount and run xfs_repair
 XFS (loop0): First 128 bytes of corrupted metadata buffer:
 00000000: 00 00 00 00 00 00 00 00 3d f1 00 00 e1 9e d5 8b  ........=.......
 00000010: 00 00 00 00 12 fa a1 58 00 00 00 29 00 00 1b cc  .......X...)....
 00000020: 91 06 78 ff f7 7e 4a 7d 8d 53 86 f2 ac 47 a8 23  ..x..~J}.S...G.#
 00000030: 00 00 00 00 17 e0 00 80 00 43 00 00 00 00 00 00  .........C......
 00000040: 00 00 00 2e 00 00 00 08 00 00 17 2e 00 00 00 0a  ................
 00000050: 02 35 79 83 00 00 00 30 04 d3 b4 80 00 00 01 50  .5y....0.......P
 00000060: 08 40 95 7f 00 00 02 98 08 41 fe b7 00 00 02 d4  .@.......A......
 00000070: 0d 62 ef a7 00 00 01 f2 14 50 21 41 00 00 00 0c  .b.......P!A....
 XFS (loop0): Corruption of in-memory data (0x8) detected at xfs_do_force_shutdown+0x1a/0x20 (fs/xfs/xfs_buf.c:1514).  Shutting down.
 XFS (loop0): Please unmount the filesystem and rectify the problem(s)
 XFS (loop0): log mount/recovery failed: error -117
 XFS (loop0): log mount failed

Tracing indicated that we were recovering changes from a transaction
at LSN 0x29/0x1c16 into a buffer that had an LSN of 0x29/0x1d57.
That is, log recovery was overwriting a buffer with newer changes on
disk than was in the transaction. Tracing indicated that we were
hitting the "recovery immediately" case in
xfs_buf_log_recovery_lsn(), and hence it was ignoring the LSN in the
buffer.

The code was extracting the LSN correctly, then ignoring it because
the UUID in the buffer did not match the superblock UUID. The
problem arises because the UUID check uses the wrong UUID - it
should be checking the sb_meta_uuid, not sb_uuid. This filesystem
has sb_uuid != sb_meta_uuid (which is fine), and the buffer has the
correct matching sb_meta_uuid in it, it's just the code checked it
against the wrong superblock uuid.

The is no corruption in the filesystem, and failing to recover the
buffer due to a write verifier failure means the recovery bug did
not propagate the corruption to disk. Hence there is no corruption
before or after this bug has manifested, the impact is limited
simply to an unmountable filesystem....

This was missed back in 2015 during an audit of incorrect sb_uuid
usage that resulted in commit fcfbe2c4ef42 ("xfs: log recovery needs
to validate against sb_meta_uuid") that fixed the magic32 buffers to
validate against sb_meta_uuid instead of sb_uuid. It missed the
magicda buffers....

Fixes: ce748eaa65f2 ("xfs: create new metadata UUID field and incompat flag")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_buf_item_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index d44e8b4a3391..1d649462d731 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -805,7 +805,7 @@ xlog_recover_get_buf_lsn(
 	}
 
 	if (lsn != (xfs_lsn_t)-1) {
-		if (!uuid_equal(&mp->m_sb.sb_uuid, uuid))
+		if (!uuid_equal(&mp->m_sb.sb_meta_uuid, uuid))
 			goto recover_immediately;
 		return lsn;
 	}
-- 
2.25.1

