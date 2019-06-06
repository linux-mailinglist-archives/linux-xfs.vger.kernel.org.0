Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03DCC37BEF
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Jun 2019 20:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbfFFSMd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 6 Jun 2019 14:12:33 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:41463 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfFFSMc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jun 2019 14:12:32 -0400
Received: by mail-yw1-f68.google.com with SMTP id y185so1194091ywy.8
        for <linux-xfs@vger.kernel.org>; Thu, 06 Jun 2019 11:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7LqHDeDAk+tdHMwsKKaxioTA8UK2su3WxfaC1sw0I0w=;
        b=NrTr2+NvCmOU01nQPlwRz0Ey5OzyOXniqGSFrARU1OOW/ybG8d2eRsWT+d7smhsDjS
         U3usvVzgLbA4x+5PVsoybBM11qJ6ARIuEzQwXwF2M2QdIxfG3cCgVSlOu7vgHS4S76bm
         ACohK0JvI+yLpjnqVrf3/QIS/UbjDN2JsNoQbUSOiOqa177iWMgvOZwCWRK0AhXZdrwA
         5S+VHncTKkI2s6R6wi417+vycYPLivFkS1cfDiwPth5oIyzJzqeEk1xngZqdiWYCIqov
         l4GZ/kHdQoeBrpr5jixMrx9FRDPRj3jX3syWX7GpWFgvxbMAgT2FEm5ZMqpvImvBqkUx
         GYIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7LqHDeDAk+tdHMwsKKaxioTA8UK2su3WxfaC1sw0I0w=;
        b=lMs+NjFdw8YFGm8u9llUU5EwUy19CUvQSDfBjfwciZYAZknaPhpFB/GQiPxOtxPvxO
         zIHaPwD9EkRYi0qea4DaXeAVwzdMtuEr1s41jNhZ+X33W6jyDDG7sU5AjkKM1rdlbCZW
         ZJ+a+N8socOsJejqwBTRDvgv5RaCf/SkXYgSkuLn3eVHKfqPk7x/5sz2ANuUysc1puWd
         G0ll6VQKpa2pi2S41DgXF+RMynz9OvV3Sq0RyHOep7PInlck1ij0KXsa9QvrXp/c7itz
         nv/fsx1O22q3VJE/RUFYPigtycTkEQmMXbjGm8lVh6SENsxgzfl9eBD7AeEbr58Uk9Pa
         hnSQ==
X-Gm-Message-State: APjAAAWyht/kYNd5MoK1d5XdTF1xeNjtyWK/KQhIIdtGVlv5D/Vu+hAq
        4MhtakwgxN1Vt2i6MJcqQInJGolbZDZrTUrwZM0=
X-Google-Smtp-Source: APXvYqxUbsQFiBhixHTlfa+IwMrBx6GR8MPxKFHvYIfXrAxWDfmTIW+z1dYo0GoJ0v82L0/uylp9dBs6j+ZbhD/qViA=
X-Received: by 2002:a81:47c1:: with SMTP id u184mr26286425ywa.313.1559844751704;
 Thu, 06 Jun 2019 11:12:31 -0700 (PDT)
MIME-Version: 1.0
References: <CABeZSNmcmL3_VvDVvbcneDd3f2jCiu7Pn8YQ7y7mJH8BizaWXw@mail.gmail.com>
 <680c16d9-cb95-f2b1-b65b-c956b1e5c1ed@sandeen.net>
In-Reply-To: <680c16d9-cb95-f2b1-b65b-c956b1e5c1ed@sandeen.net>
From:   Sheena Artrip <sheena.artrip@gmail.com>
Date:   Thu, 6 Jun 2019 11:12:20 -0700
Message-ID: <CABeZSNnw=UN9+muYXD-JYV3cECZPUfzxW1y8HE4ks=PCEdFqEQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] xfs_restore: detect rtinherit on destination
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Cc:     sheenobu@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 6, 2019 at 7:11 AM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 6/5/19 4:16 PM, Sheena Artrip wrote:
> > When running xfs_restore with a non-rtdev dump,
> > it will ignore any rtinherit flags on the destination
> > and send I/O to the metadata region.
> >
> > Instead, detect rtinherit on the destination XFS fileystem root inode
> > and use that to override the incoming inode flags.
> >
> > Original version of this patch missed some branches so multiple
> > invocations of xfsrestore onto the same fs caused
> > the rtinherit bit to get re-removed. There could be some
> > additional edge cases in non-realtime to realtime workflows so
> > the outstanding question would be: is it worth supporting?
>
> Hm, interesting.
>
> So this is a mechanism to allow dump/restore to migrate everything
> to the realtime subvol?  I can't decide if I like this - normally I'd
> think of an xfsdump/xfsrestore session as more or less replicating the
> filesystem that was dumped, and not something that will fundamentally
> change what was dumped.
>
> OTOH, we can restore onto any dir we want, and I could see the argument
> that we should respect things like the rtinherit flag if that's what
> the destination dir says.

Yes. What is strange is that an xfsrestore onto a rtdev system will
silently "fill"
the metadata partition until the available inode count goes to zero and we get
an ENOSPC. Not yet sure if the file data goes straight to the metadata partition
or if it's simply accounting for it in the metadata partition.

I'm guessing xfsrestore should either fail-fast or allow this via
rtinherit detection. I don't mind putting it behind a flag either.

> One thing about the patch - the mechanism you've copied to get the root
> inode number via bulkstat turns out to be broken ... it's possible
> to have a non-root inode with the lowest number on the fs, unfortunately.

