Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50613612E1D
	for <lists+linux-xfs@lfdr.de>; Mon, 31 Oct 2022 00:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJ3Xni (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 30 Oct 2022 19:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ3Xni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 19:43:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F969FFC
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 16:43:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2DC660F95
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 23:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497C2C433C1;
        Sun, 30 Oct 2022 23:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667173416;
        bh=a9bse081SXWnJEr/jCsu0nJWb53UT+LrQcxVT4253Iw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JBTWtc7In7PyJ6FCLUg96JgJtIEMsSTv8cXE3UDNeFO//9fNOwX/oSxUTFO9V2TAs
         qE283TgTIAUr6fw90OfXW3lwPT/sLOQsusM3Ng0u2Sn8YFwUMHHhdTsFiNDaqLc3w2
         MiiiuPst1B538lRL+sCDLFmvjCNV4NtDw2PtnWMCOXzcIy5lxYJQnNT9H0YAVHgnjq
         k9KFdNa6VnpndUEV4NgXWO6+qCqOtBh94ST6JKJFTQmyPqYetKeBID2FO2Rq2XOYC5
         Q+NNGSqZeU1/lsmvcmsSVw5tKsE6KeDnGppohBhDEQsaL+VsW1p/AYjs+GG+sfVQkb
         tbjsaE8rQFFeg==
Date:   Sun, 30 Oct 2022 16:43:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 CANDIDATE 0/3] Fixes for patches backported to 5.4.y
 from v5.7
Message-ID: <Y18MJ95sTfdCncu+@magnolia>
References: <20221029135732.574729-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221029135732.574729-1-chandan.babu@oracle.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 29, 2022 at 07:27:29PM +0530, Chandan Babu R wrote:
> Hi Darrick,
> 
> Patches backported from v5.7 to 5.4.y had fixes from newer versions of
> Linux kernel. I had missed including these patches in my previous
> patchset posting.
> 
> This patchset has been tested by executing fstests (via kdevops) using
> the following XFS configurations,
> 
> 1. No CRC (with 512 and 4k block size).
> 2. Reflink/Rmapbt (1k and 4k block size).
> 3. Reflink without Rmapbt.
> 4. External log device.

Looks good to me!
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Brian Foster (1):
>   xfs: finish dfops on every insert range shift iteration
> 
> Darrick J. Wong (2):
>   xfs: clear XFS_DQ_FREEING if we can't lock the dquot buffer to flush
>   xfs: force the log after remapping a synchronous-writes file
> 
>  fs/xfs/xfs_bmap_util.c |  2 +-
>  fs/xfs/xfs_file.c      | 17 ++++++++++++++++-
>  fs/xfs/xfs_qm.c        |  1 +
>  3 files changed, 18 insertions(+), 2 deletions(-)
> 
> -- 
> 2.35.1
> 
