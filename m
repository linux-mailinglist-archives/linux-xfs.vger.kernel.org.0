Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBFB5A2B95
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Aug 2022 17:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344645AbiHZPsZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 26 Aug 2022 11:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344656AbiHZPsN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Aug 2022 11:48:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038DDC6CEF
        for <linux-xfs@vger.kernel.org>; Fri, 26 Aug 2022 08:47:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C49F61F30
        for <linux-xfs@vger.kernel.org>; Fri, 26 Aug 2022 15:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE2DC433D6;
        Fri, 26 Aug 2022 15:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661528855;
        bh=+muvEWQcWOKTEGZomygsPhOz8KOXmKpV5SddX+hb78I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FJqFz6duY/wggcuY2goD3Vcs2W6j6+bAzFfcDtIfmlv/jjXM4HRDG1uYhzC1Qj9ZO
         R7+jZM7V3VwslQ0bRVmX9fGxhUK53reSe/aqfxh2CeuDc5KZ5RIkAV9EQJ72Giu4Ks
         hPj6h8wl4qU/UYQJrZtOgPhmXQT61CC2SmumPxEJiN3HYFTmC3mUklkA3AUHo+a/ra
         i10d5qvtn766rnXYhfLgbGaEyVGMBiYScOs5tcsiGQfUgQr0nOW/Ogi8G/x9LAdVdG
         NU9lEXBVvIlFUTHYM8CCbxvNSQA0BgLXibl3B6DT2lD5SjxuQxM60IgsyLASv2CWmn
         M8HDRqK4wttUA==
Date:   Fri, 26 Aug 2022 08:47:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: background AIL push targets physical space, not
 grant space
Message-ID: <YwjrFwUGdhHlvfaU@magnolia>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-4-david@fromorbit.com>
 <YwPSMwmcyAZfIe3M@magnolia>
 <20220823020103.GN3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823020103.GN3600936@dread.disaster.area>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 23, 2022 at 12:01:03PM +1000, Dave Chinner wrote:
> On Mon, Aug 22, 2022 at 12:00:03PM -0700, Darrick J. Wong wrote:
> > On Wed, Aug 10, 2022 at 09:03:47AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Currently the AIL attempts to keep 25% of the "log space" free,
> > > where the current used space is tracked by the reserve grant head.
> > > That is, it tracks both physical space used plus the amount reserved
> > > by transactions in progress.
> > > 
> > > When we start tail pushing, we are trying to make space for new
> > > reservations by writing back older metadata and the log is generally
> > > physically full of dirty metadata, and reservations for modifications
> > > in flight take up whatever space the AIL can physically free up.
> > > 
> > > Hence we don't really need to take into account the reservation
> > > space that has been used - we just need to keep the log tail moving
> > > as fast as we can to free up space for more reservations to be made.
> > > We know exactly how much physical space the journal is consuming in
> > > the AIL (i.e. max LSN - min LSN) so we can base push thresholds
> > > directly on this state rather than have to look at grant head
> > > reservations to determine how much to physically push out of the
> > > log.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > 
> > Makes sense, I think.  Though I was wondering about the last patch --
> > pushing the AIL until it's empty when a trans_alloc can't find grant
> > reservation could take a while on a slow storage.
> 
> The push in the grant reservation code is not a blocking push - it
> just tells the AIL to start pushing everything, then it goes to
> sleep waiting for the tail to move and space to come available. The
> AIL behaviour is largely unchanged, especially if the application is
> running under even slight memory pressure as the inode shrinker will
> repeatedly kick the AIL push-all trigger regardless of consumed
> journal/grant space.

Ok.

> > Does this mean that
> > we're trading the incremental freeing-up of the existing code for
> > potentially higher transaction allocation latency in the hopes that more
> > threads can get reservation?  Or does the "keep the AIL going" bits make
> > up for that?
> 
> So far I've typically measured slightly lower worst case latencies
> with this mechanism that with the existing "repeatedly push to 25%
> free" that we currently have. It's not really significant enough to
> make statements about (unlike cpu usage reductions or perf
> increases), but it does seem to be a bit better...

<nod>

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
