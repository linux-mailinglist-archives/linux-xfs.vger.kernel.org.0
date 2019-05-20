Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 609A7243F4
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 01:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfETXPA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Mon, 20 May 2019 19:15:00 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33504 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726357AbfETXPA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:15:00 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 11F5A2893D
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 23:15:00 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 048D52894C; Mon, 20 May 2019 23:15:00 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 203655] XFS: Assertion failed: 0, xfs_log_recover.c, line: 551
Date:   Mon, 20 May 2019 23:14:58 +0000
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
Message-ID: <bug-203655-201763-WTVoEZfV5k@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203655-201763@https.bugzilla.kernel.org/>
References: <bug-203655-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203655

--- Comment #4 from Dave Chinner (david@fromorbit.com) ---
On Mon, May 20, 2019 at 12:12:00PM -0400, Brian Foster wrote:
> On Mon, May 20, 2019 at 04:02:06PM +0000, bugzilla-daemon@bugzilla.kernel.org
> wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=203655
> > 
> > Eric Sandeen (sandeen@sandeen.net) changed:
> > 
> >            What    |Removed                     |Added
> >
> ----------------------------------------------------------------------------
> >                  CC|                            |sandeen@sandeen.net
> > 
> > --- Comment #2 from Eric Sandeen (sandeen@sandeen.net) ---
> > I think the question here is whether the ASSERT() is valid - we don't ever
> want
> > to assert on disk corruption, it should only be for "this should never
> happen
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
You are receiving this mail because:
You are watching the assignee of the bug.
