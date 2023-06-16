Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73EBB7324B3
	for <lists+linux-xfs@lfdr.de>; Fri, 16 Jun 2023 03:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbjFPBgV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Jun 2023 21:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFPBgU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 21:36:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653D12948
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 18:36:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C73061B0A
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 01:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE112C433C0;
        Fri, 16 Jun 2023 01:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686879377;
        bh=+Pmy9cDnrivvrAzeMA4I1CphxRYQuCHR2mE7vewB2uM=;
        h=Date:From:To:Cc:Subject:From;
        b=RFx2dj1s19ws1wauDQBSz/DC3EdRSKzvl0Vyspp8NvW/EYFPpby2z72XNzSXYa7SL
         3oorfddiOFmzyp9h/qQdnPQ04qw5Gz4627fFNtlL8ETK0vTdex2LwJSbMBultwG951
         cW2XfrJUx4JHFlBo3ZYwAmjhHv20fBiiqzhYy7PE6jA6Ap4RasxbSHQyChBbI18eN3
         NI9Uy8G702Hc2lZI040CIglWcbdYv5Ws5zKBuD6IeDkR6pOWQqO32QbWVg0aetVevm
         rEheq+ZXOBUJ5s5w+xlcZn46hmHDPHtgp8mheFqRcFDBw9+jZoq4mFwLNXxF7eYOW1
         TiGNCKEScFZnw==
Date:   Thu, 15 Jun 2023 18:36:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: new libxfs 6.4 sync
Message-ID: <20230616013617.GC11467@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Ok, trying this again, this time without pressing the wrong key when
stupid mutt asks "No subject, abort? [y/n]" and I don't know which one
is "continue editing"...

Here's the latest libxfs 6.4 sync, with a few cleanups and backports,
and then merging Dave's recent bug fixes:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-sync-6.4

(Will send this branch to the list as a patchbomb shortly)

--D
