Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12960649F5
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Jul 2019 17:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfGJPpm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Jul 2019 11:45:42 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43740 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727616AbfGJPpl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 11:45:41 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so2979077wru.10
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 08:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sIip4+6N0s055OeQjkszWsxeziBGrh2ICQC7CAsXcu0=;
        b=hJO2E8DrNApEgzhsFzy86b9D4wZr5Rg7Tpwz+27h+/U5QvdsviM+S4rf8xFYWSaKHL
         gcHlw6hjpAff1YS8O7nqx3MgTKE3r6mhPWCJnw2ew5186PNQSml5XGGEPZMJ2QZdgu23
         d4MIMpGGatPppxqRY2c45rJg2jOAM33ze+ZdRaUzhamhNyb9igWgEQh1TpjPQMjqfmEr
         BTEX9UhTD5sdCsmTLweOIYqqIJEZ2EkyKALjQCM0vzatvINSE221blIkb5GdOZa8FViq
         LxGPe2lrG7q7T1hOXkC49NPVOadYK1XlWKn4tVeZxSQGhUN8ASX9jeBab3kU4Kb0+7Uu
         tzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sIip4+6N0s055OeQjkszWsxeziBGrh2ICQC7CAsXcu0=;
        b=Jt+FKSlGFLEbbO23CpH8d3OeKULYMqL+t/WtSFA2OoPFlVmXkTQ/SAISP34HinowIF
         F63I+gUVdjKizkZkSwauEN4Asoq+joSZHujjSYKK5h18Jt+cC3yLnJdnWwLICz0xc4/n
         0MbVhF2bv4S7cFj7szA7cTGIZpcQWO40Oc9icECcLX+/Wt5SNBSDI8XWII/PX7FTCmeX
         7K2xVjWcuw3tsLlsR33MrLWg9e15QlQF7xLY5+YjrLwbUH9Abz4cFcvNjW5XqTJsYHXJ
         ysfwaJ+ugugEy+Ednj9WS5F0F7n5zNttgttq6AwaW0BdTMWR0WbPNHbv0hqWcdE8HK34
         IThQ==
X-Gm-Message-State: APjAAAWwEXWHNYT81WOzIRrZGS4bBzGmHf1SqNC4t6/UonpizvhjDbK+
        PckNEn4XaK6ktSl60aK1dfdW1cJcb5V0XlMJr+HU5g==
X-Google-Smtp-Source: APXvYqwocxz6hIu8PZw1E9xsM5NP+WqUzEEYSOZ6ki2bArmLYaN3U2n7GA7Mc0k7B+gvfHS6DtcX2A/zAckovyy/+A4=
X-Received: by 2002:a5d:4403:: with SMTP id z3mr32857238wrq.29.1562773539411;
 Wed, 10 Jul 2019 08:45:39 -0700 (PDT)
MIME-Version: 1.0
References: <958316946.20190710124710@a-j.ru> <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
 <1373677058.20190710182851@a-j.ru>
In-Reply-To: <1373677058.20190710182851@a-j.ru>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 10 Jul 2019 09:45:28 -0600
Message-ID: <CAJCQCtSpkAS086zSDCfB1jMQXZuacfE-SfyqQ2td4Ven4GwAzg@mail.gmail.com>
Subject: Re: Need help to recover root filesystem after a power supply issue
To:     Andrey Zhunev <a-j@a-j.ru>
Cc:     Chris Murphy <lists@colorremedies.com>,
        xfs list <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 10, 2019 at 9:29 AM Andrey Zhunev <a-j@a-j.ru> wrote:
>
> Well, this machine is always online (24/7, with a UPS backup power).
> Yesterday we found it switched OFF, without any signs of life. Trying
> to switch it on, the PSU made a humming noise and the machine didn't
> even try to start. So we replaced the PSU. After that, the machine
> powered on - but refused to boot... Something tells me these two
> failures are likely related...

Most likely the drive is dying and the spin down from power failure
and subsequent spin up has increased the rate of degradation, and
that's why they seem related.

What do you get for:

# smarctl -x /dev/sda



>
>
>
> # smartctl -l scterc /dev/sda
> smartctl 6.5 2016-05-07 r4318 [x86_64-linux-3.10.0-957.el7.x86_64] (local build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org
>
> SCT Error Recovery Control:
>            Read:     70 (7.0 seconds)
>           Write:     70 (7.0 seconds)

Good news. This can be raised by a ton and maybe you'll recover the
bad sectors. You need to do two things. You might have to iterate some
of this because I don't know what the max SCT ERC value is for this
make/model drive. Consumer drives can have really high values, upwards
of three minutes, which is ridiculous but off topic. I'd like to think
60 seconds would be enough and also below whatever cap the drive
firmware has. Also, I've had drive firmware crash when issuing
multiple SCT ERC changes - so if the drive starts doing new crazy
things, we're not going to know if it's a firmware bug or more likely
if the drive is continuing to degrade.

I would shoot for a 90 second SCT ERC for reads, and hopefully that's
long enough and also isn't above the max value for this make/model.

# smartctl -l scterc,900,100

And next, raise the kernel's command timer into the stratosphere so
that it won't get mad and do a link reset if the drive takes a long
time to recover.

# echo 180 > /sys/block/sda/device/timeout

In this configuration, it's possible every single read command for a
(marginally) bad sector will take 90 seconds. So if you have a bunch
of these, an fsck might take hours. So that's not necessarily how I
would do it. Best to see the smartctl -x to have some idea how many
bad sectors there might be.



>
> #
>
> This is a WD RED series drive, WD30EFRX.

Yeah this is a NAS drive, and this low 70 decisecond value is meant
for RAID. It's a suboptimal value if you're using it for a boot drive.
But deal with that later after recovery.

>Jul 10 11:48:05 mgmt kernel: blk_update_request: I/O error, dev sda, sector 54439176

> Jul 10 11:59:03 mgmt kernel: blk_update_request: I/O error, dev sda, sector 176473048
> Jul 10 11:59:05 mgmt kernel: blk_update_request: I/O error, dev sda, sector 176473048

So at least two bad sectors and they aren't anywhere near each other.
The smartctl -x command might give us an idea how bad the drive is.
Anyway, these drives have decent warranties, but they're going to want
the drive returned to them. So if there's anything sensitive on it and
it's not encrypted  you'll want it still working long enough to wipe
it.



-- 
Chris Murphy
