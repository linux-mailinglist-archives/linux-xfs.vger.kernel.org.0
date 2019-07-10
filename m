Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF4D64AEC
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Jul 2019 18:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfGJQq0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Jul 2019 12:46:26 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:37033 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbfGJQq0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 12:46:26 -0400
Received: by mail-wm1-f41.google.com with SMTP id f17so2974292wme.2
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 09:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lcBorXLN0P4pzTUtG4Ykx4Gkx+U+RsxLk7RfuZpBKsg=;
        b=H/FMneMRQp2Dn6hdhZmtPp8B4q3b+8uh8YM3bRAYX4XI5/UzUmYy7y1k3S1y0TwpDq
         PjLZqpbL0yAMIIgNoIdW0XX2AT8kpCiUMIU3+ZSn64Rlh7EcX4Srt3YQ4MsgJeKIfqkF
         cZvg75JNNyyP7Q1EBL5gOfzr0N3Ik3i+uUAqy7OTkkJgB8vyrpgW6+X72yAyFAEPwBxl
         UlRht+N944bFW9wovy29O3smmZC1rulF6dy2CBlI8WTPMzsDhtfb8ykFUjoRqcxj2qkS
         hkSv1KWUc1lhW3l47NEjitqMOq+JEoYK6900TNfntttMYQ/klDGOUBNRwh9amZOoevl4
         Pm3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lcBorXLN0P4pzTUtG4Ykx4Gkx+U+RsxLk7RfuZpBKsg=;
        b=kupizL6/by9B5xT+WDxXylOUNRtXboqz8Hux4kpTve064tCkj5EkFxlTnQ5k+/qLkW
         smBGI+0JXh68D1ghvhlWmAugkJwKvIk2AeMR88AVsCSJF5Q/R4Y2iHuJyL7Ag3+qZ76B
         uL83xNoj+P/Ruu8m6ziAjqeusILw/2tY7C4TNmgbjxD3qf2evgC1tCrFL9IF2m62/pva
         7qU3AEXzrdOHtXloIX8HRebX0XHVC20+qEPPChegGh/vdK021J2gH0tB0LmS8jblRur9
         GfoHG/F/D+TTAp+IIQyyEkPW9Kt/3G00l0mAT2N/fQ1RSEJPJb4D28HkLGp1Ds26A9H9
         cbOw==
X-Gm-Message-State: APjAAAUxtKwBOAJb+7IjKnZlCDYeBcXZiq/X50o+BeiNwgRBzzJc7PUC
        usigUwOX4/N9Ljk5K2JaQ3ztJSFT1dfevKHrN2ot6nM9EyCyaA==
X-Google-Smtp-Source: APXvYqzqr3QZB+mWaVGz0DAa03xEDil8iRNYmpW9ArF1sTTSueWG3iMLb5YD9EQH03ZRMrij7IgIfh8ZRN0ktKJXQXw=
X-Received: by 2002:a1c:a997:: with SMTP id s145mr6081222wme.106.1562777183881;
 Wed, 10 Jul 2019 09:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <958316946.20190710124710@a-j.ru> <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
 <1373677058.20190710182851@a-j.ru> <CAJCQCtSpkAS086zSDCfB1jMQXZuacfE-SfyqQ2td4Ven4GwAzg@mail.gmail.com>
 <1015034894.20190710190746@a-j.ru>
In-Reply-To: <1015034894.20190710190746@a-j.ru>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 10 Jul 2019 10:46:12 -0600
Message-ID: <CAJCQCtSTPaor-Wo6b1NF3QT_Pi2rO7B9QMbfudZS=9TEt-Oemw@mail.gmail.com>
Subject: Re: Need help to recover root filesystem after a power supply issue
To:     Andrey Zhunev <a-j@a-j.ru>
Cc:     Chris Murphy <lists@colorremedies.com>,
        xfs list <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 10, 2019 at 10:08 AM Andrey Zhunev <a-j@a-j.ru> wrote:
>
>
> Wednesday, July 10, 2019, 6:45:28 PM, you wrote:
>
> > On Wed, Jul 10, 2019 at 9:29 AM Andrey Zhunev <a-j@a-j.ru> wrote:
> >>
> >> Well, this machine is always online (24/7, with a UPS backup power).
> >> Yesterday we found it switched OFF, without any signs of life. Trying
> >> to switch it on, the PSU made a humming noise and the machine didn't
> >> even try to start. So we replaced the PSU. After that, the machine
> >> powered on - but refused to boot... Something tells me these two
> >> failures are likely related...
>
> > Most likely the drive is dying and the spin down from power failure
> > and subsequent spin up has increased the rate of degradation, and
> > that's why they seem related.
>
> > What do you get for:
>
> > # smarctl -x /dev/sda
>
>
> The '-x' option gives a lot of output.
> It's pasted here: https://pastebin.com/raw/yW3yDuSF

197 Current_Pending_Sector  -O--CK   200   200   000    -    68


> Well, if there are evidnces the drive is really dying - so be it...
> I just need to recover the data, if possible.
> On the other hand, if the drive will work further - I will find some
> unimportant files to store...

I think 68 pending sectors is excessive and I'd plan to have the drive
replaced under warranty, or demote it to something you don't care
about. Chances are this is going to get worse. I don't know how many
reserve sectors drives have, I don't even have a guess. But I have
seen drives run out of reserve sectors, at which point you start to
see write failures because LBA's can't be remapped from a bad sector
that fails writes, to a good one. At that point, the drive is
untenable.

Anyway, it's a bit tedious to fix 68 sectors manually, so if you have
the time to just wait for it, try this:


# smartctl -l scterc,900,100
# echo 180 > /sys/block/sda/device/timeout

And now try to fsck.

If it fails with i/o very quickly, as in less than 90 seconds, then
that means the drive firmware has concluded deep recovery won't matter
and is pretty much immediately giving up. At that point, those sectors
are lost. You could overwrite those sectors one by one with zeros and
maybe an xfs_repair will have enough information it can reconstruct
and repair things well enough to copy data off. But you'll have to be
suspicious of every file, as anyone of them could have been silently
corrupted - either bad ECC reconstruction by drive firmware or from
overwriting with zeros.

I'd say there's a decent chance of recovery but it will be tedious.

If it seems like the system is hanging without errors, that's actually
a good sign deep recovery is working. But like I said, it could take
hours. And then in the end it might still find a totally unrecoverable
sector.


-- 
Chris Murphy
