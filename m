Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3191764993
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Jul 2019 17:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfGJP3D (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Jul 2019 11:29:03 -0400
Received: from bonobo.elm.relay.mailchannels.net ([23.83.212.22]:31608 "EHLO
        bonobo.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727552AbfGJP3C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 11:29:02 -0400
X-Sender-Id: dreamhost|x-authsender|a-j@a-j.ru
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id C6D8F228CF;
        Wed, 10 Jul 2019 15:29:01 +0000 (UTC)
Received: from pdx1-sub0-mail-a65.g.dreamhost.com (100-96-30-63.trex.outbound.svc.cluster.local [100.96.30.63])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id E639322823;
        Wed, 10 Jul 2019 15:29:00 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|a-j@a-j.ru
Received: from pdx1-sub0-mail-a65.g.dreamhost.com ([TEMPUNAVAIL].
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.17.3);
        Wed, 10 Jul 2019 15:29:01 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|a-j@a-j.ru
X-MailChannels-Auth-Id: dreamhost
X-Minister-Arch: 16b35b895863b5bf_1562772541423_2308817971
X-MC-Loop-Signature: 1562772541422:2900850836
X-MC-Ingress-Time: 1562772541422
Received: from pdx1-sub0-mail-a65.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a65.g.dreamhost.com (Postfix) with ESMTP id 697F182A32;
        Wed, 10 Jul 2019 08:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=a-j.ru; h=date:from
        :message-id:to:cc:subject:in-reply-to:references:mime-version
        :content-type:content-transfer-encoding; s=a-j.ru; bh=JOXXKZ1Chh
        Nxui0sB+eJSCEIkzQ=; b=TM/8gwlhZbCqFmnUPa6VjqWubNBps4HE4bouv9HhFF
        X5Q6MkUzM2RstfcSbuT6EQzOXoVr6Va9cw4Ee7QVEUXBEmDw/nF0AASTbFQi9tKX
        TpUp3gfl+Gp/oiu1VCgS2OoTI6aomLN64h3aUI56s002XNll97rliTyNd8h1pPl7
        g=
Received: from [172.23.0.131] (broadband-178-140-10-107.ip.moscow.rt.ru [178.140.10.107])
        (using TLSv1.1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: a-j@a-j.ru)
        by pdx1-sub0-mail-a65.g.dreamhost.com (Postfix) with ESMTPSA id 5C1CE82A25;
        Wed, 10 Jul 2019 08:28:59 -0700 (PDT)
Date:   Wed, 10 Jul 2019 18:28:51 +0300
X-DH-BACKEND: pdx1-sub0-mail-a65
From:   Andrey Zhunev <a-j@a-j.ru>
Message-ID: <1373677058.20190710182851@a-j.ru>
To:     Chris Murphy <lists@colorremedies.com>
CC:     xfs list <linux-xfs@vger.kernel.org>
Subject: Re: Need help to recover root filesystem after a power supply issue
In-Reply-To: <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
References: <958316946.20190710124710@a-j.ru> 
  <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 0
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddrgeeigdeltdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhkffvufgjfhggtgfgsehtjeevtddttddvnecuhfhrohhmpeetnhgurhgvhicukghhuhhnvghvuceorgdqjhesrgdqjhdrrhhuqeenucffohhmrghinhepshhmrghrthhmohhnthhoohhlshdrohhrghenucfkphepudejkedrudegtddruddtrddutdejnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopegludejvddrvdefrddtrddufedungdpihhnvghtpedujeekrddugedtrddutddruddtjedprhgvthhurhhnqdhprghthheptehnughrvgihucgkhhhunhgvvhcuoegrqdhjsegrqdhjrdhruheqpdhmrghilhhfrhhomheprgdqjhesrgdqjhdrrhhupdhnrhgtphhtthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Wednesday, July 10, 2019, 5:30:37 PM, you wrote:

> On Wed, Jul 10, 2019 at 3:52 AM Andrey Zhunev <a-j@a-j.ru> wrote:
>>
>> [root@tftp ~]# xfs_repair /dev/centos/root
>> Phase 1 - find and verify superblock...
>> superblock read failed, offset 53057945600, size 131072, ag 2, rval -1
>>
>> fatal error -- Input/output error
>> [root@tftp ~]#

> # smartctl -l scterc /dev/

> Point it to the physical device. If it's a consumer drive, it might
> support a configurable SCT ERC. Also need to see the kernel messages
> at the time of the i/o error. There's some chance if a deep recover
> read is possible, it'll recover the data. But I don't see how this is
> related to power supply failure.



Well, this machine is always online (24/7, with a UPS backup power).
Yesterday we found it switched OFF, without any signs of life. Trying
to switch it on, the PSU made a humming noise and the machine didn't
even try to start. So we replaced the PSU. After that, the machine
powered on - but refused to boot... Something tells me these two
failures are likely related...



# smartctl -l scterc /dev/sda
smartctl 6.5 2016-05-07 r4318 [x86_64-linux-3.10.0-957.el7.x86_64] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

#

This is a WD RED series drive, WD30EFRX.
Here are some more of the error messages from kernel log file:

Jul 10 11:59:03 mgmt kernel: ata1.00: exception Emask 0x0 SAct 0x100000 SErr 0x0 action 0x0
Jul 10 11:59:03 mgmt kernel: ata1.00: irq_stat 0x40000008
Jul 10 11:59:03 mgmt kernel: ata1.00: failed command: READ FPDMA QUEUED
Jul 10 11:59:03 mgmt kernel: ata1.00: cmd 60/08:a0:d8:c3:84/00:00:0a:00:00/40 tag 20 ncq 4096 in#012         res 41/40:00:d8:c3:84/00:00:0a:00:00/40 Emask 0x409 (media error) <F>
Jul 10 11:59:03 mgmt kernel: ata1.00: status: { DRDY ERR }
Jul 10 11:59:03 mgmt kernel: ata1.00: error: { UNC }
Jul 10 11:59:03 mgmt kernel: ata1.00: configured for UDMA/133
Jul 10 11:59:03 mgmt kernel: sd 0:0:0:0: [sda] tag#20 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jul 10 11:59:03 mgmt kernel: sd 0:0:0:0: [sda] tag#20 Sense Key : Medium Error [current] [descriptor]
Jul 10 11:59:03 mgmt kernel: sd 0:0:0:0: [sda] tag#20 Add. Sense: Unrecovered read error - auto reallocate failed
Jul 10 11:59:03 mgmt kernel: sd 0:0:0:0: [sda] tag#20 CDB: Read(16) 88 00 00 00 00 00 0a 84 c3 d8 00 00 00 08 00 00
Jul 10 11:59:03 mgmt kernel: blk_update_request: I/O error, dev sda, sector 176473048
Jul 10 11:59:03 mgmt kernel: Buffer I/O error on dev sda, logical block 22059131, async page read
Jul 10 11:59:03 mgmt kernel: ata1: EH complete
Jul 10 11:59:05 mgmt kernel: ata1.00: exception Emask 0x0 SAct 0x1000000 SErr 0x0 action 0x0
Jul 10 11:59:05 mgmt kernel: ata1.00: irq_stat 0x40000008
Jul 10 11:59:05 mgmt kernel: ata1.00: failed command: READ FPDMA QUEUED
Jul 10 11:59:05 mgmt kernel: ata1.00: cmd 60/08:c0:d8:c3:84/00:00:0a:00:00/40 tag 24 ncq 4096 in#012         res 41/40:00:d8:c3:84/00:00:0a:00:00/40 Emask 0x409 (media error) <F>
Jul 10 11:59:05 mgmt kernel: ata1.00: status: { DRDY ERR }
Jul 10 11:59:05 mgmt kernel: ata1.00: error: { UNC }
Jul 10 11:59:05 mgmt kernel: ata1.00: configured for UDMA/133
Jul 10 11:59:05 mgmt kernel: sd 0:0:0:0: [sda] tag#24 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jul 10 11:59:05 mgmt kernel: sd 0:0:0:0: [sda] tag#24 Sense Key : Medium Error [current] [descriptor]
Jul 10 11:59:05 mgmt kernel: sd 0:0:0:0: [sda] tag#24 Add. Sense: Unrecovered read error - auto reallocate failed
Jul 10 11:59:05 mgmt kernel: sd 0:0:0:0: [sda] tag#24 CDB: Read(16) 88 00 00 00 00 00 0a 84 c3 d8 00 00 00 08 00 00
Jul 10 11:59:05 mgmt kernel: blk_update_request: I/O error, dev sda, sector 176473048
Jul 10 11:59:05 mgmt kernel: Buffer I/O error on dev sda, logical block 22059131, async page read
Jul 10 11:59:05 mgmt kernel: ata1: EH complete





---
Best regards,
 Andrey


