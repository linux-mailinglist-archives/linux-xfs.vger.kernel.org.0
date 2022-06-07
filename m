Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52ED53203E
	for <lists+linux-xfs@lfdr.de>; Tue, 24 May 2022 03:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiEXBUo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 23 May 2022 21:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbiEXBUm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 21:20:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A2A996B0
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 18:20:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C554EB8170D
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 01:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA3FC385AA;
        Tue, 24 May 2022 01:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653355230;
        bh=XYBGaQZgsP5jprP82V2clRKrE9W1lT8Vy0R6ouQjcLU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aMsnQmUMwKWBVVoMAwp8YHquaaqT/Otj46pLv5c/OSsYK1osjynbv1ynl9akd/7x7
         LbiOHBzm4LzcqlHoEKJ6SF3NUw2AzHIPXnCQCWQL0YseA+SLFTcFCAfmiWUIOZzmiq
         IU59QSaQmDCjRDhvZGvr649CD5OucVZ5TRwv7Bl2bQnKeXz/Couxlt3LSXoYBw4Xln
         YyOwxpzs2do9JkzONDhnHcsRJjHRNwnvtjDGy36+xWUuQ7s2yF4DWPNn9O8y36dfWy
         2LZKrNMdMrE2edb0ruh4uYfNPwBH/lOQkk4Zp+oJkdZqkCRi9u+P6/S6HjJ7dgn07N
         Lhsd/wcxJ7LbA==
Date:   Mon, 23 May 2022 18:20:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 5/5] xfs: move xfs_attr_use_log_assist out of libxfs
Message-ID: <Yowy3tivGW1WLwb3@magnolia>
References: <165323329374.78886.11371349029777433302.stgit@magnolia>
 <165323332197.78886.8893427108008735872.stgit@magnolia>
 <20220523033445.GQ1098723@dread.disaster.area>
 <YovclVb71ZblumWh@magnolia>
 <20220523225643.GU1098723@dread.disaster.area>
 <YowoXHly0w/kmKv2@magnolia>
 <20220524010249.GX1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524010249.GX1098723@dread.disaster.area>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 11:02:49AM +1000, Dave Chinner wrote:
