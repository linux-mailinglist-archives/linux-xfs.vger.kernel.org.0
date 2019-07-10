Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28EAB64A79
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Jul 2019 18:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbfGJQIB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Jul 2019 12:08:01 -0400
Received: from bonobo.elm.relay.mailchannels.net ([23.83.212.22]:4646 "EHLO
        bonobo.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728107AbfGJQIB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 12:08:01 -0400
X-Sender-Id: dreamhost|x-authsender|a-j@a-j.ru
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 2CE1B501DBA;
        Wed, 10 Jul 2019 16:07:59 +0000 (UTC)
Received: from pdx1-sub0-mail-a65.g.dreamhost.com (100-96-4-184.trex.outbound.svc.cluster.local [100.96.4.184])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 639AD5027CF;
        Wed, 10 Jul 2019 16:07:58 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|a-j@a-j.ru
Received: from pdx1-sub0-mail-a65.g.dreamhost.com ([TEMPUNAVAIL].
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.17.3);
        Wed, 10 Jul 2019 16:07:59 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|a-j@a-j.ru
X-MailChannels-Auth-Id: dreamhost
X-Harmony-Chemical: 3cb42e831faac19f_1562774878951_471072464
X-MC-Loop-Signature: 1562774878951:824787210
X-MC-Ingress-Time: 1562774878950
Received: from pdx1-sub0-mail-a65.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a65.g.dreamhost.com (Postfix) with ESMTP id 551B782A2B;
        Wed, 10 Jul 2019 09:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=a-j.ru; h=date:from
        :message-id:to:cc:subject:in-reply-to:references:mime-version
        :content-type:content-transfer-encoding; s=a-j.ru; bh=MjpoBHwa7e
        FxUO+h0SKBaxCAPj0=; b=WRZy67SHxDvAYRB9tEnAYpKbAKysUeJV8DhUuhx6e/
        vm3DpUYFfnVj47x0rPqarG5gB31DDz2J9uicFCwUseydgVPTLkYIZ+LROWmCH2ub
        9hNCRsBNCuT19opx2gxzPL59U3vjU4lDZ1NWp3T+Zxgjjt1aq+xLPL5i/xWRId+p
        Q=
Received: from [172.23.0.131] (broadband-178-140-10-107.ip.moscow.rt.ru [178.140.10.107])
        (using TLSv1.1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: a-j@a-j.ru)
        by pdx1-sub0-mail-a65.g.dreamhost.com (Postfix) with ESMTPSA id 4699D82A3E;
        Wed, 10 Jul 2019 09:07:53 -0700 (PDT)
Date:   Wed, 10 Jul 2019 19:07:46 +0300
X-DH-BACKEND: pdx1-sub0-mail-a65
From:   Andrey Zhunev <a-j@a-j.ru>
Message-ID: <1015034894.20190710190746@a-j.ru>
To:     Chris Murphy <lists@colorremedies.com>
CC:     xfs list <linux-xfs@vger.kernel.org>
Subject: Re: Need help to recover root filesystem after a power supply issue
In-Reply-To: <CAJCQCtSpkAS086zSDCfB1jMQXZuacfE-SfyqQ2td4Ven4GwAzg@mail.gmail.com>
References: <958316946.20190710124710@a-j.ru> 
  <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
  <1373677058.20190710182851@a-j.ru>
  <CAJCQCtSpkAS086zSDCfB1jMQXZuacfE-SfyqQ2td4Ven4GwAzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 0
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddrgeeigdellecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhkffvufgjfhggtgfgsehtjeevtddttddvnecuhfhrohhmpeetnhgurhgvhicukghhuhhnvghvuceorgdqjhesrgdqjhdrrhhuqeenucffohhmrghinhepphgrshhtvggsihhnrdgtohhmnecukfhppedujeekrddugedtrddutddruddtjeenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplgdujedvrddvfedrtddrudefudgnpdhinhgvthepudejkedrudegtddruddtrddutdejpdhrvghtuhhrnhdqphgrthhhpeetnhgurhgvhicukghhuhhnvghvuceorgdqjhesrgdqjhdrrhhuqedpmhgrihhlfhhrohhmpegrqdhjsegrqdhjrdhruhdpnhhrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Wednesday, July 10, 2019, 6:45:28 PM, you wrote:

> On Wed, Jul 10, 2019 at 9:29 AM Andrey Zhunev <a-j@a-j.ru> wrote:
>>
>> Well, this machine is always online (24/7, with a UPS backup power).
>> Yesterday we found it switched OFF, without any signs of life. Trying
>> to switch it on, the PSU made a humming noise and the machine didn't
>> even try to start. So we replaced the PSU. After that, the machine
>> powered on - but refused to boot... Something tells me these two
>> failures are likely related...

> Most likely the drive is dying and the spin down from power failure
> and subsequent spin up has increased the rate of degradation, and
> that's why they seem related.

> What do you get for:

> # smarctl -x /dev/sda


The '-x' option gives a lot of output.
It's pasted here: https://pastebin.com/raw/yW3yDuSF


Well, if there are evidnces the drive is really dying - so be it...
I just need to recover the data, if possible.
On the other hand, if the drive will work further - I will find some
unimportant files to store...


---
Best regards,
 Andrey

