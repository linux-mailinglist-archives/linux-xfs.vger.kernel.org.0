Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34C1685741
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Aug 2019 02:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389185AbfHHAbe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Aug 2019 20:31:34 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33714 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389044AbfHHAbe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Aug 2019 20:31:34 -0400
Received: from dread.disaster.area (pa49-181-167-148.pa.nsw.optusnet.com.au [49.181.167.148])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 0D0FA43D7FF;
        Thu,  8 Aug 2019 10:31:32 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hvWK1-0006q9-3L; Thu, 08 Aug 2019 10:30:25 +1000
Date:   Thu, 8 Aug 2019 10:30:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] [Regression, v5.0] mm: boosted kswapd reclaim b0rks
 system cache balance
Message-ID: <20190808003025.GU7777@dread.disaster.area>
References: <20190807091858.2857-1-david@fromorbit.com>
 <20190807093056.GS11812@dhcp22.suse.cz>
 <20190807150316.GL2708@suse.de>
 <20190807220817.GN7777@dread.disaster.area>
 <20190807235534.GK2739@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807235534.GK2739@techsingularity.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=gu9DDhuZhshYSb5Zs/lkOA==:117 a=gu9DDhuZhshYSb5Zs/lkOA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=InmijoeHuMX5d2-jVp4A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 08, 2019 at 12:55:34AM +0100, Mel Gorman wrote:
> On Thu, Aug 08, 2019 at 08:08:17AM +1000, Dave Chinner wrote:
> > On Wed, Aug 07, 2019 at 04:03:16PM +0100, Mel Gorman wrote:
> > > On Wed, Aug 07, 2019 at 11:30:56AM +0200, Michal Hocko wrote:
> > > The boosting was not intended to target THP specifically -- it was meant
> > > to help recover early from any fragmentation-related event for any user
> > > that might need it. Hence, it's not tied to THP but even with THP
> > > disabled, the boosting will still take effect.
> > > 
> > > One band-aid would be to disable watermark boosting entirely when THP is
> > > disabled but that feels wrong. However, I would be interested in hearing
> > > if sysctl vm.watermark_boost_factor=0 has the same effect as your patch.
> > 
> > <runs test>
> > 
> > Ok, it still runs it out of page cache, but it doesn't drive page
> > cache reclaim as hard once there's none left. The IO patterns are
> > less peaky, context switch rates are increased from ~3k/s to 15k/s
> > but remain pretty steady.
> > 
> > Test ran 5s faster and  file rate improved by ~2%. So it's better
> > once the page cache is largerly fully reclaimed, but it doesn't
> > prevent the page cache from being reclaimed instead of inodes....
> > 
> 
> Ok. Ideally you would also confirm the patch itself works as you want.
> It *should* but an actual confirmation would be nice.

Yup, I'll get to that later today.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
