Return-Path: <linux-xfs+bounces-2920-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7826C837686
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Jan 2024 23:50:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3114A286F95
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Jan 2024 22:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CF8F168A2;
	Mon, 22 Jan 2024 22:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="mGcfHMi2"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F89015E94
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 22:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705963783; cv=none; b=ST8AmQMgU1nGBx5DqOq/tKH2BvnssWaGXHB+w8ffaR5cmX8eXbA1EyMELblYamQkifIeLwlMj2g2Hp8iY/qlzY91VJ6xBHgqN/f0Cf/9Z4LVcls0vSsbMDGSjO2jR4x7+Zj8IV1OWBEAXyq2d0y2YdUUawpkL3j3931ha9EY+zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705963783; c=relaxed/simple;
	bh=GaqL/5/Ps67S72Z7pEGEXMfgYZQ0Zsw1iHeHSJJYcls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nsxpn9adlkEijHP5c+w49SEjfXT9s9LJo3oEm4eYq98/As8VOteOP//WpbXbaHu3irRYoykeOPYN2CL4oSjoOduSW8BzYMA9rVHYnTSsARiTI40LsxhzI1q+tnSku1UJ4rGLiHRQIOAWuPeWnN+TEBlbGDia/ft9OYYYM8JpUbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=mGcfHMi2; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6dbb003be79so3259959b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 14:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705963781; x=1706568581; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/UUmkEpElUy227zy70Gn9omry7f9SOCcX7+J5mLkTvc=;
        b=mGcfHMi2QYcRLpgVF0XZWbLdi01bd/pImeMxv6xR7QoOHzZihx4xWdQPdJtGHhb9nG
         cEgomWmjOurnNp3uXcG76WsYqbap/jIdW4Ehbglp47A+ujULERXbV0LX8GMq7D6XZrJX
         oysl9WvZmyUvSdYNccJIEJ1dEHKsoZyrxMDTPCTA+Hi+0bcR/zc391/jjYESiIgZzv78
         4t7y/v32KsZvP91/pokelTKqYlTMUlIIUcfaC6chNETJ7iiO5RTt+2gcoHpWRT1utd8v
         nf+N4Sx7kkPywr8r/HmT/rayqEr9trGthoNdC++Z598lt0A6x79wOUB5X34VHD2mWhnx
         HiaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705963781; x=1706568581;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/UUmkEpElUy227zy70Gn9omry7f9SOCcX7+J5mLkTvc=;
        b=Q7ryA1i56bNj2imgeJsZCNeW/cCLtm45zpSS9zWZIakBVYt/28Fe7iL9PlzZ1A3TE0
         vwWP8VHDssIkHq1IHwpx/3r4hJIepb7KAsFO4m1nvVU+3bNFrcAXsmIDG5AunmypnVkG
         5J5HGMMTRwjlXSCNjeBFxJ5LVIZ18+Lcbi8hzm8lPunaHLdTGV9ZFLZyxdJEks3t/LlP
         LEWj90XCZ9DuLUns+H0QNIbRWRZe9G7DAocOa5ZXEe6iOgo5yTcJFFb1WB4HHjV6YgK3
         G4sYVGhPtcyszDlAM3UZMmKRkqM08HoALiUKj+PUHNTDAxWAIvh3dIdjJcgyTnfV/xc/
         5khw==
X-Gm-Message-State: AOJu0YzHSsesjd5fLykWQClQeG3E6yLI5x7lMBNBtZqVQIuw3XS7ap+F
	s4Ww3QjizyEry6+191+Vmm5Jkcxc2jBb3DtU67panBitkl5cxCF+A+qDNY4sK4Uzhyj/xsV+zWQ
	E
X-Google-Smtp-Source: AGHT+IHs4MDshznPNIiPuwjufPfGXbifrU4pJJniMg3NDUJIa4hxecuS1llKoO0ZHlIvg9lIDoMVGQ==
X-Received: by 2002:a05:6a00:21d5:b0:6db:ad3c:693f with SMTP id t21-20020a056a0021d500b006dbad3c693fmr7197564pfj.11.1705963781363;
        Mon, 22 Jan 2024 14:49:41 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id f28-20020aa79d9c000000b006d9a13b491csm9961434pfq.212.2024.01.22.14.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 14:49:40 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rS36n-00DxeA-2o;
	Tue, 23 Jan 2024 09:49:37 +1100
Date: Tue, 23 Jan 2024 09:49:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [xfstests generic/648] 64k directory block size (-n size=65536)
 crash on _xfs_buf_ioapply
