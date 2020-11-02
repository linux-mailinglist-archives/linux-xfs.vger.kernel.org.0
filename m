Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8BE2A25C0
	for <lists+linux-xfs@lfdr.de>; Mon,  2 Nov 2020 08:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgKBH7u convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Mon, 2 Nov 2020 02:59:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727870AbgKBH7u (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Nov 2020 02:59:50 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209981] Unable to boot with kernel 5.10-r1
Date:   Mon, 02 Nov 2020 07:59:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: aaron.zakhrov@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: OBSOLETE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-209981-201763-vsGU4bMoHh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209981-201763@https.bugzilla.kernel.org/>
References: <bug-209981-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209981

Aaron Dominick (aaron.zakhrov@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |OBSOLETE

--- Comment #6 from Aaron Dominick (aaron.zakhrov@gmail.com) ---
(In reply to Dave Chinner from comment #5)
> On Mon, Nov 02, 2020 at 05:02:06AM +0000,
> bugzilla-daemon@bugzilla.kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=209981
> > 
> > --- Comment #4 from Aaron Dominick (aaron.zakhrov@gmail.com) ---
> > (In reply to Eric Sandeen from comment #2)
> > > Why do you feel this is an xfs bug?  I don't see any indication of xfs
> > > problems in your logs.
> > 
> > I dont think the logs are being captured. Basically after I boot and enter
> my
> > lvm password, the system locks up with a bunch of pending in flight
> requests.
> > Among them are the xfs_buf_ioend_work
> 
> Your kernel oopsed trying to load firmware for the iwl driver.
> Everything after that is colateral damage. Sort out the firmware
> loading problem first because once that problem goes away all the
> others should, too.
> 
> Cheers,
> 
> Dave.

OK my bad. 5.10-rc2 seems to work fine

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
