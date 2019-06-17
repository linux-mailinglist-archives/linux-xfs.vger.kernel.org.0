Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1054149601
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 01:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfFQXjF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Jun 2019 19:39:05 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:32869 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfFQXjE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jun 2019 19:39:04 -0400
Received: by mail-lj1-f178.google.com with SMTP id h10so11101122ljg.0
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2019 16:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2NrsuK+fQa59Rf3zJAPEk/DpTvNWtzgqr6c6Hq01cwY=;
        b=Im9oEjWyr/vEdz9cgtOyleEhoCBdeVCcp3kWvdMeHXiN7x58vAV8sjEQKDudUFBh8E
         RxS+frlO5CQUO7JQDQ8qkogDUdkU7fmgqa4eHgTl13Zom7kAUMVec5A8Ne1jWBPaYFpa
         rHkCrluVPIkibD3eDmgnHGA9jDsnp0HYN0hFo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2NrsuK+fQa59Rf3zJAPEk/DpTvNWtzgqr6c6Hq01cwY=;
        b=EMWWt33TwlEdSRK384/B4vM80h4Z4XE4bwip2rvIsJyVpHBCfFBDv+6fQn8Ao8B0j8
         Aotu8u7hthaGwyHvXaWm3NYIk/6DGpI9azYM9y10b3yshe0fnXuGhr5kHHLeasi/RLcs
         Isdv7qVvKwnNEgF8TcvQc37CX/dkE5Iiz3XLZNMSgYVzHj48aMNwEKRAH8pzsDX+KO68
         iiZ1r8baCigClTNbozo/RWjruAz4jxCXeYfOQ7SFd+Nq2PXLT7tfG2a4030n8Q7+5fii
         C8WltOnyKbPnO9belVq9DBVN561kz0KlCrbE5hPHYaZw0fUhtC3UaKuCiOVCG7kH7rx5
         Teaw==
X-Gm-Message-State: APjAAAXFEHiYCuTAn5buRKiUi4hM+6kUOPMn0AxeWDmdYy/Yy6weYpmE
        giFHvXUV36vDjGEO6H0F7Fh+g+lJ94Y=
X-Google-Smtp-Source: APXvYqzvjVsqtIdxorBKI+vR/egeQuuiM/5uapGs8Tw2YFzpb+OY1yhWfS8svQRGQ+1ZrlCmwWMnKQ==
X-Received: by 2002:a2e:9dd7:: with SMTP id x23mr28812424ljj.160.1560814742040;
        Mon, 17 Jun 2019 16:39:02 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id l25sm1959603lfk.57.2019.06.17.16.39.00
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 16:39:01 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id z15so7798177lfh.13
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2019 16:39:00 -0700 (PDT)
X-Received: by 2002:a19:f808:: with SMTP id a8mr3385678lff.29.1560814740667;
 Mon, 17 Jun 2019 16:39:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611011737.GA28701@kmo-pixel> <20190611043336.GB14363@dread.disaster.area>
 <20190612162144.GA7619@kmo-pixel> <20190612230224.GJ14308@dread.disaster.area>
 <20190613183625.GA28171@kmo-pixel> <20190613235524.GK14363@dread.disaster.area>
 <CAHk-=whMHtg62J2KDKnyOTaoLs9GxcNz1hN9QKqpxoO=0bJqdQ@mail.gmail.com>
 <CAHk-=wgz+7O0pdn8Wfxc5EQKNy44FTtf4LAPO1WgCidNjxbWzg@mail.gmail.com> <20190617224714.GR14363@dread.disaster.area>
In-Reply-To: <20190617224714.GR14363@dread.disaster.area>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 17 Jun 2019 16:38:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiR3a7+b0cUN45hGp1dvFh=s1i1OkVhoP7CivJxKqsLFQ@mail.gmail.com>
Message-ID: <CAHk-=wiR3a7+b0cUN45hGp1dvFh=s1i1OkVhoP7CivJxKqsLFQ@mail.gmail.com>
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

On Mon, Jun 17, 2019 at 3:48 PM Dave Chinner <david@fromorbit.com> wrote:
>
> The wording of posix changes every time they release a new version
> of the standard, and it's _never_ obvious what behaviour the
> standard is actually meant to define. They are always written with
> sufficient ambiguity and wiggle room that they could mean
> _anything_. The POSIX 2017.1 standard you quoted is quite different
> to older versions, but it's no less ambiguous...

POSIX has always been pretty lax, partly because all the Unixes did
things differently, but partly because it then also ended up about
trying to work for the VMS and Windows posix subsystems..

So yes, the language tends to be intentionally not all that strict.

> > The pthreads atomicity thing seems to be about not splitting up IO and
> > doing it in chunks when you have m:n threading models, but can be
> > (mis-)construed to have threads given higher atomicity guarantees than
> > processes.
>
> Right, but regardless of the spec we have to consider that the
> behaviour of XFS comes from it's Irix heritage (actually from EFS,
> the predecessor of XFS from the late 1980s)

Sure. And as I mentioned, I think it's technically the nicer guarantee.

That said, it's a pretty *expensive* guarantee. It's one that you
yourself are not willing to give for O_DIRECT IO.

And it's not a guarantee that Linux has ever had. In fact, it's not
even something I've ever seen anybody ever depend on.

I agree that it's possible that some app out there might depend on
that kind of guarantee, but I also suspect it's much much more likely
that it's the other way around: XFS is being unnecessarily strict,
because everybody is testing against filesystems that don't actually
give the total atomicity guarantees.

Nobody develops for other unixes any more (and nobody really ever did
it by reading standards papers - even if they had been very explicit).

And honestly, the only people who really do threaded accesses to the same file

 (a) don't want that guarantee in the first place

 (b) are likely to use direct-io that apparently doesn't give that
atomicity guarantee even on xfs

so I do think it's moot.

End result: if we had a really cheap range lock, I think it would be a
good idea to use it (for the whole QoI implementation), but for
practical reasons it's likely better to just stick to the current lack
of serialization because it performs better and nobody really seems to
want anything else anyway.

                  Linus