> On Mon, May 23, 2022 at 05:35:40PM -0700, Darrick J. Wong wrote:
> > On Tue, May 24, 2022 at 08:56:43AM +1000, Dave Chinner wrote:
> > > On Mon, May 23, 2022 at 12:12:21PM -0700, Darrick J. Wong wrote:
> > > > On Mon, May 23, 2022 at 01:34:45PM +1000, Dave Chinner wrote:
> > > > > On Sun, May 22, 2022 at 08:28:42AM -0700, Darrick J. Wong wrote:
> > > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > > 
> > > > > > libxfs itself should never be messing with whether or not to enable
> > > > > > logging for extended attribute updates -- this decision should be made
> > > > > > on a case-by-case basis by libxfs callers.  Move the code that actually
> > > > > > enables the log features to xfs_xattr.c, and adjust the callers.
> > > > > > 
> > > > > > This removes an awkward coupling point between libxfs and what would be
> > > > > > libxlog, if the XFS log were actually its own library.  Furthermore, it
> > > > > > makes bulk attribute updates and inode security initialization a tiny
> > > > > > bit more efficient, since they now avoid cycling the log feature between
> > > > > > every single xattr.
> > > > > > 
> > > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > > ---
> > > > > >  fs/xfs/libxfs/xfs_attr.c |   12 +-------
> > > > > >  fs/xfs/xfs_acl.c         |   10 +++++++
> > > > > >  fs/xfs/xfs_ioctl.c       |   22 +++++++++++++---
> > > > > >  fs/xfs/xfs_ioctl.h       |    2 +
> > > > > >  fs/xfs/xfs_ioctl32.c     |    4 ++-
> > > > > >  fs/xfs/xfs_iops.c        |   25 ++++++++++++++----
> > > > > >  fs/xfs/xfs_log.c         |   45 --------------------------------
> > > > > >  fs/xfs/xfs_log.h         |    1 -
> > > > > >  fs/xfs/xfs_super.h       |    2 +
> > > > > >  fs/xfs/xfs_xattr.c       |   65 ++++++++++++++++++++++++++++++++++++++++++++++
> > > > > >  10 files changed, 120 insertions(+), 68 deletions(-)
> > > > > 
> > > > > This seems like the wrong way to approach this. I would have defined
> > > > > a wrapper function for xfs_attr_set() to do the log state futzing,
> > > > > not moved it all into callers that don't need (or want) to know
> > > > > anything about how attrs are logged internally....
> > > > 
> > > > I started doing this, and within a few hours realized that I'd set upon
> > > > yet *another* refactoring of xfs_attr_set.  I'm not willing to do that
> > > > so soon after Allison's refactoring, so I'm dropping this patch.
> > > 
> > > I don't see why this ends up being a problem - xfs_attr_set() is
> > > only called by code in fs/xfs/*.c, so adding a wrapper function
> > > that just does this:
> > > 
> > > int
> > > xfs_attr_change(
> > > 	struct xfs_da_args      *args)
> > > {
> > > 	struct xfs_mount	*mp = args->dp->i_mount;
> > > 
> > > 	if (xfs_has_larp(mp)) {
> > > 		error = xfs_attr_use_log_assist(mp);
> > > 		if (error)
> > > 			return error;
> > > 	}
> > > 
> > > 	error = xfs_attr_set(args);
> > > 	if (xfs_has_larp(mp))
> > 
> > Race condition here ^^^ if we race with someone changing the debug knob,
> > we'll either drop something we never took, or leak something we did
> > take.
> 
> True, but largely irrelevant for the purposes of demonstration....
> 
> > 
> > > 		xlog_drop_incompat_feat(mp->m_log);
> > > 	return error;
> > > }
> > > 
> > > into one of the files in fs/xfs will get this out of libxfs, won't
> > > it?
> > > 
> > > What am I missing here?
> > 
> > After the last year and a half I've gotten in the bad habit of trying to
> > anticipate the likely style objections of various reviewers to try to
> > get patches into upstream with as few objections as possible, which then
> > leads me down the path of more and more scope creep from the voices
> > inside my head:
> > 
> > "These cleanups should be split into smaller changes for easy
> > backporting."
> >
> > "Setting xattr arguments via the da_args struct is a mess, make them
> > function parameters."
> > 
> > "It's nasty to have xfs_attr_change take 7 parameters, just make an
> > xfs_attrchange_args struct with the pieces we need, and use it to fill
> > out the da args internally."
> > 
> > "These calling conventions are still crap, transaction allocation
> > shouldn't even be in libxfs at all!"
> > 
> > "Why don't you make attr_change have its own flags namespace, and then
> > set attr_filter and attr_flags from that?  This would decouple the
> > interfaces and make them easier to figure out next time."
> > 
> > "There are too many little xfs_attr functions and it's really hard to
> > grok what they all do."
> 
> Yes, I understand that we need to re-layer the attr code to get rid
> of all the twisty passages that are all alike, but we don't need to
> do that right now and it avoids tying a simple change up in knots
> that prevent progress from being made.
> 
> [FWIW, I have a basic plan for that - split all the sf/leaf/node
> stuff out of xfs_attr_leaf.c into xfs_attr_sf/leaf/node.c, move all
> the sf/leaf/node add/remove/change/lookup stuff out of xfs_attr.c
> into the above files. High level API is in xfs_attr.c (same as
> xfs_dir.c for directories) and everything external interfaces with
> that API. Which we can then tailor to just the information needed
> to set up attr and da_args inside xfs_attr.c....
> 
> Then we can start cleaning up all the internal attr APIs, fix all
> the whacky quirks like sf add will do a remove if it's actually a
> replace, clean up the lookup interfaces, etc. ]
> 
> > OTOH if you'd be willing to take just that attr_change bit above (with
> > the race condition fixed, I *would* send you that in patch form.
> 
> Yes, I think that's just fine. Simple is often best...

Ok.  Since I only just noticed the for-next update, I'll rebase on that,
make this change, and send that out for testing overnight.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
