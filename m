Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A6B7224D
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jul 2019 00:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387696AbfGWWWz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Jul 2019 18:22:55 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58419 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727821AbfGWWWy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jul 2019 18:22:54 -0400
Received: from dread.disaster.area (pa49-195-139-63.pa.nsw.optusnet.com.au [49.195.139.63])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B095A2AD85A;
        Wed, 24 Jul 2019 08:22:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hq3AE-0003mj-Ey; Wed, 24 Jul 2019 08:21:42 +1000
Date:   Wed, 24 Jul 2019 08:21:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Sheriff Esseson <sheriffesseson@gmail.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "supporter:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] Documentation: filesystem: fix "Removed Sysctls" table
Message-ID: <20190723222142.GS7689@dread.disaster.area>
References: <20190723114813.GA14870@localhost>
 <20190723074218.4532737f@lwn.net>
 <20190723145201.GA20658@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723145201.GA20658@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=fNT+DnnR6FjB+3sUuX8HHA==:117 a=fNT+DnnR6FjB+3sUuX8HHA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=0o9FgrsRnhwA:10
        a=pGLkceISAAAA:8 a=7-415B0cAAAA:8 a=rzqIo9VfzmB4bOlvi8MA:9
        a=CjuIK1q_8ugA:10 a=igBNqPyMv6gA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 23, 2019 at 03:52:01PM +0100, Sheriff Esseson wrote:
> On Tue, Jul 23, 2019 at 07:42:18AM -0600, Jonathan Corbet wrote:
> > On Tue, 23 Jul 2019 12:48:13 +0100
> > Sheriff Esseson <sheriffesseson@gmail.com> wrote:
> > 
> > > the "Removed Sysctls" section is a table - bring it alive with ReST.
> > > 
> > > Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
> > 
> > So this appears to be identical to the patch you sent three days ago; is
> > there a reason why you are sending it again now?
> > 
> > Thanks,
> > 
> > jon
> 
> Sorry, I was think the patch went unnoticed during the merge window - I could
> not find a response.

The correct thing to do in that case is to reply to the original
patch and ask if it has been looked at. The usual way of doing this
is quoting the commit message and replying with a "Ping?" comment
to bump it back to the top of everyone's mail stacks.

But, again, 3 days is not a long time, people tend to be extremely
busy and might take a few days to get to reviewing non-critical
changes, and people may not even review patches during the merge
window. I'd suggest waiting a week before pinging a patch you've
sent if there's been no response....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
