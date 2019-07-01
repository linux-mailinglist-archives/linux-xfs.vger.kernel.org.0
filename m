Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDEE2E167
	for <lists+linux-xfs@lfdr.de>; Wed, 29 May 2019 17:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfE2PoW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 May 2019 11:44:22 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:41270 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfE2PoW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 11:44:22 -0400
Received: by mail-yw1-f67.google.com with SMTP id t140so1255062ywe.8
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 08:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=54h6WBi9Lz0LCqNGQV+71H62shf6DQSSWEFWaHQJXMI=;
        b=kK3NVpB2a8VsyjTlPtfDgYTxVJ9uSmgH4YWFjEHc8J5KewiThxKRAQCRwcIASzW/8+
         kxz48FdJ9GOk3mwoUOVa037SkONr8UnaMMC0MX6va9oMPTESMBrQT/vqR2I6SjMqB7ew
         flKtV8pN301/1hOwckqRPyM/qzLFWbGKmZlZLk6fVBL+rJ8HCdOnEvGU/+XBxHEv3pto
         Ove4zqVdjIjbQkbViw+P9OLnr1oIc44APmQrjB0VXQc4fJGt6RmUxgNUuCDfg4pqWNPO
         9nLwQq6QkRrhlbK5RnDkL1xN7/A91RxBXhV60wbuJLq85zl6mHnWQA3ACRYh7zIvfaoW
         TdXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=54h6WBi9Lz0LCqNGQV+71H62shf6DQSSWEFWaHQJXMI=;
        b=tKqMS3lFr/PjtBqLaTrFfKHyqFa1DyRDzYF/zLsQ6W5ULlIokiGc7zinPec+4i12Ns
         /YYmh/V/vkBMahpwtlfkOI1qn0kXl2M2Y/FIB1xxhyN4Epcz+lnl7Mda9bKKkEuMcqhr
         nJLPPY2PIdS1YcAcbU5qwLQoG9ivPics+iyWKrm2jeXoRzWekLSJXUeQtr2USOoW37fM
         p/M1EsrQTwrxRbuQUdlj2yoJdGgeA58VVxO2Jlqupzdt2pmZf4f9rGJVQfrC9PrtAA5K
         p3dECOqmVP+6ZBVGby/AQwxY74z4FXhIzbhYKPBAz1BF23JU29xMGDZkIx2DZRBWyq2U
         C8EA==
X-Gm-Message-State: APjAAAUv1/41dV7gTA9ziTh6KtMDsj1vvwR9uGg1MI4xnWjW4FQF7wtK
        mZpnNRGgh+kXrkMzAcbC9i9Cu1LQOeDit4vspEI=
X-Google-Smtp-Source: APXvYqxQypR2M1cea5HhHsRcEDLLw8W847qhHhCu8HWfDL7RsF8Ra3X1c/6tvWO1vyIVU2y/OVNuHD+jDky48bWutDQ=
X-Received: by 2002:a0d:d5c1:: with SMTP id x184mr37671244ywd.88.1559144660896;
 Wed, 29 May 2019 08:44:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190529101330.29470-1-amir73il@gmail.com> <20190529144604.GC5231@magnolia>
