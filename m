Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9961656048
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Dec 2022 07:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiLZGJ0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 26 Dec 2022 01:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiLZGJZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Dec 2022 01:09:25 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E8B10EB;
        Sun, 25 Dec 2022 22:09:24 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id c184so9593903vsc.3;
        Sun, 25 Dec 2022 22:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lfki3V/T9BQf+eM6KggzcNa6f7OxNbzodamBA6ifMZ4=;
        b=dH6IWILqcoXENdUHqOzMK6tzo8WZOA4S9GthNk/Q/I9SVYqDGxbPG+hQu1YZx/slB+
         xX7wh0dRTmtQlGzd/0FqNU+RDvvOSuYpcD8Nqqhv2nw+fuYIfmv6eun28ix/CE8Z0aDI
         xZjOXuX7MhHZwL+51QB0344oIKcsal1BKnX8DK6uFr5z2mHUQv1PUi8ZnUimaSBXndok
         9ReDCx428ensQQJtnZnr8GPtFQsj3WCU8++zgGGiu+xtDEJEb5h/SLEnollgK2zXP5lK
         zySrrfoGok5H7Szpmll4s2GFGp4yZxtFW8sO9tHPnQOdafFYds8XNPQlfEsX2XyM2wlQ
         vgtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lfki3V/T9BQf+eM6KggzcNa6f7OxNbzodamBA6ifMZ4=;
        b=b+XtzdRT+TVex9opHhoLS053DPxsZS+UUYz9IfBp2w7lkggKu+0Y2sl9lIXt/6T0Ul
         GB986DX/qtCxL9D1IrjBamEKBH+/ys9jGcFrudImxpg/Uc2jV+h/qPvRc8hP7QPAkFeZ
         l7MTNzcU3PE2rHMMkrQO6bHrQNDFMIIKNHUD9vUPBg09DFfqn86Pqw2cr9ZuRyevlx+1
         3IdeX8fh7TqGNfC/0EwdvsAzQyEAJsJQdzlo8gpaZSltJuVClf8/7v3zpCMmctwFPjbP
         0HefSOW4FDyzkU8x6w8veFpgkmOo2hBwS9wjY+rEn7/ArQsuf2QKxZyGFtOgh5W+yLou
         +9SQ==
X-Gm-Message-State: AFqh2krMz/3GB5XUyvp7nYh2KM8O8ImDtSkOv6LZxOA5AhpDqB0Ay7xk
        QiGcMXtoCqGdJ8q33aaS1udwre1l3dkIfO/Y34oJiHZkRwk=
X-Google-Smtp-Source: AMrXdXtfqoM1J0r4CfJYBK8FpLCF7iq3Yw975ZXFd4aNXzxxtB/HidriwnoQNjXVaOYXgxO4icwrCJLhgsE+J41DvfM=
X-Received: by 2002:a67:f9c1:0:b0:3b1:1713:ba0e with SMTP id
 c1-20020a67f9c1000000b003b11713ba0emr1800521vsq.2.1672034963288; Sun, 25 Dec
 2022 22:09:23 -0800 (PST)
MIME-Version: 1.0
References: <Y6kXjFeRH3Y970ss@ip-172-31-85-199.ec2.internal>
In-Reply-To: <Y6kXjFeRH3Y970ss@ip-172-31-85-199.ec2.internal>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 26 Dec 2022 08:09:10 +0200
Message-ID: <CAOQ4uxi-YZTUGvnaEqZW9Jjyn7+=RGdJB5fkT_rt00xwiS5KEA@mail.gmail.com>
Subject: Re: memory leak in xfs_init_local_fork
To:     Xingyuan Mo <hdthky0@gmail.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 26, 2022 at 5:39 AM Xingyuan Mo <hdthky0@gmail.com> wrote:
>
> Hello,
>
> Recently, when using our local Syzkaller to fuzz kernel, the following bug was
> triggered.
>
> git tree: stable
> branch: linux-5.10.y
> HEAD commit: 1a9148dfd8e03835dc7617cee696dd18c0000e99
> compiler: gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0
>
> I have included the C repro, the Syzkaller config file and the config file used
> to compile the kernel.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: Xingyuan Mo <hdthky0@gmail.com>
>
> The bug report is as follows:
>
> BUG: memory leak

Hi Xingyuan,

Let me put it this way - there are much worse bugs in v5.10 than
a memory leak generated by a fuzzed image
and there are far easier ways to take up system memory as a privileged user.

You would have to demonstrate the severity of a bug in order to justify
the work and the risk involved with patching v5.10.

Thanks,
Amir.


> unreferenced object 0xffff888104d9b100 (size 64):
>   comm "syz-executor163", pid 258, jiffies 4294772370 (age 13.800s)
>   hex dump (first 32 bytes):
>     00 22 02 00 06 06 00 78 61 74 74 72 31 78 61 74  .".....xattr1xat
>     74 72 31 00 00 00 00 00 00 00 00 32 78 61 74 74  tr1........2xatt
>   backtrace:
>     [<00000000ed987fcc>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
>     [<00000000ed987fcc>] slab_post_alloc_hook mm/slab.h:534 [inline]
>     [<00000000ed987fcc>] slab_alloc_node mm/slub.c:2896 [inline]
>     [<00000000ed987fcc>] slab_alloc mm/slub.c:2904 [inline]
>     [<00000000ed987fcc>] __kmalloc+0x19c/0x850 mm/slub.c:3967
>     [<00000000293e3034>] kmalloc include/linux/slab.h:557 [inline]
>     [<00000000293e3034>] kmem_alloc+0x131/0x310 fs/xfs/kmem.c:21
>     [<00000000c01e339f>] xfs_init_local_fork+0xf8/0x180 fs/xfs/libxfs/xfs_inode_fork.c:52
>     [<0000000016f4ae7f>] xfs_iformat_local+0x181/0x340 fs/xfs/libxfs/xfs_inode_fork.c:91
>     [<00000000815b5848>] xfs_iformat_attr_fork+0x1a4/0x1f0 fs/xfs/libxfs/xfs_inode_fork.c:302
>     [<000000004cf4bc61>] xfs_inode_from_disk+0x592/0x5f0 fs/xfs/libxfs/xfs_inode_buf.c:268
>     [<0000000067a7ee06>] xfs_iget_cache_miss fs/xfs/xfs_icache.c:516 [inline]
>     [<0000000067a7ee06>] xfs_iget+0x7a3/0x17d0 fs/xfs/xfs_icache.c:653
>     [<000000008cff65b8>] xfs_lookup+0x123/0x260 fs/xfs/xfs_inode.c:687
>     [<000000004d7ec325>] xfs_vn_lookup+0xa8/0x110 fs/xfs/xfs_iops.c:267
>     [<00000000265d1ca5>] __lookup_hash+0xa4/0xf0 fs/namei.c:1447
>     [<0000000040f86cb0>] do_renameat2+0x37f/0x7b0 fs/namei.c:4404
>     [<00000000967d8465>] __do_sys_rename fs/namei.c:4498 [inline]
>     [<00000000967d8465>] __se_sys_rename fs/namei.c:4496 [inline]
>     [<00000000967d8465>] __x64_sys_rename+0x2c/0x40 fs/namei.c:4496
>     [<000000001f16c835>] do_syscall_64+0x35/0x50 arch/x86/entry/common.c:46
>     [<000000004c35f0dd>] entry_SYSCALL_64_after_hwframe+0x61/0xc6
>
>
> Best Regards,
> Xingyuan Mo
