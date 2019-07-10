Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1306494A
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Jul 2019 17:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfGJPCs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Jul 2019 11:02:48 -0400
Received: from bonobo.elm.relay.mailchannels.net ([23.83.212.22]:55539 "EHLO
        bonobo.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727674AbfGJPCs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 11:02:48 -0400
X-Greylist: delayed 18377 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jul 2019 11:02:46 EDT
X-Sender-Id: dreamhost|x-authsender|a-j@a-j.ru
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id D4F20502ABA;
        Wed, 10 Jul 2019 15:02:44 +0000 (UTC)
Received: from pdx1-sub0-mail-a65.g.dreamhost.com (100-96-4-184.trex.outbound.svc.cluster.local [100.96.4.184])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 3ACC0502DC7;
        Wed, 10 Jul 2019 15:02:42 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|a-j@a-j.ru
Received: from pdx1-sub0-mail-a65.g.dreamhost.com ([TEMPUNAVAIL].
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.17.3);
        Wed, 10 Jul 2019 15:02:44 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|a-j@a-j.ru
X-MailChannels-Auth-Id: dreamhost
X-Dime-Befitting: 32ce7e9b2c012498_1562770963802_1291980396
X-MC-Loop-Signature: 1562770963802:2634539334
X-MC-Ingress-Time: 1562770963802
Received: from pdx1-sub0-mail-a65.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a65.g.dreamhost.com (Postfix) with ESMTP id 84E8382A31;
        Wed, 10 Jul 2019 08:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=a-j.ru; h=date:from
        :message-id:to:subject:in-reply-to:references:mime-version
        :content-type:content-transfer-encoding; s=a-j.ru; bh=Xws0g8r5dg
        7ohEdXfj1tfP+Bbf4=; b=nwx6R447A49/9W91E/z3ZrcRHQQ0NRIHSG7yCOYnUf
        UMM8EeQbmsjAxgHglUjCn3Acu/oyU+ZH73bsulpZ/0WxPStkdh6zBEUPsXJ9GqR0
        P8ehv/tiG1BnsGywgZlqi0UQzlkBiX6QbbZTjKXQ5MKvkH3JzFshwl47QG6r2QHW
        E=
Received: from [172.23.0.131] (broadband-178-140-10-107.ip.moscow.rt.ru [178.140.10.107])
        (using TLSv1.1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: a-j@a-j.ru)
        by pdx1-sub0-mail-a65.g.dreamhost.com (Postfix) with ESMTPSA id 2019882A26;
        Wed, 10 Jul 2019 08:02:38 -0700 (PDT)
Date:   Wed, 10 Jul 2019 18:02:30 +0300
X-DH-BACKEND: pdx1-sub0-mail-a65
From:   Andrey Zhunev <a-j@a-j.ru>
Message-ID: <15810023599.20190710180230@a-j.ru>
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: Need help to recover root filesystem after a power supply issue
In-Reply-To: <8bef8d1e-2f5f-a8bd-08d3-fff0dce1256e@sandeen.net>
References: <871210488.20190710125617@a-j.ru> 
  <fcbcd66e-0c78-f13b-e7aa-1487090d1dfd@sandeen.net>
  <433120592.20190710165841@a-j.ru>
  <8bef8d1e-2f5f-a8bd-08d3-fff0dce1256e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -100
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddrgeeigdekhecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffkvffujghfgggtgfesthejvedttddtvdenucfhrhhomheptehnughrvgihucgkhhhunhgvvhcuoegrqdhjsegrqdhjrdhruheqnecuffhomhgrihhnpehgnhhurdhorhhgnecukfhppedujeekrddugedtrddutddruddtjeenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplgdujedvrddvfedrtddrudefudgnpdhinhgvthepudejkedrudegtddruddtrddutdejpdhrvghtuhhrnhdqphgrthhhpeetnhgurhgvhicukghhuhhnvghvuceorgdqjhesrgdqjhdrrhhuqedpmhgrihhlfhhrohhmpegrqdhjsegrqdhjrdhruhdpnhhrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Wednesday, July 10, 2019, 5:23:41 PM, you wrote:



> On 7/10/19 8:58 AM, Andrey Zhunev wrote:
>> Wednesday, July 10, 2019, 4:26:14 PM, you wrote:
>> 
>>> On 7/10/19 4:56 AM, Andrey Zhunev wrote:
>>>> Hello All,
>>>>
>>>> I am struggling to recover my system after a PSU failure, and I was
>>>> suggested to ask here for support.
>>>>
>>>> One of the hard drives throws some read errors, and that happen to be
>>>> my root drive...
>>>> My system is CentOS 7, and the root partition is a part of LVM.
>>>>
>>>> [root@mgmt ~]# lvscan
>>>>   ACTIVE            '/dev/centos/root' [<98.83 GiB] inherit
>>>>   ACTIVE            '/dev/centos/home' [<638.31 GiB] inherit
>>>>   ACTIVE            '/dev/centos/swap' [<7.52 GiB] inherit
>>>> [root@mgmt ~]#
>>>>
>>>> [root@tftp ~]# file -s /dev/centos/root
>>>> /dev/centos/root: symbolic link to `../dm-3'
>>>> [root@tftp ~]# file -s /dev/centos/home
>>>> /dev/centos/home: symbolic link to `../dm-4'
>>>> [root@tftp ~]# file -s /dev/dm-3
>>>> /dev/dm-3: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)
>>>> [root@tftp ~]# file -s /dev/dm-4
>>>> /dev/dm-4: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)
>>>>
>>>>
>>>> [root@tftp ~]# xfs_repair /dev/centos/root
>>>> Phase 1 - find and verify superblock...
>>>> superblock read failed, offset 53057945600, size 131072, ag 2, rval -1
>>>>
>>>> fatal error -- Input/output error
>> 
>>> look at dmesg, see what the kernel says about the read failure.
>> 
>>> You might be able to use https://www.gnu.org/software/ddrescue/ 
>>> to read as many sectors off the device into an image file as possible,
>>> and that image might be enough to work with for recovery.  That would be
>>> my first approach:
>> 
>>> 1) use dd-rescue to create an image file of the device
>>> 2) make a copy of that image file
>>> 3) run xfs_repair -n on the copy to see what it would do
>>> 4) if that looks reasonable run xfs_repair on the copy
>>> 5) mount the copy and see what you get
>> 
>>> But if your drive simply cannot be read at all, this is not a filesystem
>>> problem, it is a hardware problem. If this is critical data you may wish
>>> to hire a data recovery service.
>> 
>>> -Eric
>> 
>> 
>> Hi Eric,
>> 
>> Thanks for your message!
>> I already started to copy the failing drive with ddrescue. This is a
>> large drive, so it takes some time to complete...
>> 
>> When I tried to run xfs_repair on the original (failing) drive, the
>> xfs_repair was unable to read the superblock and then just quitted
>> with an 'io error'.
>> Do you think it can behave differently on a copied image ?

