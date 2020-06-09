Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EF01F3D5B
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jun 2020 15:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbgFINyK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Jun 2020 09:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730102AbgFINyK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jun 2020 09:54:10 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76571C05BD1E;
        Tue,  9 Jun 2020 06:54:08 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id r77so9834872ior.3;
        Tue, 09 Jun 2020 06:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YkLPcoh3fGm/RWXO5ci7bmyyKKN+a2YpOOHQIJQIPqY=;
        b=AdRf2gfE+f1rEM1qnoJGslwDtiTt0tpUMEHt5U8hWRLJ4RjbzI2IShys5vOp0MgPcJ
         9srKKsBZTy9JZyGgsLOkLkXgfpJZFpY3qx5CrAEZN45964kBrg3jhHW8nMFPXefTk9bC
         mMI8DVbGosviwwCmh/PzGYtik2r0QOH1W+vKH/sYNjjSkpkuzrEJnZrNtqQTcT4ac76i
         VWjZk6Sp9M7eKSSV7+zBWkN9XMSztXe1XtoSwi+A7L7+S4b7TJ1WFaV+t/BibGNCZ/7V
         oyLO67XI2S3PC3mjYHxuvxU+eCFuAMW0wGO5WfTmGzDqtBzT8xASzUzLQ/bZ6rJFgF7M
         SHzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YkLPcoh3fGm/RWXO5ci7bmyyKKN+a2YpOOHQIJQIPqY=;
        b=gIRL/7hr0SyZGXZYVzhvqXqTos7zbxngtJHOk+V8JUqbrX6P7m0PCxgDItzLesmkYh
         j7iPGgqPomtHCykynkiJV52AvUMzlNl1YFvTa5e/LmSjNcCBfOLuIeszYdEZTFha81ms
         ZLQF4ydDv2j9M84gH4Ejpr84V4XzR21h1f2Pdzg86eVhBnJBwlNZW1ai7LXAEfvI+m9D
         5+1VLafnBUgS1+pwdZH1dXd16okLHchaqXHae7GeqXtrAnKVOWr342tV7NeUhVLMFyWe
         9jxAfcWQpac0jzvSMeMQ7mtCDaqeD7fjAqOyIzmFu+BAkJlaeW11r+0mAJ0ky97oVdWb
         95nQ==
X-Gm-Message-State: AOAM533Kmbqrgb4H1noDbNSBo1OOakXbvwlZEsSV1/t3hmB+/7nUSG7B
        kzDd43W29JxsElsIDgbBkJLlJpySiCLxRRRnxOA=
X-Google-Smtp-Source: ABdhPJwhMq/r6atG3vdj+RLpB5BNOPVBps3vee6KzFhoQutzK57aHIWn7Oqj9zN9dhhWsF/qzfblgS/EC060/C+RZjE=
X-Received: by 2002:a5d:9b03:: with SMTP id y3mr26649389ion.81.1591710848254;
 Tue, 09 Jun 2020 06:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <1591254347-15912-1-git-send-email-laoar.shao@gmail.com>
