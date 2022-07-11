Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A80656B3C5
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Jul 2022 09:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236803AbiGHHpO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Jul 2022 03:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236471AbiGHHpN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jul 2022 03:45:13 -0400
Received: from ip27.imatronix.com (ip27.imatronix.com [200.63.97.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20537D1D9
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 00:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=superfactura.cl; s=default; h=Content-Transfer-Encoding:Content-Type:To:
        Subject:From:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VE1tHBCuqOIXnR6RGO4x/WK5Yhial2SWrfcLR602KBA=; b=EbBhZNGr0PA0Mp96d+0eEWT0fC
        iZqVXyRSmpHAXcxRt3gbiJC1hW06lzDDyywn1l8jiWIkomHgJomQxDnvE8w/mvIyl4RUC2MUXl256
        oRgasBVlEmwz9aTHDLQOeCwb/3PfYRQikW+gWTGNuZaSk7L9fO6tamR9bEwdD2cIwV7NSU9P836a3
        riTcB6NNTmvotS5KnsqP3pkmB5s/E07ouMTjqysTz6+HSa4wXaF57AGaQDTVhkG3BBHH8iruWZ1/w
        wiAZtVTZ5jRCsKZEGOM+HrSs50H10Rkt9oXKnHhrycEc9xc0lnxNqGrUl/vb63kddnN795HkiosNj
        noUWjJxA==;
Received:    from [200.73.112.45]
           by cpanel.imatronix.com    with esmtpsa    (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
           (Exim 4.95)
           (envelope-from <kripper@imatronix.cl>)
           id 1o9ifi-0007fY-Js   
        for linux-xfs@vger.kernel.org;
        Fri, 08 Jul 2022 03:45:05 -0400
Message-ID: <09b4cbd7-c258-e39c-1f04-1edcc8ccf899@imatronix.cl>
Date:   Fri, 8 Jul 2022 03:45:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Christopher Pereira <kripper@imatronix.cl>
Subject: [bug report] xfs corruption - XFS_WANT_CORRUPTED_RETURN
To:     linux-xfs@vger.kernel.org
Content-Language: en-US
Organization: IMATRONIX S.A.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel.imatronix.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - imatronix.cl
X-Get-Message-Sender-Via: cpanel.imatronix.com: authenticated_id: soporte@superfactura.cl
X-Authenticated-Sender: cpanel.imatronix.com: soporte@superfactura.cl
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

I've been using XFS for many years on many qemu-kvm VMs without problems.
I do daily qcow2 snapshots and today I noticed that a snaphot I took on 
Jun  1 2022 has a corrupted XFS root partition and doesn't boot any more 
(on another VM instance).
The snapshot I took the day before is clean.
The VM is still running since May 11 2022, has not been rebooted and 
didn't crash which is the reason I'm reporting this issue.
This is a production VM with sensible data.

The kernel logged this error multiple times between 00:00:21 and 
00:03:31 on Jun 1:

Jun  1 00:00:21 *** kernel: XFS (dm-0): Internal error 
XFS_WANT_CORRUPTED_RETURN at line 337 of file 
fs/xfs/libxfs/xfs_alloc.c.  Caller xfs_alloc_ag_vextent_near+0x658/0xa60 
[xfs]
Jun  1 00:00:22 *** kernel: [<ffffffffa0230e5b>] 
xfs_error_report+0x3b/0x40 [xfs]
Jun  1 00:00:22 *** kernel: [<ffffffffa01f0588>] ? 
xfs_alloc_ag_vextent_near+0x658/0xa60 [xfs]
Jun  1 00:00:22 *** kernel: [<ffffffffa01ee684>] 
xfs_alloc_fixup_trees+0x2c4/0x370 [xfs]
Jun  1 00:00:22 *** kernel: [<ffffffffa01f0588>] 
xfs_alloc_ag_vextent_near+0x658/0xa60 [xfs]
Jun  1 00:00:22 *** kernel: [<ffffffffa01f120d>] 
xfs_alloc_ag_vextent+0xcd/0x110 [xfs]
Jun  1 00:00:22 *** kernel: [<ffffffffa01f1f89>] 
xfs_alloc_vextent+0x429/0x5e0 [xfs]
Jun  1 00:00:22 *** kernel: [<ffffffffa020237f>] 
xfs_bmap_btalloc+0x3af/0x710 [xfs]
Jun  1 00:00:22 *** kernel: [<ffffffffa02026ee>] xfs_bmap_alloc+0xe/0x10 
[xfs]
Jun  1 00:00:22 *** kernel: [<ffffffffa0203148>] 
xfs_bmapi_write+0x4d8/0xa90 [xfs]
Jun  1 00:00:22 *** kernel: [<ffffffffa023bd1b>] 
xfs_iomap_write_allocate+0x14b/0x350 [xfs]
Jun  1 00:00:22 *** kernel: [<ffffffffa0226dc6>] 
xfs_map_blocks+0x1c6/0x230 [xfs]
Jun  1 00:00:22 *** kernel: [<ffffffffa0227fe3>] 
xfs_vm_writepage+0x193/0x5d0 [xfs]
Jun  1 00:00:22 *** kernel: [<ffffffffa0227993>] 
xfs_vm_writepages+0x43/0x50 [xfs]
Jun  1 00:00:22 *** kernel: XFS (dm-0): page discard on page 
ffffea000cf60200, inode 0xc52bf7f, offset 0.

I'm running this (outdated) software:

- uname -a:
     Linux *** 3.10.0-327.22.2.el7.x86_64 #1 SMP Thu Jun 23 17:05:11 UTC 
2016 x86_64 x86_64 x86_64 GNU/Linux

- modinfo xfs
     filename: /lib/modules/3.10.0-327.22.2.el7.x86_64/kernel/fs/xfs/xfs.ko
     license:        GPL
     description:    SGI XFS with ACLs, security attributes, no debug 
enabled
     author:         Silicon Graphics, Inc.
     alias:          fs-xfs
     rhelversion:    7.2
     srcversion:     5F736B32E75482D75F98583
     depends:        libcrc32c
     intree:         Y
     vermagic:       3.10.0-327.22.2.el7.x86_64 SMP mod_unload modversions
     signer:         CentOS Linux kernel signing key
     sig_key: A9:80:1A:61:B3:68:60:1C:40:EB:DB:D5:DF:D1:F3:A7:70:07:BF:A4
     sig_hashalgo:   sha256

1) Is there any known issue with this xfs version?

2) How may I help you to trace this bug.
I could provide my WhatsApp number privately for direct communication.

Should I try a xfs_repair and post the logs here or via pastebin?

BTW: I'm a experienced developer and sysadmin, but have no experience 
regarding the XFS  driver.


