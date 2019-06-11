Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB384183D
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 00:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405777AbfFKWel (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Jun 2019 18:34:41 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:42821 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405174AbfFKWel (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 18:34:41 -0400
Received: from dread.disaster.area (pa49-195-189-25.pa.nsw.optusnet.com.au [49.195.189.25])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id EFC2D3DCB68;
        Wed, 12 Jun 2019 08:34:39 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hapKn-0002rn-Rr; Wed, 12 Jun 2019 08:33:41 +1000
Date:   Wed, 12 Jun 2019 08:33:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] xfs: create simplified inode walk function
Message-ID: <20190611223341.GD14363@dread.disaster.area>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968497450.1657646.15305138327955918345.stgit@magnolia>
 <20190610135816.GA6473@bfoster>
 <20190610165909.GI1871505@magnolia>
 <20190610175509.GF6473@bfoster>
 <20190610231134.GM1871505@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610231134.GM1871505@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=K5LJ/TdJMXINHCwnwvH1bQ==:117 a=K5LJ/TdJMXINHCwnwvH1bQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=dq6fvYVFJ5YA:10
        a=7-415B0cAAAA:8 a=IShzWTfusOBe-Ti6MjUA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 10, 2019 at 04:11:34PM -0700, Darrick J. Wong wrote:
> On Mon, Jun 10, 2019 at 01:55:10PM -0400, Brian Foster wrote:
> > > I could extend the comment to explain why we don't use PAGE_SIZE...
> > > 
> > 
> > Sounds good, though what I think would be better is to define a
> > IWALK_DEFAULT_RECS or some such somewhere and put the calculation
> > details with that.
> > 
> > Though now that you point out the readahead thing, aren't we at risk of
> > a similar problem for users who happen to pass a really large userspace
> > buffer? Should we cap the kernel allocation/readahead window in all
> > cases and not just the default case?
> 
> Hmm, that's right, we don't want to let userspace arbitrarily determine
> the size of the buffer, and I think the current implementation caps it
> the readahaead at ... oh, PAGE_SIZE / sizeof(xfs_inogrp_t).
> 
> Oh, right, and in the V1 patchset Dave said that we should constrain
> readahead even further.

Right, I should explain a bit further why, too - it's about
performance.  I've found that a user buffer size of ~1024 inodes is
generally enough to max out performance of bulkstat. i.e. somewhere
around 1000 inodes per syscall is enough to mostly amortise all of
the cost of syscall, setup, readahead, etc vs the CPU overhead of
copying all the inodes into the user buffer.

Once the user buffer goes over a few thousand inodes, performance
then starts to tail back off - we don't get any gains from trying to
bulkstat tens of thousands of inodes at a time, especially under
memory pressure because that can push us into readahead and buffer
cache thrashing.

> > > /*
> > >  * Note: We hardcode 4096 here (instead of, say, PAGE_SIZE) because we want to
> > >  * constrain the amount of inode readahead to 16k inodes regardless of CPU:
> > >  *
> > >  * 4096 bytes / 16 bytes per inobt record = 256 inobt records
> > >  * 256 inobt records * 64 inodes per record = 16384 inodes
> > >  * 16384 inodes * 512 bytes per inode(?) = 8MB of inode readahead
> > >  */

Hence I suspect that even this is overkill - it makes no sense to
have a huge readahead window when there has been no measurable
performance benefit to doing large inode count bulkstat syscalls.

And, FWIW, readahead probably should also be capped at what the user
buffer can hold - no point in reading 16k inodes when the output
buffer can only fit 1000 inodes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
