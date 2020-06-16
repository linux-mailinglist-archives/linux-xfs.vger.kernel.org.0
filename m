Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4E21FACDF
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Jun 2020 11:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgFPJkL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 16 Jun 2020 05:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgFPJkL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jun 2020 05:40:11 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B20CC05BD43;
        Tue, 16 Jun 2020 02:40:11 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id l6so2008411ilo.2;
        Tue, 16 Jun 2020 02:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pGe/Er9Jr0dwQjVHm8wrk0xJ2zUDxd0eHdfdATrGabM=;
        b=JISzqb5WUuaHpslnpQGA69Ht1wtm24SXXEG/Ko55uNC2/rGts8slc13Rj6V/ENrHTC
         OORKZIbiKBwCZvckFdVYJ56sRIc0q3Yni8HM0EsX67D0uAvQdEcxmRhjVmGLdu1NoMTn
         QAAoTa8U27C6zIJMjRyFq4Ydf1Tpljne0ggnp8IgutwDFUuHiD07Fa4NAyEp17rsozI4
         XDGSV4Us1k/Bf02MT7RCW+pwgqFbT65Ft8eXSsXqf3GR1c614NYKLEHp5pN5Clf4RN1g
         KQPjUhNDRlEu+ExH8mqdP3V/yF28u5jIKmRIbq3Z/3zGksgG+2xpBGE6zLSsmHoMJNJj
         GEPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pGe/Er9Jr0dwQjVHm8wrk0xJ2zUDxd0eHdfdATrGabM=;
        b=HGYLr6W3N347RNElGH9kiccI7FBVyS7bYDZ4JstGcHIqEMLMXS0iE5SvQ8LEWto7y4
         TPNAktyWjapryPkmYbZ6CCjwhrpKXfU3wpFdOb3grzVU3hYO+sdzziaBxVvBB51LtDAr
         kZQnJ4uOU+EPQJYT/N1pZrCk9OePzmbltJSJUzn5s28qd9yxI2732pF9j+3akNyLwC+l
         MUt5uEDfHk20AfYHt4b2uefPOiQQic0KP7svpJ6XU/t8ad9JJXfBEvP8QWK5ivdJMHyw
         pgPkr1oJLel9g5GRsifhWWQJuEhBf9bJyKe3fTxTXTQhRW2BWJehs3jEDcSC8YbMkhcs
         Y2tg==
X-Gm-Message-State: AOAM530hwLM576wr4gpEy8YdvKoYfLY7+ld5oSqwDygHzheqt9/EjlKI
        nbPAjcgWBTyLKeGPkVeM/2/Evf/pHn+Lo7RIobpZPq4Qnw/L6Q==
X-Google-Smtp-Source: ABdhPJyVDkDwxznobiB46ixzMp1V5r88m+gVTCdIlEi5zYtRD1GqD593akdkWKsh1iCTpEKXRAvIYuDSAtxdG4pab98=
X-Received: by 2002:a92:4899:: with SMTP id j25mr2349071ilg.168.1592300410577;
 Tue, 16 Jun 2020 02:40:10 -0700 (PDT)
MIME-Version: 1.0
References: <1592222181-9832-1-git-send-email-laoar.shao@gmail.com>
 <20200616081628.GC9499@dhcp22.suse.cz> <CALOAHbDsCB1yZE6m96xiX1KiUWJW-8Hn0eqGcuEipkf9R6_L2A@mail.gmail.com>
 <20200616092727.GD9499@dhcp22.suse.cz>
