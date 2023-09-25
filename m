Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078457AE11E
	for <lists+linux-xfs@lfdr.de>; Mon, 25 Sep 2023 23:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjIYV7S (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 25 Sep 2023 17:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjIYV7R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:59:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA35AF
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:59:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86F6C433C8;
        Mon, 25 Sep 2023 21:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679151;
        bh=mlmF3kDQ4bt6+zSTNROH3YkJv9Yjdm9gHhxLBuKa2IQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=C3NQjvIRVAeq9eiOTwK+aiiBGKDTDwtmU6B32rxtJQi/HEHe0/9hwK8KLpjOzrNrN
         vsbvBjG5dNLHbGYJex2bTKHG8efQ69DnklwCvfYumvzsj7M0TJKP/cpBeFC7dcZ8j9
         km8aFrlefJGx87/WyrSKWSEltWPNNVufvnpbHuQa81ILM14ug4DdCyasQciDp/mLaG
         X8zItPrvul4hiNOcmoaaXxgv3l2rTZAxrq/oEi6q3J7W+8iOuVON52yMFkDGAALnI5
         nO2YsWGZRxlFpnlUwMZPwXwEDZhZoQkfj8KAIAWmoyGnxDkxihmwO8/1uzE81AqyVF
         9WZxHCaF8Ka3g==
Subject: [PATCH 1/2] libxfs: make platform_set_blocksize optional with
 directio
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:59:10 -0700
Message-ID: <169567915037.2320255.8793397462845978368.stgit@frogsfrogsfrogs>
In-Reply-To: <169567914468.2320255.9161174588218371786.stgit@frogsfrogsfrogs>
References: <169567914468.2320255.9161174588218371786.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we're accessing the block device with directio (and hence bypassing
the page cache), then don't fail on BLKBSZSET not working.  We don't
care what happens to the pagecache bufferheads.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index fda36ba0f7d..ce6e62cde94 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -125,10 +125,14 @@ libxfs_device_open(char *path, int creat, int xflags, int setblksize)
 	}
 
 	if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK) {
-		if (setblksize == 1)
+		if (setblksize == 1) {
 			/* use the default blocksize */
 			(void)platform_set_blocksize(fd, path, statb.st_rdev, XFS_MIN_SECTORSIZE, 0);
-		else {
+		} else if (dio) {
+			/* try to use the given explicit blocksize */
+			(void)platform_set_blocksize(fd, path, statb.st_rdev,
+					setblksize, 0);
+		} else {
 			/* given an explicit blocksize to use */
 			if (platform_set_blocksize(fd, path, statb.st_rdev, setblksize, 1))
 			    exit(1);

