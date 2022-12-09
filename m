Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D94647FB7
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Dec 2022 09:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiLII7k (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Dec 2022 03:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiLII7k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Dec 2022 03:59:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E2A2EF23
        for <linux-xfs@vger.kernel.org>; Fri,  9 Dec 2022 00:59:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A19D2B827EC
        for <linux-xfs@vger.kernel.org>; Fri,  9 Dec 2022 08:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784BCC433EF;
        Fri,  9 Dec 2022 08:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670576376;
        bh=tqSQwdTrKTkW8snKcRUBItAiTRW2lj3Ua6Q7lf+y2PQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sbcmQCQdgdRpXpbXYOpcH00kKEqdSuh12NiLL8uZD6QBp4GH0PnU3IOkAU/nCHVPu
         xb7ZtN2w6POuHrt5G+MgmAmUWBvwaGBFgUJyxKqXRCWj0cOtXaiSfu600TdjlWYR8Y
         KPcl4GX18EHvWjP0LAblQfjeHh8i71cd2nhS9dAIF4q+sQfdWMORzVN109poXZ6CkB
         pJ2i5LGoDdx3GNylTlDxjKkDe1SQSCa2nIff9v1htDUo9mhM2Hs17NKYnt3r9qldJ6
         YRf7jGbAXAxldndnNGpcH5w6bd29FW9fGZyrn9J3iRUcAsjnX72Hx4IKbidtlOy+68
         G+qAMJgZAJS4w==
Date:   Fri, 9 Dec 2022 09:59:32 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 0/9] xfsprogs: random fixes for 6.1
Message-ID: <20221209085932.iclu56hrslflcdnq@andromeda>
References: <-I-A6mYlvGXZxmIaxIGm-2ZMrd2rhOOQruX8Y9AicksvGaoRMIwwd1VbgylGm0sx8N7VdVJNSuOmeXyLbGBIDw==@protonmail.internalid>
 <166922333463.1572664.2330601679911464739.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166922333463.1572664.2330601679911464739.stgit@magnolia>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 23, 2022 at 09:08:54AM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> This is a rollup of all the random fixes I've collected for xfsprogs
> 6.1.  At this point it's just an assorted collection, no particular
> theme.  Many of them are verbatim repostings from the 6.0 series.
> There's also a mkfs config file for the 6.1 LTS.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.

I've reviewed these patches before, except the last 2, which seems fine too. So,
for the whole series:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> --D
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-fixes-6.1
> ---
>  db/btblock.c             |    2 +
>  db/check.c               |    4 +-
>  db/namei.c               |    2 +
>  db/write.c               |    4 +-
>  io/pread.c               |    2 +
>  libfrog/linux.c          |    1 +
>  libxfs/libxfs_api_defs.h |    2 +
>  libxfs/libxfs_io.h       |    1 +
>  libxfs/libxfs_priv.h     |    2 +
>  libxfs/rdwr.c            |    8 +++++
>  libxfs/util.c            |    1 +
>  mkfs/Makefile            |    3 +-
>  mkfs/lts_6.1.conf        |   14 ++++++++
>  mkfs/xfs_mkfs.c          |    2 +
>  repair/phase2.c          |    8 +++++
>  repair/phase6.c          |    9 +++++
>  repair/protos.h          |    1 +
>  repair/scan.c            |   22 ++++++++++---
>  repair/xfs_repair.c      |   77 ++++++++++++++++++++++++++++++++++++++++------
>  scrub/inodes.c           |    2 +
>  20 files changed, 139 insertions(+), 28 deletions(-)
>  create mode 100644 mkfs/lts_6.1.conf
> 

-- 
Carlos Maiolino
