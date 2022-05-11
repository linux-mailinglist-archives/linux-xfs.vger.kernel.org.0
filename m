Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9505228A8
	for <lists+linux-xfs@lfdr.de>; Wed, 11 May 2022 03:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239536AbiEKBJ0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 May 2022 21:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbiEKBJZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 21:09:25 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1FCA5210BB9
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 18:09:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5DEFF10E66AA;
        Wed, 11 May 2022 11:09:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1noaqx-00AVGn-2U; Wed, 11 May 2022 11:09:23 +1000
Date:   Wed, 11 May 2022 11:09:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/18] xfs: consolidate leaf/node states in
 xfs_attr_set_iter
Message-ID: <20220511010923.GA1098723@dread.disaster.area>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-8-david@fromorbit.com>
 <20220510232019.GK27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510232019.GK27195@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=627b0cc4
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=MPjw0cGrOWHthRPRFZUA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 10, 2022 at 04:20:19PM -0700, Darrick J. Wong wrote:
> On Mon, May 09, 2022 at 10:41:27AM +1000, Dave Chinner wrote:
> > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > index d016af4dbf81..37db61649217 100644
> > --- a/fs/xfs/libxfs/xfs_attr.h
> > +++ b/fs/xfs/libxfs/xfs_attr.h
> > @@ -450,16 +450,21 @@ enum xfs_delattr_state {
> >  	XFS_DAS_RMTBLK,			/* Removing remote blks */
> >  	XFS_DAS_RM_NAME,		/* Remove attr name */
> >  	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree */
> > +
> > +	/* Leaf state set sequence */
> 
> I think this comment should note that the state increment operations of
> xfs_attr_set_iter requires that the exact order of the values
> FOUND_[LN]BLK through RM_[LN]BLK must be preserved exactly.

Happens later, as you've already noticed, when....

> Question: Are we supposed to be able to dela_state++ our way from
> RM_LBLK to RD_LEAF and from RM_NBLK to CLR_FLAG?

... we are finally able to dela_state++ our way right through the
leaf/node operations.

> With that comment added,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