In-Reply-To: <20190529144604.GC5231@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 29 May 2019 18:44:09 +0300
Message-ID: <CAOQ4uxgxiLGwvbeoKx3P+nvakTA75dh8hsyH4+gv2G=e5T3M=w@mail.gmail.com>
Subject: Re: [PATCH] xfs_io: allow passing an open file to copy_range
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 29, 2019 at 5:46 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Wed, May 29, 2019 at 01:13:30PM +0300, Amir Goldstein wrote:
> > Commit 1a05efba ("io: open pipes in non-blocking mode")
> > addressed a specific copy_range issue with pipes by always opening
> > pipes in non-blocking mode.
> >
> > This change takes a different approach and allows passing any
> > open file as the source file to copy_range.  Besides providing
> > more flexibility to the copy_range command, this allows xfstests
> > to check if xfs_io supports passing an open file to copy_range.
> >
> > The intended usage is:
> > $ mkfifo fifo
> > $ xfs_io -f -n -r -c "open -f dst" -C "copy_range -f 0" fifo
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Darrick,
> >
> > Folowing our discussion on the copy_range bounds test [1],
> > what do you think about using copy_range -f in the copy_range
> > fifo test with a fifo that was explicitly opened non-blocking,
> > instead of trying to figure out if copy_range is going to hang
> > or not?
> >
> > This option is already available with sendfile command and
> > we can make it available for reflink and dedupe commands if
> > we want to. Too bad that these 4 commands have 3 different
> > usage patterns to begin with...
>
> I wonder if there's any sane way to overload the src_file argument such
> that we can pass filetable[] offsets without having to burn more getopt
> flags...?
>
> (Oh wait, I bet you're using the '-f' flag to figure out if xfs_io is
> new enough not to block on fifos, right? :))

Yes, but this time it is not a hack its a feature..

>
> But otherwise this seems like a reasonable approach.
>
> > Thanks,
> > Amir.
> >
> > [1] https://marc.info/?l=fstests&m=155910786017989&w=2
> >
> >  io/copy_file_range.c | 30 ++++++++++++++++++++++++------
> >  man/man8/xfs_io.8    | 10 +++++++---
> >  2 files changed, 31 insertions(+), 9 deletions(-)
> >
> > diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> > index d069e5bb..1f0d2713 100644
> > --- a/io/copy_file_range.c
> > +++ b/io/copy_file_range.c
> > @@ -26,6 +26,8 @@ copy_range_help(void)
> >                                              file at offset 200\n\
> >   'copy_range some_file' - copies all bytes from some_file into the open file\n\
> >                            at position 0\n\
> > + 'copy_range -f 2' - copies all bytes from open file 2 into the current open file\n\
> > +                          at position 0\n\
> >  "));
> >  }
> >
> > @@ -82,11 +84,12 @@ copy_range_f(int argc, char **argv)
> >       int opt;
> >       int ret;
> >       int fd;
> > +     int src_file_arg = 1;
> >       size_t fsblocksize, fssectsize;
> >
> >       init_cvtnum(&fsblocksize, &fssectsize);
> >
> > -     while ((opt = getopt(argc, argv, "s:d:l:")) != -1) {
> > +     while ((opt = getopt(argc, argv, "s:d:l:f:")) != -1) {
> >               switch (opt) {
> >               case 's':
> >                       src = cvtnum(fsblocksize, fssectsize, optarg);
> > @@ -109,15 +112,30 @@ copy_range_f(int argc, char **argv)
> >                               return 0;
> >                       }
> >                       break;
> > +             case 'f':
> > +                     fd = atoi(argv[1]);
> > +                     if (fd < 0 || fd >= filecount) {
> > +                             printf(_("value %d is out of range (0-%d)\n"),
> > +                                     fd, filecount-1);
> > +                             return 0;
> > +                     }
> > +                     fd = filetable[fd].fd;
> > +                     /* Expect no src_file arg */
> > +                     src_file_arg = 0;
> > +                     break;
> >               }
> >       }
> >
> > -     if (optind != argc - 1)
> > +     if (optind != argc - src_file_arg) {
> > +             fprintf(stderr, "optind=%d, argc=%d, src_file_arg=%d\n", optind, argc, src_file_arg);
> >               return command_usage(&copy_range_cmd);
> > +     }
> >
> > -     fd = openfile(argv[optind], NULL, IO_READONLY, 0, NULL);
> > -     if (fd < 0)
> > -             return 0;
> > +     if (src_file_arg) {
>
> I wonder if it would be easier to declare "int fd = -1" and the only do
> the openfile here if fd < 0?
>

I started out with if (fd == -1), but I changed to src_file_arg to
unify the condition for (optind != argc - src_file_arg)
and avoid another condition (i.e. argc - (fd == -1 ? 1 : 0))

Thanks,
Amir.