I think i saw that on the list but this code is also a near-identical
copy of what is in xfsdump/content.c.

> But, wouldn't you want to test the rtinherit flag on the target dir anyway,
> not necessarily the root dir?

Makes sense. How would I get the rtinherit flag on the target dir? Is there
a xfs-specific stat function that will give us a xfs_bstat_t for the
dstdir inode
I've opened or is it already part of stat64_t?

> > Signed-off-by: Sheena Artrip <sheena.artrip@gmail.com>
> > ---
> >  restore/content.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 65 insertions(+)
> >
> > diff --git a/restore/content.c b/restore/content.c
> > index 6b22965..96dd698 100644
> > --- a/restore/content.c
> > +++ b/restore/content.c
> > @@ -670,6 +670,9 @@ struct tran {
> >                  /* to establish critical regions while updating pers
> >                   * inventory
> >                   */
> > +       bool_t t_dstisrealtime;
> > +               /* to force the realtime flag on incoming inodes
> > +                */
> >  };
> >
> >  typedef struct tran tran_t;
> > @@ -1803,6 +1806,51 @@ content_init(int argc, char *argv[], size64_t vmsz)
> >                  free_handle(fshanp, fshlen);
> >          }
> >
> > +       /* determine if destination root inode has rtinherit.
> > +        * If so, we should force XFS_REALTIME on the incoming inodes.
> > +        */
> > +       if (persp->a.dstdirisxfspr) {
> > +               stat64_t rootstat;
> > +               xfs_fsop_bulkreq_t bulkreq;
> > +               int ocount = 0;
> > +               xfs_bstat_t *sc_rootxfsstatp;
> > +
> > +               int rootfd = open(persp->a.dstdir, O_RDONLY);
> > +
> > +               sc_rootxfsstatp =
> > +                       (xfs_bstat_t *)calloc(1, sizeof(xfs_bstat_t));
> > +               assert(sc_rootxfsstatp);
> > +
> > +               /* Get the inode of the destination folder */
> > +               int rval = fstat64(rootfd, &rootstat);
> > +               if (rval) {
> > +                       (void)close(rootfd);
> > +                       mlog(MLOG_NORMAL, _(
> > +                         "could not stat %s\n"),
> > +                         persp->a.dstdir);
> > +                       return BOOL_FALSE;
> > +               }
> > +
> > +               /* Get the first valid (i.e. root) inode in this fs */
> > +               bulkreq.lastip = (__u64 *)&rootstat.st_ino;
> > +               bulkreq.icount = 1;
> > +               bulkreq.ubuffer = sc_rootxfsstatp;
> > +               bulkreq.ocount = &ocount;
> > +               if (ioctl(rootfd, XFS_IOC_FSBULKSTAT, &bulkreq) < 0) {
> > +                       (void)close(rootfd);
> > +                       mlog(MLOG_ERROR,
> > +                             _("failed to get bulkstat information
> > for root inode\n"));
> > +                       return BOOL_FALSE;
> > +               }
> > +
> > +               (void)close(rootfd);
> > +
> > +               /* test against rtinherit */
> > +               if((sc_rootxfsstatp->bs_xflags & XFS_XFLAG_RTINHERIT) != 0) {
> > +                       tranp->t_dstisrealtime = true;
> > +               }
> > +       }
> > +
> >          /* map in pers. inv. descriptors, if any. NOTE: this ptr is to be
> >           * referenced ONLY via the macros provided; the descriptors will be
> >           * occasionally remapped, causing the ptr to change.
> > @@ -7270,6 +7318,10 @@ restore_file_cb(void *cp, bool_t linkpr, char
> > *path1, char *path2)
> >          bool_t ahcs = contextp->cb_ahcs;
> >          stream_context_t *strctxp = (stream_context_t *)drivep->d_strmcontextp;
> >
> > +       if (tranp->t_dstisrealtime) {
> > +               bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
> > +       }
> > +
> >          int rval;
> >          bool_t ok;
> >
> > @@ -7480,6 +7532,10 @@ restore_reg(drive_t *drivep,
> >          if (tranp->t_toconlypr)
> >                  return BOOL_TRUE;
> >
> > +       if (tranp->t_dstisrealtime) {
> > +             bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
> > +       }
> > +
> >          oflags = O_CREAT | O_RDWR;
> >          if (persp->a.dstdirisxfspr && bstatp->bs_xflags & XFS_XFLAG_REALTIME)
> >                  oflags |= O_DIRECT;
> > @@ -8470,6 +8526,11 @@ restore_extent(filehdr_t *fhdrp,
> >                  }
> >                  assert(new_off == off);
> >          }
> > +
> > +       if (tranp->t_dstisrealtime) {
> > +             bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
> > +       }
> > +
> >          if ((fd != -1) && (bstatp->bs_xflags & XFS_XFLAG_REALTIME)) {
> >                  if ((ioctl(fd, XFS_IOC_DIOINFO, &da) < 0)) {
> >                          mlog(MLOG_NORMAL | MLOG_WARNING, _(
> > @@ -8729,6 +8790,10 @@ restore_extattr(drive_t *drivep,
> >
> >          assert(extattrbufp);
> >
> > +       if (tranp->t_dstisrealtime) {
> > +               bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
> > +       }
> > +
> >          if (!isdirpr)
> >                  isfilerestored = partial_check(bstatp->bs_ino,
> > bstatp->bs_size);
> >
> > --
> > 2.17.1
> >
