Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3509962A1F
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Jul 2019 22:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731859AbfGHUIM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Jul 2019 16:08:12 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42545 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729930AbfGHUIM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jul 2019 16:08:12 -0400
Received: by mail-qt1-f194.google.com with SMTP id h18so11895115qtm.9
        for <linux-xfs@vger.kernel.org>; Mon, 08 Jul 2019 13:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=IEOOGZ0jTM2nddEdOHk5v2LVdO+M+edWOTp/slMy05g=;
        b=dnlY5sL1A6X/MbF0KBH1dV7EiEIIidj9FuMkqMchUknLzbCQRsEMlaV5jfMcqBEGq7
         QAbieMlF1ho4AG9KktSxH9Q8L2fgK8jzHkkl0I5Qw+24QwDYdvvMNHNE+5tRF54msCDk
         3FHMIILwJ+P377O718G9rWMxkBYO/7yDCkgfRs6fox+dYr54GSFuLfWfdlqSvbS+CHfZ
         e2BTMPCoNXKkcHMrqYRVn2wb642e5ij/hSzfQn8lB+LS7Kt5iuEoRTItuLLnbZJXFeiK
         Zj/UkMDmO0vKjmbNTY/mXUUqVUtZ3MDFRCzzTDqeY7fnD93NRqqEb5vEspQ8KV+s8ogX
         tSQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=IEOOGZ0jTM2nddEdOHk5v2LVdO+M+edWOTp/slMy05g=;
        b=mK2ajxvehot/xaCDsKL94JjOIKIs/5dchBiykbxuRzz/FRsgWNOqXWCmBcy0BXf5UY
         luDuLm54Iq1B0GZDSve4pL1Vwrux0kkFnqj5CGJlmV7zS3klHiCKiU4BfuvyrllpNFwL
         Dn6YZjeqSrIlzzazDHA2BLS738tVaMM8uz9CmYmH5ks1g+rXgaNqOdcTxI0DA9Rl4ak+
         Na5zpMaVpk4KPP8g7+/oNBaekBYy/bsKM5BPoQZ99o6TAbMTJAMSXwxPI4smLbPP+cW1
         E2K+6QB3dm4wN7GFcxSxjenkhV4UNArM2WVlRFQc+esCQ8XWZLjOPkuvsrLMIroowRMw
         phHg==
X-Gm-Message-State: APjAAAWe5UT8Pv4VYF7xs8FB8fsJaPZF7Yvk0YyEff6ocCg6NTD83hqH
        yl5puiNNo77p9sWUiJPw0v2mZg==
X-Google-Smtp-Source: APXvYqy49Ddm4mmtPGJv4NHSDrNSw2X0Iu6KriJFk5Vb7V/2bg0Z9HFn6DcH0/uFzgxjIt1a4T0OUw==
X-Received: by 2002:aed:2dc7:: with SMTP id i65mr15457755qtd.365.1562616491425;
        Mon, 08 Jul 2019 13:08:11 -0700 (PDT)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f20sm7425605qkh.15.2019.07.08.13.08.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 13:08:10 -0700 (PDT)
Message-ID: <1562616489.8510.15.camel@lca.pw>
Subject: memory leaks from xfs_rw_bdev()
From:   Qian Cai <cai@lca.pw>
To:     hch@lst.de
Cc:     darrick.wong@oracle.com, david@fromorbit.com,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 08 Jul 2019 16:08:09 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Booting today's linux-next starts to have several memory leaks. Looks like the
new xfs_rw_bdev() was introduced in the commit "xfs: use bios directly to read
and write the log recovery buffers".

https://patchwork.kernel.org/patch/10977673/

unreferenced object 0xffff888f595487c0 (size 184):
  comm "mount", pid 1473, jiffies 4294946340 (age 14914.220s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 08 40 28 67 8f 88 ff ff  .........@(g....
    00 18 00 00 40 c6 00 00 00 00 00 00 00 00 00 00  ....@...........
  backtrace:
    [<0000000031fb6250>] kmem_cache_alloc+0x272/0x400
    [<000000008ce62f00>] mempool_alloc_slab+0x2d/0x40
    [<000000004eaa8110>] mempool_alloc+0x10a/0x29e
    [<00000000906127bf>] bio_alloc_bioset+0x150/0x330
    [<000000005d5cc981>] xfs_rw_bdev+0x72/0x300 [xfs]
    [<00000000bbf739cd>] xlog_do_io+0xd8/0x1a0 [xfs]
    [<000000003815ee16>] xlog_bread+0x28/0x70 [xfs]
    [<00000000883dc328>] xlog_find_verify_cycle+0x180/0x2c0 [xfs]
    [<00000000457d45f8>] xlog_find_head+0x27c/0x5a0 [xfs]
    [<000000009956dd1f>] xlog_find_tail+0xdb/0x530 [xfs]
    [<00000000c0cdfde4>] xlog_recover+0x8f/0x2a0 [xfs]
    [<00000000f87803cd>] xfs_log_mount+0x247/0x3b0 [xfs]
    [<00000000e3a05975>] xfs_mountfs+0x7bd/0xe30 [xfs]
    [<00000000128f1a43>] xfs_fs_fill_super+0x6f0/0xaa0 [xfs]
    [<000000000ead1e3b>] mount_bdev+0x1d9/0x220
    [<00000000d48a9588>] xfs_fs_mount+0x15/0x20 [xfs]
