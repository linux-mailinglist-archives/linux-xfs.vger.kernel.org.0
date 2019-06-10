Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A593BA15
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Jun 2019 18:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbfFJQzD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jun 2019 12:55:03 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:44575 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727648AbfFJQzD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 12:55:03 -0400
Received: by mail-yw1-f67.google.com with SMTP id m80so4039129ywd.11;
        Mon, 10 Jun 2019 09:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t1D98BCQp6VoZzEiXRjpgcnz+3XDqHqts3ioMrIuUQY=;
        b=VzP9H3LAi+OCAvC4XHlN0K0UeAX+tF+VPwhGWBFw2UVM3zauVNPLp82SJFJm/3DKgh
         7YnXmYqvb+VodKmk+c1ld4h9LGDp9jh9DRYLMT4PVoV5oYyKLuhR9jhJzrrnMzFVJIju
         xThE8GnVTjFGnb7Til0APUxd5UCFtbUrJeYPI4F8ec/6hqvCOKC36wTFTozPIkdxmJY8
         z75S37+BRnt8outfbg6WlFXZ/n681llIQ9SC7SAcR5nOCU5ckQ4LJEvPUidhOYWcEVCw
         PvbL2ULjenlGJTlUjzu06rYLSL4LKeO14ImW09ROCCn/wR248jE0JT5bYf3cj+wQbdKQ
         Pf8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t1D98BCQp6VoZzEiXRjpgcnz+3XDqHqts3ioMrIuUQY=;
        b=nxYJ9LPnJcQd0xPYGk+0uYl9DT2+dRO4QsfIm3UHCcZna/F8BwlMhGLN54hx4rlePw
         0MDlkezr21kE6ppS2FX9f9Cp7uJcdDukTTpYSVsqYo1HIiEd/6IxiktralRlQAo8i7Oy
         HpFz7iO+i7TQt0VbneDfk5X4ZgdK1q7UEyuGFEeiXZLjd4QSjGP1CXEISs/a5e+Mjxto
         q5DiPz++90If3bA54Ce4gImDXp0waLKzK/UoExyv8dO0YP86k9eGd2UYXnOjqnrxyFmg
         O7i5CeIkvQ0GdfixDqu6xvLcnvvjE5TL1cpQLZd7n/5lMz6h9SIW6oK3YDKZMGy8rRnu
         W7IQ==
X-Gm-Message-State: APjAAAV56lxSGtWnRjpHWtEjs7r+sivpyIZ67Zc4ZIuZU6wACKNO4eH4
        fRV0ulFNH131/8I7T1SSDlFVd3DsBrfbvmHnZ/s=
X-Google-Smtp-Source: APXvYqxFpaQ+NjQyvyF/0DJi3vBcWv6UhLhrTw+kVWChSmqixZ1Lv/9PQRFriorhsSjtf1XIv8g6DLyOX9dLOEaffb4=
X-Received: by 2002:a0d:f5c4:: with SMTP id e187mr25328487ywf.88.1560185702769;
 Mon, 10 Jun 2019 09:55:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190602124114.26810-1-amir73il@gmail.com> <20190602124114.26810-4-amir73il@gmail.com>
 <20190610035829.GA18429@mit.edu> <CAOQ4uxi-s6ncLGjh_u5x4DFK+dvcaobDCqup_ZV3mZOYDRuOEQ@mail.gmail.com>
 <20190610133131.GE15963@mit.edu> <20190610160616.GE1688126@magnolia>
In-Reply-To: <20190610160616.GE1688126@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 10 Jun 2019 19:54:52 +0300
Message-ID: <CAOQ4uxiQsOTFO5f_aQWrmbSgSGuOy2wHoJbQAdWHrA1s-pZoHQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] generic: copy_file_range swapfile test
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, Eryu Guan <guaneryu@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 10, 2019 at 7:06 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Mon, Jun 10, 2019 at 09:31:31AM -0400, Theodore Ts'o wrote:
> > On Mon, Jun 10, 2019 at 09:37:32AM +0300, Amir Goldstein wrote:
> > >
> > >Why do you think thhis is xfs_io fall back and not kernel fall back to
> > >do_splice_direct()? Anyway, both cases allow read from swapfile
> > >on upstream.
> >
> > Ah, I had assumed this was changed that was made because if you are
> > implementing copy_file_range in terms of some kind of reflink-like
> > mechanism, it becomes super-messy since you know have to break tons
> > and tons of COW sharing each time the kernel swaps to the swap file.
> >
> > I didn't think we had (or maybe we did, and I missed it) a discussion
> > about whether reading from a swap file should be prohibited.
> > Personally, I think it's security theatre, and not worth the
> > effort/overhead, but whatever.... my main complaint was with the
> > unnecessary test failures with upstream kernels.
> >
> > > Trying to understand the desired flow of tests and fixes.
> > > I agree that generic/554 failure may be a test/interface bug that
> > > we should fix in a way that current upstream passes the test for
> > > ext4. Unless there is objection, I will send a patch to fix the test
> > > to only test copy *to* swapfile.
> > >
> > > generic/553, OTOH, is expected to fail on upstream kernel.
> > > Are you leaving 553 in appliance build in anticipation to upstream fix?
> > > I guess the answer is in the ext4 IS_IMMUTABLE patch that you
> > > posted and plan to push to upstream/stable sooner than VFS patches.
> >
> > So I find it kind of annoying when tests land before the fixes do
> > upstream.  I still have this in my global_exclude file:
>
> Yeah, it's awkward for VFS fixes because on the one hand we don't want
> to have multiyear regressions like generic/484, but OTOH stuffing tests
> in before code goes upstream enables broader testing by the other fs
> maintainers.

And to prove this point, Ted pointed out a test bug in 554, which also
affects the kernel and man pages fixes, so it was really worth it ;-)

>
> In any case, the fixes are in the copy-range-fixes branch which I'm
> finally publishing...
>
> > # The proposed fix for generic/484, "locks: change POSIX lock
> > # ownership on execve when files_struct is displaced" would break NFS
> > # Jeff Layton and Eric Biederman have some ideas for how to address it
> > # but fixing it is non-trivial
>
> Also, uh, can we remove this from the auto and quick groups for now?
>

I am not opposed to removing these test from auto,quick, although removing
from quick is a bit shady. I would like to mark them explicitly with group
known_issues, so that users can run ./check -g quick -x known_issues.
BTW, overlay/061 is also a known_issue that is going to be hard to fix.

But anyway, neither 553 nor 554 fall into that category.

Thanks,
Amir.
