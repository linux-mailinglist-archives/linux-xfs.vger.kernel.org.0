Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D0D596B86
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Aug 2022 10:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbiHQImY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 17 Aug 2022 04:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235318AbiHQImX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Aug 2022 04:42:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CE97E813
        for <linux-xfs@vger.kernel.org>; Wed, 17 Aug 2022 01:42:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BECBBB81AD3
        for <linux-xfs@vger.kernel.org>; Wed, 17 Aug 2022 08:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AB1C433C1;
        Wed, 17 Aug 2022 08:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660725739;
        bh=DdMj46JFcqlfdXoocv20E70XbvZtS87K/Zwe/87MnpI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vLUXHm2EGuPD45VwgrGmU2PhbAg9f7QrvAxr+9lAuBQjMtf+quztUHCqo8Gsr/6Gq
         UMdd4+Wo9IjQHwQ1uGnd3yT9hhs0q4Vuyps07eGcvFiASgBUPD/R6KkNIf6GDl3wm+
         2kdaRsH8DFxQYIkN6rUaIZb7aALFEBWsHJNPfEEAouYfxiNTvR7PlskzOyQtweBkIL
         xCoTWRnmXXX6FNE5r8v3pxrzKVxe09Uagqfmr08o4W4Qq8ztr7kO+resyfCibNbfHk
         BOGxg++ekwVQefnkFdpivmkUyPWaHPAU6lfYKSTztugvdIYQbNW/ITxWkcv2DPIjUW
         wmtSZTWEOOaUw==
Date:   Wed, 17 Aug 2022 10:42:14 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsdump: Initialize getbmap structure in quantity2offset
Message-ID: <20220817084214.sk6oar5jlhae6blv@orion>
References: <166063952935.40771.5357077583333371260.stgit@orion>
 <cUd3hfyxm_FjsQ62RYGb76fd-cEtRSCtAMq3rh_nv6T8eAwScvjwPA03iMjbKZ9h4P7uDBQk7CS3upmPOsBiwg==@protonmail.internalid>
 <Yvu1h/dQi9CSft0X@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yvu1h/dQi9CSft0X@magnolia>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 16, 2022 at 08:19:35AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 16, 2022 at 10:45:50AM +0200, Carlos Maiolino wrote:
> > Prevent uninitialized data in the stack by initializing getbmap structure
> > to zero.
> 
> The kernel should fill out all the bmap[1..BMAP_LEN-1] entries, right?
> 
> The only part of the array that's critical to initialize to a known
> value is bmap[0], since that's what the kernel will read to decide what
> to do, right?
> 
> Or, zooming out a bit, why did you decide to initialize the struct?  Was
> it valgrind complaining about uninitialized ioctl memory, or did someone
> report a bug?
> 

I thought about this from a userspace perspective at first, and by pure code
inspection, not anything valgrind complained about.
The previous mentioned patch replaced getbmapx by getbmap to remove the
uninitialized bmv_iflags from the middle of bmap[0], which for sure is the most
critical part here. At the array declaration though, the first element is zeroed,
but it still leaves garbage on the remaining arrays, so, I thought it would be
wise to just zero out the whole array there without leaving uninitialized data
we might trip over in the future.

I just did a quick look from the kernel side, and if I'm not wrong, if the file
has fewer extents than the array has slots, the kernel won't touch the remaining
array entries, leaving that space uninitialized.
I don't think it's a big deal anyway, as xfsdump walk through the array based on
the returned entries.

> (I'm actually fine with this change, I just want to know how you got
> here. ;))

Just thought it as a 'better safe than sorry' kind of situation, nothing more :P

> 
> --D
> 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >
> > There is already a patch on the list to remove remaining DMAPI stuff from
> > xfsdump:
> > xfsdump: remove BMV_IF_NO_DMAPI_READ flag
> >
> > This patch though, does not initialize the getbmap structure, and although
> > the
> > first struct in the array is initialized, the remaining structures in the
> > array are not, leaving garbage in the stack.
> >
> >
> >  dump/inomap.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/dump/inomap.c b/dump/inomap.c
> > index f3200be..c4ea21d 100644
> > --- a/dump/inomap.c
> > +++ b/dump/inomap.c
> > @@ -1627,7 +1627,7 @@ static off64_t
> >  quantity2offset(jdm_fshandle_t *fshandlep, struct xfs_bstat *statp, off64_t qty)
> >  {
> >  	int fd;
> > -	struct getbmap bmap[BMAP_LEN];
> > +	struct getbmap bmap[BMAP_LEN] = {0};
> >  	off64_t offset;
> >  	off64_t offset_next;
> >  	off64_t qty_accum;
> >
> >

-- 
Carlos Maiolino
