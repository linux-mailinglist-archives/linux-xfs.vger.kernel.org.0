Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74CA67E7B7
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Aug 2019 04:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732468AbfHBCF2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Aug 2019 22:05:28 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:53734 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726796AbfHBCF2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 22:05:28 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04391;MF=eguan@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0TYR76HQ_1564710922;
Received: from localhost(mailfrom:eguan@linux.alibaba.com fp:SMTPD_---0TYR76HQ_1564710922)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 02 Aug 2019 09:55:22 +0800
Date:   Fri, 2 Aug 2019 09:55:22 +0800
From:   Eryu Guan <eguan@linux.alibaba.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: test new v5 bulkstat commands
Message-ID: <20190802015454.GF52397@e18g06458.et15sqa>
References: <156462375516.2945299.16564635037236083118.stgit@magnolia>
 <156462379043.2945299.17354996626313190310.stgit@magnolia>
 <20190801104814.GC59093@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801104814.GC59093@bfoster>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 01, 2019 at 06:48:15AM -0400, Brian Foster wrote:
> On Wed, Jul 31, 2019 at 06:43:10PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Check that the new v5 bulkstat commands do everything the old one do,
> > and then make sure the new functionality actually works.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  .gitignore                 |    1 
> >  src/Makefile               |    2 
> >  src/bulkstat_null_ocount.c |   61 +++++++++
> >  tests/xfs/744              |  215 ++++++++++++++++++++++++++++++++
> >  tests/xfs/744.out          |  297 ++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/745              |   47 +++++++
> >  tests/xfs/745.out          |    2 
> >  tests/xfs/group            |    2 
> >  8 files changed, 626 insertions(+), 1 deletion(-)
> >  create mode 100644 src/bulkstat_null_ocount.c
> >  create mode 100755 tests/xfs/744
> >  create mode 100644 tests/xfs/744.out
> >  create mode 100755 tests/xfs/745
> >  create mode 100644 tests/xfs/745.out
> > 
> > 
> ...
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 270d82ff..ef0cf92c 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -506,3 +506,5 @@
> >  506 auto quick health
> >  507 clone
> >  508 auto quick quota
> > +744 auto ioctl quick
> > +745 auto ioctl quick
> > 
> 
> One quick note that xfs/744 runs in ~68 seconds in my (low resource)
> test VM. Not a problem in and of itself, but it seems slightly long for
> the quick group. Can somebody remind me of the quick group criteria?

A quick test is usually under 30s run-time.

> 
> FWIW if I kick off a quick group run, the first 10-15 tests complete in
> 10s or so or less with the exception of generic/013, which takes over a
> minute. So perhaps anything under a minute or so is fine..? Either way,
> that can be easily changed on merge if appropriate:

Yeah, I'll drop quick group if it's not really quick :)

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks for the review!

Eryu
