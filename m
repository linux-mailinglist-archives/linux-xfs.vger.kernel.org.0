Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE2A36D11C
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Apr 2021 06:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbhD1EJu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Apr 2021 00:09:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233960AbhD1EJp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 00:09:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ABFA613F1;
        Wed, 28 Apr 2021 04:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619582941;
        bh=lW7lFlbmUaXKOOdn5osdf44wOyG07HxU6Aquzssyb0Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rinPTcr2Gyo5N2/sRkW6oMJaQKlnq5FMAqETGXaiE3IIXvEYgsgJpIw0VnkhCChCn
         W8rSZsyJNNci2A61EUs8hvRkNU2r/GRU1GVVtpsUej5545BlWj2ZFKrhYZVrPzHGpA
         DxJNjvQLtcqtBr9oogSU5i+oH34KL9E9iUxrt88AWtxcEVNOl7oSO6m7HuwxN80RpP
         RKBB0VAfN2VTHLIGXGQKRevLewBxXNRHNj3Wn0pLHu/HvYwssli0fIOsKRGx72jgbS
         BXjYtNIWlHb1k4c5VQtKTTvHklNFhzG3W6tbNVLFYqpCUTPp6HgqoeiIiUo8nG8UlD
         FIMdRcDabMy4A==
Subject: [PATCH 1/5] xfs/276: remove unnecessary mkfs golden output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Apr 2021 21:09:00 -0700
Message-ID: <161958294062.3452351.18374824154438201788.stgit@magnolia>
In-Reply-To: <161958293466.3452351.14394620932744162301.stgit@magnolia>
References: <161958293466.3452351.14394620932744162301.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

A previous update to this test dropped the clause where the mkfs
standard output gets sent to /dev/null.  The filtered mkfs output isn't
needed here and it breaks the test, so fix that.

Fixes: e97f96e5 ("xfs/27[26]: force realtime on or off as needed")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/276 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/276 b/tests/xfs/276
index 6e2b2fb4..afea48ad 100755
--- a/tests/xfs/276
+++ b/tests/xfs/276
@@ -35,7 +35,7 @@ _require_test_program "punch-alternating"
 rm -f "$seqres.full"
 
 echo "Format and mount"
-_scratch_mkfs | _filter_mkfs 2> "$tmp.mkfs"
+_scratch_mkfs | _filter_mkfs 2> "$tmp.mkfs" >/dev/null
 . $tmp.mkfs
 cat "$tmp.mkfs" > $seqres.full
 _scratch_mount

