Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D68652290C
	for <lists+linux-xfs@lfdr.de>; Wed, 11 May 2022 03:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237260AbiEKBiz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 May 2022 21:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbiEKBiy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 21:38:54 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 52FB1260863
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 18:38:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7493010E6A5F;
        Wed, 11 May 2022 11:38:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nobJT-00AVmx-DW; Wed, 11 May 2022 11:38:51 +1000
Date:   Wed, 11 May 2022 11:38:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/18] xfs: separate out initial attr_set states
Message-ID: <20220511013851.GD1098723@dread.disaster.area>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-6-david@fromorbit.com>
 <20220510231234.GI27195@magnolia>
 <20220511010651.GZ1098723@dread.disaster.area>
 <20220511010848.GB27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511010848.GB27195@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=627b13ac
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=vS09GEP_iI6d4CcACJ0A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 10, 2022 at 06:08:48PM -0700, Darrick J. Wong wrote:
> On Wed, May 11, 2022 at 11:06:51AM +1000, Dave Chinner wrote:
> > On Tue, May 10, 2022 at 04:12:34PM -0700, Darrick J. Wong wrote:
> > > On Mon, May 09, 2022 at 10:41:25AM +1000, Dave Chinner wrote:
> > > > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > > > index c9c867e3406c..ad52b5dc59e4 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr.h
> > > > +++ b/fs/xfs/libxfs/xfs_attr.h
> > > > @@ -530,4 +553,35 @@ void xfs_attri_destroy_cache(void);
> > > >  int __init xfs_attrd_init_cache(void);
> > > >  void xfs_attrd_destroy_cache(void);
> > > >  
> > > > +/*
> > > > + * Check to see if the attr should be upgraded from non-existent or shortform to
> > > > + * single-leaf-block attribute list.
> > > > + */
> > > > +static inline bool
> > > > +xfs_attr_is_shortform(
> > > > +	struct xfs_inode    *ip)
> > > > +{
> > > > +	return ip->i_afp->if_format == XFS_DINODE_FMT_LOCAL ||
> > > > +	       (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
> > > > +		ip->i_afp->if_nextents == 0);
> > > > +}
> > > > +
> > > > +static inline enum xfs_delattr_state
> > > > +xfs_attr_init_add_state(struct xfs_da_args *args)
> > > > +{
> > > > +	if (!args->dp->i_afp)
> > > > +		return XFS_DAS_DONE;
> > > 
> > > If we're in add/replace attr call without an attr fork, why do we go
> > > straight to finished?
> > 
> > I suspect I've fixed all the issues that triggered crashes here
> > because args->dp->i_afp was null. THere were transient states in a
> > replace operaiton when the remove takes away the last attr, removes
> > the attr fork, then calls the ADD operation. The add operation
> > assumes that the attr fork has already been set up, and so bad
> > things happened here.
> > 
> > This also occurred when setting up recovery operations - recovery of
> > an add/replace could start from that same "there's no attr fork"
> > condition, and so calling xfs_inode_has_attr() or
> > xfs_attr_is_shortform() direct from the reocovery setup code would
> > go splat because ip->i_afp was null.
> > 
> > I'm going to leave this for the moment (cleanup note made) because I
> > don't want to have to find out that I missed a corner case somewhere
> > they hard way right now. It's basically there to stop log recovery
> > crashing hard, which only occurs when the experimental larp code is
> > running, so I think this is safe to leave for a later cleanup.
> 
> Hmm, in that case, can this become:
> 
> 	if (!args->dp->i_afp) {
> 		ASSERT(0);
> 		return XFS_DAS_DONE;
> 	}

OK.

> And then you can add:
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
