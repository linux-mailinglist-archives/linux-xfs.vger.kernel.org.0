Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D52858B626
	for <lists+linux-xfs@lfdr.de>; Sat,  6 Aug 2022 16:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiHFOgS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 6 Aug 2022 10:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiHFOgR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Aug 2022 10:36:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 389A6DFBE
        for <linux-xfs@vger.kernel.org>; Sat,  6 Aug 2022 07:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659796575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nEiFrT8pUfGEdF80sgqt23VsfWyfMiuRGEYUmc8/30c=;
        b=StbAmVpvES4Mx1/uCNDknd2kFbJi/w2ckVE8Sn84fYyWzI/TLF6w3B0nvqXpjWD3fuutat
        w+gTRsBF3yWxLHLCHE1YilUxAULPvDzbBTVhgzDlD/qC6tIa8dCSMWDYUXYXvcgrcNj5VV
        Tt+5Bi1P5ZsFz0uCDDNRmpJqrfsgK1E=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-Zmfz7OnvMB6TWxDMGcdskg-1; Sat, 06 Aug 2022 10:36:14 -0400
X-MC-Unique: Zmfz7OnvMB6TWxDMGcdskg-1
Received: by mail-qt1-f198.google.com with SMTP id a8-20020a05622a064800b00342240a9fccso3727289qtb.18
        for <linux-xfs@vger.kernel.org>; Sat, 06 Aug 2022 07:36:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nEiFrT8pUfGEdF80sgqt23VsfWyfMiuRGEYUmc8/30c=;
        b=xB7TvEaWcCaAYClmf3A33MORfKvWjxeojQHJV6wG0QdDYnGDPRz1Zl30AuEYMRxSGf
         wGu+DdvwYA1ICDHkk0VDQwlacLJiT0FYvPPcpogFRgXVWYZvRTGaSYu8CuHHBk4VYQ//
         BPLUi8zIym8c/68PJpAx2PbqUKRchfxRrCyMACoekyeYTNc8cbAJk0Yx2j0l1xospyLs
         WX0aDFHyX2TPbDJXg4IW62acqG4FpVEPKLfni1q4SnkSmj7L3EzyG8r0u34n4O/Vyzsm
         x2DoxC+np+2aGcpdmL008sS6mA4x/bWL/AcjiKrU4WMgYRuch3uY+slssST7oriVkpXd
         IF9w==
X-Gm-Message-State: ACgBeo15vfFh/EwMvHW7AtdgZ6FSHYkT/Zj+YaR+0vWESxbulOsdleAj
        iNhliWd6T6GNvNzDnpFteiXZJTNFa/U+S0jJgD4WZwbe8Ve6icsjj0wdHRhw7yx77hbBS1Ekm4i
        3982DCEXGLuTmJGUQNIlz
X-Received: by 2002:ac8:5793:0:b0:342:ea28:742f with SMTP id v19-20020ac85793000000b00342ea28742fmr3541696qta.177.1659796573514;
        Sat, 06 Aug 2022 07:36:13 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5Edqgd5tEma8Bbe0qmCrc7D7VQUC2Kd1HRUpHkIo359q3oDb/C2ul7wCAHGRuyZNWLp8tMpQ==
X-Received: by 2002:ac8:5793:0:b0:342:ea28:742f with SMTP id v19-20020ac85793000000b00342ea28742fmr3541671qta.177.1659796573204;
        Sat, 06 Aug 2022 07:36:13 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i14-20020a05620a248e00b006b57b63a8ddsm5295002qkn.122.2022.08.06.07.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Aug 2022 07:36:12 -0700 (PDT)
Date:   Sat, 6 Aug 2022 22:36:06 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, tytso@mit.edu,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCHSET 0/3] fstests: refactor ext4-specific code
Message-ID: <20220806143606.kd7ikbdjntugcpp4@zlang-mailbox>
References: <165950050051.198922.13423077997881086438.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165950050051.198922.13423077997881086438.stgit@magnolia>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 02, 2022 at 09:21:40PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This series aims to make it so that fstests can install device mapper
> filters for external log devices.  Before we can do that, however, we
> need to change fstests to pass the device path of the jbd2 device to
> mount and mkfs.  Before we can do /that/, refactor all the ext4-specific
> code out of common/rc into a separate common/ext4 file.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=refactor-ext4-helpers
> ---