In-Reply-To: <20200616092727.GD9499@dhcp22.suse.cz>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 16 Jun 2020 17:39:33 +0800
Message-ID: <CALOAHbD8x3sULHpGe=t58cBU2u1vuqrBRtAB3-+oR7TQNwOxwg@mail.gmail.com>
Subject: Re: [PATCH v3] xfs: avoid deadlock when trigger memory reclaim in ->writepages
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 16, 2020 at 5:27 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Tue 16-06-20 17:05:25, Yafang Shao wrote:
> > On Tue, Jun 16, 2020 at 4:16 PM Michal Hocko <mhocko@kernel.org> wrote:
> > >
> > > On Mon 15-06-20 07:56:21, Yafang Shao wrote:
> > > > Recently there is a XFS deadlock on our server with an old kernel.
> > > > This deadlock is caused by allocating memory in xfs_map_blocks() while
> > > > doing writeback on behalf of memroy reclaim. Although this deadlock happens
> > > > on an old kernel, I think it could happen on the upstream as well. This
> > > > issue only happens once and can't be reproduced, so I haven't tried to
> > > > reproduce it on upsteam kernel.
> > > >
> > > > Bellow is the call trace of this deadlock.
> > > > [480594.790087] INFO: task redis-server:16212 blocked for more than 120 seconds.
> > > > [480594.790087] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > > [480594.790088] redis-server    D ffffffff8168bd60     0 16212  14347 0x00000004
> > > > [480594.790090]  ffff880da128f070 0000000000000082 ffff880f94a2eeb0 ffff880da128ffd8
> > > > [480594.790092]  ffff880da128ffd8 ffff880da128ffd8 ffff880f94a2eeb0 ffff88103f9d6c40
> > > > [480594.790094]  0000000000000000 7fffffffffffffff ffff88207ffc0ee8 ffffffff8168bd60
> > > > [480594.790096] Call Trace:
> > > > [480594.790101]  [<ffffffff8168dce9>] schedule+0x29/0x70
> > > > [480594.790103]  [<ffffffff8168b749>] schedule_timeout+0x239/0x2c0
> > > > [480594.790111]  [<ffffffff8168d28e>] io_schedule_timeout+0xae/0x130
> > > > [480594.790114]  [<ffffffff8168d328>] io_schedule+0x18/0x20
> > > > [480594.790116]  [<ffffffff8168bd71>] bit_wait_io+0x11/0x50
> > > > [480594.790118]  [<ffffffff8168b895>] __wait_on_bit+0x65/0x90
> > > > [480594.790121]  [<ffffffff811814e1>] wait_on_page_bit+0x81/0xa0
> > > > [480594.790125]  [<ffffffff81196ad2>] shrink_page_list+0x6d2/0xaf0
> > > > [480594.790130]  [<ffffffff811975a3>] shrink_inactive_list+0x223/0x710
> > > > [480594.790135]  [<ffffffff81198225>] shrink_lruvec+0x3b5/0x810
> > > > [480594.790139]  [<ffffffff8119873a>] shrink_zone+0xba/0x1e0
> > > > [480594.790141]  [<ffffffff81198c20>] do_try_to_free_pages+0x100/0x510
> > > > [480594.790143]  [<ffffffff8119928d>] try_to_free_mem_cgroup_pages+0xdd/0x170
> > > > [480594.790145]  [<ffffffff811f32de>] mem_cgroup_reclaim+0x4e/0x120
> > > > [480594.790147]  [<ffffffff811f37cc>] __mem_cgroup_try_charge+0x41c/0x670
> > > > [480594.790153]  [<ffffffff811f5cb6>] __memcg_kmem_newpage_charge+0xf6/0x180
> > > > [480594.790157]  [<ffffffff8118c72d>] __alloc_pages_nodemask+0x22d/0x420
> > > > [480594.790162]  [<ffffffff811d0c7a>] alloc_pages_current+0xaa/0x170
> > > > [480594.790165]  [<ffffffff811db8fc>] new_slab+0x30c/0x320
> > > > [480594.790168]  [<ffffffff811dd17c>] ___slab_alloc+0x3ac/0x4f0
> > > > [480594.790204]  [<ffffffff81685656>] __slab_alloc+0x40/0x5c
> > > > [480594.790206]  [<ffffffff811dfc43>] kmem_cache_alloc+0x193/0x1e0
> > > > [480594.790233]  [<ffffffffa04fab67>] kmem_zone_alloc+0x97/0x130 [xfs]
> > > > [480594.790247]  [<ffffffffa04f90ba>] _xfs_trans_alloc+0x3a/0xa0 [xfs]
> > > > [480594.790261]  [<ffffffffa04f915c>] xfs_trans_alloc+0x3c/0x50 [xfs]
> > >
> > > Now with a more explanation from Dave I have got back to the original
> > > backtrace. Not sure which kernel version you are using but this path
> > > should have passed xfs_trans_reserve which sets PF_MEMALLOC_NOFS and
> > > this in turn should have made __alloc_pages_nodemask to use __GFP_NOFS
> > > and the memcg reclaim shouldn't ever wait_on_page_writeback (pressumably
> > > this is what the io_schedule is coming from).
> >
> > Hi Michal,
> >
> > The page is allocated before calling xfs_trans_reserve, so the
> > PF_MEMALLOC_NOFS hasn't been set yet.
> > See bellow,
> >
> > xfs_trans_alloc
> >     kmem_zone_zalloc() <<< GPF_NOFS hasn't been set yet, but it may
> > trigger memory reclaim
> >     xfs_trans_reserve() <<<< GPF_NOFS is set here (for the kernel
> > prior to commit 9070733b4efac, it is PF_FSTRANS)
>
> You are right, I have misread the actual allocation side. 8683edb7755b8
> has added KM_NOFS and 73d30d48749f8 has removed it. I cannot really
> judge the correctness here.
>

The history is complicated, but it doesn't matter.
Let's  turn back to the upstream kernel now. As I explained in the commit log,
xfs_vm_writepages
  -> iomap_writepages.
     -> write_cache_pages
        -> lock_page <<<< This page is locked.
        -> writepages ( which is  iomap_do_writepage)
           -> xfs_map_blocks
              -> xfs_convert_blocks
                 -> xfs_bmapi_convert_delalloc
                    -> xfs_trans_alloc
                         -> kmem_zone_zalloc //It should alloc page
with GFP_NOFS

If GFP_NOFS isn't set in xfs_trans_alloc(), the kmem_zone_zalloc() may
trigger the memory reclaim then it may wait on the page locked in
write_cache_pages() ...
That means the ->writepages should be set with GFP_NOFS to avoid this
recursive filesystem reclaim.

-- 
Thanks
Yafang
