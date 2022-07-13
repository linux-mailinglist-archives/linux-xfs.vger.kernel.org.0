Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71290572AA2
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Jul 2022 03:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbiGMBKC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 Jul 2022 21:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiGMBKB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 21:10:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12062CEB8C
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jul 2022 18:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4230618CD
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 01:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E55C3411E;
        Wed, 13 Jul 2022 01:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657674600;
        bh=CQPNrqiDvFNpUIrSoRVT9Mjl3ing8zxzCYljsacsPso=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=beK9wFq5zOe7kQTIbieaULLOBxEIJhUkazOKGMN4ZbW08r8Tn2s3iJsaG4Bsa0Eij
         1x0LkqKNMsdjOwW8Ccz/CfHeOTy0UyH+BaFWVs0XErjpCDV30I7oYWv1DuIguwUlv0
         d7AhudbYLgEh+0s9eWYBVovjhZ88hBhfQYR3qRQGPy/UReL23rjK2tU43AnsKuB8hW
         KydM44QdCVhXJRDqBnNSm6WjWBmQaLK7blTZVJ8PLx9pZ3Fnl/65ihwV/VdcAyW9AU
         vo/Vvd0fTDeO0btBRcjVsAlIkERU5iLo0DWOe9XmLCZTqj0YUJSitjvI6lZlzHHFM6
         HYrv+fDbQ15Yg==
Subject: [PATCH 4/4] mkfs: terminate getsubopt arrays properly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 12 Jul 2022 18:09:59 -0700
Message-ID: <165767459958.891854.15344618102582353193.stgit@magnolia>
In-Reply-To: <165767457703.891854.2108521135190969641.stgit@magnolia>
References: <165767457703.891854.2108521135190969641.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Having not drank any (or maybe too much) coffee this morning, I typed:

$ mkfs.xfs -d agcount=3 -d nrext64=0
Segmentation fault

I traced this down to getsubopt walking off the end of the dopts.subopts
array.  The manpage says you're supposed to terminate the suboptions
string array with a NULL entry, but the structure definition uses
MAX_SUBOPTS/D_MAX_OPTS directly, which means there is no terminator.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 61ac1a4a..9a58ff8b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -141,7 +141,7 @@ enum {
 };
 
 /* Just define the max options array size manually right now */
-#define MAX_SUBOPTS	D_MAX_OPTS
+#define MAX_SUBOPTS	(D_MAX_OPTS + 1)
 
 #define SUBOPT_NEEDS_VAL	(-1LL)
 #define MAX_CONFLICTS	8

