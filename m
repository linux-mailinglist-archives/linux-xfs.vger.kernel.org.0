Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A01915633
	for <lists+linux-xfs@lfdr.de>; Tue,  7 May 2019 00:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfEFWvG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 6 May 2019 18:51:06 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58221 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726063AbfEFWvF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 May 2019 18:51:05 -0400
Received: from dread.disaster.area (pa49-181-171-240.pa.nsw.optusnet.com.au [49.181.171.240])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1D3084388A9;
        Tue,  7 May 2019 08:51:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hNmRp-0004YD-KM; Tue, 07 May 2019 08:51:01 +1000
Date:   Tue, 7 May 2019 08:51:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Rosen Penev <rosenp@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] db/malloc: Use posix_memalign instead of deprecated
 valloc
Message-ID: <20190506225101.GN29573@dread.disaster.area>
References: <20190506210326.29581-1-rosenp@gmail.com>
 <b85f5489-70ed-3145-3989-592ee1de3899@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b85f5489-70ed-3145-3989-592ee1de3899@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0 cx=a_idp_d
        a=LhzQONXuMOhFZtk4TmSJIw==:117 a=LhzQONXuMOhFZtk4TmSJIw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=QCsuf9VlqjBIDrebahUA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 06, 2019 at 05:20:11PM -0500, Eric Sandeen wrote:
> 
> 
> On 5/6/19 4:03 PM, Rosen Penev wrote:
> > valloc is not available with uClibc-ng as well as being deprecated, which
> > causes compilation errors. aligned_alloc is not available before C11 so
> > used posix_memalign.'
> > 
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > ---
> >  db/malloc.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/db/malloc.c b/db/malloc.c
> > index 77b3e022..38fe0b05 100644
> > --- a/db/malloc.c
> > +++ b/db/malloc.c
> > @@ -44,8 +44,7 @@ xmalloc(
> >  {
> >  	void	*ptr;
> >  
> > -	ptr = valloc(size);
> > -	if (ptr)
> > +	if(!posix_memalign(&ptr, sysconf(_SC_PAGESIZE), size))
> 
> 
> I'll stick a space after the 'if' but otherwise, seems fine, thanks.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Can we just get rid of db/malloc.[ch]? They are just a set
of wrappers that exit() when malloc fails, largely used by the
deprecated xfs_check functionality we still have hidden inside
xfs_db. Be a useful code self-documentation exercise to get rid
of them to indicate that the callers don't actually handle malloc
failures at all....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
