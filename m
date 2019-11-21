Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01399104ACD
	for <lists+linux-xfs@lfdr.de>; Thu, 21 Nov 2019 07:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfKUGok (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 21 Nov 2019 01:44:40 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60679 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726346AbfKUGoj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Nov 2019 01:44:39 -0500
Received: from dread.disaster.area (pa49-181-174-87.pa.nsw.optusnet.com.au [49.181.174.87])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 4E8913A09D0;
        Thu, 21 Nov 2019 17:44:35 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iXgCg-0006Wb-DY; Thu, 21 Nov 2019 17:44:34 +1100
Date:   Thu, 21 Nov 2019 17:44:34 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, zhangshaokun@hisilicon.com
Subject: Re: [PATCH] xfs: gut error handling in
 xfs_trans_unreserve_and_mod_sb()
Message-ID: <20191121064434.GE4614@dread.disaster.area>
References: <20191121004437.9633-1-david@fromorbit.com>
 <20191121023836.GV6219@magnolia>
 <20191121040023.GD4614@dread.disaster.area>
 <20191121045003.GX6235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121045003.GX6235@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=3v0Do7u/0+cnL2zxahI5mg==:117 a=3v0Do7u/0+cnL2zxahI5mg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=7-415B0cAAAA:8 a=5sfiy0JnNyzRjNOjCP8A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 08:50:03PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 21, 2019 at 03:00:23PM +1100, Dave Chinner wrote:
> > On Wed, Nov 20, 2019 at 06:38:36PM -0800, Darrick J. Wong wrote:
> > > On Thu, Nov 21, 2019 at 11:44:37AM +1100, Dave Chinner wrote:
> > > > -out_undo_frextents:
> > > > -	if (rtxdelta)
> > > > -		xfs_sb_mod64(&mp->m_sb.sb_frextents, -rtxdelta);
> > > > -out_undo_ifree:
> > > > +	xfs_sb_mod64(&mp->m_sb.sb_frextents, rtxdelta);
> > > 
> > > As for these bits... why even bother with a three line helper?  I think
> > > this is clearer about what's going on:
> > > 
> > > 	mp->m_sb.sb_frextents += rtxdelta;
> > > 	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
> > > 	...
> > > 	ASSERT(!rtxdelta || mp->m_sb.sb_frextents >= 0);
> > > 	ASSERT(!tp->t_dblocks_delta || mp->m_sb.sb.dblocks >= 0);
> > 
> > That required writing more code and adding more logic I'd have to
> > think about to write, and then think about again every time I read
> > it.
> 
> OTOH it's an opportunity to make the asserts more useful, because right
> now they just say:
> 
> XFS (sda): Assertion failed: counter >= 0, file: xfs_trans.c, line XXX
> 
> *Which* counter just tripped the assert?  At least it could say:
> 
> XFS (sda): Assertion failed: mp->m_sb.sb_dblocks >= 0, file: xfs_trans.c, line XXX

Ok, that's a decent reason to make the code a bit more complex. I'll
see what I can do....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
