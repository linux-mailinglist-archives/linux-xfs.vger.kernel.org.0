Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07BD4B05B0
	for <lists+linux-xfs@lfdr.de>; Thu, 10 Feb 2022 06:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbiBJFpo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 10 Feb 2022 00:45:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiBJFpo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Feb 2022 00:45:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB6F13B;
        Wed,  9 Feb 2022 21:45:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEF9261C2A;
        Thu, 10 Feb 2022 05:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F86DC004E1;
        Thu, 10 Feb 2022 05:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644471945;
        bh=wIMwoFokzxieggVxNlS0sjpR3zxkl7FFDhk9hd5icCs=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=YplwMkfWUz5CcGtetd/ys4VegrDc+QcOBZNTulHRq5lpsCiWRXbBfpfa+KJ2dAFcx
         3HSzN9Adic0X5sIn7UemeZuAPCa78GvgWyEME4L8op/9smFolM4BmdQ7pt1B5aCxUt
         l8GnA/mF+TtazNS/gXLQ5TI/r4UJhq1bLQPkfqRj8sO7tENBnqhOOnJg1Xm0MvrMxK
         jryiRfxpoH7Z/Bi/cs4DmZja1/ImYOVtdg5WgRTZl96Jxlqlw8BJlrOIMC/+kY3CtJ
         i/M0SEDyFA9IOCkofX2lueuxywsvUyn44kCRWJ02iMJXZ0EgamqYLxkxzEMJWi6nKF
         OxHZX8LPgp2xw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 012AE5C0440; Wed,  9 Feb 2022 21:45:44 -0800 (PST)
Date:   Wed, 9 Feb 2022 21:45:44 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org,
        Ian Kent <raven@themaw.net>, rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <20220210054544.GI4285@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220125224551.GQ59729@dread.disaster.area>
 <YfIdVq6R6xEWxy0K@zeniv-ca.linux.org.uk>
 <20220127052609.GR59729@dread.disaster.area>
 <YfLsBdPBSsyPFgHJ@bfoster>
 <20220128213911.GO4285@paulmck-ThinkPad-P17-Gen-1>
 <Yffioz+t9cjZbIBv@bfoster>
 <20220201220028.GH4285@paulmck-ThinkPad-P17-Gen-1>
 <YgEe21z+WUvpQa0N@bfoster>
 <20220207163621.GC4285@paulmck-ThinkPad-P17-Gen-1>
 <20220210040917.GN59729@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210040917.GN59729@dread.disaster.area>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 10, 2022 at 03:09:17PM +1100, Dave Chinner wrote:
> On Mon, Feb 07, 2022 at 08:36:21AM -0800, Paul E. McKenney wrote:
> > On Mon, Feb 07, 2022 at 08:30:03AM -0500, Brian Foster wrote:
> > Another approach is to use SLAB_TYPESAFE_BY_RCU.  This allows immediate
> > reuse of freed memory, but also requires pointer traversals to the memory
> > to do a revalidation operation.  (Sorry, no free lunch here!)
> 
> Can't do that with inodes - newly allocated/reused inodes have to go
> through inode_init_always() which is the very function that causes
> the problems we have now with path-walk tripping over inodes in an
> intermediate re-initialised state because we recycled it inside a
> RCU grace period.

So not just no free lunch, but this is also not a lunch that is consistent
with the code's dietary restrictions.

From what you said earlier in this thread, I am guessing that you have
some other fix in mind.

							Thanx, Paul
