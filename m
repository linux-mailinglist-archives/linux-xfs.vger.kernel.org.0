Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319B25ABE54
	for <lists+linux-xfs@lfdr.de>; Sat,  3 Sep 2022 11:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiICJ6J (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 3 Sep 2022 05:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiICJ6H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Sep 2022 05:58:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A755AA0E
        for <linux-xfs@vger.kernel.org>; Sat,  3 Sep 2022 02:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662199085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gWY2yrJHV9mR+2imgb/aG2YZoxvlt8rD9Vjqyq016nQ=;
        b=cVGKZ9Igk/sTUWzRuRX4jNB75wt8xV+gLf9NR8PMVqUjybK7fTI/Gyei18sVIvu4M1JlED
        g7qvdjALLrsY/CUcrpxUtstdp182y8ptvewVLKq6TsNmnCHPudOA1uWPIgWRVYGsbXyHPx
        FWx2YIOUrk5EbomysCdrQRBpl1c3v28=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-642-hLsqY0v5PxuPVAc3Sv8izA-1; Sat, 03 Sep 2022 05:58:04 -0400
X-MC-Unique: hLsqY0v5PxuPVAc3Sv8izA-1
Received: by mail-qk1-f199.google.com with SMTP id m19-20020a05620a24d300b006bb85a44e96so3827316qkn.23
        for <linux-xfs@vger.kernel.org>; Sat, 03 Sep 2022 02:58:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=gWY2yrJHV9mR+2imgb/aG2YZoxvlt8rD9Vjqyq016nQ=;
        b=psXvHUEcZLhLbEkAsVbdc4RFxYj5UtuUT8VnImokMYPhsP9bcayvFaT6WkF0W781A1
         kAY2PyEnZzaRC6DXSRCykeZQGU9CPsbWv0K7yAJ9zDUsQR5wat34Y8q/y/R0lw4dRYB/
         gIYk6lkjOFRQ9omMBzmtBqf7KyzRvoBxNe4j9n9ptVQEzsZWTadYa+Jd7a11GcBYYv7v
         F+p8k5OayIJnbZs4JTNQktY09U0pGH67YdVfIqDEmy0UQ9kUtL7uC/2vtutNpu0zGVAS
         UYAxDD5A1iH72L8kGDPjYDCIGOfwzHDDm1F7SrxF0M/laXjSPpe9vPWc/mqErHtVuQYc
         vWVw==
X-Gm-Message-State: ACgBeo2lSVpKrubGI4ybrE/S3A8MveOsH2vOHu4Rfn2K4moEZLyqa6qq
        +7yuN95kAMt/7CStMTNnLgfE8xRByyI7qvSeyhQdIJNefvcG/KOYSpE4xXboSaaXa4pq9CsnkTL
        sX/Xbs5v27vdg53T7ocE/
X-Received: by 2002:a05:622a:18a4:b0:343:5f48:ec67 with SMTP id v36-20020a05622a18a400b003435f48ec67mr32693851qtc.73.1662199083335;
        Sat, 03 Sep 2022 02:58:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6hw7E0jfxduMzn9z6ckbWpXH3fj3Na+uOAml8G0N4uxxVIOhW3yneMehfKCTuhOddz0t301g==
X-Received: by 2002:a05:622a:18a4:b0:343:5f48:ec67 with SMTP id v36-20020a05622a18a400b003435f48ec67mr32693841qtc.73.1662199083010;
        Sat, 03 Sep 2022 02:58:03 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id fy9-20020a05622a5a0900b0034359fc348fsm2755765qtb.73.2022.09.03.02.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 02:58:02 -0700 (PDT)
Date:   Sat, 3 Sep 2022 17:57:55 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     fstests@vger.kernel.org, djwong@kernel.org, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
        zhengbin13@huawei.com, jack.qiu@huawei.com
Subject: Re: [PATCH fstests] xfs/554: xfs add illegal bestfree array size
 inject for leaf dir
Message-ID: <20220903095755.ftrecvbfkt6drdwc@zlang-mailbox>
References: <20220902094046.3891252-1-guoxuenan@huawei.com>
 <20220903013921.wbmwkf6rs2iknqn6@zlang-mailbox>
 <e51811d6-be83-47ee-c4bb-7dc18f97df97@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e51811d6-be83-47ee-c4bb-7dc18f97df97@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 03, 2022 at 11:51:13AM +0800, Guo Xuenan wrote:
> Hi Zorro：
> 
> On 2022/9/3 9:39, Zorro Lang wrote:
> > On Fri, Sep 02, 2022 at 05:40:46PM +0800, Guo Xuenan wrote:
> > > Test leaf dir allocting new block when bestfree array size
> > > less than data blocks count, which may lead to UAF.
> > > 
> > > Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
> > > ---
> > >   tests/xfs/554     | 48 +++++++++++++++++++++++++++++++++++++++++++++++
> > >   tests/xfs/554.out |  6 ++++++
> > >   2 files changed, 54 insertions(+)
> > >   create mode 100755 tests/xfs/554
> > >   create mode 100644 tests/xfs/554.out
> > > 
> > > diff --git a/tests/xfs/554 b/tests/xfs/554
> > > new file mode 100755
> > > index 00000000..fcf45731
> > > --- /dev/null
> > > +++ b/tests/xfs/554
> > > @@ -0,0 +1,48 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2022 Huawei Limited.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 554
> > > +#
> > > +# Test leaf dir bestfree array size match with dir disk size
> > Is it for a known bug? known commit id?
> The bug is being solved and waitting to be reviewed here[v1/v2].
> [v1]
> https://lore.kernel.org/all/20220902094046.3891252-1-guoxuenan@huawei.com/
> [v2]
> https://lore.kernel.org/all/20220831121639.3060527-1-guoxuenan@huawei.com/
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick
> > > +
> > > +# Import common functions.
> > > +. ./common/populate
> > > +
> > > +# real QA test starts here
> > > +_supported_fs xfs
> > > +_require_scratch
> > Do you need V5 xfs? Or v4 is fine?
> > _require_scratch_xfs_crc ??
> 
> > > +_require_check_dmesg
> > > +
> > > +echo "Format and mount"
> > > +_scratch_mkfs > $seqres.full 2>&1
> > > +_scratch_mount  >> $seqres.full 2>&1

If _scratch_mount fails, the testing will exit directly, so generally we just
run _scratch_mount.

> > > +
> > > +echo "Create and check leaf dir"
> > > +blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > > +dblksz="$($XFS_INFO_PROG "${SCRATCH_DEV}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > Why do you need these two kinds of block size for xfs? And you sometimes
> > use the former, sometimes use the later? If you'd like to get the xfs data
> > block size, you can:
> > 
> >    _scratch_mkfs | _filter_mkfs >>$seqres.full 2>$tmp.mkfs
> >    . $tmp.mkfs
> > 
> > Then "dbsize" is what you want.
> > 
> > > +leaf_lblk="$((32 * 1073741824 / blksz))"
> > > +node_lblk="$((64 * 1073741824 / blksz))"
> > I didn't see the "node_lblk" is used in this case, looks like you don't want to
> > get directory node blocks in this case.
> It's really needed here, must define leaf_lblk and node_lblk before calling
> __populate_check_xfs_dir
> or an waring will be printed by the function.

Oh, so these two global parameters are used for later __populate_check_xfs_dir.
Hmm.. are "blksz" and "dblksz" necessary too, for someone __populate_* helper
you used? I really don't understand why we need them both. These helpers are
written by Darrick, I think he learns about that more :)

