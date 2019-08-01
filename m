Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4397E2A5
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Aug 2019 20:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfHASvB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Aug 2019 14:51:01 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43231 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbfHASvB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 14:51:01 -0400
Received: by mail-pg1-f195.google.com with SMTP id r22so7092203pgk.10
        for <linux-xfs@vger.kernel.org>; Thu, 01 Aug 2019 11:51:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UpWnymL2+4KdyzCRUEIxGgsysgrfUyY1BIj3POv1g+g=;
        b=QBdfVbpAznRkUquhdS2c9qvMloowpnYxEoLEbqja5YaMvFuR4xi/UbBmwwJI7/W6us
         XwWRWLeIMkD0oS8lmKTFwSHYAAKDir7hZRXsKMLQWvSfbnvnTWqcF/aT3RFTFVG494Ue
         a5HnbPtX/YEY6ccqPoHI6R/JPkHRUoc3xkUWglZjAM1anqEYsYijfxjyf1LjU/sMcMFz
         I5b/nmpmerKjH7GA6ZJdYN4qU2Zj5Lk//lbFBdLVm5BMqCXgMPAo6EJw31JypHzT0JfB
         67KpQ5miEIo9ySD8/m5aLrhXOAf5+DZKL/flmN/AfJCZuV64iLTnUVt1yId+t758n1TC
         jc8g==
X-Gm-Message-State: APjAAAVTTvWObAd+uHc4NnT2k9XOTByBaN3WWKzVSg1Vboy9itYBJYI4
        rWkbG8CjiJH5jVQkkyGC7l0=
X-Google-Smtp-Source: APXvYqxEqq8BWxXuuchwAGLExMV7ozu/XI/72f7k1kuab13JKONr5wjKmJegHt51ixjPriRoX0z3Gg==
X-Received: by 2002:a17:90a:36a7:: with SMTP id t36mr258502pjb.34.1564685460076;
        Thu, 01 Aug 2019 11:51:00 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id k3sm56069396pgq.92.2019.08.01.11.50.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 11:50:58 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 06B7540280; Thu,  1 Aug 2019 18:50:58 +0000 (UTC)
Date:   Thu, 1 Aug 2019 18:50:57 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] fs: xfs: xfs_log: Don't use KM_MAYFAIL at
 xfs_log_reserve().
Message-ID: <20190801185057.GT30113@42.do-not-panic.com>
References: <20190729215657.GI7777@dread.disaster.area>
 <1564653995-9004-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564653995-9004-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 01, 2019 at 07:06:35PM +0900, Tetsuo Handa wrote:
> When the system is close-to-OOM, fsync() may fail due to -ENOMEM because
> xfs_log_reserve() is using KM_MAYFAIL. It is a bad thing to fail writeback
> operation due to user-triggerable OOM condition. Since we are not using
> KM_MAYFAIL at xfs_trans_alloc() before calling xfs_log_reserve(), let's
> use the same flags at xfs_log_reserve().
> 
>   oom-torture: page allocation failure: order:0, mode:0x46c40(GFP_NOFS|__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_COMP), nodemask=(null)
>   CPU: 7 PID: 1662 Comm: oom-torture Kdump: loaded Not tainted 5.3.0-rc2+ #925
>   Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00
>   Call Trace:
>    dump_stack+0x67/0x95
>    warn_alloc+0xa9/0x140
>    __alloc_pages_slowpath+0x9a8/0xbce
>    __alloc_pages_nodemask+0x372/0x3b0
>    alloc_slab_page+0x3a/0x8d0
>    new_slab+0x330/0x420
>    ___slab_alloc.constprop.94+0x879/0xb00
>    __slab_alloc.isra.89.constprop.93+0x43/0x6f
>    kmem_cache_alloc+0x331/0x390
>    kmem_zone_alloc+0x9f/0x110 [xfs]
>    kmem_zone_alloc+0x9f/0x110 [xfs]
>    xlog_ticket_alloc+0x33/0xd0 [xfs]
>    xfs_log_reserve+0xb4/0x410 [xfs]
>    xfs_trans_reserve+0x1d1/0x2b0 [xfs]
>    xfs_trans_alloc+0xc9/0x250 [xfs]
>    xfs_setfilesize_trans_alloc.isra.27+0x44/0xc0 [xfs]
>    xfs_submit_ioend.isra.28+0xa5/0x180 [xfs]
>    xfs_vm_writepages+0x76/0xa0 [xfs]
>    do_writepages+0x17/0x80
>    __filemap_fdatawrite_range+0xc1/0xf0
>    file_write_and_wait_range+0x53/0xa0
>    xfs_file_fsync+0x87/0x290 [xfs]
>    vfs_fsync_range+0x37/0x80
>    do_fsync+0x38/0x60
>    __x64_sys_fsync+0xf/0x20
>    do_syscall_64+0x4a/0x1c0
>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

That's quite an opaque commit log for what started off as a severe email
thread of potential leak of information. As such, can you expand on this
commit log considerably to explain the situation a bit better? Your
initial thread here provided much clearer evidence of the issue. As-is
this commit log tells the reader *nothing* about the potential harm in
not applying this patch.

You had mentioned you identified this issue present on at least
4.18 till 5.3-rc1. So, I'm at least inclined to consider this for
stable for at least v4.19.

However, what about older kernels? Now that you have identified
a fix, were the flag changed in prior commits, is it a regression
that perhaps added KM_MAYFAIL at some point?

  Luis
