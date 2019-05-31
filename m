Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A592931191
	for <lists+linux-xfs@lfdr.de>; Fri, 31 May 2019 17:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfEaPtG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 31 May 2019 11:49:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53348 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfEaPtF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 May 2019 11:49:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4VFhrHq180755;
        Fri, 31 May 2019 15:48:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=UO4f0w3okQR40tTL+u8DrrfQx6kViyVUmW08rHP9Kjw=;
 b=MzRy3KVlpzz5Fp9+HjNRp4+fy95dgrseIapsV7TrzRIA19vPSyIyBP6j1LxPG6H8ZsOW
 uqF17Y4SHRBmn7hT9vmgroHnAvgufKGEwx+wSz2LLkgAvVrhV/gEGAxhNt1evSmowuKk
 Ms8ajDpTmZCaBbEFjE4s0uS+sAGGWIh5/ssS2lu2F5JOtG3mTiHTNXx4yPbP7K2BTw4H
 Z7Plk+lkP5U+ZotL2fdgUYsXD/x+ksDlYt6TweY2YX/NlcPcJwK53zqs3FMm1EBGYDuX
 NVZkvqCWW9EOpR1ZHIlXB7fcx+nMuVnGzD3Gqmi+VLAf0lVBrBF9OyLZt3tDYCWkK9VD sQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2spxbqq2pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 May 2019 15:48:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4VFmBuD155891;
        Fri, 31 May 2019 15:48:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2sr31wgvjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 May 2019 15:48:31 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4VFmUJa018686;
        Fri, 31 May 2019 15:48:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 31 May 2019 08:48:30 -0700
Date:   Fri, 31 May 2019 08:48:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_io: allow passing an open file to copy_range
Message-ID: <20190531154829.GC5398@magnolia>
References: <20190529101330.29470-1-amir73il@gmail.com>
 <20190529144604.GC5231@magnolia>
 <CAOQ4uxgxiLGwvbeoKx3P+nvakTA75dh8hsyH4+gv2G=e5T3M=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgxiLGwvbeoKx3P+nvakTA75dh8hsyH4+gv2G=e5T3M=w@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9273 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905310098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9273 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905310098
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 29, 2019 at 06:44:09PM +0300, Amir Goldstein wrote:
> On Wed, May 29, 2019 at 5:46 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > On Wed, May 29, 2019 at 01:13:30PM +0300, Amir Goldstein wrote:
> > > Commit 1a05efba ("io: open pipes in non-blocking mode")
> > > addressed a specific copy_range issue with pipes by always opening
> > > pipes in non-blocking mode.
> > >
> > > This change takes a different approach and allows passing any
> > > open file as the source file to copy_range.  Besides providing
> > > more flexibility to the copy_range command, this allows xfstests
> > > to check if xfs_io supports passing an open file to copy_range.
> > >
> > > The intended usage is:
> > > $ mkfifo fifo
> > > $ xfs_io -f -n -r -c "open -f dst" -C "copy_range -f 0" fifo
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >
> > > Darrick,
> > >
> > > Folowing our discussion on the copy_range bounds test [1],
> > > what do you think about using copy_range -f in the copy_range
> > > fifo test with a fifo that was explicitly opened non-blocking,
> > > instead of trying to figure out if copy_range is going to hang
> > > or not?
> > >
> > > This option is already available with sendfile command and
> > > we can make it available for reflink and dedupe commands if
> > > we want to. Too bad that these 4 commands have 3 different
> > > usage patterns to begin with...
> >
> > I wonder if there's any sane way to overload the src_file argument such
> > that we can pass filetable[] offsets without having to burn more getopt
> > flags...?
> >
> > (Oh wait, I bet you're using the '-f' flag to figure out if xfs_io is
> > new enough not to block on fifos, right? :))
> 
> Yes, but this time it is not a hack its a feature..

Heh, ok. :)

> > But otherwise this seems like a reasonable approach.
> >
> > > Thanks,
> > > Amir.
> > >
> > > [1] https://marc.info/?l=fstests&m=155910786017989&w=2
> > >
> > >  io/copy_file_range.c | 30 ++++++++++++++++++++++++------
> > >  man/man8/xfs_io.8    | 10 +++++++---
> > >  2 files changed, 31 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> > > index d069e5bb..1f0d2713 100644
> > > --- a/io/copy_file_range.c
> > > +++ b/io/copy_file_range.c
> > > @@ -26,6 +26,8 @@ copy_range_help(void)
> > >                                              file at offset 200\n\
> > >   'copy_range some_file' - copies all bytes from some_file into the open file\n\
> > >                            at position 0\n\
> > > + 'copy_range -f 2' - copies all bytes from open file 2 into the current open file\n\
> > > +                          at position 0\n\
> > >  "));
> > >  }
> > >
> > > @@ -82,11 +84,12 @@ copy_range_f(int argc, char **argv)
> > >       int opt;
> > >       int ret;
> > >       int fd;
> > > +     int src_file_arg = 1;
> > >       size_t fsblocksize, fssectsize;
> > >
> > >       init_cvtnum(&fsblocksize, &fssectsize);
> > >
> > > -     while ((opt = getopt(argc, argv, "s:d:l:")) != -1) {
> > > +     while ((opt = getopt(argc, argv, "s:d:l:f:")) != -1) {
> > >               switch (opt) {
> > >               case 's':
> > >                       src = cvtnum(fsblocksize, fssectsize, optarg);
> > > @@ -109,15 +112,30 @@ copy_range_f(int argc, char **argv)
> > >                               return 0;
> > >                       }
> > >                       break;
> > > +             case 'f':
> > > +                     fd = atoi(argv[1]);
> > > +                     if (fd < 0 || fd >= filecount) {
> > > +                             printf(_("value %d is out of range (0-%d)\n"),
> > > +                                     fd, filecount-1);
> > > +                             return 0;
> > > +                     }
> > > +                     fd = filetable[fd].fd;
> > > +                     /* Expect no src_file arg */
> > > +                     src_file_arg = 0;
> > > +                     break;
> > >               }
> > >       }
> > >
> > > -     if (optind != argc - 1)
> > > +     if (optind != argc - src_file_arg) {
> > > +             fprintf(stderr, "optind=%d, argc=%d, src_file_arg=%d\n", optind, argc, src_file_arg);
> > >               return command_usage(&copy_range_cmd);
> > > +     }
> > >
> > > -     fd = openfile(argv[optind], NULL, IO_READONLY, 0, NULL);
> > > -     if (fd < 0)
> > > -             return 0;
> > > +     if (src_file_arg) {
> >
> > I wonder if it would be easier to declare "int fd = -1" and the only do
> > the openfile here if fd < 0?
> >
> 
> I started out with if (fd == -1), but I changed to src_file_arg to
> unify the condition for (optind != argc - src_file_arg)
> and avoid another condition (i.e. argc - (fd == -1 ? 1 : 0))

<nod>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


--D

> Thanks,
> Amir.