In-Reply-To: <1591254347-15912-1-git-send-email-laoar.shao@gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 9 Jun 2020 21:53:30 +0800
Message-ID: <CALOAHbA=YJWbu4EF3mBKAoQr+WHa9U+t1TViERUgKurhvnWTbA@mail.gmail.com>
Subject: Re: [PATCH v2] iomap: avoid deadlock if memory reclaim is triggered
 in writepage path
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>, hch@infradead.org
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 4, 2020 at 3:06 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> Recently there is a XFS deadlock on our server with an old kernel.
> This deadlock is caused by allocating memory in xfs_map_blocks() while
> doing writeback on behalf of memroy reclaim. Although this deadlock happens
> on an old kernel, I think it could happen on the upstream as well. This
> issue only happens once and can't be reproduced, so I haven't tried to
> reproduce it on upsteam kernel.
>
> Bellow is the call trace of this deadlock.
> [480594.790087] INFO: task redis-server:16212 blocked for more than 120 seconds.
> [480594.790087] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [480594.790088] redis-server    D ffffffff8168bd60     0 16212  14347 0x00000004
> [480594.790090]  ffff880da128f070 0000000000000082 ffff880f94a2eeb0 ffff880da128ffd8
> [480594.790092]  ffff880da128ffd8 ffff880da128ffd8 ffff880f94a2eeb0 ffff88103f9d6c40
> [480594.790094]  0000000000000000 7fffffffffffffff ffff88207ffc0ee8 ffffffff8168bd60
> [480594.790096] Call Trace:
> [480594.790101]  [<ffffffff8168dce9>] schedule+0x29/0x70
> [480594.790103]  [<ffffffff8168b749>] schedule_timeout+0x239/0x2c0
> [480594.790111]  [<ffffffff8168d28e>] io_schedule_timeout+0xae/0x130
> [480594.790114]  [<ffffffff8168d328>] io_schedule+0x18/0x20
> [480594.790116]  [<ffffffff8168bd71>] bit_wait_io+0x11/0x50
> [480594.790118]  [<ffffffff8168b895>] __wait_on_bit+0x65/0x90
> [480594.790121]  [<ffffffff811814e1>] wait_on_page_bit+0x81/0xa0
> [480594.790125]  [<ffffffff81196ad2>] shrink_page_list+0x6d2/0xaf0
> [480594.790130]  [<ffffffff811975a3>] shrink_inactive_list+0x223/0x710
> [480594.790135]  [<ffffffff81198225>] shrink_lruvec+0x3b5/0x810
> [480594.790139]  [<ffffffff8119873a>] shrink_zone+0xba/0x1e0
> [480594.790141]  [<ffffffff81198c20>] do_try_to_free_pages+0x100/0x510
> [480594.790143]  [<ffffffff8119928d>] try_to_free_mem_cgroup_pages+0xdd/0x170
> [480594.790145]  [<ffffffff811f32de>] mem_cgroup_reclaim+0x4e/0x120
> [480594.790147]  [<ffffffff811f37cc>] __mem_cgroup_try_charge+0x41c/0x670
> [480594.790153]  [<ffffffff811f5cb6>] __memcg_kmem_newpage_charge+0xf6/0x180
> [480594.790157]  [<ffffffff8118c72d>] __alloc_pages_nodemask+0x22d/0x420
> [480594.790162]  [<ffffffff811d0c7a>] alloc_pages_current+0xaa/0x170
> [480594.790165]  [<ffffffff811db8fc>] new_slab+0x30c/0x320
> [480594.790168]  [<ffffffff811dd17c>] ___slab_alloc+0x3ac/0x4f0
> [480594.790204]  [<ffffffff81685656>] __slab_alloc+0x40/0x5c
> [480594.790206]  [<ffffffff811dfc43>] kmem_cache_alloc+0x193/0x1e0
> [480594.790233]  [<ffffffffa04fab67>] kmem_zone_alloc+0x97/0x130 [xfs]
> [480594.790247]  [<ffffffffa04f90ba>] _xfs_trans_alloc+0x3a/0xa0 [xfs]
> [480594.790261]  [<ffffffffa04f915c>] xfs_trans_alloc+0x3c/0x50 [xfs]
> [480594.790276]  [<ffffffffa04e958b>] xfs_iomap_write_allocate+0x1cb/0x390 [xfs]
> [480594.790299]  [<ffffffffa04d3616>] xfs_map_blocks+0x1a6/0x210 [xfs]
> [480594.790312]  [<ffffffffa04d416b>] xfs_do_writepage+0x17b/0x550 [xfs]
> [480594.790314]  [<ffffffff8118d881>] write_cache_pages+0x251/0x4d0 [xfs]
> [480594.790338]  [<ffffffffa04d3e05>] xfs_vm_writepages+0xc5/0xe0 [xfs]
> [480594.790341]  [<ffffffff8118ebfe>] do_writepages+0x1e/0x40
> [480594.790343]  [<ffffffff811837b5>] __filemap_fdatawrite_range+0x65/0x80
> [480594.790346]  [<ffffffff81183901>] filemap_write_and_wait_range+0x41/0x90
> [480594.790360]  [<ffffffffa04df2c6>] xfs_file_fsync+0x66/0x1e0 [xfs]
> [480594.790363]  [<ffffffff81231cf5>] do_fsync+0x65/0xa0
> [480594.790365]  [<ffffffff81231fe3>] SyS_fdatasync+0x13/0x20
> [480594.790367]  [<ffffffff81698d09>] system_call_fastpath+0x16/0x1b
>
> Note that xfs_iomap_write_allocate() is replaced by xfs_convert_blocks() in
> commit 4ad765edb02a ("xfs: move xfs_iomap_write_allocate to xfs_aops.c")
> and write_cache_pages() is replaced by iomap_writepages() in
> commit 598ecfbaa742 ("iomap: lift the xfs writeback code to iomap").
> So for upsteam, the call trace should be,
> xfs_vm_writepages
>   -> iomap_writepages
>      -> write_cache_pages
>         -> iomap_do_writepage
>            -> xfs_map_blocks
>               -> xfs_convert_blocks
>                  -> xfs_bmapi_convert_delalloc
>                     -> xfs_trans_alloc //It should alloc page with GFP_NOFS
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
>
> ---
> v1 - >v2:
> - retile the subject from "xfs: avoid deadlock when tigger memory reclam in xfs_map_blocks()"
> - set GFP_NOFS in iomap_do_writepage(), per Dave.
> ---
>  fs/iomap/buffered-io.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index a1ed762..f5176e3 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -17,6 +17,7 @@
>  #include <linux/bio.h>
>  #include <linux/sched/signal.h>
>  #include <linux/migrate.h>
> +#include <linux/sched/mm.h>
>  #include "trace.h"
>
>  #include "../internal.h"
> @@ -1478,9 +1479,11 @@ static void iomap_writepage_end_bio(struct bio *bio)
>  {
>         struct iomap_writepage_ctx *wpc = data;
>         struct inode *inode = page->mapping->host;
> +       unsigned int nofs_flag;
>         pgoff_t end_index;
>         u64 end_offset;
>         loff_t offset;
> +       int ret;
>
>         trace_iomap_writepage(inode, page_offset(page), PAGE_SIZE);
>
> @@ -1571,7 +1574,16 @@ static void iomap_writepage_end_bio(struct bio *bio)
>                 end_offset = offset;
>         }
>
> -       return iomap_writepage_map(wpc, wbc, inode, page, end_offset);
> +       /*
> +        * We can allocate memory here while doing writeback on behalf of
> +        * memory reclaim.  To avoid memory allocation deadlocks set the
> +        * task-wide nofs context for the following operations.
> +        */
> +       nofs_flag = memalloc_nofs_save();
> +       ret = iomap_writepage_map(wpc, wbc, inode, page, end_offset);
> +       memalloc_nofs_restore(nofs_flag);
> +
> +       return ret;
>
>  redirty:
>         redirty_page_for_writepage(wbc, page);
> --
> 1.8.3.1
>


Dave, Darrick,

Any comments on this version ?

Thanks
Yafang
