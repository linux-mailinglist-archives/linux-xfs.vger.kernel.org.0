Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C51644E2
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Jul 2019 12:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfGJKEP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Jul 2019 06:04:15 -0400
Received: from egyptian.birch.relay.mailchannels.net ([23.83.209.56]:35510
        "EHLO egyptian.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726132AbfGJKEP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 06:04:15 -0400
X-Sender-Id: dreamhost|x-authsender|a-j@a-j.ru
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id F207B6A191D
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 09:56:28 +0000 (UTC)
Received: from pdx1-sub0-mail-a65.g.dreamhost.com (100-96-92-226.trex.outbound.svc.cluster.local [100.96.92.226])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 853DB6A1160
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 09:56:28 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|a-j@a-j.ru
Received: from pdx1-sub0-mail-a65.g.dreamhost.com ([TEMPUNAVAIL].
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.17.3);
        Wed, 10 Jul 2019 09:56:28 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|a-j@a-j.ru
X-MailChannels-Auth-Id: dreamhost
X-Plucky-Harmony: 5c7df2071809ad58_1562752588821_123993838
X-MC-Loop-Signature: 1562752588821:2395402459
X-MC-Ingress-Time: 1562752588821
Received: from pdx1-sub0-mail-a65.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a65.g.dreamhost.com (Postfix) with ESMTP id 239987F131
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 02:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=a-j.ru; h=date:from
        :message-id:to:subject:mime-version:content-type
        :content-transfer-encoding; s=a-j.ru; bh=Qt/VKhOTJ2EPsK5t7t24jNc
        U6+A=; b=DiH0Vn9zjJSCQgtl538xAgxvag+90FHKvwfACVLyXUiLsXfWyrp5rMH
        X3b1W0pfX7D6WybkklY1FKrayasnR4532xTpxRaDS5rBvcFfRBjnmHUTbecEmaBY
        BRyACCE9Zh5uRMq6kFT0iNHRXzE6lrwAw0OZRxb0kplaaYToRNOI=
Received: from [172.23.0.131] (broadband-178-140-10-107.ip.moscow.rt.ru [178.140.10.107])
        (using TLSv1.1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: a-j@a-j.ru)
        by pdx1-sub0-mail-a65.g.dreamhost.com (Postfix) with ESMTPSA id 339F17FAA6
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 02:56:24 -0700 (PDT)
Date:   Wed, 10 Jul 2019 12:56:17 +0300
X-DH-BACKEND: pdx1-sub0-mail-a65
From:   Andrey Zhunev <a-j@a-j.ru>
Message-ID: <871210488.20190710125617@a-j.ru>
To:     linux-xfs@vger.kernel.org
Subject: Need help to recover root filesystem after a power supply issue
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 0
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddrgeeigddvvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhkffvufggtgfgsehtjeevtddttddvnecuhfhrohhmpeetnhgurhgvhicukghhuhhnvghvuceorgdqjhesrgdqjhdrrhhuqeenucfkphepudejkedrudegtddruddtrddutdejnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopegludejvddrvdefrddtrddufedungdpihhnvghtpedujeekrddugedtrddutddruddtjedprhgvthhurhhnqdhprghthheptehnughrvgihucgkhhhunhgvvhcuoegrqdhjsegrqdhjrdhruheqpdhmrghilhhfrhhomheprgdqjhesrgdqjhdrrhhupdhnrhgtphhtthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello All,

I am struggling to recover my system after a PSU failure, and I was
suggested to ask here for support.

One of the hard drives throws some read errors, and that happen to be
my root drive...
My system is CentOS 7, and the root partition is a part of LVM.

[root@mgmt ~]# lvscan
  ACTIVE            '/dev/centos/root' [<98.83 GiB] inherit
  ACTIVE            '/dev/centos/home' [<638.31 GiB] inherit
  ACTIVE            '/dev/centos/swap' [<7.52 GiB] inherit
[root@mgmt ~]#

[root@tftp ~]# file -s /dev/centos/root
/dev/centos/root: symbolic link to `../dm-3'
[root@tftp ~]# file -s /dev/centos/home
/dev/centos/home: symbolic link to `../dm-4'
[root@tftp ~]# file -s /dev/dm-3
/dev/dm-3: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)
[root@tftp ~]# file -s /dev/dm-4
/dev/dm-4: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)


[root@tftp ~]# xfs_repair /dev/centos/root
Phase 1 - find and verify superblock...
superblock read failed, offset 53057945600, size 131072, ag 2, rval -1

fatal error -- Input/output error
[root@tftp ~]#


smartctl shows some pending sectors on /dev/sda, and no reallocated
sectors (yet?).

Can someone please give me a hand to bring root partition back to life
(ideally)? Or, at least, recover a couple of critical configuration
files...


---
Best regards,
 Andrey