Message-ID: <Za7xAQUZa1PtnAHn@dread.disaster.area>
References: <20231218140134.gql6oecpezvj2e66@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZainBd2Jz6I0Pgm1@dread.disaster.area>
 <20240119013807.ivgvwe7yxweamg2m@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZaoiBF9KqyMt3URQ@dread.disaster.area>
 <20240120112600.phkv37z4nx3pj2jn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZaxeOXSb0+jPYCe1@dread.disaster.area>
 <20240122072312.usotep2ajokhcuci@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <Za5PoyT0WZdqgphT@dread.disaster.area>
 <20240122131856.2rtzmdtore25nj7k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122131856.2rtzmdtore25nj7k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Mon, Jan 22, 2024 at 09:18:56PM +0800, Zorro Lang wrote:
> # dmesg
> [180724.293443] loop: module loaded
> [180724.294001] loop0: detected capacity change from 0 to 6876344
> [180724.296987] XFS (loop0): Mounting V5 Filesystem 59e2f6ae-ceab-4232-9531-a85417847238
> [180724.309088] XFS (loop0): Starting recovery (logdev: internal)
> [180724.335207] XFS (loop0): Bad dir block magic!
> [180724.335210] XFS: Assertion failed: 0, file: fs/xfs/xfs_buf_item_recover.c, line: 414
> [180724.335264] ------------[ cut here ]------------
> [180724.335265] kernel BUG at fs/xfs/xfs_message.c:102!
> [180724.335356] monitor event: 0040 ilc:2 [#1] SMP 
> [180724.335362] Modules linked in: loop sunrpc rfkill vfio_ccw mdev vfio_iommu_type1 zcrypt_cex4 vfio iommufd drm fuse i2c_core drm_panel_orientation_quirks xfs libcrc32c ghash_s390 prng virt
> io_net des_s390 sha3_512_s390 net_failover sha3_256_s390 failover virtio_blk dm_mirror dm_region_hash dm_log dm_mod pkey zcrypt aes_s390
> [180724.335379] CPU: 2 PID: 6449 Comm: mount Kdump: loaded Not tainted 6.7.0+ #1
> [180724.335382] Hardware name: IBM 3931 LA1 400 (KVM/Linux)
> [180724.335384] Krnl PSW : 0704e00180000000 000003ff7fe692ca (assfail+0x62/0x68 [xfs])
> [180724.335727]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
> [180724.335729] Krnl GPRS: c000000000000021 000003ff7fee3a40 ffffffffffffffea 000000000000000a
> [180724.335731]            000003800005b3c0 0000000000000000 000003ff800004c4 0000000300014178
> [180724.335732]            0000000090a87e80 0000000300014178 000000008bcf6000 00000000924a5000
> [180724.335734]            000003ffbe72ef68 000003ff7ffe4c20 000003ff7fe692a8 000003800005b468
> [180724.335742] Krnl Code: 000003ff7fe692bc: f0a8000407fe       srp     4(11,%r0),2046,8
>                            000003ff7fe692c2: 47000700           bc      0,1792
>                           #000003ff7fe692c6: af000000           mc      0,0
>                           >000003ff7fe692ca: 0707               bcr     0,%r7
>                            000003ff7fe692cc: 0707               bcr     0,%r7
>                            000003ff7fe692ce: 0707               bcr     0,%r7
>                            000003ff7fe692d0: c00400133e0c       brcl    0,000003ff800d0ee8
>                            000003ff7fe692d6: eb6ff0480024       stmg    %r6,%r15,72(%r15)
> [180724.335753] Call Trace:
> [180724.335754]  [<000003ff7fe692ca>] assfail+0x62/0x68 [xfs] 
> [180724.335835] ([<000003ff7fe692a8>] assfail+0x40/0x68 [xfs])
> [180724.335915]  [<000003ff7fe8323e>] xlog_recover_validate_buf_type+0x2a6/0x5c8 [xfs] 
> [180724.335997]  [<000003ff7fe845ba>] xlog_recover_buf_commit_pass2+0x382/0x448 [xfs] 
> [180724.336078]  [<000003ff7fe8e89a>] xlog_recover_items_pass2+0x72/0xf0 [xfs] 
> [180724.336159]  [<000003ff7fe8f7ce>] xlog_recover_commit_trans+0x39e/0x3c0 [xfs] 
> [180724.336240]  [<000003ff7fe8f930>] xlog_recovery_process_trans+0x140/0x148 [xfs] 
> [180724.336321]  [<000003ff7fe8f9f8>] xlog_recover_process_ophdr+0xc0/0x180 [xfs] 
> [180724.336402]  [<000003ff7fe9002e>] xlog_recover_process_data+0xb6/0x168 [xfs] 
> [180724.336482]  [<000003ff7fe901e4>] xlog_recover_process+0x104/0x150 [xfs] 
> [180724.336563]  [<000003ff7fe905e2>] xlog_do_recovery_pass+0x3b2/0x748 [xfs] 
> [180724.336643]  [<000003ff7fe90dd0>] xlog_do_log_recovery+0x88/0xd8 [xfs] 
> [180724.336727]  [<000003ff7fe90e6c>] xlog_do_recover+0x4c/0x218 [xfs] 
> [180724.336808]  [<000003ff7fe9247a>] xlog_recover+0xda/0x1a0 [xfs] 
> [180724.336888]  [<000003ff7fe78d36>] xfs_log_mount+0x11e/0x280 [xfs] 
> [180724.336967]  [<000003ff7fe6a756>] xfs_mountfs+0x3e6/0x920 [xfs] 
> [180724.337047]  [<000003ff7fe71ffc>] xfs_fs_fill_super+0x40c/0x7d8 [xfs] 
> [180724.337127]  [<00000000552adf88>] get_tree_bdev+0x120/0x1a8 
> [180724.337142]  [<00000000552ab690>] vfs_get_tree+0x38/0x110 
> [180724.337146]  [<00000000552dee28>] do_new_mount+0x188/0x2e0 
> [180724.337150]  [<00000000552dfaa4>] path_mount+0x1ac/0x818 
> [180724.337153]  [<00000000552e0214>] __s390x_sys_mount+0x104/0x148 
> [180724.337156]  [<0000000055934796>] __do_syscall+0x21e/0x2b0 
> [180724.337163]  [<0000000055944d60>] system_call+0x70/0x98 
> [180724.337170] Last Breaking-Event-Address:
> [180724.337221]  [<000003ff7fe692b2>] assfail+0x4a/0x68 [xfs]
> [180724.337301] ---[ end trace 0000000000000000 ]---
> 
> # trace-cmd report > testfs.trace.txt
> # bzip2 testfs.trace.txt
> 
> Please download it from:
> https://drive.google.com/file/d/1FgpPidbMZHSjZinyc_WbVGfvwp2btA86/view?usp=sharing

Actually, looking at the compound buffer logging code and reminding
myself of how it works, I think this might actually be a false
positive.

What I see in the trace is this pattern of buffer log items being
processed through every phase of recovery:

 xfs_log_recover_buf_not_cancel: dev 7:0 daddr 0x2c2ce0, bbcount 0x10, flags 0x5000, size 2, map_size 2
 xfs_log_recover_item_recover: dev 7:0 tid 0xce3ce480 lsn 0x300014178, pass 1, item 0x8ea70fc0, item type XFS_LI_BUF item region count/total 2/2
 xfs_log_recover_buf_not_cancel: dev 7:0 daddr 0x331fb0, bbcount 0x58, flags 0x5000, size 2, map_size 11
 xfs_log_recover_item_recover: dev 7:0 tid 0xce3ce480 lsn 0x300014178, pass 1, item 0x8f36c040, item type XFS_LI_BUF item region count/total 2/2

The item addresses, tid and LSN change, but the order of the two
buf log items does not.

These are both "flags 0x5000" which means both log items are
XFS_BLFT_DIR_BLOCK_BUF types, and they are both partial directory
block buffers, and they are discontiguous. They also have different
types of log items both before and after them, so it is likely these
are two extents within the same compound buffer.

The way we log compound buffers is that we create a buf log format
item for each extent in the buffer, and then we log each range as a
separate buf log format item. IOWs, to recovery these fragments of
the directory block appear just like complete regular buffers that
need to be recovered.

Hence what we see above is the first buffer (daddr 0x2c2ce0, bbcount
0x10) is the first extent in the directory block that contains the
header and magic number, so it recovers and verifies just fine. The
second buffer is the tail of the directory block, and it does not
contain a magic number because it starts mid-way through the
directory block. Hence the magic number verification fails and the
buffer is not recovered.

Compound buffers were logged this way so that they didn't require a
change of log format to recover. Prior to compound buffers, the
directory code kept it's own dabuf structure to map multiple extents
in a singel directory block, and they got logged as separate buffer
log format items as well.

So the problem isn't directly related to the conversion of dabufs to
compound buffers - the problem is related to the buffer recovery
verification code not knowing that directory buffer fragments are
valid recovery targets.

IOWs, this appears to be a log recovery problem and not a runtime
issue. I think the fix will be to allow directory blocks to fail the
magic number check if and only if the buffer length does not match
the directory block size (i.e. it is a partial directory block
fragment being recovered). 

This makes the verification a bit more tricky and perhaps a little
less robust, but we do know that we are supposed to be recovering a
directory block from the buf log format flags and so this additional
check can be constrained.

I suspect that we also need to verify that all other buffers that
are supposed to log and recover entire objects have the correct
size, too.

I'll start working on a fix now - I'm not sure what form that will
take yet as I need to stare at the code for a while longer yet.

Zorro, in the mean time, can you write up an xfstest that creates a
small XFS filesystem with "-n size=64k" and a large log, sets it up
with single block fragmentation (falloc, punch alternate), then
creates a bunch of files (a few thousand) to create a set of
fragmented directory blocks, then runs 'shutdown -f' to force the
log and prevent metadata writeback, then unmounts and mounts the
filesystem. The mount of the filesystem should then trigger this
directory fragment recovery issue on any platform, not just s390.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

