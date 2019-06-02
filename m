Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2DC03234D
	for <lists+linux-xfs@lfdr.de>; Sun,  2 Jun 2019 14:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfFBMl3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 2 Jun 2019 08:41:29 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34737 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfFBMl2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Jun 2019 08:41:28 -0400
Received: by mail-wr1-f66.google.com with SMTP id e16so1206985wrn.1;
        Sun, 02 Jun 2019 05:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YeE+/BVUjXzXtoRPrMlnZ7zrvZqFsthbg+ijCE7TqkE=;
        b=gjnt2+49FgfzLTbXMPdMhQADlZ4URIceNw3GlTodGW0Ck/fPXWEwHRxhmbDr1+WjKN
         6pL+Jfw4vUr8Sv1avpgGiTScmYWyi/0/ZCBoYdipFz/5jNeArWRe7aXju+yOaBp+8fbk
         t/P5ivx7M8/qthFM9/N6zvmSgkGBCr8vFKXrOOm3JVQbrAmbPt3DkBEc8p0s0g2ZdVMs
         dXFb2GeyhxyuHRT58waWAkWvbJdOVGWCQZJcFExT+mMlnzKZ1oGEXv44tQYUHL5H7qVe
         4PkpjB8/YiYKEUC7i5EL9Kv5tQNs0DD+Ji0JAz5saZPbJJPBQVOiDlkkG6ULpwTeoSMw
         XtUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YeE+/BVUjXzXtoRPrMlnZ7zrvZqFsthbg+ijCE7TqkE=;
        b=tduUAbDCZwSLyj10UV6dYTupw2X/Ye99WoJli1yeirQ4cHPDw3k97lpYG4PftSxp9u
         7w/8WXciYY6GIZidOHsxPcn/gWo9OyPCCe0UKWbYkkAYNT5Hu+cONgn1AOR3bcktoHRB
         adqG4p3ZNO6u2YPta0Fk7yGJAMKhV80HzFYZxixG3P1NoMm1SS2GzNHJCwdGNwHFsrO0
         TCjOaqeuS1bffkpFIS3XrX711gtXBb9ewZKL4eTHZg0yGgkm51jTKV2yFrQSmTAT7T2V
         CYri47jmpwfTSjvvlx2PfPi+2zNlFhSGiIlzh3txjII+H0WWqYqW7shmuqejn/0A2rfZ
         FVyg==
X-Gm-Message-State: APjAAAXibtNeR+Moa0TVDMy2gAM4SS3nTfXmTzZQ+dW5bEXNoD0G22/J
        wheFuo0Af85K/933YUVEqYk=
X-Google-Smtp-Source: APXvYqzidEmmo4dGcjD8hqfuWmHMMckOVMctao7b/Y+OQPZOAMGWxj6UH43Tbs1cTi14VEWrIBrh8A==
X-Received: by 2002:adf:ea4a:: with SMTP id j10mr1027982wrn.114.1559479286990;
        Sun, 02 Jun 2019 05:41:26 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id g185sm11214827wmf.30.2019.06.02.05.41.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 05:41:26 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH v3 4/6] common/rc: check support for xfs_io copy_range -f N
Date:   Sun,  2 Jun 2019 15:41:12 +0300
Message-Id: <20190602124114.26810-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602124114.26810-1-amir73il@gmail.com>
References: <20190602124114.26810-1-amir73il@gmail.com>
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
index 17b89d5d..0d26b0fc 100644
--- a/common/rc
+++ b/common/rc
@@ -2086,9 +2086,16 @@ _require_xfs_io_command()
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
+		param_checked=1
 		;;
 	"falloc" )
 		testio=`$XFS_IO_PROG -F -f -c "falloc $param 0 1m" $testfile 2>&1`
-- 
2.17.1

