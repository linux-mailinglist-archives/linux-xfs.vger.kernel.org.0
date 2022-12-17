Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE6864FC30
	for <lists+linux-xfs@lfdr.de>; Sat, 17 Dec 2022 21:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiLQUG5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 17 Dec 2022 15:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLQUG4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Dec 2022 15:06:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFFB2DF8;
        Sat, 17 Dec 2022 12:06:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEE65B80926;
        Sat, 17 Dec 2022 20:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389E2C433EF;
        Sat, 17 Dec 2022 20:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671307612;
        bh=vztAfKdt0IIPwAbygvpZfLuyd9G6PPujslXDQWB0Noc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rmpnO9y6vHseH0zOPSkiIrgqjvvlTMwU6JpGie2wc+7o3I2/XZoxY1K6s9gKPfCCS
         RaH7SGlkgPQ4luMTypbdEKFFZ5sOvt0pl2VD3Gn/r/98/oHRvnUWnJfszSRzQ7MZQA
         vS7e3QEPKpv1REo9Bkop3ko14AkrqzmsIXbx8H9NG6uofFj71C3OeckuMxth1lAhTB
         wZxbdqBaXDuWdUxbjTDWOtieZP47OhsfedKBdHqKdVIfrgjIxz4gRk9xmtSU2OeZQb
         fAem4EPNVzccTgSmlPLVyCIlfrFN9KGUA7U4LBTOR9KNOAad+DKkHfjKLv7aQ6DVHW
         HgimLSM0teedA==
Date:   Sat, 17 Dec 2022 12:06:51 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] fuzzy: don't fail on compressed metadumps
Message-ID: <Y54hW+ecHDNtC7M9@magnolia>
References: <167096070957.1750373.5715692265711468248.stgit@magnolia>
 <167096073394.1750373.2942809607367883189.stgit@magnolia>
 <20221217070329.holhjbwq6xcjrgsa@zlang-mailbox>
 <20221217103333.knedx24lltmnodxq@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221217103333.knedx24lltmnodxq@zlang-mailbox>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Dec 17, 2022 at 06:33:33PM +0800, Zorro Lang wrote:
> On Sat, Dec 17, 2022 at 03:03:29PM +0800, Zorro Lang wrote:
> > On Tue, Dec 13, 2022 at 11:45:33AM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > This line in __scratch_xfs_fuzz_mdrestore:
> > > 
> > > 	test -e "${POPULATE_METADUMP}"
> > > 
> > > Breaks spectacularly on a setup that uses DUMP_COMPRESSOR to compress
> > > the metadump files, because the metadump files get the compression
> > > program added to the name (e.g. "${POPULATE_METADUMP}.xz").  The check
> > > is wrong, and since the naming policy is an implementation detail of
> > > _xfs_mdrestore, let's get rid of the -e test.
> > > 
> > > However, we still need a way to fail the test if the metadump cannot be
> > > restored.  _xfs_mdrestore returns nonzero on failure, so use that
> > > instead.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > 
> > Looks good to me,
> > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > 
> > >  common/fuzzy |    5 ++---
> > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > > 
> > > 
> > > diff --git a/common/fuzzy b/common/fuzzy
> > > index e634815eec..49c850f2d5 100644
> > > --- a/common/fuzzy
> > > +++ b/common/fuzzy
> > > @@ -156,10 +156,9 @@ __scratch_xfs_fuzz_unmount()
> > >  # Restore metadata to scratch device prior to field-fuzzing.
> > >  __scratch_xfs_fuzz_mdrestore()
> > >  {
> > > -	test -e "${POPULATE_METADUMP}" || _fail "Need to set POPULATE_METADUMP"
> > > -
> > >  	__scratch_xfs_fuzz_unmount
> > > -	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" compress
> > > +	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" compress || \
> 
> FYI, I've also removed the "compress" parameter according to:
>   [PATCH v1.1 3/4] common/populate: move decompression code to _{xfs,ext4}_mdrestore
> When I merged this patch.

Thank you!  Sorry for the mess. :/

--D

> > > +		_fail "${POPULATE_METADUMP}: Could not find metadump to restore?"
> > >  }
> > >  
> > >  __fuzz_notify() {
> > > 
> 
