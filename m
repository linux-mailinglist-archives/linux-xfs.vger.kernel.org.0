Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4E83BD25
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Jun 2019 21:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389190AbfFJTxZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jun 2019 15:53:25 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37887 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389093AbfFJTxZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 15:53:25 -0400
Received: by mail-wr1-f66.google.com with SMTP id v14so10424266wrr.4;
        Mon, 10 Jun 2019 12:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5yVezAEm3Kh+ZyUafFUiOr+jNzdi59oca4GxknCYlSI=;
        b=d6O1D255Qjy9nvYS7BoqnI5kWDjC8+kwfzyjZUFb5upePASPRImcQt/ifl35ON9pD9
         3tfttuFnQn0dM7PdwdmvF8fnFI2fjWCQaibDCUmX8OiU4uLYOleRQLpbSB6ww3YqnAPX
         WVyg6ASy+BUIjlqAPvsQPxUFJUtH3pdLP9acb60XvhMNlO51zItazS+VWdJopmh/tFuy
         oRMkOC1YH++bcLwkkjgUcW+cDzsbG7k+neh+d1EFJ4AEnCRe99VEpLVM17K+r2wi7RzS
         AOm0tzqIpKnouMr6dlJVPfx1TBsWdz4ucS/gjdArLPq1MHXi1GKobyX8oZQglAPUUYeG
         xIMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5yVezAEm3Kh+ZyUafFUiOr+jNzdi59oca4GxknCYlSI=;
        b=LecQ+ZVxtFWLp2C6A0wgyHJW9VgHAWpjykHbusSt1preq7oXEC1eyz2qGvbUCnixDq
         U5U5wN+6lcs02umeLsoJFBatkSgwYtZWWkaQ8UbeDZMCZo87+dBbqft1+fIzAM27V/1I
         X9uI1HSKLSCw4nvSu57kqKuummPlyQUq4zCOhMAantXV7w0Tnpvp1b8Z+xLp6NWfoqhF
         4QCdlb4w7pvizAUFiHbJdu0cymIN3ESsMKq+IAhActewJRgFCPLdEQhyJxLKFmNBPyya
         swvEB/+tVqVD6W2n4G/n8oPB5NHhl4f70P3HCzTWIPzV2Sj+D6PGcJEhVQ85vv/vVZGt
         m48A==
X-Gm-Message-State: APjAAAVSq1nof28gDmjwM9rhU9wauZVpXTWcDl7YcaKe5V4WLMBvJTQ8
        45JnzidtQpMP+PYN/nE/0Tk=
X-Google-Smtp-Source: APXvYqwuMWmlfMbkzpodTrRaG0lF8piB6xuvEq0mo1p5LCz0KidrBAJsPz88aW5Vu7M6hIWqctL6tg==
X-Received: by 2002:a5d:6949:: with SMTP id r9mr31112650wrw.73.1560196403266;
        Mon, 10 Jun 2019 12:53:23 -0700 (PDT)
Received: from localhost.localdomain ([5.102.238.208])
        by smtp.gmail.com with ESMTPSA id t13sm26398651wra.81.2019.06.10.12.53.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 12:53:22 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH] generic/554: test only copy to active swap file
Date:   Mon, 10 Jun 2019 22:53:17 +0300
Message-Id: <20190610195317.8516-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Depending on filesystem, copying from active swapfile may be allowed,
just as read from swapfile may be allowed.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

Following feedback by Ted, I've decided it would be better to
remove the test case of copy from swap file.
There is no reason to deny that copy, but there is also no reason
for us to assert that filesystems must allow this functionality.

Even after removing the copy from test case, test still fails
on upstream for all filesystems I tested.
Tests passes with Darrick's copy-file-range-fixes branch.

Thanks,
Amir.

 tests/generic/554     | 3 +--
 tests/generic/554.out | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/tests/generic/554 b/tests/generic/554
index 10ae4035..c946ca17 100755
--- a/tests/generic/554
+++ b/tests/generic/554
@@ -4,7 +4,7 @@
 #
 # FS QA Test No. 554
 #
-# Check that we cannot copy_file_range() to/from a swapfile
+# Check that we cannot copy_file_range() to a swapfile
 #
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
@@ -46,7 +46,6 @@ echo swap files return ETXTBUSY
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

