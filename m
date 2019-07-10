Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED68644B2
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Jul 2019 11:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfGJJwd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Jul 2019 05:52:33 -0400
Received: from egyptian.birch.relay.mailchannels.net ([23.83.209.56]:61261
        "EHLO egyptian.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725994AbfGJJwd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 05:52:33 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jul 2019 05:52:31 EDT
X-Sender-Id: dreamhost|x-authsender|a-j@a-j.ru
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id AFD255E1FE0
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 09:47:19 +0000 (UTC)
Received: from pdx1-sub0-mail-a65.g.dreamhost.com (100-96-92-226.trex.outbound.svc.cluster.local [100.96.92.226])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 433D55E1CEA
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 09:47:19 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|a-j@a-j.ru
Received: from pdx1-sub0-mail-a65.g.dreamhost.com ([TEMPUNAVAIL].
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.17.3);
        Wed, 10 Jul 2019 09:47:19 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|a-j@a-j.ru
X-MailChannels-Auth-Id: dreamhost
X-Abiding-Squirrel: 43f8830f0703f31c_1562752039558_3156936307
X-MC-Loop-Signature: 1562752039558:640426488
X-MC-Ingress-Time: 1562752039558
Received: from pdx1-sub0-mail-a65.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a65.g.dreamhost.com (Postfix) with ESMTP id 7F68C7F14C
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 02:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=a-j.ru; h=date:from
        :message-id:to:subject:mime-version:content-type
        :content-transfer-encoding; s=a-j.ru; bh=PBtSKeYUp0FkW9ku0nw71u8
        o/Ng=; b=T4JqIdcqBGJ6+08m2Fx7P/pPpw5h/HsRxcxL3Xo7b6z4KbEbLCNQ/lf
        CUPQlKgpZ4YAMq4Z7/odJO711Hq/ji9eoqNk2mjWGfsgdoXHnFTmPOUc8/O2rbDQ
        uUxgdPRfFLD5bprz2bxSNDsxWkA9amx2Y7sBop+hdWeyQo5B5CO8=
Received: from [172.23.0.131] (broadband-178-140-10-107.ip.moscow.rt.ru [178.140.10.107])
        (using TLSv1.1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: a-j@a-j.ru)
        by pdx1-sub0-mail-a65.g.dreamhost.com (Postfix) with ESMTPSA id 8CF027F13A
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 02:47:17 -0700 (PDT)
Date:   Wed, 10 Jul 2019 12:47:10 +0300
X-DH-BACKEND: pdx1-sub0-mail-a65
From:   Andrey Zhunev <a-j@a-j.ru>
Message-ID: <958316946.20190710124710@a-j.ru>
To:     linux-xfs@vger.kernel.org
Subject: Need help to recover root filesystem after a power supply issue
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 0
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddrgeeigddvtdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhkffvufggtgfgsehtjeevtddttddvnecuhfhrohhmpeetnhgurhgvhicukghhuhhnvghvuceorgdqjhesrgdqjhdrrhhuqeenucfkphepudejkedrudegtddruddtrddutdejnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopegludejvddrvdefrddtrddufedungdpihhnvghtpedujeekrddugedtrddutddruddtjedprhgvthhurhhnqdhprghthheptehnughrvgihucgkhhhunhgvvhcuoegrqdhjsegrqdhjrdhruheqpdhmrghilhhfrhhomheprgdqjhesrgdqjhdrrhhupdhnrhgtphhtthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello All,

I am struggling to recover my system after a PSU failure.

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

