Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 122D86AE995
	for <lists+linux-xfs@lfdr.de>; Tue,  7 Mar 2023 18:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjCGRZo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 7 Mar 2023 12:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbjCGRZV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Mar 2023 12:25:21 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF779887A
        for <linux-xfs@vger.kernel.org>; Tue,  7 Mar 2023 09:20:24 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id x11so10342940pln.12
        for <linux-xfs@vger.kernel.org>; Tue, 07 Mar 2023 09:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678209624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QGzn8Jh8ZKEAR+XabpvsJcqmOPwNEpOpb9eL39TjD2s=;
        b=1eyM8I2j7WCg36Foo4+Sc4CeRGDLUDGUnMpyF0UHm72mQxc9kfH5fw6ttfD/K+QHd9
         h3eWq0JPdOhMjwMXDPsIbow0slc2h5ls9s1vUuFSIYTjxvxZyRccZrT3E1ShYIlNDFB6
         g3Fghio8gD0sp07Pc/8uU6Z/ieb0E9t8rO35xhbkzpF6NlEqcvgLx1GTP+FUAtloSqA2
         QtCz9pvFzkX17VUJhs9AhXIWA/nO3FxZmX6Kkf36Tct4+tPQDxb8z2YynfrOR9qBNaGb
         l0FTaW0myw0bMaxU0sXWOGq4RyGUkF25IPN04mrn8Dds2qV0wdODxinb9v1PcC9+YL+/
         Yd5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678209624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QGzn8Jh8ZKEAR+XabpvsJcqmOPwNEpOpb9eL39TjD2s=;
        b=42qHitaIN+fImDM5aXwP9faHLqpF3Rbg3tuksHxS57OsHbc652HXRA5Bty4Y27gx9x
         uEWRGOMw6+I22yPcjYTCJYDlyGEMw+LH3Ea/yn5YnfCfLtr05D9HNN/du3ZptwQa6T7V
         4gDKyhGHzfwko/4RCF5/wcPzbcVyUAJlPdI20Z13UpaNEoVUlkyaz++/VIQcqotBMx7H
         lMQ5uzk2FnMK3/UIUkSiEGpwk+GfzmFB0JNegxqoI5zRlSJ5Md1a46O0gMoLOQ8e16bk
         zx0IHWNKw9CCtJJF9rTVydqocSLGXjQBItaUWHXHUp9yiIOYfGz9lndkQQHRfS4temqT
         qGrg==
X-Gm-Message-State: AO0yUKXumFjTcCoOjA55RbeozKANqFDl+pUUV/PBT4VluMclrhELmDx5
        LJdaVOto19PqMAeOvEJwAjMfHx/nTGY6ZoUSInY=
X-Google-Smtp-Source: AK7set+yJzNNfb3gCkbf0SKS9XnejUmfExgD0rV7zoPrtcvqqHLIbcOfeAPkLbbCmPVNcx079Pp+yQ==
X-Received: by 2002:a17:902:ecc7:b0:19e:b5d3:1710 with SMTP id a7-20020a170902ecc700b0019eb5d31710mr9904245plh.2.1678209623665;
        Tue, 07 Mar 2023 09:20:23 -0800 (PST)
Received: from localhost.localdomain ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id c17-20020a170903235100b0019e76a99cdbsm8651390plh.243.2023.03.07.09.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 09:20:23 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: avoid hashing O_DIRECT writes if the filesystem doesn't need it
Date:   Tue,  7 Mar 2023 10:20:15 -0700
Message-Id: <20230307172015.54911-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307172015.54911-1-axboe@kernel.dk>
References: <20230307172015.54911-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

io_uring hashes writes to a given file/inode so that it can serialize
them. This is useful if the file system needs exclusive access to the
file to perform the write, as otherwise we end up with a ton of io-wq
threads trying to lock the inode at the same time. This can cause
excessive system time.

But if the file system has flagged that it supports parallel O_DIRECT
writes, then there's no need to serialize the writes. Check for that
through FMODE_DIO_PARALLEL_WRITE and don't hash it if we don't need to.

In a basic test of 8 threads writing to a file on XFS on a gen2 Optane,
with each thread writing in 4k chunks, it improves performance from
~1350K IOPS (or ~5290MiB/sec) to ~1410K IOPS (or ~5500MiB/sec).

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fd9ba840c4a2..93cc1ff5e9cd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -429,7 +429,13 @@ static void io_prep_async_work(struct io_kiocb *req)
 	}
 
 	if (req->flags & REQ_F_ISREG) {
-		if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
+		bool should_hash = def->hash_reg_file;
+
+		/* don't serialize this request if the fs doesn't need it */
+		if (should_hash && (req->file->f_flags & O_DIRECT) &&
+		    (req->file->f_mode & FMODE_DIO_PARALLEL_WRITE))
+			should_hash = false;
+		if (should_hash || (ctx->flags & IORING_SETUP_IOPOLL))
 			io_wq_hash_work(&req->work, file_inode(req->file));
 	} else if (!req->file || !S_ISBLK(file_inode(req->file)->i_mode)) {
 		if (def->unbound_nonreg_file)
-- 
2.39.2

