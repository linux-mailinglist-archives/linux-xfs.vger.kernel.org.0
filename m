Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7A87802A8
	for <lists+linux-xfs@lfdr.de>; Sat,  3 Aug 2019 00:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388095AbfHBWWB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Aug 2019 18:22:01 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39644 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730633AbfHBWWB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 18:22:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id f17so32701188pfn.6
        for <linux-xfs@vger.kernel.org>; Fri, 02 Aug 2019 15:22:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+lxFnYb7knlPr3w44I2bN9oAG+dV1bxC/VVmY2mDdqI=;
        b=D2opEfeT7NkIQH+yQ8YLRHJvm8XyEJJ/aNgBrBsmJ0W+gAEEpszuz+Muu2NEgRBFfV
         PHm4E+vJENrPyE/BdBAr++L/4F163JkmwUDiBdkd3+RimaD0o/tNroll8lSYw1V8hSn3
         2mQHsFObhv9EMu/EGvjhW96p5DRvtO2GBmb6wDFO9ru+T47+oHKzG4dKgckrU5KUvKM3
         W0T8d8FxZfHOtqxJE6b0MFn92dBCZLRr39T0bo8PTKiNx9fpBomZeFibKbyOHytdZWxK
         0Zmq5tRTj8zim2zQ+F5Vn7TMC46bi8F3QnIy61UBOSzPRMxqnhQe3tD6WlKY5hY04FsL
         aSVg==
X-Gm-Message-State: APjAAAV55G63e8snaP+35pelRc6z6fp+UtnQxZipGZXiOBtFByAqTti6
        eQWjlGKlYVABnRCmpV1GXVcxtD67
X-Google-Smtp-Source: APXvYqwHCmBu7sut/CuNRufpuBENf3AOsPh67m6RWEXONEXxpMk1V0p0gkpvIqBEs6u9gPyWDkfXPg==
X-Received: by 2002:a62:483:: with SMTP id 125mr63647282pfe.245.1564784520709;
        Fri, 02 Aug 2019 15:22:00 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id p27sm113436731pfq.136.2019.08.02.15.21.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 15:21:59 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id DD9EC402A1; Fri,  2 Aug 2019 22:21:58 +0000 (UTC)
Date:   Fri, 2 Aug 2019 22:21:58 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] fs: xfs: xfs_log: Don't use KM_MAYFAIL at
 xfs_log_reserve().
Message-ID: <20190802222158.GU30113@42.do-not-panic.com>
References: <20190729215657.GI7777@dread.disaster.area>
 <1564653995-9004-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <20190801185057.GT30113@42.do-not-panic.com>
 <20190801204614.GD7138@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801204614.GD7138@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 01, 2019 at 01:46:14PM -0700, Darrick J. Wong wrote:
> On Thu, Aug 01, 2019 at 06:50:57PM +0000, Luis Chamberlain wrote:
> > On Thu, Aug 01, 2019 at 07:06:35PM +0900, Tetsuo Handa wrote:
> > > When the system is close-to-OOM, fsync() may fail due to -ENOMEM because
> > > xfs_log_reserve() is using KM_MAYFAIL. It is a bad thing to fail writeback
> > > operation due to user-triggerable OOM condition. Since we are not using
> > > KM_MAYFAIL at xfs_trans_alloc() before calling xfs_log_reserve(), let's
> > > use the same flags at xfs_log_reserve().
> > > 
> > >   oom-torture: page allocation failure: order:0, mode:0x46c40(GFP_NOFS|__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_COMP), nodemask=(null)
> > >   CPU: 7 PID: 1662 Comm: oom-torture Kdump: loaded Not tainted 5.3.0-rc2+ #925
> > >   Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00
> > >   Call Trace:
> > >    dump_stack+0x67/0x95
> > >    warn_alloc+0xa9/0x140
> > >    __alloc_pages_slowpath+0x9a8/0xbce
> > >    __alloc_pages_nodemask+0x372/0x3b0
> > >    alloc_slab_page+0x3a/0x8d0
> > >    new_slab+0x330/0x420
> > >    ___slab_alloc.constprop.94+0x879/0xb00
> > >    __slab_alloc.isra.89.constprop.93+0x43/0x6f
> > >    kmem_cache_alloc+0x331/0x390
> > >    kmem_zone_alloc+0x9f/0x110 [xfs]
> > >    kmem_zone_alloc+0x9f/0x110 [xfs]
> > >    xlog_ticket_alloc+0x33/0xd0 [xfs]
> > >    xfs_log_reserve+0xb4/0x410 [xfs]
> > >    xfs_trans_reserve+0x1d1/0x2b0 [xfs]
> > >    xfs_trans_alloc+0xc9/0x250 [xfs]
> > >    xfs_setfilesize_trans_alloc.isra.27+0x44/0xc0 [xfs]
> > >    xfs_submit_ioend.isra.28+0xa5/0x180 [xfs]
> > >    xfs_vm_writepages+0x76/0xa0 [xfs]
> > >    do_writepages+0x17/0x80
> > >    __filemap_fdatawrite_range+0xc1/0xf0
> > >    file_write_and_wait_range+0x53/0xa0
> > >    xfs_file_fsync+0x87/0x290 [xfs]
> > >    vfs_fsync_range+0x37/0x80
> > >    do_fsync+0x38/0x60
> > >    __x64_sys_fsync+0xf/0x20
> > >    do_syscall_64+0x4a/0x1c0
> > >    entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > > 
> > > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > 
> > That's quite an opaque commit log for what started off as a severe email
> > thread of potential leak of information. As such, can you expand on this
> > commit log considerably to explain the situation a bit better?
> 
> I'm pretty sure this didn't solve the underlying stale data exposure
> problem, which might be why you think this is "opaque".  It fixes a bug
> that causes data writeback failure (which was the exposure vector this
> time) but I think the ultimate fix for the exposure problem are the two
> patches I linked to quite a ways back in this discussion....
> 
> --D
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?id=bd012b434a56d9fac3cbc33062b8e2cd6e1ad0a0
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?id=adcf7c0c87191fd3616813c8ce9790f89a9a8eba

Got it, thanks! Even with this, I still think the current commit could
say a bit a more about the effects of not having this patch applied.
What are the effects of say having the above two patches applied but not
the one being submitted now?

  Luis
