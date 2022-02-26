Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91CAC4C536A
	for <lists+linux-xfs@lfdr.de>; Sat, 26 Feb 2022 03:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiBZCsw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 25 Feb 2022 21:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiBZCsw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 21:48:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12541180D35
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 18:48:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7268861E1A
        for <linux-xfs@vger.kernel.org>; Sat, 26 Feb 2022 02:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4701C340E7;
        Sat, 26 Feb 2022 02:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645843696;
        bh=YlouIyJ249dgHDNbm+/2SHX2HUa36zQSjNxtan+mg9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S6d5/L5JwIHNAuDCLLpM8yAgig9JEs2/mcejB5qQWSZNrAyN5pFsyMz9EV693RQtJ
         p7ZZ8vrlqFx9aZ6RYzGSKvh3nAavVzrEgg410CE1pWcgKMvArtlCf2wC+n1wVbjqNK
         cc8pR3Ku4XU/7rojXWyWn7yksIMQMF/pLqcn7nhfJ0H+pXQBQkE8a7cwVIKSGRh2Bn
         hZPxpvOeh6dXKgUUdHhco8nu/Nua8FTLAC1Yjr8MYhn8AVZEASLscCiZf5NbicDjPx
         GIRK5vi10qmEKmirebEU+oTINU/yIJCVk6CKAWOo65OE6IWx3j3hauhGEVtKGWjRI+
         bw47iYwUL2HJA==
Date:   Fri, 25 Feb 2022 18:48:16 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH v2 12/17] xfs_scrub: report optional features in version
 string
Message-ID: <20220226024816.GV8313@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263816090.863810.16834243121150635355.stgit@magnolia>
 <20220120013233.GJ13540@magnolia>
 <3ef560bc-25ae-2fa2-26c0-844acf800c24@sandeen.net>
 <20220226000421.GT8313@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226000421.GT8313@magnolia>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 25, 2022 at 04:04:21PM -0800, Darrick J. Wong wrote:
> On Fri, Feb 25, 2022 at 04:14:13PM -0600, Eric Sandeen wrote:
> > On 1/19/22 7:32 PM, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Ted Ts'o reported brittleness in the fstests logic in generic/45[34] to
> > > detect whether or not xfs_scrub is capable of detecting Unicode mischief
> > > in directory and xattr names.  This is a compile-time feature, since we
> > > do not assume that all distros will want to ship xfsprogs with libicu.
> > > 
> > > Rather than relying on ldd tests (which don't work at all if xfs_scrub
> > > is compiled statically), let's have -V print whether or not the feature
> > > is built into the tool.  Phase 5 still requires the presence of "UTF-8"
> > > in LC_MESSAGES to enable Unicode confusable detection; this merely makes
> > > the feature easier to discover.
> > > 
> > > Reported-by: Theodore Ts'o <tytso@mit.edu>
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > > v2: correct the name of the reporter
> > > ---
> > 
> > Hum, every single other utility just does "$progname version $version"
> > and I'm not that keen to tack on something for everyone, if it won't
> > really mean anything to anyone except xfstests scripts ;)
> > 
> > What about adding an "-F" to display features, and xfstests can use that,
> > and xfs_scrub -V will keep acting like every other utility?
> > 
> > Other utilities could use this too if we ever cared (though xfs_db
> > and xfs_io already have an "-F" option ... we could choose -Z for
> > featureZ, which is unused as a primary option anywhere ...)
> > 
> > like so:
> > 
> > ===
> > 
> > diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
> > index e881ae76..65d8f4a2 100644
> > --- a/man/man8/xfs_scrub.8
> > +++ b/man/man8/xfs_scrub.8
> > @@ -8,7 +8,7 @@ xfs_scrub \- check and repair the contents of a mounted XFS filesystem
> >  ]
> >  .I mount-point
> >  .br
> > -.B xfs_scrub \-V
> > +.B xfs_scrub \-V | \-F
> >  .SH DESCRIPTION
> >  .B xfs_scrub
> >  attempts to check and repair all metadata in a mounted XFS filesystem.
> > @@ -76,6 +76,9 @@ If
> >  is given, no action is taken if errors are found; this is the default
> >  behavior.
> >  .TP
> > +.B \-F
> > +Prints the version number along with optional build-time features and exits.
> > +.TP
> >  .B \-k
> >  Do not call TRIM on the free space.
> >  .TP
> > diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> > index bc2e84a7..9e9a098c 100644
> > --- a/scrub/xfs_scrub.c
> > +++ b/scrub/xfs_scrub.c
> > @@ -582,6 +582,13 @@ report_outcome(
> >  	}
> >  }
> >  
> > +/* Compile-time features discoverable via version strings */
> > +#ifdef HAVE_LIBICU
> > +# define XFS_SCRUB_HAVE_UNICODE	"+"
> > +#else
> > +# define XFS_SCRUB_HAVE_UNICODE	"-"
> > +#endif
> > +
> >  int
> >  main(
> >  	int			argc,
> > @@ -613,7 +620,7 @@ main(
> >  	pthread_mutex_init(&ctx.lock, NULL);
> >  	ctx.mode = SCRUB_MODE_REPAIR;
> >  	ctx.error_action = ERRORS_CONTINUE;
> > -	while ((c = getopt(argc, argv, "a:bC:de:km:nTvxV")) != EOF) {
> > +	while ((c = getopt(argc, argv, "a:bC:de:Fkm:nTvxV")) != EOF) {
> >  		switch (c) {
> >  		case 'a':
> >  			ctx.max_errors = cvt_u64(optarg, 10);
> > @@ -654,6 +661,12 @@ main(
> >  				usage();
> >  			}
> >  			break;
> > +		case 'F':
> > +			fprintf(stdout, _("%s version %s %sUnicode\n"),
> > +					progname, VERSION,
> > +					XFS_SCRUB_HAVE_UNICODE);
> > +			fflush(stdout);
> > +			return SCRUB_RET_SUCCESS;
> 
> Works for me!

Actually, I take it back, let's keep -F unused for now and simply make
'-VV' the magic command that triggers the feature reporting.  I'll send
a v3 with this.

--D

> 
> --D
> 
> >  		case 'k':
> >  			want_fstrim = false;
> >  			break;
