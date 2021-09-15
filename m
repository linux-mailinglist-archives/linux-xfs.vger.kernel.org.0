Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68BCE40D062
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Sep 2021 01:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhIOXou (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 Sep 2021 19:44:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229769AbhIOXoq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:44:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D071960F25;
        Wed, 15 Sep 2021 23:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631749406;
        bh=Wwnf7Myvevd+6SzfYQlIGdUlsu5mvL+Va58aS8i5qYg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VnI/EJ52VVfIog8KBu4tfDc7TO1DoN9yO8P2JTbzXchdrm8ptuil5FfKAZDQy40S2
         QLDsHA/afmA1njtVbykUeB+OZb36WeNmsXuO2biJ0UG3xQ1ofZJ/v+U9hSYYVJiUxM
         cJCrIbe/FlFgckZ4rO+C36Vdz9OMI7Dipgf0GrXWPDMcMzEyXMA9mznpxFlLqbWPGg
         1pZ8Dscg02ZjA7PR6WR/E30vy5s71L4EfFxoVZlnBQP3SIVI8FONZcJTOfDJMhKjKN
         mzzmOi+1H9tJ0EgkBzWoLnzhlOVHJWQc4VLlGvV8OJneTm8WA3/sf1eGli8f4/MG0M
         cBKKoHsqNyAiw==
Subject: [PATCH 9/9] new: don't allow new tests in group 'other'
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 15 Sep 2021 16:43:26 -0700
Message-ID: <163174940659.380880.14564845266535022734.stgit@magnolia>
In-Reply-To: <163174935747.380880.7635671692624086987.stgit@magnolia>
References: <163174935747.380880.7635671692624086987.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The 'other' group is vaguely defined at best -- other than what?  It's
not clear what tests belong in this group, and it has become a dumping
ground for random stuff that are classified in other groups.  Don't let
people create new other group tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 new |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


diff --git a/new b/new
index 6b7dc5d4..5cf96c50 100755
--- a/new
+++ b/new
@@ -96,9 +96,9 @@ then
 
     while true
     do
-	echo -n "Add to group(s) [other] (separate by space, ? for list): "
+	echo -n "Add to group(s) [auto] (separate by space, ? for list): "
 	read ans
-	[ -z "$ans" ] && ans=other
+	[ -z "$ans" ] && ans=auto
 	if [ "X$ans" = "X?" ]
 	then
 	    echo $(group_names)
@@ -109,6 +109,9 @@ then
 		echo "Invalid characters in group(s): $inval"
 		echo "Only lower cases, digits and underscore are allowed in groups, separated by space"
 		continue
+	    elif echo "$ans" | grep -q -w "other"; then
+		echo "Do not add more tests to group \"other\"."
+		continue
 	    else
 		# remove redundant spaces/tabs
 		ans=`echo "$ans" | sed 's/\s\+/ /g'`

