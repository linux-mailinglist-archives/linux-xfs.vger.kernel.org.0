Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE11653CA5
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Dec 2022 08:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbiLVHoT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 22 Dec 2022 02:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiLVHoS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2022 02:44:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270BD1A07C
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 23:44:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A63BE619E2
        for <linux-xfs@vger.kernel.org>; Thu, 22 Dec 2022 07:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6ADC433EF
        for <linux-xfs@vger.kernel.org>; Thu, 22 Dec 2022 07:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671695057;
        bh=xFAVifJ94TtT1Nn/APfnNNJcFEOb2qU2eJn8guN7u68=;
        h=Date:From:To:Subject:From;
        b=SZZYTJY6WyufEwYw3fs5V93Fta/lWkFHM1nryW0kTOzuYy+3fTTS8P7QFpv0UX1qA
         6JJyxHRup5cwXtdPQkkmgz3hVo2bu3lqQMY++9hlcRJrMKyZ6OhMm6t7rNx/WzZNb4
         XlP9W4g7PMJl4YD47HsLUIHfOrbl3ttQoDjBv9kf15U461gXEZpqkIkW2Np8x6CxbN
         3sAZ9e10/wl6DMQVFUowYRnYO/p7fQD7UnQ9LpGaKfeo8+aeubtIJbxSEZoOQiJldJ
         uBrgvGgtuLQHrmCKM9dF8x+SzcjDd2CWQ1Z2IxyLVBxF3D1j7ZOXvRszsJlB9iPwhG
         HHqgSD2B0R0pw==
Date:   Thu, 22 Dec 2022 08:44:12 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs for-next branch updated
Message-ID: <20221222074412.d6dsmln7zd32blde@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello folks.

This is an 'extra' xfsprogs for-next branch update before the v6.1 release on
tomorrow, so that we can include a xfs_db fix in the new version.

This update only contains this commit:

Darrick J. Wong (1):
      7374f58bf xfs_db: fix dir3 block magic check


-- 
Carlos Maiolino
