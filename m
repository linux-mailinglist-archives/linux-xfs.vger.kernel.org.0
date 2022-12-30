Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826C3659FE4
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 01:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbiLaApN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 19:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235868AbiLaApN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:45:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54ED1EAD1;
        Fri, 30 Dec 2022 16:45:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A7C2B81E67;
        Sat, 31 Dec 2022 00:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17597C433D2;
        Sat, 31 Dec 2022 00:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447510;
        bh=ZAzs2xev1tfa8EyQhXzzWBBAFojFFl6uRQi+nzTBvp8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Mc+jU5ovYdBVWyHKoObFuZmYUJXYJ0tuft28UEf05P1BLOOJFHGbAZo5nFxvvaj+w
         1kecPkHpS1H7goxMa8OVoXzCna5SC0+lPpD8sk9nE5CAxwMRU3hkPrfHTIzNs7u57C
         ZVrZNMfgKLYnVR3tni0GBydbieQu+9hL7gEH4pk1eunq5fPxqhEEwazGGDJ0RwFWvW
         SHw6NVc1L1aTEkm2EpRhwLDbwG6opxS7Wx5f++y4PJtUNVivjrijdG2mW9T40/e6wx
         +cHjoA8a08T+JYU1A9OuH1z5PeUYOd0bpeimYafbZkm2LJ85c3r2lhtMWddUSXJcdA
         LhICBJynL2Lkg==
Subject: [PATCH 04/24] fuzzy: don't fuzz obsolete inode fields
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:39 -0800
Message-ID: <167243877960.730387.18399629813029803190.stgit@magnolia>
In-Reply-To: <167243877899.730387.9276624623424433346.stgit@magnolia>
References: <167243877899.730387.9276624623424433346.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We don't really care about inode fields were used in V4 (deprecated) or
DMAPI (unsupported) so don't bother fuzzing them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index 677e655d68..d183052a14 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -80,7 +80,10 @@ __filter_unvalidated_xfs_db_fields() {
 	sed -e '/\.sec/d' \
 	    -e '/\.nsec/d' \
 	    -e '/^lsn$/d' \
-	    -e '/\.lsn/d'
+	    -e '/\.lsn/d' \
+	    -e '/^core.flushiter/d' \
+	    -e '/^core.dmevmask/d' \
+	    -e '/^core.dmstate/d'
 }
 
 # Filter the xfs_db print command's field debug information

