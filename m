Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A8E5BC13E
	for <lists+linux-xfs@lfdr.de>; Mon, 19 Sep 2022 04:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiISCGu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 18 Sep 2022 22:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiISCGt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Sep 2022 22:06:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBDB13D12
        for <linux-xfs@vger.kernel.org>; Sun, 18 Sep 2022 19:06:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9028160B7B
        for <linux-xfs@vger.kernel.org>; Mon, 19 Sep 2022 02:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA0BC433C1;
        Mon, 19 Sep 2022 02:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663553208;
        bh=2USmOpcqIvDzY+BqDZ8EZH6dTs6+yA4bdmc5eB6tGCk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LYcIry44IlheXF0EtVKM+mxiiJdyoHMVwWxh1mkmccGHAc7SQxMBaxCTe7Y7lmy4R
         PQYerJ2oWa2xpDmgei4KKHDI/NpMHJoHhcO0JR7UVKX5ZXuH55bnv93FScylKGYSvj
         /xJx8CHASZ0sg3+tvkHY9MMMqahYVCgCgHOuKCsiX80RglCva1u46iRv6o4nrtDguM
         fGHQsaamCY2ScUOvHT6cSPxbwGIt1lWsKVjXeMhx5IE06AAGPRbsDmqLdxtfHf/Kn8
         OXBFivcFn7cQK1XrTF0qrYtF9pjLufR+oFC1oXZVN4XooolqgYHxuMSy2SbaZ1j1kL
         9Yd0jnMS1hEkQ==
Date:   Sun, 18 Sep 2022 19:06:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfs: for-next branch has been updated to dc256418235a
Message-ID: <YyfOt2u87VMtDtpY@magnolia>
References: <20220919020138.GI3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919020138.GI3600936@dread.disaster.area>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 19, 2022 at 12:01:38PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> I've just updated the mast branch to v6.0-rc6 and the for-next
> branch with some of the outstanding changes posted and reviewed in
> the last few weeks. This is a relatively small update - I've been
> largely out of action for the past 3 weeks so this update is just
> trying to catch up on the small stuff that has been happening
> recently.
> 
> It's likely I've missed stuff, so don't be afraid to resend anything
> you think I should have picke dup but didn't. Note  I haven't even
> considered any of major patchsets anyone (including myself) have
> proposed so far this cycle. It's unlikely at this point that
> anything other than small changes will make this cycle as a result.

Could you pick up "xfs: on memory failure, only shut down fs after
scanning all mappings", please?  The code fixed in the patch was added
for 6.0-rc1 so it'd be nice to get it merged before 6.0 releases:

https://lore.kernel.org/linux-xfs/Yv5wIa2crHioYeRr@magnolia/

I probably should've slapped a:

Fixes: 6f643c57d57c ("xfs: implement ->notify_failure() for XFS")

on it too. :/

--D

> 
> -Dave.
> 
> ----------------------------------------------------------------
> 
> Current head commit: dc256418235a8355fbdf83b90048d8704b8d1654:
> 
>   xfs: do not need to check return value of xlog_kvmalloc() (2022-09-19 06:55:14 +1000)
> 
> ----------------------------------------------------------------
> Christian Brauner (1):
>       xfs: port to vfs{g,u}id_t and associated helpers
> 
> Gaosheng Cui (1):
>       xfs: remove xfs_setattr_time() declaration
> 
> Zeng Heng (7):
>       xfs: remove the redundant word in comment
>       xfs: remove redundant else for clean code
>       xfs: clean up "%Ld/%Lu" which doesn't meet C standard
>       xfs: replace unnecessary seq_printf with seq_puts
>       xfs: simplify if-else condition in xfs_validate_new_dalign
>       xfs: simplify if-else condition in xfs_reflink_trim_around_shared
>       xfs: missing space in xfs trace log
> 
> Zhiqiang Liu (1):
>       xfs: do not need to check return value of xlog_kvmalloc()
> 
> ye xingchen (1):
>       xfs: Remove the unneeded result variable
> 
>  fs/xfs/libxfs/xfs_bmap.c        |  2 +-
>  fs/xfs/libxfs/xfs_dir2_sf.c     |  4 +---
>  fs/xfs/libxfs/xfs_inode_fork.c  |  4 ++--
>  fs/xfs/xfs_attr_item.c          |  6 ------
>  fs/xfs/xfs_inode.c              | 13 ++++++-------
>  fs/xfs/xfs_inode_item.c         |  2 +-
>  fs/xfs/xfs_inode_item_recover.c |  4 ++--
>  fs/xfs/xfs_iops.c               |  6 ++++--
>  fs/xfs/xfs_iops.h               |  1 -
>  fs/xfs/xfs_itable.c             |  8 ++++++--
>  fs/xfs/xfs_log.c                | 10 +++++-----
>  fs/xfs/xfs_mount.c              | 38 ++++++++++++++++++++------------------
>  fs/xfs/xfs_reflink.c            | 22 ++++++++++++----------
>  fs/xfs/xfs_stats.c              |  4 ++--
>  fs/xfs/xfs_trace.h              |  4 ++--
>  15 files changed, 64 insertions(+), 64 deletions(-)
> 
> -- 
> Dave Chinner
> david@fromorbit.com
