Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB191DD3F3
	for <lists+linux-xfs@lfdr.de>; Thu, 21 May 2020 19:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgEURKK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Thu, 21 May 2020 13:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728581AbgEURKK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 May 2020 13:10:10 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 207817] kworker using a lots of cpu
Date:   Thu, 21 May 2020 17:10:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: bfoster@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-207817-201763-pRHW8pwtFR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207817-201763@https.bugzilla.kernel.org/>
References: <bug-207817-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207817

--- Comment #2 from bfoster@redhat.com ---
On Thu, May 21, 2020 at 04:45:34PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=207817
> 
> --- Comment #1 from Alexander Petrovsky (askjuise@gmail.com) ---
> After 1 day, it seems like some internal activity calm down kworker at 00:00
> UTC, it could be logrotate or smth else. But now, I'm observe the follow
> (seems
> like it has the same root cause):
> 

Note that you're reporting problems with a distro kernel and proprietary
hypervisor to an upstream mailing list (via an upstream bug tracker).
The feedback will likely be limited unless you can reproduce on an
upstream kernel.

In general, it's not really clear to me what you're reporting beyond the
writeback task using more CPU than anticipated. What is that based on?
What problematic functional or performance related behavior is observed?
If performance related, what exactly is the workload?

> #df -h
> Filesystem                     Size  Used Avail Use% Mounted on
> ...
> /dev/mapper/vg_logs-lv_varlog   38G  -30G   68G    - /var/log
> ...

I think we've had some upstream patches to fix underflows and such in
space reporting paths fairly recently, but I'm not sure off hand if
those are associated with any functional issues beyond indication of
potential corruption. This suggests you should probably run 'xfs_repair
-n' on this filesystem if you haven't already.

Brian

> 
> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.
>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
