Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCBA35EA36
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Apr 2021 03:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348967AbhDNBFr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 13 Apr 2021 21:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231892AbhDNBFr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 21:05:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5CDE613B6;
        Wed, 14 Apr 2021 01:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618362326;
        bh=ciw9XawiOHA/nO5Uu28ulUUKiFo2Lyl5PEG2yeWAXww=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SLwP6qk6J6gPX6hvDwihGeXYWKnkItH0q7nbZMEN6qCimHtK2gJcfiEYOau72wj9u
         lQIkXull1mn3BPbgQQoCYYKQ0peYHZngMLTjjdMN5kkOGcWvOm3HlmOhI7IhaKyv1o
         9dceVIF0nI0PO7NMMWO8GFbTW/N+9AxlPHfqJBBRsMQff+8opH1NAdzmpeY/uFw1WN
         21oBBibpi4d+CdodazHLsUQMF1CQUO0kTd6/BWxcfvzCODZN76/YtilnxFwD0+FWqK
         uhItEgksrCzLxNjR+NK8rZmVUlRR18p8IUn8u6fyV7+Qht1Sqp5XhUVc6EnajKKZN0
         ASUxm5sHM71WQ==
Subject: [PATCH 9/9] xfs/305: make sure that fsstress is still running when we
 quotaoff
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Apr 2021 18:05:26 -0700
Message-ID: <161836232608.2754991.16417283237743979525.stgit@magnolia>
In-Reply-To: <161836227000.2754991.9697150788054520169.stgit@magnolia>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Greatly increase the number of fs ops that fsstress is supposed to run
in in this test so that we can ensure that it's still running when the
quotaoff gets run.  1000 might have been sufficient in 2013, but it
isn't now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/305 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/305 b/tests/xfs/305
index fdb48a1d..9a3f0e03 100755
--- a/tests/xfs/305
+++ b/tests/xfs/305
@@ -50,7 +50,7 @@ _exercise()
 	_qmount
 	mkdir -p $QUOTA_DIR
 
-	$FSSTRESS_PROG -d $QUOTA_DIR -n 1000 -p 100 $FSSTRESS_AVOID >/dev/null 2>&1 &
+	$FSSTRESS_PROG -d $QUOTA_DIR -n 1000000 -p 100 $FSSTRESS_AVOID >/dev/null 2>&1 &
 	sleep 10
 	xfs_quota -x -c "off -$type" $SCRATCH_DEV
 	sleep 5

