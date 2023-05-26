Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFBA711D28
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 03:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbjEZByE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 21:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbjEZByC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:54:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3380A189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:54:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BA9061295
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDA1C433D2;
        Fri, 26 May 2023 01:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066040;
        bh=vLSeD5/pg8YhezMGdZXQpUX0oy28Tr8WfY78AjdNaQ8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=eI0A1won7Ge4H0oBVUoqI90Upg9seo61lZuMwk9mQ8oXH2JV8U+1y2AMCeB4p6KeR
         bNNWfvh0MvqnmvL78JzDbVZonAiMyBLewgM2RQ0j5fnxM1A2m8ncuz4Y2avTA6NFA2
         j5+/+x2jBPRfn1Ea6PnRVYopPS4+b3skaxBlUMelPE84dOT0H6uSLhEkHEir2ZX+Jk
         bVL/UIbekf70teQmnoiPMB75l+Btm0UJUB0J9OVpamVqasb48MDf9A0yea775zXbJu
         SeHxyeL02dEVfTlHLeEdfrmum5Kn6nP1M7UdafUz8yc8pRTAyEJ6xdc5pVJ5FeGYIF
         xlLdnlaYkjn/Q==
Date:   Thu, 25 May 2023 18:54:00 -0700
Subject: [PATCH 1/4] xfs_scrub_all: fix argument passing when invoking
 xfs_scrub manually
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506074189.3745941.864125085157099570.stgit@frogsfrogsfrogs>
In-Reply-To: <168506074176.3745941.5054006111815853213.stgit@frogsfrogsfrogs>
References: <168506074176.3745941.5054006111815853213.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, xfs_scrub_all will try to invoke xfs_scrub with argv[1] being
"-n -x".  This of course is recognized by C getopt as a weird looking
string, not two individual arguments, and causes the child process to
exit with complaints about CLI usage.

What we really want is to split the string into a proper array and then
add them to the xfs_scrub command line.  The code here isn't strictly
correct, but as @scrub_args@ is controlled by us in the Makefile, it'll
do for now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 060d8f66bfc..3fa8491c606 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -123,7 +123,9 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 				return
 
 		# Invoke xfs_scrub manually
-		cmd=['@sbindir@/xfs_scrub', '@scrub_args@', mnt]
+		cmd = ['@sbindir@/xfs_scrub']
+		cmd += '@scrub_args@'.split()
+		cmd += [mnt]
 		ret = run_killable(cmd, None, killfuncs, \
 				lambda proc: proc.terminate())
 		if ret >= 0:

