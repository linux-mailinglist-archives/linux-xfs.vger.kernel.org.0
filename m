Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEFD711CDE
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 03:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjEZBkt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 21:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234071AbjEZBkr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1721A6
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:40:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57F88646CD
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE52C433EF;
        Fri, 26 May 2023 01:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065245;
        bh=HUnWsZNV3KWVr6RHfR4PExfmzGQO0dCj+j9bl/tJTAQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=EB8SDQNpGwCf8zVfo69eyqozgpagdS7EJOeN4McsBWiYz+TgV2G+ltaqw645J4f9H
         oQejTd3ROe5eXL4pbyxhR8ZbWtc4C1q9H6A8+jdpKLvhxJs3nEDh07gJvXznenEfRL
         9JdC4YG2rLNBm+ebM4hN+xgTdTVE0DDZ9pnNIIx8mPNAKLX7RLwt0YcAWRo+eFZr5T
         JBI1nqKDsj1vimA3En0au6OiCiVEjgcXuFfFxucLR7R+fptgp4or01mVcPBmZSMUk4
         VYzKXMXtzplkLo4SkRZyzbZqTmeeU1cbvSSVKD1VWq4JEIIlPCOcQ5GLswaqV1gaon
         YZOvAeabGRM7A==
Date:   Thu, 25 May 2023 18:40:45 -0700
Subject: [PATCH 1/7] xfs_scrub: flush stdout after printing to it
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506071329.3742205.349121998840471158.stgit@frogsfrogsfrogs>
In-Reply-To: <168506071314.3742205.8114181660121831202.stgit@frogsfrogsfrogs>
References: <168506071314.3742205.8114181660121831202.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure we flush stdout after printf'ing to it, especially before we
start any operation that could take a while to complete.  Most of scrub
already does this, but we missed a couple of spots.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 4b96723f9ba..6c090a6dd88 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -535,6 +535,7 @@ _("%s: repairs made: %llu.\n"),
 		fprintf(stdout,
 _("%s: optimizations made: %llu.\n"),
 				ctx->mntpoint, ctx->preens);
+	fflush(stdout);
 }
 
 static void
@@ -620,6 +621,7 @@ main(
 	int			error;
 
 	fprintf(stdout, "EXPERIMENTAL xfs_scrub program in use! Use at your own risk!\n");
+	fflush(stdout);
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");

