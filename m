Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26D2C68A0A
	for <lists+linux-xfs@lfdr.de>; Mon, 15 Jul 2019 14:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbfGOMz0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 15 Jul 2019 08:55:26 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39447 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730012AbfGOMzZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 08:55:25 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so16962835wrt.6;
        Mon, 15 Jul 2019 05:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=x8+ET7vxAVjRgnK7tq9lJZBKdxKLB5BJlAWtcRWokrg=;
        b=mrEevGftlTk1FJHkCUAfyzb8cnRmJC2zxDwRK636L4GY0bw2rcG19R0SwFKNylGMYs
         /vVfuXdXcwYBWJKTku2f7RqpqQM4tsJS4ML1SPTV1RX4xwS7S9pq+N+XvZgSuxlVE7r5
         uBcF5VQyPxrdmsCPjTliQfBLBamdLcl7IMKV6xubKRqMqtEIBs645e+iz9Hu5mTe8/ML
         i6zBmsO6uPtPG0o4bF79k/+YQWWZU7tdfqX3CZqKQeNiOeVsFHrDJROj2Yu7HdR+5MmF
         3Lp4eThv85nuKIL2Zzi/teBRTh9f3ZD08cLl30Xkohrby8zH8DxYzksO3frrxWq7yjoD
         uLYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=x8+ET7vxAVjRgnK7tq9lJZBKdxKLB5BJlAWtcRWokrg=;
        b=ET8AJyxeoJvCejskzQOkIibMz1YWc8GrVc1iufFVJ+m3fFqGoT85VPTdIsVy6i/3PM
         FtmuNCrXHvWKGU2YYgN/XkDs7h8wxwFiTd0jZp4cdS2VPzNd08eSmYUEvM6tKA1mkCMH
         rCyVJKhvVG12sh5LNvXY01TeVnoOHQcSDgng94yBxI8lqvdJDVWmSrpeJPKvTeQXp+RN
         Ui0J82vULhCSjsODfXZKvTXILCfrPDDYXbjaceyivFX4+6WceB3MlMsH8u3sG/f0CXBo
         X3Fnj8RSvhqPcMs3IC49xRhkHX5rWu8COvdQkIlQEZ3LwjI+rl9Tpo0Nt/z6Jy9MTEk6
         Lhpg==
X-Gm-Message-State: APjAAAXGaWQzrxnfOCDyE9oiXLUigqDXFQNoic4jplMP1GZ7zEElQGi+
        NQMBIWoPzj87ahsCMQUVU2k=
X-Google-Smtp-Source: APXvYqw15pbS1a69y/uI18Cm/1IytKsI/6afs/aOTds3C2luoxZBP8GJ3HzfrYcGPiVNXp/6luRd7g==
X-Received: by 2002:a5d:51c1:: with SMTP id n1mr24851259wrv.254.1563195323896;
        Mon, 15 Jul 2019 05:55:23 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id u6sm20747920wml.9.2019.07.15.05.55.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 05:55:23 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH v4 1/3] common/rc: check support for xfs_io copy_range -f N
Date:   Mon, 15 Jul 2019 15:55:14 +0300
Message-Id: <20190715125516.7367-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190715125516.7367-1-amir73il@gmail.com>
References: <20190715125516.7367-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Implement "_require_xfs_io_command copy_range -f" to check for
the option added by following xfsprogs commit:

  xfs_io: allow passing an open file to copy_range

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index 000a7cc8..f1cec5ad 100644
--- a/common/rc
+++ b/common/rc
@@ -2105,9 +2105,16 @@ _require_xfs_io_command()
 		;;
 	"copy_range")
 		local testcopy=$TEST_DIR/$$.copy.xfs_io
+		local copy_opts=$testfile
+		if [ "$param" == "-f" ]; then
+			# source file is the open destination file
+			testcopy=$testfile
+			copy_opts="0 -d 4k"
+		fi
 		$XFS_IO_PROG -F -f -c "pwrite 0 4k" $testfile > /dev/null 2>&1
-		testio=`$XFS_IO_PROG -F -f -c "copy_range $testfile" $testcopy 2>&1`
+		testio=`$XFS_IO_PROG -F -f -c "copy_range $param $copy_opts" $testcopy 2>&1`
 		rm -f $testcopy > /dev/null 2>&1
+		param_checked="$param"
 		;;
 	"falloc" )
 		testio=`$XFS_IO_PROG -F -f -c "falloc $param 0 1m" $testfile 2>&1`
-- 
2.17.1

