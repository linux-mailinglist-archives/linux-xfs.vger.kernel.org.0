Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723915BF23E
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Sep 2022 02:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiIUAiV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 20 Sep 2022 20:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbiIUAhy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 20:37:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665E3167D0
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 17:36:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F25AA61A2A
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 00:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5893DC433D7;
        Wed, 21 Sep 2022 00:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663720615;
        bh=qvgC3bjmQkNClAUi/V24OpM2XaLYAG0TQYXL0VoRP+8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sJEkx68hQzuvRld4B6R45ja0Qa7kDZoP5RmJaZhr9tobRxf8vfCJXmJp9oyBTyLp9
         QqUk6fAL2GefF8bHsrOhvvVycjGhwnMsnna/AMyGt8D4DiwprEumCtdzEYA2nBaWWp
         D64XAl2LOGEh4pYGTvrmhZDk6bf0zHodzY2y6es40QBL3rr//hv5+tql7Q0pVTWUU3
         OKplgXtkQEUySbsFOfjF3B6okd2UNVjcqx7S6432AA/VtPe4YXns4Eopofs/Yf7lEm
         WFCs97T+MOHSNnzvEWHfSVzhhpM/vQdfzjRVmAMSK26hTemYKut9zm2D+b6TFqTvGW
         ykFb82shlRw8w==
Date:   Tue, 20 Sep 2022 17:36:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com
Subject: Re: [PATCH 5.15 CANDIDATE 0/3] xfs stable candidate patches (part 5)
Message-ID: <YypcplVAkNX6o1gA@magnolia>
References: <20220920203750.1989625-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920203750.1989625-1-leah.rumancik@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 20, 2022 at 01:37:47PM -0700, Leah Rumancik wrote:
> Hello,
> 
> These patches correspond to the last two patches from the 5.10 series
> [1]. These patches were postponed for 5.10 until they were tested on
> 5.15. I have tested these on 5.15 (40 runs of the auto group x 4
> configs).

Looks good to me!
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Best,
> Leah
> 
> [1] https://lore.kernel.org/linux-xfs/20220901054854.2449416-1-amir73il@gmail.com/
> 
> Brian Foster (1):
>   xfs: fix xfs_ifree() error handling to not leak perag ref
> 
> Dave Chinner (2):
>   xfs: reorder iunlink remove operation in xfs_ifree
>   xfs: validate inode fork size against fork format
> 
>  fs/xfs/libxfs/xfs_inode_buf.c | 35 ++++++++++++++++++++++++++---------
>  fs/xfs/xfs_inode.c            | 22 ++++++++++++----------
>  2 files changed, 38 insertions(+), 19 deletions(-)
> 
> -- 
> 2.37.3.968.ga6b4b080e4-goog
> 
