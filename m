Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7305B8C3CC
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Aug 2019 23:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfHMVe6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 13 Aug 2019 17:34:58 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36357 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726649AbfHMVe5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Aug 2019 17:34:57 -0400
Received: from dread.disaster.area (pa49-181-167-148.pa.nsw.optusnet.com.au [49.181.167.148])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5A34043C76F;
        Wed, 14 Aug 2019 07:34:55 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hxeQO-0005Uo-Fj; Wed, 14 Aug 2019 07:33:48 +1000
Date:   Wed, 14 Aug 2019 07:33:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfsprogs: Fix --disable-static option build
Message-ID: <20190813213348.GG6129@dread.disaster.area>
References: <20190813051421.21137-1-david@fromorbit.com>
 <20190813051421.21137-3-david@fromorbit.com>
 <20190813142801.GP7138@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813142801.GP7138@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=gu9DDhuZhshYSb5Zs/lkOA==:117 a=gu9DDhuZhshYSb5Zs/lkOA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=puw--JPT7wG1HlNdRHgA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 13, 2019 at 07:28:01AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 13, 2019 at 03:14:20PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Internal xfsprogs libraries are linked statically to binaries as
> > they are not shipped libraries. Using --disable-static prevents the
> > internal static libraries from being built and this breaks dead code
> > elimination and results in linker failures from link dependencies
> > introduced by dead code.
> > 
> > We can't remove the --disable-static option that causes this as it
> > is part of the libtool/autoconf generated infrastructure. We can,
> > however, reliably detect whether static library building has been
> > disabled after the libtool infrastructure has been configured.
> > Therefore, add a check to determine the static build status and
> > abort the configure script with an error if we have been configured
> > not to build static libraries.
> 
> Uh... is this missing from the patch?  I don't see anything that aborts
> configure.  Though I sense this might be your v2 solution that works
> around --disable-static via the ld command line and leaves configure
> alone...? :)

Ugh, forgot to refresh the patch after updating the comment. That
paragraph should read:

	We can't remove the --disable-static option that causes this as it
	is part of the libtool/autoconf generated infrastructure. We can,
	however, override --disable-static on a per-library basis inside the
	build by passing -static to the libtool link command. Therefore, add
	-static to all the internal libraries we build and link statically
	to the shipping binaries.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
