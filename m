Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C192C3234A
	for <lists+linux-xfs@lfdr.de>; Sun,  2 Jun 2019 14:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfFBMlZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 2 Jun 2019 08:41:25 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37776 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfFBMlZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Jun 2019 08:41:25 -0400
Received: by mail-wm1-f68.google.com with SMTP id 22so390841wmg.2;
        Sun, 02 Jun 2019 05:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tckcn1y7FRzPO6G+za+EoFRuwFIstypjqH+5hS8iplw=;
        b=aH6OlV7e7Q1VqQuuAmbgzOJrikOWu4pnksLXOJabPp5bRyzTFu+btfC7E+NVNDd2At
         majA3ms5igQBJi9jaK9gGrfjvS6oHRb2c0GCufrfxQRvOrOBaHofFGRDA8KInICqRCSW
         04+Oz6rlYFcqrymJOwmPhQ+iAKsfC0gy55d/JyU4Z+rRCOQm8sggkJK7ZbI1dQGWslk7
         QVn7RBrzp1E2rHezD0kKn1GsttLo2uKgmwsPyV0GogVfeLYUQXeeDxNdtwhgFzS87P+I
         zJbKnKXEnRR5TWwXTVALdIjL3q3npZ/u93M4Uuxmm5gcU+koZatcdJ3YStMlFBM1ucnd
         ziUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tckcn1y7FRzPO6G+za+EoFRuwFIstypjqH+5hS8iplw=;
        b=QA9ZoliI5yykMf95A3OTz2WeAF0ZcWXeANLonY/5qqiBeh66NCZ6pwxWxrFtxNyZKs
         09Iv8HDxHKZPflGY9oaiMtLF+lqiTh4ywDBMPej2U7xH7fxjmGhpLs4yzeirsjXwXjRV
         54o90+BUhozwbn0YnuWH2eaSQzUoIUqz4oajV4D2ihQ1YbgXWKO9+nOdvtwscXHtLlZr
         CX52Z9f37tPgSQ/NPRY8BZ0pKWebVnXqvJ/F42AuFR2tIgIHXoI8fih0O7oxiQxM4zZK
         40eAHdmOSEGeKO1SVhE8QgrXtcD0E3obeElNjugLtV8j1oeoxNG7okqTAd/ot8CsThvw
         JbUw==
X-Gm-Message-State: APjAAAXy3gOKebH0Gc5IiQ24duxicE+CcIHDTSWnYIEBl0PBEieNRhGY
        aBV1OI7ykH7e6htwVtWivNc=
X-Google-Smtp-Source: APXvYqwIyaFv2YsfAAg88pMgSkeWJxEDY0BV5PfqcIjJ0bB3S6dazG1L8OV8PIHBUAorPOT4dbR8bg==
X-Received: by 2002:a1c:9a16:: with SMTP id c22mr11562318wme.39.1559479282857;
        Sun, 02 Jun 2019 05:41:22 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id g185sm11214827wmf.30.2019.06.02.05.41.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 05:41:22 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v3 1/6] generic: create copy_range group
Date:   Sun,  2 Jun 2019 15:41:09 +0300
Message-Id: <20190602124114.26810-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602124114.26810-1-amir73il@gmail.com>
References: <20190602124114.26810-1-amir73il@gmail.com>
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

