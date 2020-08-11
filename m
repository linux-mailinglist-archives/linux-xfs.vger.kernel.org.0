Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BADE242258
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Aug 2020 00:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgHKWJf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Tue, 11 Aug 2020 18:09:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgHKWJf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Aug 2020 18:09:35 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208827] [fio io_uring] io_uring write data crc32c verify failed
Date:   Tue, 11 Aug 2020 22:09:34 +0000
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
Message-ID: <bug-208827-201763-ad6LEmPujS@https.bugzilla.kernel.org/>
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

--- Comment #19 from Dave Chinner (david@fromorbit.com) ---
On Tue, Aug 11, 2020 at 04:56:37PM -0400, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
> > So it seems to me like the file state is consistent, at least after the
> > run, and that this seems more likely to be a fio issue with short
> > read handling.
> 
> Any idea why there was a short read, though?

Yes. See:

https://lore.kernel.org/linux-xfs/20200807024211.GG2114@dread.disaster.area/T/#maf3bd9325fb3ac0773089ca58609a2cea0386ddf

It's a race between the readahead io completion marking pages
uptodate and unlocking them, and the io_uring worker function
getting woken on the first page being unlocked and running the
buffered read before the entire readahead IO completion has unlocked
all the pages in the IO.

Basically, io_uring is re-running the IOCB_NOWAIT|IOCB_WAITQ IO when
there are still pages locked under IO. This will happen much more
frequently the larger the buffered read (these are only 64kB) and
the readahead windows are opened.

Essentially, the io_uring buffered read needs to wait until _all_
pages in the IO are marked up to date and unlocked, not just the
first one. And not just the last one, either - readahead can be
broken into multiple bios (because it spans extents) and there is no
guarantee of order of completion of the readahead bios given by the
readahead code....

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
