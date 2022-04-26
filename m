Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D70750F01A
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Apr 2022 07:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241360AbiDZFNL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 26 Apr 2022 01:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbiDZFNK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 01:13:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95461C5
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 22:10:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89C6860DDD
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 05:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC305C385A4;
        Tue, 26 Apr 2022 05:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650949801;
        bh=9r5dJJyztCUKRvaq+0SToM2qRG4BnNGVFquDfCAIFgo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TfGqvDyVZjY3GLrGkoGt/ZULfOX22HmiReoRqrM/bFfEBGDekefls7XZuv66kvxa0
         j6GiqN2cNAx0/NSfj8Vfgkq7vO1TSVdjSVCEuqaLjsolebmp6ndY4EhQVVDJCbp20C
         5CjELTP79ewp30SRE9Q5AKyoBAmlc1j/7ZLt4Fv/IxiOFNQreM8TX72W9Au1L4jd8G
         QwgP7lzuao8VS4wm1ddjmSpcgA4zKzxLCoe7GgY5Pcl8FWybyiHeyicBK2kowiNWMs
         a5XKBFH2Ejq739C59cbi58sx4PBg8Sx1e7aNWU4MS06XQqs2nM7gEixUVn0/LCGPk+
         U9fWrRu1KfHKQ==
Date:   Mon, 25 Apr 2022 22:10:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: create shadow transaction reservations for
 computing minimum log size
Message-ID: <20220426051001.GS17025@magnolia>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
 <164997688275.383881.1038640482191339784.stgit@magnolia>
 <20220422223635.GC1544202@dread.disaster.area>
 <20220425233905.GN17025@magnolia>
 <20220426042444.GL1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426042444.GL1544202@dread.disaster.area>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 02:24:44PM +1000, Dave Chinner wrote:
