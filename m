Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFF5A24395
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 00:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfETWql (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 18:46:41 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54828 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726088AbfETWql (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 18:46:41 -0400
Received: from dread.disaster.area (pa49-181-171-240.pa.nsw.optusnet.com.au [49.181.171.240])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9577510C7FE;
        Tue, 21 May 2019 08:46:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hSr3F-0003D1-6Y; Tue, 21 May 2019 08:46:37 +1000
Date:   Tue, 21 May 2019 08:46:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     bugzilla-daemon@bugzilla.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [Bug 203655] XFS: Assertion failed: 0, xfs_log_recover.c, line:
 551
Message-ID: <20190520224637.GE29573@dread.disaster.area>
References: <bug-203655-201763@https.bugzilla.kernel.org/>
 <bug-203655-201763-WLgC3hGYRF@https.bugzilla.kernel.org/>
 <20190520161200.GB32784@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520161200.GB32784@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=LhzQONXuMOhFZtk4TmSJIw==:117 a=LhzQONXuMOhFZtk4TmSJIw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=VwQbUJbxAAAA:8 a=5xOlfOR4AAAA:8 a=7-415B0cAAAA:8 a=wROLhzylN7vpBhtwFiUA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=SGlsW6VomvECssOqsvzv:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 12:12:00PM -0400, Brian Foster wrote:
> On Mon, May 20, 2019 at 04:02:06PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=203655
> > 
> > Eric Sandeen (sandeen@sandeen.net) changed:
> > 
> >            What    |Removed                     |Added
> > ----------------------------------------------------------------------------
> >                  CC|                            |sandeen@sandeen.net
> > 
> > --- Comment #2 from Eric Sandeen (sandeen@sandeen.net) ---
> > I think the question here is whether the ASSERT() is valid - we don't ever want
> > to assert on disk corruption, it should only be for "this should never happen
> > in the code" scenarios.
> > 
> 
> Makes sense. It's not clear to me whether that's the intent of the bug,
> but regardless I think it would be reasonable to kill off that
> particular assert. We already warn and return an error.

IMO, the assert is most definitely valid for a debug build.  If I'm
writing new code and I corrupt the log, I want it to stop
immediately so I can look at what I did wrong the moment it is
detected and (hopefully) preserving the underlying filesystem state
that is associated with the corrupt journal.

Production systems will not have the assert built in and so will
return -EIO and fail log recovery gracefully. i.e. The ASSERT is
there for the benefit of the XFS developers and has no impact on
user systems, so I'd close this NOTABUG.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
