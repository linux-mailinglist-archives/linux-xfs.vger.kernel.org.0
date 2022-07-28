Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4135836AE
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Jul 2022 04:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbiG1CIA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 27 Jul 2022 22:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234722AbiG1CH7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jul 2022 22:07:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E065924B;
        Wed, 27 Jul 2022 19:07:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C773B822C1;
        Thu, 28 Jul 2022 02:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C73C433D6;
        Thu, 28 Jul 2022 02:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658974076;
        bh=mPizJS500MSP0cYU5EZTgLeMH7tOxjxjyl++9Q65tl8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TKJQV528VCf18A5MrzMbH3py4xXacr6zjv3P6rGeab2smnuHzl3jsIKb26kVT163X
         K090QzoUJ3FjZ76S4sf5zoPlAMu+qOj56M11tbzlU+kSP+RyMnJhhPBwu+CdtwqcrS
         L3poMIh4JOhdANT3cJzJL5EPe22lNfqXCRrNwv4OJOwZGDWocs03V3u62/tkN3Yao9
         0jn6WUF+6SDSQiZqUq99+hQUgjOkNN0CI3p3clCrHztCNdzfdyUvoCEIiPgj8QxABT
         aU1O7CD8Q2FblW86cKv7rou3iqk7os7D1BYeQDbMrVpEzv8GkhVLMf5MopdgofzSpV
         QlN7nNuroY0NA==
Date:   Wed, 27 Jul 2022 19:07:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 5.10 CANDIDATE 0/9] xfs stable candidate patches for
 5.10.y (from v5.13+)
Message-ID: <YuHve9LEkM7nmbUJ@magnolia>
References: <20220726092125.3899077-1-amir73il@gmail.com>
 <CAOQ4uxi=VYa+86A7G3wqCX84n2Aezx2mYqfYrFTAVtSpYmeq_Q@mail.gmail.com>
 <YuHt65YWtkqLxlpv@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuHt65YWtkqLxlpv@magnolia>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 27, 2022 at 07:01:15PM -0700, Darrick J. Wong wrote:
> On Wed, Jul 27, 2022 at 09:17:47PM +0200, Amir Goldstein wrote:
> > On Tue, Jul 26, 2022 at 11:21 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > Darrick,
> > >
> > > This backport series contains mostly fixes from v5.14 release along
> > > with three deferred patches from the joint 5.10/5.15 series [1].
> > >
> > > I ran the auto group 10 times on baseline (v5.10.131) and this series
> > > with no observed regressions.
> > >
> > > I ran the recoveryloop group 100 times with no observed regressions.
> > > The soak group run is in progress (10+) with no observed regressions
> > > so far.
> > >
> > > I am somewhat disappointed from not seeing any improvement in the
> > > results of the recoveryloop tests comapred to baseline.
> > >
> > > This is the summary of the recoveryloop test results on both baseline
> > > and backport branch:
> > >
> > > generic,455, generic/457, generic/646: pass
> > > generic/019, generic/475, generic/648: failing often in all config
> 
> <nod> I posted a couple of patchsets to fstests@ yesterday that might
> help with these recoveryloop tests failing.
> 
> https://lore.kernel.org/fstests/165886493457.1585218.32410114728132213.stgit@magnolia/T/#t
> https://lore.kernel.org/fstests/165886492580.1585149.760428651537119015.stgit@magnolia/T/#t
> https://lore.kernel.org/fstests/165886491119.1585061.14285332087646848837.stgit@magnolia/T/#t
> 
> > > generic/388: failing often with reflink_1024
> > > generic/388: failing at ~1/50 rate for any config
> > > generic/482: failing often on V4 configs
> > > generic/482: failing at ~1/100 rate for V5 configs
> > > xfs/057: failing at ~1/200 rate for any config
> > >
> > > I observed no failures in soak group so far neither on baseline nor
> > > on backport branch. I will update when I have more results.
> > >
> > 
> > Some more results after 1.5 days of spinning:
> > 1. soak group reached 100 runs (x5 configs) with no failures
> > 2. Ran all the tests also on debian/testing with xfsprogs 5.18 and
> >     observed a very similar fail/pass pattern as with xfsprogs 5.10
> > 3. Started to run the 3 passing recoveryloop tests 1000 times and
> >     an interesting pattern emerged -
> > 
> > generic/455 failed 3 times on baseline (out of 250 runs x 5 configs),
> > but if has not failed on backport branch yet (700 runs x 5 configs).
> > 
> > And it's not just failures, it's proper data corruptions, e.g.
> > "testfile2.mark1 md5sum mismatched" (and not always on mark1)
> 
> Oh good!
> 
> 
> > 
> > I will keep this loop spinning, but I am cautiously optimistic about
> > this being an actual proof of bug fix.
> > 
> > If these results don't change, I would be happy to get an ACK for the
> > series so I can post it after the long soaking.
> 
> Patches 4-9 are an easy
> Acked-by: Darrick J. Wong <djwong@kernel.org>

I hit send too fast.

I think patches 1-3 look correct.  I still think it's sort of risky,
but your testing shows that things at least get better and don't
immediately explode or anything. :)

By my recollection of the log changes between 5.10 and 5.17 I think the
lsn/cil split didn't change all that much, so if you get to the end of
the week with no further problems then I say Acked-by for them too.

--D

> 
> 
> --D
> 
> > Thanks,
> > Amir.
