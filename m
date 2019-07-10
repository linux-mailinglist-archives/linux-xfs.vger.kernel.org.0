Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9295A647B1
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Jul 2019 15:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbfGJN6z (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Jul 2019 09:58:55 -0400
Received: from egyptian.birch.relay.mailchannels.net ([23.83.209.56]:5658 "EHLO
        egyptian.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726080AbfGJN6y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 09:58:54 -0400
X-Sender-Id: dreamhost|x-authsender|a-j@a-j.ru
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 4EE542C22ED;
        Wed, 10 Jul 2019 13:58:52 +0000 (UTC)
Received: from pdx1-sub0-mail-a65.g.dreamhost.com (100-96-1-113.trex.outbound.svc.cluster.local [100.96.1.113])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 8A9862C2318;
        Wed, 10 Jul 2019 13:58:51 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|a-j@a-j.ru
Received: from pdx1-sub0-mail-a65.g.dreamhost.com ([TEMPUNAVAIL].
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.17.3);
        Wed, 10 Jul 2019 13:58:52 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|a-j@a-j.ru
X-MailChannels-Auth-Id: dreamhost
X-Illegal-Sponge: 67986d5d710bfe12_1562767132023_377756906
X-MC-Loop-Signature: 1562767132023:956182353
X-MC-Ingress-Time: 1562767132023
Received: from pdx1-sub0-mail-a65.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a65.g.dreamhost.com (Postfix) with ESMTP id B5C9D829B3;
        Wed, 10 Jul 2019 06:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=a-j.ru; h=date:from
        :message-id:to:subject:in-reply-to:references:mime-version
        :content-type:content-transfer-encoding; s=a-j.ru; bh=h3odq4QWoK
        574kP+F+pqQTu/rx0=; b=GgmQNpoFaBoTFKgnncayS53qeCck0eyjcVaKpH3oUJ
        QX5n45RzkpODj5LCCt/bxSGpYcpoWaoaX6vSrQGXzQjFQoRcl+PWxiI70QupoiSj
        NkhMwj0VAViSJ7/Gbvu86KaHj2GRc8IihY58KchH7tgR5DvaZDSFFaDyolihNCVl
        k=
Received: from [172.23.0.131] (broadband-178-140-10-107.ip.moscow.rt.ru [178.140.10.107])
        (using TLSv1.1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: a-j@a-j.ru)
        by pdx1-sub0-mail-a65.g.dreamhost.com (Postfix) with ESMTPSA id 26B4E82089;
        Wed, 10 Jul 2019 06:58:48 -0700 (PDT)
Date:   Wed, 10 Jul 2019 16:58:41 +0300
X-DH-BACKEND: pdx1-sub0-mail-a65
From:   Andrey Zhunev <a-j@a-j.ru>
Message-ID: <433120592.20190710165841@a-j.ru>
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: Need help to recover root filesystem after a power supply issue
In-Reply-To: <fcbcd66e-0c78-f13b-e7aa-1487090d1dfd@sandeen.net>
References: <871210488.20190710125617@a-j.ru> <fcbcd66e-0c78-f13b-e7aa-1487090d1dfd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -100
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddrgeeigdejvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffkvffujghfgggtgfesthejvedttddtvdenucfhrhhomheptehnughrvgihucgkhhhunhgvvhcuoegrqdhjsegrqdhjrdhruheqnecuffhomhgrihhnpehgnhhurdhorhhgnecukfhppedujeekrddugedtrddutddruddtjeenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplgdujedvrddvfedrtddrudefudgnpdhinhgvthepudejkedrudegtddruddtrddutdejpdhrvghtuhhrnhdqphgrthhhpeetnhgurhgvhicukghhuhhnvghvuceorgdqjhesrgdqjhdrrhhuqedpmhgrihhlfhhrohhmpegrqdhjsegrqdhjrdhruhdpnhhrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Wednesday, July 10, 2019, 4:26:14 PM, you wrote:

> On 7/10/19 4:56 AM, Andrey Zhunev wrote:
>> Hello All,
>> 
>> I am struggling to recover my system after a PSU failure, and I was
>> suggested to ask here for support.
>> 
>> One of the hard drives throws some read errors, and that happen to be
>> my root drive...
>> My system is CentOS 7, and the root partition is a part of LVM.
>> 
>> [root@mgmt ~]# lvscan
>>   ACTIVE            '/dev/centos/root' [<98.83 GiB] inherit
>>   ACTIVE            '/dev/centos/home' [<638.31 GiB] inherit
>>   ACTIVE            '/dev/centos/swap' [<7.52 GiB] inherit
>> [root@mgmt ~]#
>> 
>> [root@tftp ~]# file -s /dev/centos/root
>> /dev/centos/root: symbolic link to `../dm-3'
>> [root@tftp ~]# file -s /dev/centos/home
>> /dev/centos/home: symbolic link to `../dm-4'
>> [root@tftp ~]# file -s /dev/dm-3
>> /dev/dm-3: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)
>> [root@tftp ~]# file -s /dev/dm-4
>> /dev/dm-4: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)
>> 
>> 
>> [root@tftp ~]# xfs_repair /dev/centos/root
>> Phase 1 - find and verify superblock...
>> superblock read failed, offset 53057945600, size 131072, ag 2, rval -1
>> 
>> fatal error -- Input/output error

> look at dmesg, see what the kernel says about the read failure.

> You might be able to use https://www.gnu.org/software/ddrescue/ 
> to read as many sectors off the device into an image file as possible,
> and that image might be enough to work with for recovery.  That would be
> my first approach:

> 1) use dd-rescue to create an image file of the device
> 2) make a copy of that image file
> 3) run xfs_repair -n on the copy to see what it would do
> 4) if that looks reasonable run xfs_repair on the copy
> 5) mount the copy and see what you get

> But if your drive simply cannot be read at all, this is not a filesystem
> problem, it is a hardware problem. If this is critical data you may wish
> to hire a data recovery service.

> -Eric


Hi Eric,

Thanks for your message!
I already started to copy the failing drive with ddrescue. This is a
large drive, so it takes some time to complete...

When I tried to run xfs_repair on the original (failing) drive, the
xfs_repair was unable to read the superblock and then just quitted
with an 'io error'.
Do you think it can behave differently on a copied image ?

I will definitely give it a try once the ddrescue finishes.


P.S. The data on this drive is not THAT critical to hire a
professional data recovery service. Still, there are some files I
would really like to restore (mostly settings and configuration
files - nothing large, but important)... This will save me weeks to
reconfigure and get the system back to its original state...
Backups, always make backups... yeah, I know... :(


 ---
 Best regards,
  Andrey

