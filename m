Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E576B58863C
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Aug 2022 06:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbiHCEVk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 3 Aug 2022 00:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbiHCEVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Aug 2022 00:21:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46A754658;
        Tue,  2 Aug 2022 21:21:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A2AE612BF;
        Wed,  3 Aug 2022 04:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC9BC433D6;
        Wed,  3 Aug 2022 04:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659500497;
        bh=f7C6JziZ45Fs5wdruwI+E86ZzjuLGQpZfR5RpkB4qRg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CKUncda+c9tD/dhNdl/kCrGtOlk3RY/1F7ZQ0MJm5wkDZHsZAMKHL6WN5F+QZ44TQ
         7ey29/Bz5+O+IMkqoi0ih84MlH3zW06acSw27uaCWC8L7gbDciNchJpEFVH39W+g48
         ZjBWT5VaEtjNPFxmK+0YortvSBdNTGsnooj3Er/3D5wqe9R+ooVMPVjhRvwydOfo4s
         e9VX92EEeofDBwzMjgJByadSjsFBnHaZPmIaUFYNC6pma4JZWxKO+4kK0WB0BZKDSV
         cLa7UTxPY3zxTPmzaLAAF3hUha7Rl0ZN9apek9e6/urbSgRkBGpPHClkBJqZxI6bwO
         Uc+A9MgV8mimg==
Subject: [PATCH 3/3] xfs/533: fix golden output for this test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 Aug 2022 21:21:37 -0700
Message-ID: <165950049724.198815.5496412458825635633.stgit@magnolia>
In-Reply-To: <165950048029.198815.11843926234080013062.stgit@magnolia>
References: <165950048029.198815.11843926234080013062.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Not sure what's up with this new test, but the golden output isn't right
for upstream xfsprogs for-next.  Change it to pass there...

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/533.out |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/533.out b/tests/xfs/533.out
index 7deb78a3..439fb16e 100644
--- a/tests/xfs/533.out
+++ b/tests/xfs/533.out
@@ -1,5 +1,5 @@
 QA output created by 533
 Allowing write of corrupted data with good CRC
 magicnum = 0
-bad magic number
+Superblock has bad magic number 0x0. Not an XFS filesystem?
 0

