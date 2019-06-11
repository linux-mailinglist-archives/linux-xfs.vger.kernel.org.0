Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8D23D119
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 17:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405258AbfFKPj2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Jun 2019 11:39:28 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55152 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405251AbfFKPj2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 11:39:28 -0400
Received: by mail-wm1-f65.google.com with SMTP id g135so3473007wme.4;
        Tue, 11 Jun 2019 08:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dzP0rBdsxrEl8CUn719JHTsNjWllx8oI1IOQwj6wH0o=;
        b=GHZqvnIVujlMgZyoC+Zc5UZDpC/omGu6+SSPvUpnNEvJ+R8TUnhPgdK7K47noIHbWP
         uhxRge/JNnEbrJ8hzHcy2XKRZ2HrdeLewWdIy2CoWXWjmwvgGp/6Ke8d+atnYHuo6JyK
         UtfvTfcoGHAq47cBJqIiuuZQ3DoMciI0VsIJonDXq+RMyybK6/JLw9qj4u9ZXp4+bvpl
         DEXnXiHAcbNJ23s9Fbm8KwfrV6Kjc1PGX78FNwa06YU5vI8ZJ6z7qvX3Jdcf1K8eg9HN
         J9fsr+BM7rfQSQ2lAqnJYKqqiBR47Wbk9xYG4FsaH+IMXbroZwfWvH+SnLebVKPVps+X
         FaNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dzP0rBdsxrEl8CUn719JHTsNjWllx8oI1IOQwj6wH0o=;
        b=WDfH42rnM9FE/gC2PX9WkwXhN0nGDExVvTjulcgI/KHYsmElzFBq2wH2h6mOAOkBN6
         z1VWJg7YbrO0W1eQp5mbVwByaHq3xUmX0lVcvI0jFy/N48S9yqUyHEQ8jlRMh0kU7lov
         Yep8iuOrM/n8/rw3vn8OAlLh0VQONbx7sQKwExwlknh3x3NyUaqSlwQjUm1XdTNjRTmB
         xOe3DHU7qm5bz9nGCknARk91NT8IwDxSQ3R5qxQwauVtGitf60x/RfeI1gfrZi+IFMXK
         yjXY7nzH/2QG8+ZMc8on7Hxjcg4k0BNcOLSCD/mfaHpJ+pzKs+1b2l5eL+YEuCnoCcSS
         tJhA==
X-Gm-Message-State: APjAAAWlsXObmoe0i+sBpml2ZCbkeMrGIeUCI3CzQbJ5xwH0slFiP0SJ
        +Cn4fucC4FcGPUk5BdA6+Mk=
X-Google-Smtp-Source: APXvYqx4LLmNvlRrjGQzGJTEfCNrEg9BQzuWM0MWh5duUfFSSuL7h5+97vwfLGHdP9DGRvnThPHFVw==
X-Received: by 2002:a1c:6242:: with SMTP id w63mr19650139wmb.161.1560267566207;
        Tue, 11 Jun 2019 08:39:26 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id f3sm10425904wre.93.2019.06.11.08.39.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 08:39:25 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/2] generic/554: test only copy to active swap file
Date:   Tue, 11 Jun 2019 18:39:16 +0300
Message-Id: <20190611153916.13360-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611153916.13360-1-amir73il@gmail.com>
References: <20190611153916.13360-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Depending on filesystem, copying from active swapfile may be allowed,
just as read from swapfile may be allowed.

Note the kernel fix commit in test description.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

Per your and Ted's request, I've documented the kernel fix commit
in the new copy_range tests. Those commits are now on Darrick's
copy-file-range-fixes branch, which is on its way to linux-next
and to kernel 5.3.

Thanks,
Amir.


Changes from v1:
- Document kernel fix commit

 tests/generic/554     | 6 ++++--
 tests/generic/554.out | 1 -
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tests/generic/554 b/tests/generic/554
index 10ae4035..fa19d580 100755
--- a/tests/generic/554
+++ b/tests/generic/554
@@ -4,7 +4,10 @@
 #
 # FS QA Test No. 554
 #
-# Check that we cannot copy_file_range() to/from a swapfile
+# Check that we cannot copy_file_range() to a swapfile
+#
+# This is a regression test for kernel commit:
+#   a31713517dac ("vfs: introduce generic_file_rw_checks()")
 #
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
@@ -46,7 +49,6 @@ echo swap files return ETXTBUSY
 _format_swapfile $SCRATCH_MNT/swapfile 16m
 swapon $SCRATCH_MNT/swapfile
 $XFS_IO_PROG -f -c "copy_range -l 32k $SCRATCH_MNT/file" $SCRATCH_MNT/swapfile
-$XFS_IO_PROG -f -c "copy_range -l 32k $SCRATCH_MNT/swapfile" $SCRATCH_MNT/copy
 swapoff $SCRATCH_MNT/swapfile
 
 # success, all done
diff --git a/tests/generic/554.out b/tests/generic/554.out
index ffaa7b0a..19385a05 100644
--- a/tests/generic/554.out
+++ b/tests/generic/554.out
@@ -1,4 +1,3 @@
 QA output created by 554
 swap files return ETXTBUSY
 copy_range: Text file busy
-copy_range: Text file busy
-- 
2.17.1