> On Mon, Apr 25, 2022 at 04:39:05PM -0700, Darrick J. Wong wrote:
> > On Sat, Apr 23, 2022 at 08:36:35AM +1000, Dave Chinner wrote:
> > > On Thu, Apr 14, 2022 at 03:54:42PM -0700, Darrick J. Wong wrote:
> ....
> > > > @@ -47,18 +48,25 @@ xfs_log_get_max_trans_res(
> > > >  	struct xfs_trans_res	*max_resp)
> > > >  {
> > > >  	struct xfs_trans_res	*resp;
> > > > +	struct xfs_trans_res	*start_resp;
> > > >  	struct xfs_trans_res	*end_resp;
> > > > +	struct xfs_trans_resv	*resv;
> > > >  	int			log_space = 0;
> > > >  	int			attr_space;
> > > >  
> > > >  	attr_space = xfs_log_calc_max_attrsetm_res(mp);
> > > >  
> > > > -	resp = (struct xfs_trans_res *)M_RES(mp);
> > > > -	end_resp = (struct xfs_trans_res *)(M_RES(mp) + 1);
> > > > -	for (; resp < end_resp; resp++) {
> > > > +	resv = kmem_zalloc(sizeof(struct xfs_trans_resv), 0);
> > > > +	xfs_trans_resv_calc_logsize(mp, resv);
> > > > +
> > > > +	start_resp = (struct xfs_trans_res *)resv;
> > > > +	end_resp = (struct xfs_trans_res *)(resv + 1);
> > > > +	for (resp = start_resp; resp < end_resp; resp++) {
> > > >  		int		tmp = resp->tr_logcount > 1 ?
> > > >  				      resp->tr_logres * resp->tr_logcount :
> > > >  				      resp->tr_logres;
> > > > +
> > > > +		trace_xfs_trans_resv_calc_logsize(mp, resp - start_resp, resp);
> > > >  		if (log_space < tmp) {
> > > >  			log_space = tmp;
> > > >  			*max_resp = *resp;		/* struct copy */
> > > 
> > > This took me a while to get my head around. The minimum logsize
> > > calculation stuff is all a bit of a mess.
> > > 
> > > Essentially, we call xfs_log_get_max_trans_res() from two places.
> > > One is to calculate the minimum log size, the other is the
> > > transaction reservation tracing code done when M_RES(mp) is set up
> > > via xfs_trans_trace_reservations().  We don't need the call from
> > > xfs_trans_trace_reservations() - it's trivial to scan the list of
> > > tracepoints emitted by this function at mount time to find the
> > > maximum reservation.
> > 
> > Here's the thing -- xfs_db also calls xfs_log_get_max_trans_res to
> > figure out the transaction reservation that's used to compute the
> > minimum log size.  Whenever I get a report about mount failing due to
> > minlogsize checks, I can ask the reporter to send me the ftrace output
> > from the mount attempt and compare it against what userspace thinks:
> > 
> > # xfs_db /dev/sde -c logres
> > type 0 logres 168184 logcount 5 flags 0x4
> > type 1 logres 293760 logcount 5 flags 0x4
> > type 2 logres 307936 logcount 2 flags 0x4
> > type 3 logres 187760 logcount 2 flags 0x4
> > type 4 logres 170616 logcount 2 flags 0x4
> > type 5 logres 244720 logcount 3 flags 0x4
> > type 6 logres 243568 logcount 2 flags 0x4
> > type 7 logres 260352 logcount 2 flags 0x4
> > type 8 logres 243568 logcount 3 flags 0x4
> > type 9 logres 278648 logcount 2 flags 0x4
> > type 10 logres 2168 logcount 0 flags 0x0
> > type 11 logres 73728 logcount 2 flags 0x4
> > type 12 logres 99960 logcount 2 flags 0x4
> > type 13 logres 760 logcount 0 flags 0x0
> > type 14 logres 292992 logcount 1 flags 0x4
> > type 15 logres 23288 logcount 3 flags 0x4
> > type 16 logres 13312 logcount 0 flags 0x0
> > type 17 logres 147584 logcount 3 flags 0x4
> > type 18 logres 640 logcount 0 flags 0x0
> > type 19 logres 94968 logcount 2 flags 0x4
> > type 20 logres 4224 logcount 0 flags 0x0
> > type 21 logres 6512 logcount 0 flags 0x0
> > type 22 logres 232 logcount 1 flags 0x0
> > type 23 logres 172407 logcount 5 flags 0x4
> > type 24 logres 640 logcount 1 flags 0x0
> > type 25 logres 760 logcount 0 flags 0x0
> > type 26 logres 243568 logcount 2 flags 0x4
> > type 27 logres 170616 logcount 2 flags 0x4
> > type -1 logres 547200 logcount 8 flags 0x4
> > 
> > And this "-1" entry matches the last output of the kernel.
> 
> I look at that and thing "xfs_db output is broken" because that last
> line cannot be derived from the individual transaction reservations
> that are listed. It makes no sense in isolation/without
> documentation. :/
> 
> > I'd rather
> > not lose this tracing facility (which means keeping this function
> > non-static) though I will move the tracepoint out of
> > xfs_trans_trace_reservations.
> 
> You mean "remove only the '-1' tracepoint" from
> xfs_trans_trace_reservations()?

Rework into a better tracepoint?

	xfs_minlogblocks_trans_resv: logres 547200 logcount 8 flags 0x4

Or something like that.  I don't think we actually care about flags
there.

> > > Hence I think we should start by removing that call to this
> > > function, and making this a static function called only from
> > > xfs_log_calc_minimum_size().
> > > 
> > > At this point, we can use an on-stack struct xfs_trans_resv for the
> > > calculated values - no need for memory allocation here as we will
> > > never be short of stack space in this path.
> > 
> > ~312 bytes?  That's ~8% of the kernel stack.  I'll see if I run into any
> > complaints, though I bet I won't on x64.
> 
> What architecture still uses 4kB stacks?  Filesystems have blown
> through 4kB stacks without even trying on 32bit systems for years
> now.

I doubt they /all/ have larger stacks, though it might simply be the
case that we don't care about supporting the long tail of small machines
(h8300 anyone?) that Linux supports.

> Regardless, the mount path call chain here is nowhere near deep
> enough to be at risk of blowing stacks, and this is at the leaf so
> it's largely irrelevant if we put this on the stack...

<nod> I'm not expecting to see any problems.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
