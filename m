Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E894544E6
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Nov 2021 11:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236362AbhKQK2L (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 17 Nov 2021 05:28:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49896 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236324AbhKQK2L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Nov 2021 05:28:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637144712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PeLytMpeobAX/Mbka1azxJ5y2EI4oXxreVBxQFm+D34=;
        b=O3TlVrYvmVDcSKr4FXHNsZQ/cEKxfRvN/NUqJHtOZJfQ+MrVr0b6dyONH8BBFRTEOH6JXj
        J/dDKe9+L/1Z+Ij6YVeqiC23yXkbvGXxR+Is3kJe8cXGUCHhEn0Y4xYkuD9yZURqqoNwPn
        db0elfcktF1BeCjdOd6OSTU/8NOqKnw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-RSIgHPEHMbqmTTrVnQStXA-1; Wed, 17 Nov 2021 05:25:09 -0500
X-MC-Unique: RSIgHPEHMbqmTTrVnQStXA-1
Received: by mail-wm1-f70.google.com with SMTP id r6-20020a1c4406000000b0033119c22fdbso872458wma.4
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 02:25:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PeLytMpeobAX/Mbka1azxJ5y2EI4oXxreVBxQFm+D34=;
        b=udHZSzqgmNutMA6l/5NVSjTgVo1dGTmUNHXGxxKs1KAfjFkHeGCwW2U83rQimknX8+
         CyxdZQuuN8SZAblTKdjZfHV8xaghmfqtDf35PTRYlhR93ncWqFKquVP9Xhri/esTD24D
         6gYuG4zet0aiO1sKkqo/msbjkkDxjJ71wbbz9B/0ureG+eySemowu1rPgW7B3RaIlUz6
         m4S3Bv27RHQ3QrSs2HylWv4eayPiE3/IoWMjAIPQn4xKZI8aA8f8dUwG46947bZoWmIl
         W2GqB44YRsAiJb7GLFtxlFJ+BLXQHND6qlmEbtSIoT50ZjF40g3NX+HbyUXmtdIZuJWl
         aXpw==
X-Gm-Message-State: AOAM531sY2L42UJ74Ni03tadWyRBFo5isyodrN4bWoM3YQMnDYapHKYp
        jix/hctDxwxMNosI9oB7fEEt6uMDjgkwGGx9opG5adKxEUfRCP0mHUNQctnGBiMt+7BHFuIJEbm
        XIn/r4JnzWgU+iljwI4dm6HoUldb6u4WTsoY6
X-Received: by 2002:a5d:43c5:: with SMTP id v5mr19042040wrr.11.1637144708008;
        Wed, 17 Nov 2021 02:25:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxV/yzimt/rDgfIdS6R4Pe333apTi73Ff+k6sK61bEAJtugKa8lazitGgtGHk5ESX82WxjntResUX5IKf1Fx4o=
X-Received: by 2002:a5d:43c5:: with SMTP id v5mr19042003wrr.11.1637144707799;
 Wed, 17 Nov 2021 02:25:07 -0800 (PST)
MIME-Version: 1.0
References: <20211111161714.584718-1-agruenba@redhat.com> <20211117053330.GU24307@magnolia>
In-Reply-To: <20211117053330.GU24307@magnolia>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Wed, 17 Nov 2021 11:24:56 +0100
Message-ID: <CAHc6FU4rY=G-pdKzYPVXyQ5SEhtfgh_9CK9wNKbBQRONuP=BFA@mail.gmail.com>
Subject: Re: [5.15 REGRESSION v2] iomap: Fix inline extent handling in iomap_readpage
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 17, 2021 at 6:33 AM Darrick J. Wong <djwong@kernel.org> wrote:
> On Thu, Nov 11, 2021 at 05:17:14PM +0100, Andreas Gruenbacher wrote:
> > Before commit 740499c78408 ("iomap: fix the iomap_readpage_actor return
> > value for inline data"), when hitting an IOMAP_INLINE extent,
> > iomap_readpage_actor would report having read the entire page.  Since
> > then, it only reports having read the inline data (iomap->length).
> >
> > This will force iomap_readpage into another iteration, and the
> > filesystem will report an unaligned hole after the IOMAP_INLINE extent.
> > But iomap_readpage_actor (now iomap_readpage_iter) isn't prepared to
> > deal with unaligned extents, it will get things wrong on filesystems
> > with a block size smaller than the page size, and we'll eventually run
> > into the following warning in iomap_iter_advance:
> >
> >   WARN_ON_ONCE(iter->processed > iomap_length(iter));
> >
> > Fix that by changing iomap_readpage_iter to return 0 when hitting an
> > inline extent; this will cause iomap_iter to stop immediately.
>
> I guess this means that we also only support having inline data that
> ends at EOF?  IIRC this is true for the three(?) filesystems that have
> expressed any interest in inline data: yours, ext4, and erofs?

Yes.

> > To fix readahead as well, change iomap_readahead_iter to pass on
> > iomap_readpage_iter return values less than or equal to zero.
> >
> > Fixes: 740499c78408 ("iomap: fix the iomap_readpage_actor return value for inline data")
> > Cc: stable@vger.kernel.org # v5.15+
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > ---
> >  fs/iomap/buffered-io.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index 1753c26c8e76..fe10d8a30f6b 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -256,8 +256,13 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
> >       unsigned poff, plen;
> >       sector_t sector;
> >
> > -     if (iomap->type == IOMAP_INLINE)
> > -             return min(iomap_read_inline_data(iter, page), length);
> > +     if (iomap->type == IOMAP_INLINE) {
> > +             loff_t ret = iomap_read_inline_data(iter, page);
>
> Ew, iomap_read_inline_data returns loff_t.  I think I'll slip in a
> change of return type to ssize_t, if you don't mind?

Really?

> > +
> > +             if (ret < 0)
> > +                     return ret;
>
> ...and a comment here explaining that we only support inline data that
> ends at EOF?

I'll send a separate patch that adds a description for
iomap_read_inline_data and cleans up its return value.

Thanks,
Andreas

> If the answers to all /four/ questions are 'yes', then consider this:
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>
> --D
>
> > +             return 0;
> > +     }
> >
> >       /* zero post-eof blocks as the page may be mapped */
> >       iop = iomap_page_create(iter->inode, page);
> > @@ -370,6 +375,8 @@ static loff_t iomap_readahead_iter(const struct iomap_iter *iter,
> >                       ctx->cur_page_in_bio = false;
> >               }
> >               ret = iomap_readpage_iter(iter, ctx, done);
> > +             if (ret <= 0)
> > +                     return ret;
> >       }
> >
> >       return done;
> > --
> > 2.31.1
> >
>

