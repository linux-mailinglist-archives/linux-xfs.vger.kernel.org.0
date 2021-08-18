Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D993EF65C
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Aug 2021 01:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236664AbhHQXxj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Aug 2021 19:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235369AbhHQXxj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:53:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8F0161008;
        Tue, 17 Aug 2021 23:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629244385;
        bh=mHYqQrWJ0Y67Nv8iy03CGJU/DY9sjGbFXpT3rwTWKIY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GbsIAZXJGqQDFgYCaDUKWWsMZaHO0/nFLgJtA1+kNOPr7tIo6FccU6E56/r46+7cc
         gMj3/mvMee+3OvBxkY6CT2gy7XSq9RgCQGZsUnccvC0qNdTqqj2JKipc7clyXA3UJV
         cBi12aV6BTgqb3bWisxvEihLldKYqw3Oo6skepJnTmz8hvdjeSEs5JoO59QltFCj1d
         BdCisy3r6a74eqHGg5HyeT/ihiDMK4QYX75g4JthCHXnErpDVgIsQK+uXplrV+Yrez
         LV/BqgThIsWdwfBR4+ULdogY0L8f4/KXmzYBSyuJXrTtDqrteE+zglKjoBPXFFOhgF
         dIx41oKXlRwmw==
Subject: [PATCH 1/2] xfs/176: fix the group name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 17 Aug 2021 16:53:05 -0700
Message-ID: <162924438548.779373.13859752576829414097.stgit@magnolia>
In-Reply-To: <162924437987.779373.1973564511078951065.stgit@magnolia>
References: <162924437987.779373.1973564511078951065.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Filesystem shrink tests for xfs are supposed to be in the 'shrinkfs'
group, not 'shrink'.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/176 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/176 b/tests/xfs/176
index ce9965c2..ba4aae59 100755
--- a/tests/xfs/176
+++ b/tests/xfs/176
@@ -8,7 +8,7 @@
 # of the filesystem is now in the middle of a sparse inode cluster.
 #
 . ./common/preamble
-_begin_fstest auto quick shrink
+_begin_fstest auto quick shrinkfs
 
 # Import common functions.
 . ./common/filter

