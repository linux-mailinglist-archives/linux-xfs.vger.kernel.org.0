Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C700382C79
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Aug 2019 09:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731898AbfHFHTj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Aug 2019 03:19:39 -0400
Received: from datenwanderung.de ([194.59.205.165]:58232 "EHLO
        mail.nekoboi.moe" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731807AbfHFHTj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 03:19:39 -0400
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Aug 2019 03:19:36 EDT
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: kinky_nekoboi@nekoboi.moe)
        by mail.nekoboi.moe (Postcow) with ESMTPSA id 5923BB40024;
        Tue,  6 Aug 2019 09:10:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nekoboi.moe; s=dkim;
        t=1565075459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=VlJghK2IZVrfZWxRYNQjWVzw6kBFhErnMAU9KYaBUfg=;
        b=WKwJ1U0s7MrEZ4NKjeKKhih0nncnzPfV0Goojoj0K+fiIf3uugLXK8R7ZwjEgk5aQGaq7O
        Gjau3/+bf/OWvcTVXxfTPWOhuy9KPIaHUlKp8g6daJWFAwIlJMNELvEVvuyCSzXbTZGnxf
        mauQHcpN+0l/2UsVx8rpSS0bvlsRKx73Tpu6Abrv+R7UaQisL4I2t0iLunbFcJIktnGvN0
        TyZQ6eN1PzDzigy4ybAO3jfI+ZFTchWa5fNLQxzgDyODoR4A3DeuyVeXdgYDvbrI1N/vGW
        BRFfRuRL2aSh+Zss3b2ZAsHFSLgCFxbtlssZW12m9t8V8V+zS3qygw+fGNTJpg==
Subject: Re: XFS segementation fault with new linux 4.19.63
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
References: <e0ca189e-2f96-6599-40ce-a4fc8866d8d1@nekoboi.moe>
 <20190806070806.GA13112@infradead.org>
From:   Kinky Nekoboi <kinky_nekoboi@nekoboi.moe>
Openpgp: preference=signencrypt
Autocrypt: addr=kinky_nekoboi@nekoboi.moe; keydata=
 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
 KlTseuU=
Message-ID: <cbe57554-ed5f-6163-d48c-9069aa2dcc7b@nekoboi.moe>
Date:   Tue, 6 Aug 2019 09:10:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190806070806.GA13112@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=nekoboi.moe;
        s=dkim; t=1565075459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=VlJghK2IZVrfZWxRYNQjWVzw6kBFhErnMAU9KYaBUfg=;
        b=EvbXRIR+a8yp3g0OaRpWu1EmjnSq2dgFSF+vsCymlUaiwl9KszhH1NvVj5DMKIpkg0SBkI
        7hvbdMKMkckwPiHR7HjEKuvJ5hd6rTKZMva0a1L8GFemQGDPwJye018qNbJ+OmzWFWzKe2
        MNNbo99FmG7xsAW5KXXjGFKd4gJOx/0slYrW/cDT8jGBxkRm2giyW/EOqqOEJkSWeT/2td
        Z+5qzckCXexewBjrtLpIhUu8xpwWCXeq96LxVlMwoXM2uub0JTHdmUaguFcveSmPH5LeBs
        GE1Tcz3oORU/Asi8Ed1HnzZ+pxgB9mkEifhbQPBbRJ1SD1+pi1pggAPKRrFdvQ==
ARC-Seal: i=1; s=dkim; d=nekoboi.moe; t=1565075459; a=rsa-sha256; cv=none;
        b=NOO3E39DgaRmYfrhy+luXbVbqI0N8ASml8TaRzCvomU7B/8D+UJlFHohJzWwNmR/51jreq
        DgEXiXc6NDner/4umLDoEybqFNyi725A9qvjGoPnvYN4lPa15J2qMCuWl4jBD09/W5iTZW
        FLv1tH9NnW2M5wU3rQtrjNExKDDJGN3l/TvEiC2wYDk5Zn3Vc79hBbTmxm3hC9CRVM5V4D
        6vVIh0BuzklxKbK0g1UXGnKvL4uROn8cn776A42l+7B8l6mleWD5T+2RAmUxvPN8GaXjlO
        2DHmkAC32wbGpH+2yBkMfCkU5kHcjZfx1vDEXfOYvYzD8PesSMz/cQ0qSk3RUw==
ARC-Authentication-Results: i=1;
        mail.nekoboi.moe;
        auth=pass smtp.mailfrom=kinky_nekoboi@nekoboi.moe
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Addional info:

this only occurs if kernel is compiled with:

CONFIG_XFS_DEBUG=y

running 4.19.64 without xfs debugging works fine

