Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8EA51954D
	for <lists+linux-xfs@lfdr.de>; Wed,  4 May 2022 04:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbiEDCEl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 3 May 2022 22:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344087AbiEDCEe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 22:04:34 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC8E146B13
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 18:49:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 446FC10E62D5;
        Wed,  4 May 2022 11:49:29 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nm48v-007jta-2L; Wed, 04 May 2022 11:49:29 +1000
Date:   Wed, 4 May 2022 11:49:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: intent item whiteouts
Message-ID: <20220504014929.GF1098723@dread.disaster.area>
References: <20220503221728.185449-1-david@fromorbit.com>
 <20220503221728.185449-11-david@fromorbit.com>
 <20220503225009.GE8265@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503225009.GE8265@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6271dbaa
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=jDrtCpy_rNN_5xVklIgA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 03, 2022 at 03:50:09PM -0700, Darrick J. Wong wrote:
> On Wed, May 04, 2022 at 08:17:28AM +1000, Dave Chinner wrote:
> > @@ -985,6 +993,13 @@ xlog_cil_build_lv_chain(
> >  
> >  		item = list_first_entry(&cil->xc_cil,
> >  					struct xfs_log_item, li_cil);
> > +
> > +		if (test_bit(XFS_LI_WHITEOUT, &item->li_flags)) {
> > +			list_move(&item->li_cil, whiteouts);
> > +			trace_xfs_cil_whiteout_skip(item);
> > +			continue;
> > +		}
> > +
> >  		list_del_init(&item->li_cil);
> >  		if (!ctx->lv_chain)
> >  			ctx->lv_chain = item->li_lv;
> > @@ -1000,6 +1015,19 @@ xlog_cil_build_lv_chain(
> >  	}
> >  }
> >  
> > +static void
> > +xlog_cil_push_cleanup_whiteouts(
> 
> Pushing cleanup whiteouts?
> 
> Oh, clean up whiteouts as part of pushing CIL.
> 
> I almost want to ask for a comment here:
> 
> /* Remove log items from the CIL that have been elided from the checkpoint. */
> static void
> xlog_cil_push_cleanup_whiteouts(
> 
> But fmeh, aside from my own momentary confusion this isn't that big of a
> deal.

Oh, fair comment - it's not consistent with other helpers that
are just named xlog_cil_<thing>, like xlog_cil_build_lv_chain().

I dropped the "push" out of the name.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