> As I said, look at dmesg to see what failed on the original drive read
> attempt.

> ddrescue will fill unreadable sectors with 0, and then of course that
> can be read from the image file.


Ooops, I forgot to paste the error message from dmesg.
Here it is:

Jul 10 11:48:05 mgmt kernel: ata1.00: exception Emask 0x0 SAct 0x180000 SErr 0x0 action 0x0
Jul 10 11:48:05 mgmt kernel: ata1.00: irq_stat 0x40000008
Jul 10 11:48:05 mgmt kernel: ata1.00: failed command: READ FPDMA QUEUED
Jul 10 11:48:05 mgmt kernel: ata1.00: cmd 60/00:98:28:ac:3e/01:00:03:00:00/40 tag 19 ncq 131072 in#012         res 41/40:00:08:ad:3e/00:00:03:00:00/40 Emask 0x409 (media error) <F>
Jul 10 11:48:05 mgmt kernel: ata1.00: status: { DRDY ERR }
Jul 10 11:48:05 mgmt kernel: ata1.00: error: { UNC }
Jul 10 11:48:05 mgmt kernel: ata1.00: configured for UDMA/133
Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 Sense Key : Medium Error [current] [descriptor]
Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 Add. Sense: Unrecovered read error - auto reallocate failed
Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 CDB: Read(16) 88 00 00 00 00 00 03 3e ac 28 00 00 01 00 00 00
Jul 10 11:48:05 mgmt kernel: blk_update_request: I/O error, dev sda, sector 54439176
Jul 10 11:48:05 mgmt kernel: ata1: EH complete

There are several of these.
At the moment ddrescue reports 22 read errors (with 35% of the data
copied to a new storage). If I remember correctly, the LVM with my
root partition is at the end of the drive. This means more errors will
likely come... :( 

The way I interpret the dmesg message, that's just a read error. I'm
not sure, but maybe a complete wipe of the drive will even overwrite /
clear these unreadable sectors.
Well, that's something to be checked after the copy process finishes.


---
Best regards,
 Andrey

