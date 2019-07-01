Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 462AB4999A
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 08:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfFRG5q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 02:57:46 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:38481 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfFRG5q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 02:57:46 -0400
Received: by mail-yw1-f66.google.com with SMTP id k125so6277902ywe.5
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2019 23:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UfxLmve6hN9X4gbIJ4aO5r6R2DUJ67ywGPTkl9WJgj8=;
        b=qpxChYFZjR/Peok1+hZCixgcDyoFAxN9npQcK1dURe5Sy7LW4FnMiV/xniKgwFusBn
         /oInZI+tm7LSA5ps1aOPgSAaDplv5JGuJNh/cPdKgWYTUUzHxfG7SySR51DBj+JKmGCE
         UDCSq0Q+9Ixiuv83vy9ohMTcQJLQRlEyDHbx7J+JRiZPbtHnEupNv0aMUhNE6IDmpQJa
         prgjtNdekSti5EyOea+EdfgX+V8DsaVliT++ZNFE/VxH8ocbyXn4DGuppUPkvYtlAIMt
         Z4SkaXaJMs1vb8W3HZGB6sGxjBOs78pr6FAT0k6lJ9R8Z6L2enZ56CPcyCQAmpGgk2YW
         XMhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UfxLmve6hN9X4gbIJ4aO5r6R2DUJ67ywGPTkl9WJgj8=;
        b=rkrO3WeRUklzsDfRNLm5UJzzU91zC6Oia+DHsyyImVqawuD4+/t48Y+Km9hIlPCgB8
         VdXup2aTB1xuSdE1t8D6cSyAmJ9O+TzEIyYZU5eLenlDWrwidt10BvBrFeSeTqY/BjpS
         LfjgZN5D0JjH40Pr0NZastaRYm3Zr7NWXP26ii1MOpXPiorVM+qgtjOjCnoKwJOgwKv0
         ZO/fzp+EoELNTlTCVELtDNHMrPVe7WgyG3Ap2/YzfduphN+ieG/F3QXm15IMxMOXyC/1
         oRZC/hwtLENknpndjZaQFebweo20NqIinLsZzhWSt8oOsiuGPlQN81mvvwbShoMJNVgY
         EOjA==
X-Gm-Message-State: APjAAAXkCBrtzpdWGVx9gKxTyZsPL+2xeh8CruVUfuT77teSboXOaYqz
        QpRyUJwdfW0MekR4jZC9oCMY033fletpfw+r8Xg=
X-Google-Smtp-Source: APXvYqwj3pkSyuy7eo3C53ZQ0hnu0Yv8Wm82cvhTCR/2PR4aricAJ4Bc2JUBebNhd/gooqleoQJNHiIQ7FHGEjWjZKc=
X-Received: by 2002:a81:47c1:: with SMTP id u184mr65445466ywa.313.1560839294946;
 Mon, 17 Jun 2019 23:28:14 -0700 (PDT)
MIME-Version: 1.0
References: <e6968aa2-a5ad-4964-2966-589486e4a251@sandeen.net>
 <20190606195724.2975689-1-sheenobu@fb.com> <f89a09b5-8a91-51e0-d869-039dbe9a7349@sandeen.net>
 <20190606215008.GA14308@dread.disaster.area> <4a03b347-1a71-857d-af9d-1d7eca00056a@sandeen.net>
 <20190606223607.GE14308@dread.disaster.area> <CABeZSNkGoKhfV2-=CfqSPUsf9CxLNFP5vRa161M_LowfnJ8TzA@mail.gmail.com>
 <20190617225558.GN3773859@magnolia>
In-Reply-To: <20190617225558.GN3773859@magnolia>
From:   Sheena Artrip <sheena.artrip@gmail.com>
Date:   Mon, 17 Jun 2019 23:28:03 -0700
Message-ID: <CABeZSNkuNrLPMJ+HK8MPvBbLjHu4XszimOu+TsWnQNENbfoxNg@mail.gmail.com>
Subject: Re: [PATCH v2] xfs_restore: detect rtinherit on destination
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Sheena Artrip <sheenobu@fb.com>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 17, 2019 at 3:56 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Mon, Jun 17, 2019 at 03:09:15PM -0700, Sheena Artrip wrote:
> > On Thu, Jun 6, 2019 at 3:37 PM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Thu, Jun 06, 2019 at 05:08:12PM -0500, Eric Sandeen wrote:
> > > > On 6/6/19 4:50 PM, Dave Chinner wrote:
> > > > > My take on this is that we need to decide which allocation policy to
> > > > > use - the kernel policy or the dump file policy - in the different
> > > > > situations. It's a simple, easy to document and understand solution.
> > > > >
> > > > > At minimum, if there's a mismatch between rtdev/non-rtdev between
> > > > > dump and restore, then restore should not try to restore or clear rt
> > > > > flags at all. i.e the rt flags in the dump image should be
> > > > > considered invalid in this situation and masked out in the restore
> > > > > process. This prevents errors from being reported during restore,
> > > > > and it does "the right thing" according to how the user has
> > > > > configured the destination directory. i.e.  if the destdir has the
> > > > > rtinherit bit set and there's a rtdev present, the kernel policy
> > > > > will cause all file data that is restored to be allocated on the
> > > > > rtdev. Otherwise the kernel will place it (correctly) on the data
> > > > > dev.
> > > > >
> > > > > In the case where both have rtdevs, but you want to restore to
> > > > > ignore the dump file rtdev policy, we really only need to add a CLI
> > > > > option to say "ignore rt flags" and that then allows the kernel
> > > > > policy to dictate how the restored files are placed in the same way
> > > > > that having a rtdev mismatch does.
> > > > >
> > > > > This is simple, consistent, fulfils the requirements and should have
> > > > > no hidden surprises for users....
> > > >
> > > > Sounds reasonable.  So the CLI flag would say "ignore RT info in the
> > > > dump, and write files according to the destination fs policy?"
> > > > I think that makes sense.
> >
> > Any suggested flag name/prefix for this? Last i checked all the single
> > letters were taken up?
>
> I suggest --preserve-xflags=<same letters as xfs_io lsattr command>

What's the implication? That we do not copy any xflags bits unless you
include them in --preserve-xflags?
The defaults of this would be all the available fields.

That still leaves the destination needing a xflag bit like realtime
and the source not having it...Maybe
xfsdump needs --preserve-xflags and xfsrestore needs --apply-xflags ?
That will catch
all the cases and the solution is just an and/xor on the
outgoing/incoming bsp_xflags field:

 * realtime->realtime (--preserve-xflags=all --apply-xflags=none)
 * non-realtime->realtime (--preserve-xflags=all --apply-xflags=t)
 * non-realtime->non-realtime (--preserve-xflags=all --apply-xflags=none)
 * realtime->non-realtime (--preserve-xflags=all-but-t)

Thanks!

> --D
>
> > > *nod*
> > >
> > > > Now: do we need to do the same for all inheritable flags?  projid,
> > > > extsize, etc?  I think we probably do.
> > >
> > > I disagree. These things are all supported on all destination
> > > filesystems, unlike the rtdev. They are also things that can be
> > > changed after the fact, unlike rtdev allocation policy. i.e. rtdev
> > > has to be set /before/ restore, just about everything else can be
> > > set or reset after the fact....
> > > Cheers,
> > >
> > > Dave.
> > > --
> > > Dave Chinner
> > > david@fromorbit.com
