Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886803A70D8
	for <lists+linux-xfs@lfdr.de>; Mon, 14 Jun 2021 22:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbhFNVBI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 14 Jun 2021 17:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229771AbhFNVBI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jun 2021 17:01:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2510560241;
        Mon, 14 Jun 2021 20:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623704345;
        bh=ApdCffIvyioWE5Hu140dbIZdhPvJCBTDwfPFytVLGjo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RrquCN1x4PJ2FPR+9pzV7XKO5zOmJdcS+ZP+JOxWDMiw21fzixwMiidu1z9fr1Mdb
         RNDN8QhvXFHeVBPoQhM9RZcdGn9jtiabVfRTUMfHFglBBhVqzLT+kcVAaF5LVrfoaw
         r4nYSV3BpiafImSQOVu/e0HzRss7gRI3ISOw/KZY8dPYbAHIgJG53o4MPCqoldrHY+
         Bn8kF5c4Z5j4/Rh12rm2P2Tg6o1uTZLIoPX90fJgWhXmXQOb0q8w5GHoqh5nULJiqn
         cYL1Njh47kwN6rRlg7TEW6ST8Sm9/hGraBhJKX3eCtdzP8hHesTiTeVKdQ/1uBujVW
         HhWk3GNx4DxvQ==
Subject: [PATCH 01/13] fstests: fix group check in new script
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Date:   Mon, 14 Jun 2021 13:59:04 -0700
Message-ID: <162370434486.3800603.7731814883918606071.stgit@locust>
In-Reply-To: <162370433910.3800603.9623820748404628250.stgit@locust>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In the tests/*/group files, group names are found in the Nth columns of
the file, where N > 1.  The grep expression to warn about unknown groups
is not correct (since it currently checks column 1), so fix this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 new |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)


diff --git a/new b/new
index bb427f0d..357983d9 100755
--- a/new
+++ b/new
@@ -243,10 +243,7 @@ else
     #
     for g in $*
     do
-	if grep "^$g[ 	]" $tdir/group >/dev/null
-	then
-	    :
-	else
+	if ! grep -q "[[:space:]]$g" "$tdir/group"; then
 	    echo "Warning: group \"$g\" not defined in $tdir/group"
 	fi
     done

