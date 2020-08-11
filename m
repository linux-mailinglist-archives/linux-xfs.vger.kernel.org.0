Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDD224222F
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Aug 2020 23:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgHKV7T convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Tue, 11 Aug 2020 17:59:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726453AbgHKV7T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Aug 2020 17:59:19 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208827] [fio io_uring] io_uring write data crc32c verify failed
Date:   Tue, 11 Aug 2020 21:59:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-208827-201763-w1a7mTghXy@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208827-201763@https.bugzilla.kernel.org/>
References: <bug-208827-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208827

--- Comment #18 from Dave Chinner (david@fromorbit.com) ---
On Tue, Aug 11, 2020 at 07:10:30AM -0600, Jens Axboe wrote:
> On 8/11/20 1:05 AM, Dave Chinner wrote:
> > On Mon, Aug 10, 2020 at 08:19:57PM -0600, Jens Axboe wrote:
> >> On 8/10/20 8:00 PM, Dave Chinner wrote:
> >>> On Mon, Aug 10, 2020 at 07:08:59PM +1000, Dave Chinner wrote:
> >>>> On Mon, Aug 10, 2020 at 05:08:07PM +1000, Dave Chinner wrote:
> >>>>> [cc Jens]
> >>>>>
> >>>>> [Jens, data corruption w/ io_uring and simple fio reproducer. see
> >>>>> the bz link below.]
> >>>
> >>> Looks like a io_uring/fio bugs at this point, Jens. All your go fast
> >>> bits turns the buffered read into a short read, and neither fio nor
> >>> io_uring async buffered read path handle short reads. Details below.
> >>
> >> It's a fio issue. The io_uring engine uses a different path for short
> >> IO completions, and that's being ignored by the backend... Hence the
> >> IO just gets completed and not retried for this case, and that'll then
> >> trigger verification as if it did complete. I'm fixing it up.
> > 
> > I just updated fio to:
> > 
> > cb7d7abb (HEAD -> master, origin/master, origin/HEAD) io_u: set
> io_u->verify_offset in fill_io_u()
> > 
> > The workload still reports corruption almost instantly. Only this
> > time, the trace is not reporting a short read.
> > 
> > File is patterned with:
> > 
> > verify_pattern=0x33333333%o-16
> > 
> > Offset of "bad" data is 0x1240000.
> > 
> > Expected:
> > 
> > 00000000:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000010:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000020:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000030:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000040:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000050:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000060:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000070:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000080:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
> > .....
> > 0000ffd0:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 
> 3333............
> > 0000ffe0:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 
> 3333............
> > 0000fff0:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 
> 3333............
> > 
> > 
> > Received:
> > 
> > 00000000:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000010:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000020:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000030:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000040:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000050:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000060:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000070:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> > 00000080:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
> > .....
> > 0000ffd0:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 
> 3333............
> > 0000ffe0:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 
> 3333............
> > 0000fff0:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 
> 3333............
> > 
> > 
> > Looks like the data in the expected buffer is wrong - the data
> > pattern in the received buffer is correct according the defined
> > pattern.
> > 
> > Error is 100% reproducable from the same test case. Same bad byte in
> > the expected buffer dump every single time.
> 
> What job file are you running? It's not impossible that I broken
> something else in fio, the io_u->verify_offset is a bit risky... I'll
> get it fleshed out shortly.

Details are in the bugzilla I pointed you at. I modified the
original config specified to put per-file and offset identifiers
into the file data rather than using random data. This is
"determining the origin of stale data 101" stuff - the first thing
we _always_ do when trying to diagnose data corruption is identify
where the bad data came from.

Entire config file is below.

CHeers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
