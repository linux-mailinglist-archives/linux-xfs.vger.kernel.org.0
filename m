Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF9E8AC57
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Aug 2019 03:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfHMBF6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 21:05:58 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33356 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726296AbfHMBF6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 21:05:58 -0400
Received: from dread.disaster.area (pa49-181-167-148.pa.nsw.optusnet.com.au [49.181.167.148])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B67B6360C33;
        Tue, 13 Aug 2019 11:05:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hxLF1-0003oD-Gl; Tue, 13 Aug 2019 11:04:47 +1000
Date:   Tue, 13 Aug 2019 11:04:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Thomas Deutschmann <whissi@gentoo.org>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
Message-ID: <20190813010447.GE6129@dread.disaster.area>
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
 <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
 <20190812031123.GA6129@dread.disaster.area>
 <20190812043046.GB6129@dread.disaster.area>
 <09ad7dd5-c2cd-aaaa-82d5-0f3a18eb4062@gentoo.org>
 <20190812214449.GC6129@dread.disaster.area>
 <ddabd271-2820-85f3-4393-99deb5a0eaef@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddabd271-2820-85f3-4393-99deb5a0eaef@gentoo.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=gu9DDhuZhshYSb5Zs/lkOA==:117 a=gu9DDhuZhshYSb5Zs/lkOA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=1aPJfSmGWw4G1AIuc_kA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 13, 2019 at 12:18:04AM +0200, Thomas Deutschmann wrote:
> On 2019-08-12 23:44, Dave Chinner wrote:
> >> That's not the correct way to reproduce. It's really important to
> >> _export_ the variable to trigger the problem and _this_ is a problem in
> >> xfsprogs' build system.
> > Which means you are overriding the LDFLAGS set by configure when
> > you _run make_, not just telling configure to use those LDFLAGS.
> > 
> > That's why _make_ is getting screwed up - it is doing exactly what
> > you are telling it to do, and that is to overrides every occurrence
> > of LDFLAGS with your exported options rather than using the correct
> > set configure calculated and specified.
> > 
> > Exporting your CFLAGS and LDFLAGS is the wrong thing to doing
> > - they should only ever be passed to the configure invocation and
> > not remain to pollute the build environment after you've run
> > configure.
> 
> I disagree with the conclusion. LDFLAGS in build environment shouldn't
> cause any problems, especially when you are using a build system:
>
> Normally, configure will get the value and the Makefiles will use the
> value _from_ configure... but using configure _and_ reading _and adding_
> values from environment _in addition_ seems to be wrong.

<sigh>

xfsprogs-2.7.18 (16 May 2006)
        - Fixed a case where xfs_repair was reporting a valid used
          block as a duplicate during phase 4.
        - Fixed a case where xfs_repair could incorrectly flag extent
          b+tree nodes as corrupt.
        - Portability changes, get xfs_repair compiling on IRIX.
        - Parent pointer updates in xfs_io checker command.
        - Allow LDFLAGS to be overridden, for Gentoo punters.
	  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Back in 2006 we added the ability for LDFLAGS to be overriden
specifically because Gentoo users wanted it.

> So you either use a build system or you don't.

Yup, but Gentoo wanted it both ways, and so we gave them that
capability.  And now you're complaining that Gentoo users can shoot
themselves in the foot with it.... :/

Just pass your special CFLAGS/LDFLAGS to configure like the rest of
the world does and everything will work correctly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