Am 06.08.19 um 09:08 schrieb Christoph Hellwig:
> [adding the linux-xfs list]
>
> On Wed, Jul 31, 2019 at 03:01:33PM +0200, Kinky Nekoboi wrote:
>> I am not subscribed, so if you want to contact me do Direkt Email.
>>
>> kern output:
>>
>>
>> ul 31 13:51:53 lain kernel: [   71.660736] XFS: Assertion failed:
>> xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
>> xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
>> pag->pagf_freeblks + pag->pagf_flcount, file:
>> fs/xfs/libxfs/xfs_ag_resv.c, line: 319
>> Jul 31 13:51:53 lain kernel: [   71.681711] ------------[ cut here
>> ]------------
>> Jul 31 13:51:53 lain kernel: [   71.686416] kernel BUG at
>> fs/xfs/xfs_message.c:102!
>> Jul 31 13:51:53 lain kernel: [   71.691431] invalid opcode: 0000 [#1]
>> SMP NOPTI
>> Jul 31 13:51:53 lain kernel: [   71.696047] CPU: 2 PID: 1322 Comm: mount
>> Not tainted 4.19.63-custom #1
>> Jul 31 13:51:53 lain kernel: [   71.702730] Hardware name: ASUS
>> KGPE-D16/KGPE-D16, BIOS 4.10-108-gc19161538c 07/29/2019
>> Jul 31 13:51:53 lain kernel: [   71.711028] RIP: 0010:assfail+0x25/0x36
>> [xfs]
>> Jul 31 13:51:53 lain kernel: [   71.715475] Code: d4 e8 0f 0b c3 0f 1f
>> 44 00 00 48 89 f1 41 89 d0 48 c7 c6 80 62 fb c0 48 89 fa 31 ff e8 72 f9
>> ff ff 80 3d 2e cb 08 00 00 74 02 <0f> 0b 48 c7 c7 b0 62 fb c0 e8 74 11
>> d4 e8 0f 0b c3 48 8b b3 a8 01
>> Jul 31 13:51:53 lain kernel: [   71.734532] RSP: 0018:ffffb3a584117cb8
>> EFLAGS: 00010202
>> Jul 31 13:51:53 lain kernel: [   71.739849] RAX: 0000000000000000 RBX:
>> ffffa0259fc22a00 RCX: 0000000000000000
>> Jul 31 13:51:53 lain kernel: [   71.747135] RDX: 00000000ffffffc0 RSI:
>> 000000000000000a RDI: ffffffffc0fa971b
>> Jul 31 13:51:53 lain kernel: [   71.754407] RBP: 0000000000000000 R08:
>> 0000000000000000 R09: 0000000000000000
>> Jul 31 13:51:53 lain kernel: [   71.761633] R10: 000000000000000a R11:
>> f000000000000000 R12: ffffa0259c157000
>> Jul 31 13:51:53 lain kernel: [   71.768861] R13: 0000000000000008 R14:
>> ffffa0259c157000 R15: 0000000000000000
>> Jul 31 13:51:53 lain kernel: [   71.776110] FS:  00007f169d61f100(0000)
>> GS:ffffa025a7c80000(0000) knlGS:0000000000000000
>> Jul 31 13:51:53 lain kernel: [   71.784330] CS:  0010 DS: 0000 ES: 0000
>> CR0: 0000000080050033
>> Jul 31 13:51:53 lain kernel: [   71.790198] CR2: 00007fa8c52fc441 CR3:
>> 000000042453c000 CR4: 00000000000406e0
>> Jul 31 13:51:53 lain kernel: [   71.797446] Call Trace:
>> Jul 31 13:51:53 lain kernel: [   71.800040] 
>> xfs_ag_resv_init+0x1bd/0x1d0 [xfs]
>> Jul 31 13:51:53 lain kernel: [   71.804717] 
>> xfs_fs_reserve_ag_blocks+0x3e/0xb0 [xfs]
>> Jul 31 13:51:53 lain kernel: [   71.809937]  xfs_mountfs+0x5b3/0x920 [xfs]
>> Jul 31 13:51:53 lain kernel: [   71.814212] 
>> xfs_fs_fill_super+0x44d/0x620 [xfs]
>> Jul 31 13:51:53 lain kernel: [   71.818997]  ?
>> xfs_test_remount_options+0x60/0x60 [xfs]
>> Jul 31 13:51:53 lain kernel: [   71.824320]  mount_bdev+0x177/0x1b0
>> Jul 31 13:51:53 lain kernel: [   71.827868]  mount_fs+0x3e/0x145
>> Jul 31 13:51:53 lain kernel: [   71.831178] 
>> vfs_kern_mount.part.35+0x54/0x120
>> Jul 31 13:51:53 lain kernel: [   71.835728]  do_mount+0x20e/0xcc0
>> Jul 31 13:51:53 lain kernel: [   71.839098]  ? _copy_from_user+0x37/0x60
>> Jul 31 13:51:53 lain kernel: [   71.843097]  ? memdup_user+0x4b/0x70
>> Jul 31 13:51:53 lain kernel: [   71.846751]  ksys_mount+0xb6/0xd0
>> Jul 31 13:51:53 lain kernel: [   71.850137]  __x64_sys_mount+0x21/0x30
>> Jul 31 13:51:53 lain kernel: [   71.853983]  do_syscall_64+0x55/0xf0
>> Jul 31 13:51:53 lain kernel: [   71.857621] 
>> entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> Jul 31 13:51:53 lain kernel: [   71.862727] RIP: 0033:0x7f169d2b1fea
>> Jul 31 13:51:53 lain kernel: [   71.866362] Code: 48 8b 0d a9 0e 0c 00
>> f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00
>> 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d
>> 76 0e 0c 00 f7 d8 64 89 01 48
>> Jul 31 13:51:53 lain kernel: [   71.885417] RSP: 002b:00007ffe6c4dd048
>> EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
>> Jul 31 13:51:53 lain kernel: [   71.895075] RAX: ffffffffffffffda RBX:
>> 000055e2f3093a40 RCX: 00007f169d2b1fea
>> Jul 31 13:51:53 lain kernel: [   71.904309] RDX: 000055e2f309b220 RSI:
>> 000055e2f3093c70 RDI: 000055e2f3093c50
>> Jul 31 13:51:53 lain kernel: [   71.913532] RBP: 00007f169d6061c4 R08:
>> 0000000000000000 R09: 00007f169d2f3400
>> Jul 31 13:51:53 lain kernel: [   71.922730] R10: 0000000000000000 R11:
>> 0000000000000246 R12: 0000000000000000
>> Jul 31 13:51:53 lain kernel: [   71.931950] R13: 0000000000000000 R14:
>> 000055e2f3093c50 R15: 000055e2f309b220
>> Jul 31 13:51:53 lain kernel: [   71.941107] Modules linked in: dm_crypt
>> twofish_generic twofish_avx_x86_64 twofish_x86_64_3way twofish_x86_64
>> twofish_common xts algif_skcipher af_alg dm_mod tun devlink
>> cpufreq_userspace cpufreq_powersave cpufreq_conservative binfmt_misc xfs
>> amd64_edac_mod edac_mce_amd kvm_amd ccp rng_core kvm irqbypass
>> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc snd_hda_intel ast
>> snd_hda_codec ttm snd_hda_core evdev snd_pcsp snd_hwdep drm_kms_helper
>> snd_pcm snd_timer aesni_intel aes_x86_64 drm crypto_simd snd cryptd
>> serio_raw i2c_algo_bit fam15h_power k10temp glue_helper soundcore sg
>> sp5100_tco pcc_cpufreq button acpi_cpufreq nft_counter nft_ct
>> nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables_set nf_tables
>> nfnetlink ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 fscrypto
>> raid10 raid1 raid0 multipath
>> Jul 31 13:51:53 lain kernel: [   72.027825]  linear raid456
>> async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq
>> libcrc32c crc32c_generic md_mod sd_mod ohci_pci ata_generic ahci
>> firewire_ohci xhci_pci libahci ohci_hcd ehci_pci pata_atiixp xhci_hcd
>> firewire_core ehci_hcd crc_itu_t libata psmouse crc32c_intel i2c_piix4
>> usbcore scsi_mod e1000e
>> Jul 31 13:51:53 lain kernel: [   72.064151] ---[ end trace
>> a6475ff3d1350cc4 ]---
>> Jul 31 13:51:53 lain kernel: [   72.071244] RIP: 0010:assfail+0x25/0x36
>> [xfs]
>> Jul 31 13:51:53 lain kernel: [   72.077951] Code: d4 e8 0f 0b c3 0f 1f
>> 44 00 00 48 89 f1 41 89 d0 48 c7 c6 80 62 fb c0 48 89 fa 31 ff e8 72 f9
>> ff ff 80 3d 2e cb 08 00 00 74 02 <0f> 0b 48 c7 c7 b0 62 fb c0 e8 74 11
>> d4 e8 0f 0b c3 48 8b b3 a8 01
>> Jul 31 13:51:53 lain kernel: [   72.101469] RSP: 0018:ffffb3a584117cb8
>> EFLAGS: 00010202
>> Jul 31 13:51:53 lain kernel: [   72.109081] RAX: 0000000000000000 RBX:
>> ffffa0259fc22a00 RCX: 0000000000000000
>> Jul 31 13:51:53 lain kernel: [   72.118620] RDX: 00000000ffffffc0 RSI:
>> 000000000000000a RDI: ffffffffc0fa971b
>> Jul 31 13:51:53 lain kernel: [   72.128206] RBP: 0000000000000000 R08:
>> 0000000000000000 R09: 0000000000000000
>> Jul 31 13:51:53 lain kernel: [   72.137789] R10: 000000000000000a R11:
>> f000000000000000 R12: ffffa0259c157000
>> Jul 31 13:51:53 lain kernel: [   72.147332] R13: 0000000000000008 R14:
>> ffffa0259c157000 R15: 0000000000000000
>> Jul 31 13:51:53 lain kernel: [   72.156892] FS:  00007f169d61f100(0000)
>> GS:ffffa025a7c80000(0000) knlGS:0000000000000000
>> Jul 31 13:51:53 lain kernel: [   72.167382] CS:  0010 DS: 0000 ES: 0000
>> CR0: 0000000080050033
>> Jul 31 13:51:53 lain kernel: [   72.175498] CR2: 00007fa8c52fc441 CR3:
>> 000000042453c000 CR4: 00000000000406e0
>>
> ---end quoted text---
