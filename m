Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616E366A26C
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Jan 2023 19:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjAMS6M (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 13 Jan 2023 13:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjAMS6K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jan 2023 13:58:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B06551D7
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jan 2023 10:58:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F39E3B821CB
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jan 2023 18:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76D4C433F0
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jan 2023 18:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673636286;
        bh=BRL3yMVIfAwFbGqARcgILqeN4ptp1LkqNikOvQdqJ90=;
        h=Date:From:To:Subject:From;
        b=mD6wB1oA1bPj4RAEO9et/fwoMl6URsPf0p58hM8412VFytsHbOYfQUvXNoIM8eEUr
         Ov9aNR3wpmdpIPKNnNItg8CiqHCZENsqcninJVVO/BG03dmUqFZnjAkpQiIDgoc4Il
         j+cI+GrdsEXedPzzIccwtXMQuN0dKqYKKAs+1K353DVYdV6NvIfUjCETRc27L2cADP
         v/Xk7JUFrMceo4K/+f43hX2C8GPo4rN2tbonRv+aLNDHTNN23wjKS+n1lHvb7vbD9o
         zwuSLHghUjJC7LcOhVP7P2BtzvSdbFbrBwaGoMOyAQJJUrHL504lCMjpNbfZJhnGI1
         QPljyaYLgYAwg==
Date:   Fri, 13 Jan 2023 19:58:02 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs-6.1.1 released
Message-ID: <20230113185802.a6wl5egsf4hodqtf@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

for-next branch has also been synchronized with this update.

This is a minor update to fix a build error on clang-16 and include the pkg
version on debian changelog for the past two releases.

Please, any questions, let me know.

The new head of the master branch is commit:

fdf036695 xfsprogs: Release v6.1.1

New Commits:

Carlos Maiolino (2):
      [96867d44f] Add pkg version to debian changelog
      [fdf036695] xfsprogs: Release v6.1.1

Holger Hoffstätte (1):
      [5ead2de38] xfsprogs: scrub: fix warnings/errors due to missing include


Code Diffstat:

 VERSION          |  2 +-
 configure.ac     |  2 +-
 debian/changelog | 10 ++++++++--
 doc/CHANGES      |  4 ++++
 scrub/unicrash.c |  1 +
 5 files changed, 15 insertions(+), 4 deletions(-)


-- 
Carlos Maiolino
