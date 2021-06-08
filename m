Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC6639FD75
	for <lists+linux-xfs@lfdr.de>; Tue,  8 Jun 2021 19:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbhFHRVs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 8 Jun 2021 13:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233094AbhFHRVs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Jun 2021 13:21:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4387761359;
        Tue,  8 Jun 2021 17:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623172795;
        bh=YL/o1WyGAgqDY22nMhmz/PoqxP9YmmxmjN4nRAtvjN8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IvNe4fdCCQIcGBjvis8gBj3L7Is042SM+SKLjvjx7XIPYBveT0pFQ+BZhPouJoc+7
         1VsbXD6+pfmX+Zs84/+TLDCOFS7OWBGLtrTEAgDLrHtV0pYBLZ+djaP4mQ8Tr9ulFi
         2SH6Dbu0Y7qgo65JLKwho0SjLxv9kBW6DlsHyps8jnhITbf/5A6lZqZQj2DIo3EkH8
         p7Vag7qj1+FhQ6SyTuFxNIFIQlkTdeEUtD5QODNCcN87Y3iQiKkqpxRqm4w9na0ZVo
         MQt/FWT51N95yTm193uTbuk0xr27W0rVxkNPxWUdk7LYc7DYmS738/mAskqpPRm/D+
         nDghgnfU0b8Ig==
Subject: [PATCH 06/13] fstests: clean up open-coded golden output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Date:   Tue, 08 Jun 2021 10:19:55 -0700
Message-ID: <162317279504.653489.6631181052382825481.stgit@locust>
In-Reply-To: <162317276202.653489.13006238543620278716.stgit@locust>
References: <162317276202.653489.13006238543620278716.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix the handful of tests that open-coded 'QA output created by XXX'.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/btrfs/006.out   |    2 +-
 tests/btrfs/012.out   |    2 +-
 tests/generic/184.out |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/btrfs/006.out b/tests/btrfs/006.out
index a9769721..b7f29f96 100644
--- a/tests/btrfs/006.out
+++ b/tests/btrfs/006.out
@@ -1,4 +1,4 @@
-== QA output created by 006
+QA output created by 006
 == Set filesystem label to TestLabel.006
 == Get filesystem label
 TestLabel.006
diff --git a/tests/btrfs/012.out b/tests/btrfs/012.out
index 2a41e7e4..7aa5ae94 100644
--- a/tests/btrfs/012.out
+++ b/tests/btrfs/012.out
@@ -1 +1 @@
-== QA output created by 012
+QA output created by 012
diff --git a/tests/generic/184.out b/tests/generic/184.out
index 2d19691d..4c300543 100644
--- a/tests/generic/184.out
+++ b/tests/generic/184.out
@@ -1 +1 @@
-QA output created by 184 - silence is golden
+QA output created by 184

