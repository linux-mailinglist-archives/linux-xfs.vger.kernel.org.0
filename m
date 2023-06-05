Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5115B722B57
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Jun 2023 17:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbjFEPiD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 5 Jun 2023 11:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234802AbjFEPh7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:37:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E58F7
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:37:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09CB76130E
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67979C433EF;
        Mon,  5 Jun 2023 15:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979476;
        bh=OWZH+9mk66qA+LSQBnehZuELZjXLtA3fisApuxt2odM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IJ1Xn+cQ/SZrgwKTYZMFDZYt+rAWqBvxKhhE6+3ole53XIyf8/Z7oNFQe5iX+hOLN
         ZkL+0sGZbr6vzS/qt192b7D2jGpSJaHV0dnfTL3RHxAAat5eQAMt19gaCCG2K4iBND
         8EiFw6LVoBL2686lpjCQoxo2bK3zDXkfH8JCCfmyK7DFjUqzLRd7sgj4edFz08RH6v
         dNkChLCYYxZpEeCUx8NnhpM/PIUn9KIBCHuyvbB4ylEe+COS0eIIL8u3pRhJuupm0/
         nGWpcDe3IzcLXXmgKDEhVptcqVl4TM7DMqUIXmiDngCs6hVkUFlsyXoRZIghhSPbwe
         THHSZ41w8TVLQ==
Subject: [PATCH 4/5] xfs_repair: fix messaging in
 longform_dir2_entry_check_data
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 05 Jun 2023 08:37:56 -0700
Message-ID: <168597947599.1226461.6500396961278469460.stgit@frogsfrogsfrogs>
In-Reply-To: <168597945354.1226461.5438962607608083851.stgit@frogsfrogsfrogs>
References: <168597945354.1226461.5438962607608083851.stgit@frogsfrogsfrogs>
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

Always log when we're junking a dirent from a non-shortform directory,
because we're fixing corruptions.  Even if we're in !verbose repair
mode.  Otherwise, we print things like:

entry "FOO" in dir inode XXX inconsistent with .. value (YYY) in ino ZZZ

Without telling the user that we're clearing the entry.

Fixes: 6c39a3cbda3 ("Don't trash lost+found in phase 4 Merge of master-melb:xfs-cmds:29144a by kenmcd.")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index a457429b3c6..3870c5c933a 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1883,8 +1883,7 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
 				dir_hash_junkit(hashtab, addr);
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
-				if (verbose)
-					do_warn(
+				do_warn(
 					_("\twill clear entry \"%s\"\n"),
 						fname);
 			} else  {