> > > +__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF" "$((dblksz / 12))"
> > > +leaf_dir="$(__populate_find_inode "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF")"
> > > +_scratch_unmount
> > > +__populate_check_xfs_dir "${leaf_dir}" "leaf"
> > > +
> > > +echo "Inject bad bestfress array size"
> > > +_scratch_xfs_db -x -c "inode ${leaf_dir}" -c "dblock 8388608" -c "write ltail.bestcount 0"
> > As you tried to detect xfs block size above, so it might not 4k block size, so
> > 8388608 is not fixed.
> > 
> > According to the kernel definition:
> >    #define XFS_DIR2_DATA_ALIGN_LOG 3
> >    #define XFS_DIR2_SPACE_SIZE     (1ULL << (32 + XFS_DIR2_DATA_ALIGN_LOG))
> >    #define XFS_DIR2_LEAF_SPACE     1
> >    #define XFS_DIR2_LEAF_OFFSET    (XFS_DIR2_LEAF_SPACE * XFS_DIR2_SPACE_SIZE)
> > 
> > The XFS_DIR2_LEAF_OFFSET = 1 * (1 << (32 + 3)) = 1<<35 = 34359738368 = 32GB, so
> > the fixed logical offset of leaf extent is 34359738368 bytes, then the offset
> > block number should be "34359738368 / dbsize". 8388608 is only for 4k block
> > size.
> Sorry, you are totally right! it should be "dblock ${leaf_lblk}"

That looks better.

