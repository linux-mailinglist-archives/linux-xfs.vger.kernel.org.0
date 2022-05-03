Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4425651922F
	for <lists+linux-xfs@lfdr.de>; Wed,  4 May 2022 01:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244054AbiECXRS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 3 May 2022 19:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243437AbiECXRS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 19:17:18 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5BEA8419A9
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 16:13:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 729475344CE;
        Wed,  4 May 2022 09:13:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nm1iA-007hHU-93; Wed, 04 May 2022 09:13:42 +1000
Date:   Wed, 4 May 2022 09:13:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: detect self referencing btree sibling pointers
Message-ID: <20220503231342.GD1098723@dread.disaster.area>
References: <20220502082018.1076561-1-david@fromorbit.com>
 <20220502082018.1076561-2-david@fromorbit.com>
 <20220503225314.GF8265@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503225314.GF8265@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6271b727
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=zHb2TUICMvuGg-o49G8A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 03, 2022 at 03:53:14PM -0700, Darrick J. Wong wrote:
> On Mon, May 02, 2022 at 06:20:15PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To catch the obvious graph cycle problem and hence potential endless
> > looping.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_btree.c | 137 ++++++++++++++++++++++++++++----------
> >  1 file changed, 102 insertions(+), 35 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > index a8c79e760d8a..991fae6f500a 100644
> > --- a/fs/xfs/libxfs/xfs_btree.c
> > +++ b/fs/xfs/libxfs/xfs_btree.c
> > @@ -51,6 +51,50 @@ xfs_btree_magic(
> >  	return magic;
> >  }
> >  
> > +static xfs_failaddr_t
> 
> Minor nit: static inline?

Not necessary - the compiler will do that automatically if
optimisations are turned on (as they always are).  Modern compilers
are pretty aggressive at inlining code when they know there are no
other external references to the function.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.

-- 
Dave Chinner
david@fromorbit.com
