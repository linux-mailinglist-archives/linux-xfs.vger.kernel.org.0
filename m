Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7489E451E2
	for <lists+linux-xfs@lfdr.de>; Fri, 14 Jun 2019 04:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfFNCbC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 22:31:02 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:36343 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfFNCbB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 22:31:01 -0400
Received: by mail-lj1-f177.google.com with SMTP id i21so752879ljj.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 19:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=54SzfXIM0CUZELnkDPId2LFnAOP2eMm66mZYeVaiMIc=;
        b=b6wus35DaLhs8FFeq7PNRZ3hYyz4oMdypJnhTcMZaFiSx3caRk6yJHOkFLmXfc68gQ
         FYnDbGsYmvinxpLwPoM2+Xa2pga+BkCWG8bI9aaj+MagRJ3SZ/YT13ZFs5CQZvlGQwk+
         z315q1qxQWAhXJ4qm5Fc+0jzeL3t3lDjn2XKM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=54SzfXIM0CUZELnkDPId2LFnAOP2eMm66mZYeVaiMIc=;
        b=o2uB+odRLA9WEcf5likOBRoUxGoz3lye1H6wJ1RFFFFLyaRpghbYnsWIypRY3YofwI
         7/B2H2rIbsf10UninuCopJA5K3WEeTW4V4Ofg8NFH45GkMQcUnSY0XfSd+VLCDjABAS1
         5db8/u0x29vI1sT95T/R4m8EgmFUe3Nqne2otmb1m3tZycfjwe+X3ewMSQinR/L8S1ti
         AYShMGPcMh+AFqY0DEqFjQdCR2ciNO0DREGekhz9q656YtGQ7iqgqCk2H7zuBeEzmAoT
         u1+bB5P8r0yWj/PWXsrS1pgVk+F4EAcjyXWh4pQthzAdpzFWYpGWZqe2N0kQPrDeYmmX
         4aSg==
X-Gm-Message-State: APjAAAVwhcRTUWkkuma9GJCjTj8WCG7wSv0liruzBy34T69CZWeIfiQB
        fnxojmhkd8Bbznub0hWzT+U1tvGOWGg=
X-Google-Smtp-Source: APXvYqxd5wDMwkKr0b0D24xxDYTmDieuTS+J9RKhkX6oqgiI7MY9Yol5snKAP1oQsijAgsacCKHrjw==
X-Received: by 2002:a2e:298a:: with SMTP id p10mr19876050ljp.74.1560479459198;
        Thu, 13 Jun 2019 19:30:59 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id c19sm243945lfi.39.2019.06.13.19.30.58
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 19:30:58 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id p17so765848ljg.1
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 19:30:58 -0700 (PDT)
X-Received: by 2002:a2e:9ec9:: with SMTP id h9mr11450885ljk.90.1560479452914;
 Thu, 13 Jun 2019 19:30:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611011737.GA28701@kmo-pixel> <20190611043336.GB14363@dread.disaster.area>
 <20190612162144.GA7619@kmo-pixel> <20190612230224.GJ14308@dread.disaster.area>
 <20190613183625.GA28171@kmo-pixel> <20190613235524.GK14363@dread.disaster.area>
In-Reply-To: <20190613235524.GK14363@dread.disaster.area>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 13 Jun 2019 16:30:36 -1000
X-Gmail-Original-Message-ID: <CAHk-=wj3SQjfHHvE_CNrQAYS2p7bsC=OXEc156cHA_ujyaG0NA@mail.gmail.com>
Message-ID: <CAHk-=wj3SQjfHHvE_CNrQAYS2p7bsC=OXEc156cHA_ujyaG0NA@mail.gmail.com>
Subject: Re: pagecache locking (was: bcachefs status update) merged)
To:     Dave Chinner <david@fromorbit.com>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 13, 2019 at 1:56 PM Dave Chinner <david@fromorbit.com> wrote:
>
> That said, the page cache is still far, far slower than direct IO,

Bullshit, Dave.

You've made that claim before, and it's been complete bullshit before
too, and I've called you out on it then too.

Why do you continue to make this obviously garbage argument?

The key word in the "page cache" name is "cache".

Caches work, Dave. Anybody who thinks caches don't work is
incompetent. 99% of all filesystem accesses are cached, and they never
do any IO at all, and the page cache handles them beautifully.

When you say that the page cache is slower than direct IO, it's
because you don't even see or care about the *fast* case. You only get
involved once there is actual IO to be done.

So you're making that statement without taking into account all the
cases that you don't see, and that you don't care about, because the
page cache has already handled them for you, and done so much better
than DIO can do or ever _will_ do.

Is direct IO faster when you *know* it's not cached, and shouldn't be
cached? Sure. But that/s actually quite rare.

How often do you use non-temporal stores when you do non-IO
programming? Approximately never, perhaps? Because caches work.

And no, SSD's haven't made caches irrelevant. Not doing IO at all is
still orders of magnitude faster than doing IO. And it's not clear
nvdimms will either.

So stop with the stupid and dishonest argument already, where you
ignore the effects of caching.

                Linus
