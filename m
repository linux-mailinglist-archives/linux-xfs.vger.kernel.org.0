Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 343322A914
	for <lists+linux-xfs@lfdr.de>; Sun, 26 May 2019 10:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbfEZIpq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 May 2019 04:45:46 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34809 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbfEZIpq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 May 2019 04:45:46 -0400
Received: by mail-wr1-f68.google.com with SMTP id f8so13862346wrt.1;
        Sun, 26 May 2019 01:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tckcn1y7FRzPO6G+za+EoFRuwFIstypjqH+5hS8iplw=;
        b=WlmkaEJpte23u6Dl9zCuzyqbEWvbovqpjI/mZsT2OaHmYeKwdbSFJ6ZElhofx6FE57
         pTrAgW0ls0WzinBloO6YEtf4gu8VqBPCugDjYFfmVPuMzs8US+nmv7nw1t7enEimD78P
         03UKsl7pJp6bb+BvWSFcjlf8Z28QCoNK7Oa5uv730n4BE/Qp3ZXWQn5P94vdWFfkK05d
         LqM2wu0uJAUxoNhD46JTDMh6Br7DStWGJjke3Xfjqj5TSs0VoctBSm3DJbR4u2MHW6XY
         AMVtJPmVwcbc5bZW0dEOJlhWmMiPlt+/xcwOVGvZ8WePMSD0nfNaF+0debhvP0hEpN0x
         eDgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tckcn1y7FRzPO6G+za+EoFRuwFIstypjqH+5hS8iplw=;
        b=s1Vlc908UYWMc9ilaJ4SbjIhLbR35CLYdyzG8D513ioIwsT+ALMNmDYYAyiZnP3xKR
         EsPhKFoDI2Mz35iIadNxNa6vY47ujZyfU1WuJCbJtCrp14KD9eUpCDp7sUpr0Ga3OY2m
         qOs8JxMjAaoJNIwKyoXvxgsg56gMGAHLCBPHkc/PNiNuryFNQl+q6tf5hnlDwYw86bhp
         4HAndJISpNzTir/glxIvX98yNm4DPgyVZyIiW+5gP19H/1aemDaFNH1wkEmACV6vq8Y6
         fGTHya6zCwBmgml5bRhFuEKidNaXZs/IBXWcR2h91UOaC6A0pZnMkhr3c3qHlgioy0yq
         OKfw==
X-Gm-Message-State: APjAAAVc6X3Pop0rsjEx4c2MIrAWRUpcXrEyN01a/LJSAjyJbrlTpQ65
        5Ec3R8mqicOPF9RJ3AEcMVQ=
X-Google-Smtp-Source: APXvYqw9GFKKMhbAfdF0nCC1+D4AP5s4W/vWJ0y6xJbUrju2jpLcoriYAyMB+N8+IbXCOONpbkvgOQ==
X-Received: by 2002:adf:f9c5:: with SMTP id w5mr39523188wrr.26.1558860343834;
        Sun, 26 May 2019 01:45:43 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id q11sm7089717wmc.15.2019.05.26.01.45.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 01:45:43 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v2 1/5] generic: create copy_range group
Date:   Sun, 26 May 2019 11:45:31 +0300
Message-Id: <20190526084535.999-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190526084535.999-1-amir73il@gmail.com>
References: <20190526084535.999-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move some tests to the copy_range group so they are distinct
from the copy group which refers to xfs_copy tests.

[Amir] Revert copy past EOF behavior change

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/434   |  2 ++
 tests/generic/group | 10 +++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tests/generic/434 b/tests/generic/434
index 032f933d..edbf49d3 100755
--- a/tests/generic/434
+++ b/tests/generic/434
@@ -46,10 +46,12 @@ $XFS_IO_PROG -f -c "copy_range -s 1000 -l 100 $testdir/file" "$testdir/copy"
 md5sum $testdir/copy | _filter_test_dir
 
 echo "Try to copy to a read-only file"
+rm -f $testdir/copy
 $XFS_IO_PROG -r -f -c "copy_range -s 0 -l 100 $testdir/file" "$testdir/copy"
 md5sum $testdir/copy | _filter_test_dir
 
 echo "Try to copy to an append-only file"
+rm -f $testdir/copy
 $XFS_IO_PROG -a -f -c "copy_range -s 0 -l 100 $testdir/file" "$testdir/copy"
 md5sum $testdir/copy | _filter_test_dir
 
diff --git a/tests/generic/group b/tests/generic/group
index 49639fc9..b498eb56 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -432,11 +432,11 @@
 427 auto quick aio rw
 428 auto quick dax
 429 auto encrypt
-430 auto quick copy
-431 auto quick copy
-432 auto quick copy
-433 auto quick copy
-434 auto quick copy
+430 auto quick copy_range
+431 auto quick copy_range
+432 auto quick copy_range
+433 auto quick copy_range
+434 auto quick copy_range
 435 auto encrypt
 436 auto quick rw seek prealloc
 437 auto quick dax
-- 
2.17.1

