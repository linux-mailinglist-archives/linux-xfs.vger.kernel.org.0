Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 798B5895B4
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 05:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfHLDMc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 11 Aug 2019 23:12:32 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46485 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726144AbfHLDMc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Aug 2019 23:12:32 -0400
Received: from dread.disaster.area (pa49-181-167-148.pa.nsw.optusnet.com.au [49.181.167.148])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 57C9743D8CB;
        Mon, 12 Aug 2019 13:12:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hx0jz-0003s7-1o; Mon, 12 Aug 2019 13:11:23 +1000
Date:   Mon, 12 Aug 2019 13:11:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Thomas Deutschmann <whissi@gentoo.org>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
Message-ID: <20190812031123.GA6129@dread.disaster.area>
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
 <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=gu9DDhuZhshYSb5Zs/lkOA==:117 a=gu9DDhuZhshYSb5Zs/lkOA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=yxhqBpBs0ox-ETPTzNkA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 12, 2019 at 03:21:28AM +0200, Thomas Deutschmann wrote:
> On 2019-08-12 02:23, Dave Chinner wrote:
> > That still doesn't explain where all the whacky gcc options are
> > coming from - that's got to be something specific to your build or
> > distro environment.
> 
> Mh, at the moment it looks like xfsprogs' build system is adding
> $LDFLAGS multiple times when LDFLAGS is set in environment.
> 
> In a clear environment, do:
> 
> > tar -xaf xfsprogs-5.2.0.tar.xz
> > cd xfsprogs-5.2.0
> > export CFLAGS="-O2 -pipe -march=ivybridge -mtune=ivybridge -mno-xsaveopt"
> > export LDFLAGS="-Wl,-O1 -Wl,--as-needed"
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Don't do this.

"--as-needed" is the default linker behaviour since gcc 4.x. You do
not need this. As for passing "-O1" to the linker, that's not going
to do anything measurable for you. Use --enable-lto to turn on link
time optimisations if they are supported by the compiler.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