Hi Darrick,

There're 3 failures[1] if test ext4 with external logdev, after merging this
patchset.
The g/629 is always failed with or without this patchset, it fails if test
with external logdev.
The g/250 and g/252 fail due to _scratch_mkfs_sized doesn't use common ext4
mkfs helper, so can't deal with SCRATCH_LOGDEV well.

Thanks,
Zorro

[1]
SECTION       -- logdev
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 5.19.0-0.rc2.21.fc37.x86_64+debug #1 SMP PREEMPT_DYNAMIC Mon Jun 13 14:55:18 UTC 2022
MKFS_OPTIONS  -- -F -J device=/dev/loop0 /dev/sda3
MOUNT_OPTIONS -- -o acl,user_xattr -o context=system_u:object_r:root_t:s0 -o journal_path=/dev/loop0 /dev/sda3 /mnt/scratch

generic/250 2s ... - output mismatch (see /root/git/xfstests/results//logdev/generic/250.out.bad)
    --- tests/generic/250.out   2022-04-29 23:07:23.262498285 +0800
    +++ /root/git/xfstests/results//logdev/generic/250.out.bad  2022-08-06 22:26:45.179294149 +0800
    @@ -1,9 +1,19 @@
     QA output created by 250
     Format and mount
    +umount: /mnt/scratch: not mounted.
    +mount: /mnt/scratch: wrong fs type, bad option, bad superblock on /dev/mapper/error-test, missing codepage or helper program, or other error.
    +       dmesg(1) may have more information after failed mount system call.
     Create the original files
    +umount: /mnt/scratch: not mounted.
    ...
    (Run 'diff -u /root/git/xfstests/tests/generic/250.out /root/git/xfstests/results//logdev/generic/250.out.bad'  to see the entire diff)
generic/252 2s ... - output mismatch (see /root/git/xfstests/results//logdev/generic/252.out.bad)
    --- tests/generic/252.out   2022-04-29 23:07:23.264498308 +0800
    +++ /root/git/xfstests/results//logdev/generic/252.out.bad  2022-08-06 22:26:48.495330525 +0800
    @@ -1,10 +1,19 @@
     QA output created by 252
     Format and mount
    +umount: /mnt/scratch: not mounted.
    +mount: /mnt/scratch: wrong fs type, bad option, bad superblock on /dev/mapper/error-test, missing codepage or helper program, or other error.
    +       dmesg(1) may have more information after failed mount system call.
     Create the original files
    +umount: /mnt/scratch: not mounted.
    ...
    (Run 'diff -u /root/git/xfstests/tests/generic/252.out /root/git/xfstests/results//logdev/generic/252.out.bad'  to see the entire diff)
generic/629 3s ... - output mismatch (see /root/git/xfstests/results//logdev/generic/629.out.bad)
    --- tests/generic/629.out   2022-04-29 23:07:23.545501491 +0800
    +++ /root/git/xfstests/results//logdev/generic/629.out.bad  2022-08-06 22:26:50.810355920 +0800
    @@ -1,4 +1,5 @@
     QA output created by 629
    +mke2fs 1.46.5 (30-Dec-2021)
     test o_sync write
     310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/0
     test unaligned copy range o_sync
    ...
    (Run 'diff -u /root/git/xfstests/tests/generic/629.out /root/git/xfstests/results//logdev/generic/629.out.bad'  to see the entire diff)
Ran: generic/250 generic/252 generic/629
Failures: generic/250 generic/252 generic/629
Failed 3 of 3 tests


>  common/config |    4 +
>  common/ext4   |  176 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  common/rc     |  177 ++-------------------------------------------------------
>  common/xfs    |   23 +++++++
>  4 files changed, 208 insertions(+), 172 deletions(-)
>  create mode 100644 common/ext4
> 

