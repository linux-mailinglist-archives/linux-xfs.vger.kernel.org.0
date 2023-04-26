Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33D16EEB57
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Apr 2023 02:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238067AbjDZAOc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Apr 2023 20:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjDZAOb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Apr 2023 20:14:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EF08699;
        Tue, 25 Apr 2023 17:14:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 588D862E29;
        Wed, 26 Apr 2023 00:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B149DC4339B;
        Wed, 26 Apr 2023 00:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682468069;
        bh=1OdYSRlKf/AjwCMaQJt3WpDk9qqw5MOjbOMMhVctL7o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q+IIULorW0qqipcUAzrVh0sVNP8nmpVYBPA5TvYdzWM/TP5qLPf7HQT6tr3j/tFuO
         kp1xSDdb5VBsJ8xJhqcfrXRY2deufeO1llcUzZv8kBJDgOkDE2Lh0IFr9LuagfiPfa
         QWz/iGGNHxZC6dDTwMycddduYRXQpcMMz6tNfdkWUxf/hJ57GmnRIFO/a+ehsINGb1
         80pHGYW2Rt5CH8N93x7LNz8ma5jaBfrlLCFzaMuAuIQ1HGAAs+wZaCTHThHS4mb7wg
         jHvUZUJP8XzC1OvgTDIsU/oe+mR5C8mvTODvxwHfFXFDtxpM0uQ+fhHxg8/9WRxDC1
         7MGj8tEiFDHQQ==
Subject: [PATCH 2/4] readme: document TIME/LOAD_FACTOR
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 25 Apr 2023 17:14:29 -0700
Message-ID: <168246806922.732186.14938530606710009918.stgit@frogsfrogsfrogs>
In-Reply-To: <168246805791.732186.9294980643404649.stgit@frogsfrogsfrogs>
References: <168246805791.732186.9294980643404649.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Document these two variables so that we have /some/ reference for what
they're supposed to do.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 README |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/README b/README
index 4ee877a962..030b47d92a 100644
--- a/README
+++ b/README
@@ -250,6 +250,12 @@ Kernel/Modules related configuration:
  - Set KCONFIG_PATH to specify your preferred location of kernel config
    file. The config is used by tests to check if kernel feature is enabled.
 
+Test control:
+ - Set LOAD_FACTOR to a nonzero positive integer to increase the amount of
+   load applied to the system during a test by the specified multiple.
+ - Set TIME_FACTOR to a nonzero positive integer to increase the amount of
+   time that a test runs by the specified multiple.
+
 Misc:
  - If you wish to disable UDF verification test set the environment variable
    DISABLE_UDF_TEST to 1.

