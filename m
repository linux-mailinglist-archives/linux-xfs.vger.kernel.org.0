Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC95153CC
	for <lists+linux-xfs@lfdr.de>; Mon,  6 May 2019 20:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbfEFSlT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 6 May 2019 14:41:19 -0400
Received: from sandeen.net ([63.231.237.45]:43444 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbfEFSlT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 May 2019 14:41:19 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0D366B67;
        Mon,  6 May 2019 13:41:11 -0500 (CDT)
Subject: Re: [v5.0.0] Assertion in xfs_repair: dir2.c:1445: process_dir2:
 Assertion `(ino != mp->m_sb.sb_rootino && ino != *parent) || (ino ==
 mp->m_sb.sb_rootino && (ino == *parent || need_root_dotdot == 1))'
To:     Anatoly Trosinenko <anatoly.trosinenko@gmail.com>,
        linux-xfs@vger.kernel.org
References: <CAE5jQCfP95cvjkKTmawpbfFLmBVwYZ3t89WED=U3uk4z+7U+CQ@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <d057c6f1-cbce-c986-ccbf-b0ca266484e5@sandeen.net>
Date:   Mon, 6 May 2019 13:41:17 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAE5jQCfP95cvjkKTmawpbfFLmBVwYZ3t89WED=U3uk4z+7U+CQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/4/19 7:08 AM, Anatoly Trosinenko wrote:
> By fuzzing the xfsprogs 5.0.0 (commit 65dcd3bc), I have found a
> modification to the image, that triggers an assertion in xfs_repair.
> An assertion like this was already fixed almost a year ago (see commit
> 77b3425 @ Jun 21 2018), but this reproducer works for the v5.0.0
> xfsprogs release.

FWIW, back at commit 77b3425 this image still fails w/ the same assert.
So, this doesn't seem like a regression.  I'll take a look.

Thanks,
-Eric

> ## How to reproduce:
> Clone xfsprogs (commit 65dcd3bc30) and run `make`, then run
> 
> $ ./repair/xfs_repair -Pnf /tmp/xfs.img
> Cannot get host filesystem geometry.
> Repair may fail if there is a sector size mismatch between
> the image and the host filesystem.
> Phase 1 - find and verify superblock...
> Cannot get host filesystem geometry.
> Repair may fail if there is a sector size mismatch between
> the image and the host filesystem.
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> Metadata CRC error detected at 0x55836064d5a4, xfs_agfl block 0x10003/0x200
> agfl has bad CRC for ag 1
> Metadata CRC error detected at 0x558360680abd, xfs_inobt block 0x20018/0x1000
> btree block 2/3 is suspect, error -74
> Metadata CRC error detected at 0x558360680abd, xfs_inobt block 0x20020/0x1000
> btree block 2/4 is suspect, error -74
> Metadata CRC error detected at 0x55836065120d, xfs_allocbt block 0x8/0x1000
> btree block 0/1 is suspect, error -74
> Metadata CRC error detected at 0x558360680abd, xfs_inobt block 0x20/0x1000
> btree block 0/4 is suspect, error -74
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
> bad CRC for inode 96
> bad CRC for inode 117
> bad CRC for inode 133
> bad CRC for inode 137
> bad CRC for inode 96, would rewrite
> would have corrected root directory 96 .. entry from 9056 to 96
> xfs_repair: dir2.c:1445: process_dir2: Assertion `(ino !=
> mp->m_sb.sb_rootino && ino != *parent) || (ino == mp->m_sb.sb_rootino
> && (ino == *parent || need_root_dotdot == 1))' failed.
> 
> ## Stack trace:
> 
> (gdb) bt
> #0  __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:50
> #1  0x00007ffff7d36535 in __GI_abort () at abort.c:79
> #2  0x00007ffff7d3640f in __assert_fail_base (fmt=0x7ffff7ec4588
> "%s%s%s:%u: %s%sAssertion `%s' failed.\n%n", assertion=0x5555555dc7c0
> "(ino != mp->m_sb.sb_rootino && ino != *parent) || (ino ==
> mp->m_sb.sb_rootino && (ino == *parent || need_root_dotdot == 1))",
>     file=0x5555555dc8b2 "dir2.c", line=1445, function=<optimized out>)
> at assert.c:92
> #3  0x00007ffff7d46012 in __GI___assert_fail
> (assertion=assertion@entry=0x5555555dc7c0 "(ino != mp->m_sb.sb_rootino
> && ino != *parent) || (ino == mp->m_sb.sb_rootino && (ino == *parent
> || need_root_dotdot == 1))", file=file@entry=0x5555555dc8b2 "dir2.c",
>     line=line@entry=1445, function=function@entry=0x5555555dca90
> <__PRETTY_FUNCTION__.12672> "process_dir2") at assert.c:101
> #4  0x000055555556ae15 in process_dir2 (mp=mp@entry=0x7fffffffd930,
> ino=ino@entry=96, dip=dip@entry=0x55555565b200,
> ino_discovery=ino_discovery@entry=1,
> dino_dirty=dino_dirty@entry=0x7fffffffd438,
> dirname=dirname@entry=0x5555555dfc7f "", parent=0x7fffffffd440,
>     blkmap=0x0) at dir2.c:1443
> #5  0x00005555555687d1 in process_dinode_int
> (mp=mp@entry=0x7fffffffd930, dino=dino@entry=0x55555565b200,
> agno=agno@entry=0, ino=ino@entry=96, was_free=<optimized out>,
> dirty=dirty@entry=0x7fffffffd438, used=0x7fffffffd434, verify_mode=0,
> uncertain=0, ino_discovery=1,
>     check_dups=0, extra_attr_check=1, isa_dir=0x7fffffffd43c,
> parent=0x7fffffffd440) at dinode.c:2819
> #6  0x0000555555569378 in process_dinode (mp=mp@entry=0x7fffffffd930,
> dino=dino@entry=0x55555565b200, agno=agno@entry=0, ino=ino@entry=96,
> was_free=<optimized out>, dirty=dirty@entry=0x7fffffffd438,
> used=0x7fffffffd434, ino_discovery=1, check_dups=0,
>     extra_attr_check=1, isa_dir=0x7fffffffd43c, parent=0x7fffffffd440)
> at dinode.c:2936
> #7  0x00005555555625cb in process_inode_chunk
> (mp=mp@entry=0x7fffffffd930, agno=agno@entry=0,
> first_irec=first_irec@entry=0x7fffe0005720,
> ino_discovery=ino_discovery@entry=1, check_dups=check_dups@entry=0,
> extra_attr_check=extra_attr_check@entry=1,
>     bogus=0x7fffffffd4d4, num_inos=64) at incore.h:472
> #8  0x000055555556394a in process_aginodes (mp=0x7fffffffd930,
> pf_args=pf_args@entry=0x0, agno=agno@entry=0,
> ino_discovery=ino_discovery@entry=1, check_dups=check_dups@entry=0,
> extra_attr_check=extra_attr_check@entry=1) at dino_chunks.c:1031
> #9  0x000055555556f62f in process_ag_func (wq=0x7fffffffd5d0, agno=0,
> arg=0x0) at phase3.c:67
> #10 0x000055555557cc0b in prefetch_ag_range (work=0x7fffffffd5d0,
> start_ag=<optimized out>, end_ag=4, dirs_only=false,
> func=0x55555556f5e0 <process_ag_func>) at prefetch.c:968
> #11 0x000055555557e675 in do_inode_prefetch
> (mp=mp@entry=0x7fffffffd930, stride=0, func=func@entry=0x55555556f5e0
> <process_ag_func>, check_cache=check_cache@entry=false,
> dirs_only=dirs_only@entry=false) at prefetch.c:1031
> #12 0x000055555556f79b in process_ags (mp=0x7fffffffd930) at phase3.c:135
> #13 phase3 (mp=0x7fffffffd930, scan_threads=32) at phase3.c:135
> #14 0x000055555555a440 in main (argc=<optimized out>, argv=<optimized
> out>) at xfs_repair.c:940
> 
> Best regards
> Anatoly
> 
