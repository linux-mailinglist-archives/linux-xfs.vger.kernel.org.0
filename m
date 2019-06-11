Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C52503D118
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 17:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405256AbfFKPj0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Jun 2019 11:39:26 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41034 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405251AbfFKPj0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 11:39:26 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so13574488wrm.8;
        Tue, 11 Jun 2019 08:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YhTovJ3cWGZwkGPRnBO3Qj0c5DPWCt41kmytJyRSigI=;
        b=PxpxaqMHapkYG08GTlPCYA3Rc8H5jz2nCmiKLJsSfynGIurFFwAH9/HAY0xZGcNL9M
         FsCE+hErf0mzOHeWVfmUcxbab9W06EQet6BtNUXu4VX0Xbv3wSxCpiXrhe5BmFDp0+x/
         KppZB9LJhb4J3ldQ4V9J2tl/aQktMpZF46AnZ3wgV5RK7LfejlkiGKO2fhUr5XBUoarI
         P5D5dzAVzbVfzOjHgbhnqJlzP7ToATNp+efZqtRGuvCLMB/rbZH/mSdx6XHucK4b1sPh
         1vhwjk62pEAcnVmwe9BKf3+5RgdeeIiG2OARTAHaCWjJO+Z4/UjftsE5cRbv2L0O3Apo
         vXYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YhTovJ3cWGZwkGPRnBO3Qj0c5DPWCt41kmytJyRSigI=;
        b=Buri9cIKnu0Psp+A0F77W5xCA8CTut4rH4eZskGBaBPtDHKmeSu4LPWKMc87T2B2ao
         2zSQsDF04cleKOOn03ir/HV/+k2eXQ/9EX5t/45F1KenQzmCOIXAdKX/fRxB1BWpnFur
         AJPc7e7tfoHGVZif1Ez4zAQYuQERsACsjHbh44YYgOz1vSlQ8sbLpwGAqjHUJ7YX+n06
         6DXvjc3YSGQeTiaOj2rzQ7RHPZt+/CT8n2YkXLM3Cf7g2GwP+tAZKP86hMPs3Go6FNoa
         uc1efJf6Xwz42EvWZjHs0gV/+/leD/N/DZ84BI5HBFLqOCz90SGt6M+rxZvmZNZCYCON
         +gxA==
X-Gm-Message-State: APjAAAXFQ5cRNDDnalCEXlXY+L0QE8o6kw1JORfcE2UXSD4vTUGEVh+l
        Sw/o3qz/UtSDKIAkEp6Bm3w=
X-Google-Smtp-Source: APXvYqwbtXQoD8aSvz6KBdiVzj0lIatKXBi5H6zm3kbgjISLMFJu/eOPsWQW+gs/jagqx8nEsgCgzw==
X-Received: by 2002:a5d:53ca:: with SMTP id a10mr37761824wrw.131.1560267564551;
        Tue, 11 Jun 2019 08:39:24 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id f3sm10425904wre.93.2019.06.11.08.39.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 08:39:23 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH v2 1/2] generic/553: fix test description
Date:   Tue, 11 Jun 2019 18:39:15 +0300
Message-Id: <20190611153916.13360-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The test only checks copy to immutable file.
Note the kernel fix commit.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Changes from v1:
- Document kernel fix commit

 tests/generic/553 | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tests/generic/553 b/tests/generic/553
index 98ef77cc..58e0d5ef 100755
--- a/tests/generic/553
+++ b/tests/generic/553
@@ -4,7 +4,10 @@
 #
 # FS QA Test No. 553
 #
-# Check that we cannot copy_file_range() to/from an immutable file
+# Check that we cannot copy_file_range() to an immutable file
+#
+# This is a regression test for kernel commit:
+#   a31713517dac ("vfs: introduce generic_file_rw_checks()")
 #
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-- 
2.17.1

