Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2229664B4F
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Jul 2019 19:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfGJRQe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Jul 2019 13:16:34 -0400
Received: from egyptian.birch.relay.mailchannels.net ([23.83.209.56]:26765
        "EHLO egyptian.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbfGJRQe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 13:16:34 -0400
X-Sender-Id: dreamhost|x-authsender|a-j@a-j.ru
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id BE762501B88;
        Wed, 10 Jul 2019 17:16:32 +0000 (UTC)
Received: from pdx1-sub0-mail-a65.g.dreamhost.com (100-96-14-124.trex.outbound.svc.cluster.local [100.96.14.124])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 536DD502B5C;
        Wed, 10 Jul 2019 17:16:30 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|a-j@a-j.ru
Received: from pdx1-sub0-mail-a65.g.dreamhost.com ([TEMPUNAVAIL].
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.17.3);
        Wed, 10 Jul 2019 17:16:32 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|a-j@a-j.ru
X-MailChannels-Auth-Id: dreamhost
X-Squirrel-Industry: 0c193ef5351648ba_1562778990848_2840090664
X-MC-Loop-Signature: 1562778990848:1220974120
X-MC-Ingress-Time: 1562778990847
Received: from pdx1-sub0-mail-a65.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a65.g.dreamhost.com (Postfix) with ESMTP id 122EA82940;
        Wed, 10 Jul 2019 10:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=a-j.ru; h=date:from
        :message-id:to:cc:subject:in-reply-to:references:mime-version
        :content-type:content-transfer-encoding; s=a-j.ru; bh=VMetsobeuu
        wf5nyfL1gI2JOrqNQ=; b=CFZyHJer9Q+AR78DHf2k5n9rUb3omzUuyrhI9BPkpz
        bD1+NjIzzw184/u85xsBdN4bPmDw5J1UrlbhU/r7swEiu8OwmEKhOgACQ22cg64r
        +LgBB3KqfH0xQFFOB2EGQrz0VrzewuFX7a+qC0hR3SOKlQpBMEb6PWXyTOimTuS0
        M=
Received: from [172.23.0.131] (broadband-178-140-10-107.ip.moscow.rt.ru [178.140.10.107])
        (using TLSv1.1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: a-j@a-j.ru)
        by pdx1-sub0-mail-a65.g.dreamhost.com (Postfix) with ESMTPSA id 09EE082A4E;
        Wed, 10 Jul 2019 10:16:22 -0700 (PDT)
Date:   Wed, 10 Jul 2019 20:16:14 +0300
X-DH-BACKEND: pdx1-sub0-mail-a65
From:   Andrey Zhunev <a-j@a-j.ru>
Message-ID: <816157686.20190710201614@a-j.ru>
To:     Chris Murphy <lists@colorremedies.com>
CC:     xfs list <linux-xfs@vger.kernel.org>
Subject: Re: Need help to recover root filesystem after a power supply issue
In-Reply-To: <CAJCQCtQn17ktjatXU5vvFjfsfEJx8EDrq1+b8+O1yvAf7ij96w@mail.gmail.com>
References: <958316946.20190710124710@a-j.ru> 
  <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
  <1373677058.20190710182851@a-j.ru>
  <CAJCQCtSpkAS086zSDCfB1jMQXZuacfE-SfyqQ2td4Ven4GwAzg@mail.gmail.com>
  <1015034894.20190710190746@a-j.ru>
  <CAJCQCtSTPaor-Wo6b1NF3QT_Pi2rO7B9QMbfudZS=9TEt-Oemw@mail.gmail.com>
  <CAJCQCtQn17ktjatXU5vvFjfsfEJx8EDrq1+b8+O1yvAf7ij96w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 0
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddrgeeigdduudefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucenucfjughrpeffhffkvffujghfgggtgfesthhqvedttddtjeenucfhrhhomheptehnughrvgihucgkhhhunhgvvhcuoegrqdhjsegrqdhjrdhruheqnecukfhppedujeekrddugedtrddutddruddtjeenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplgdujedvrddvfedrtddrudefudgnpdhinhgvthepudejkedrudegtddruddtrddutdejpdhrvghtuhhrnhdqphgrthhhpeetnhgurhgvhicukghhuhhnvghvuceorgdqjhesrgdqjhdrrhhuqedpmhgrihhlfhhrohhmpegrqdhjsegrqdhjrdhruhdpnhhrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Wednesday, July 10, 2019, 7:47:55 PM, you wrote:

> On Wed, Jul 10, 2019 at 10:46 AM Chris Murphy <lists@colorremedies.com> w=
rote:
>>
>> # smartctl -l scterc,900,100
>> # echo 180 > /sys/block/sda/device/timeout


> smartctl command above does need a drive specified...

Indeed! :)

With the commands above, you are increasing the timeout and then fsck
will try to re-read the sectors, right?

As for the SMART status, the number of pending sectors was 0 before.
It started to grow after the PSU incident yesterday. Now, since I'm
doing a ddrescue, all the sectors will be read (or attempted to be
read). So the pending sectors counter may increase further.

As I understand, when a drive cannot READ a sector, the sector is
reported as pending. And it will stay like that until either the
sector is finally read or until it is overwritten. When either of
these happens, the Pending Sector Counter should decrease.
In theory, it can go back to 0 (although I didn't follow this closely
enough, so I never saw a drive like that).

If a drive can't WRITE to a sector, it tries to reallocate it. If it
succeeds, Reallocated Sectors Counter is increased. If it fails to
reallocate - I guess there should be another kind of error or a
counter, but I'm not sure which one.

When reallocated sectors appear - it's clearly a bad sign. If the
number of reallocated sectors grow - the drive should not be used.
But it's not that obvious for the pending sectors...

Anyway, as you noted, the drive isn't new already:


>   9 Power_On_Hours          -O--CK   022   022   000    -    56941
>
> 56941=C3=B78760 =3D 6.5 years ?
>
> Doubtful it's under warranty.


Mmm... yeah... I guess it was one of the early WD30EFRX drives...
This model was launched about 7 years ago, if I'm not mistaken... :)


---
Best regards,
 Andrey