> > > +
> > > +echo "Test add entry to dir"
> > > +_scratch_mount
> > > +touch ${SCRATCH_MNT}/S_IFDIR.FMT_LEAF/{1..100}.txt > /dev/null 2>&1
> > > +_scratch_unmount 2>&1

This "2>&1" looks useless, I think it can be removed

> > > +_repair_scratch_fs >> $seqres.full 2>&1
> > Can you explain more about this testing steps? The xfs has been corrupted, then
> > we expect is can be mounted. And create 100 new files on that corrupted dir,
> > do you expect the 100 files can be created successfully? Or what ever, even
> > nothing be created?
> since we have create an leaf dir,and set bestfree count to 0; then, need to
> touch some files to
> trigger the problem, the action will be failed as expected.

OK, I think you can add more comments to explain this part. Due to you make
a obvious corruption at first, then try to mount and write the corrupted fs,
there must be some error happen, so you'd better to explain what do you
expect, and what's not.

> > What's the xfs_repair expect? Fix all curruption and left a clean xfs?
> Adding repair is really not necessary, only toavoid _check_xfs_filesystem
> warning
> " _check_xfs_filesystem: filesystem on /dev/sdb is inconsistent (r)"

Except you'd like to verify if xfs_repair can fix this corruption. Or replace
_require_scatch with _require_scratch_nocheck, that will help you avoid known
fs corruption warning. Then you can remove _repair_scratch_fs and above
_scratch_unmount.

> > > +
> > > +# check demsg error
> > > +_check_dmesg
> > Which above step will trigger a dmesg you want to check? What kind of dmesg do
> dmesg eg:
> [   80.543884] XFS (sdb): Internal error xfs_dir2_data_use_free at line 1200
> of file fs/xfs/libxfs/xfs_dir2_data.c.  Caller
> xfs_dir2_data_use_free+0xb3/0xeb0
> [   80.545141] CPU: 2 PID: 2978 Comm: touch Not tainted 6.0.0-rc3+ #115
> [   80.545715] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> [   80.546546] Call Trace:
> [   80.546785]  <TASK>
> [   80.546985]  dump_stack_lvl+0x4d/0x66
> [   80.547335] xfs_corruption_error+0x132/0x150
> [   80.548391]  ? xfs_dir2_data_use_free+0xb3/0xeb0
> [   80.548901]  ? xfs_dir2_data_use_free+0xb3/0xeb0
> [   80.549319]  ? xfs_dir2_data_use_free+0xb3/0xeb0
> [   80.550190] xfs_dir2_data_use_free+0x198/0xeb0
> [   80.550718]  ? xfs_dir2_data_use_free+0xb3/0xeb0
> [   80.551140] xfs_dir2_leaf_addname+0xa59/0x1ac0
> [   80.551881]  ? _raw_spin_unlock_irqrestore+0x42/0x80
> [   80.552403]  ? xfs_dir2_leaf_search_hash+0x300/0x300
> or
> [  201.405239] BUG: KASAN: slab-out-of-bounds in
> xfs_dir2_leaf_addname+0x1995/0x1ac0
> [  201.406179] Write of size 2 at addr ffff888078c33000 by task touch/7433
> [  201.407010]
> [  201.407217] CPU: 6 PID: 7433 Comm: touch Not tainted 6.0.0-rc3+ #115
> [  201.408016] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> [  201.409143] Call Trace:
> [  201.409461]  <TASK>
> [  201.409740]  dump_stack_lvl+0x4d/0x66
> [  201.410214]  print_report.cold+0xf6/0x691
> [  201.410730]  ? xfs_dir3_data_init+0x18e/0x960
> 
> UAF/slab-out-of bound etc...

Look at the _check_dmesg, it checks "Internal error" and "\bBUG:" etc, so I
think it can catch above dmesg error, you can remove this _check_dmesg and
run again, to make sure if it works as you wish.

> 
> > you want to check? I think xfstests checks dmesg at the end of each test case,
> > except you need to check some special one, or need a special filter?
> check demsg without filter seems enough, so i did not add special filter.
> > Thanks,
> > Zorro
> > 
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/554.out b/tests/xfs/554.out
> > > new file mode 100644
> > > index 00000000..ea1f30cc
> > > --- /dev/null
> > > +++ b/tests/xfs/554.out
> > > @@ -0,0 +1,6 @@
> > > +QA output created by 554
> > > +Format and mount
> > > +Create and check leaf dir
> > > +Inject bad bestfress array size
> > > +ltail.bestcount = 0
> > > +Test add entry to dir
> > > -- 
> > > 2.25.1
> > > 
> > .
> 

