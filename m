Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D48B4151EF0
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Feb 2020 18:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgBDRKG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Tue, 4 Feb 2020 12:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727348AbgBDRKG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Feb 2020 12:10:06 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 206397] [xfstests generic/475] XFS: Assertion failed:
 iclog->ic_state == XLOG_STATE_ACTIVE, file: fs/xfs/xfs_log.c, line: 572
Date:   Tue, 04 Feb 2020 17:10:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206397-201763-9tX2Bll3tL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206397-201763@https.bugzilla.kernel.org/>
References: <bug-206397-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206397

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---
(In reply to Chandan Rajendra from comment #1)
> I was unable to recreate this issue on a ppc64le kvm guest. I used Linux
> v5.5 and xfsprogs' for-next branch.
> 
> Can you please share the kernel config file? Also, Can you please tell me
> how easy is it recreate this bug?

It's really hard to reproduce. The g/475 is a random test, it's helped us to
find many different issues. For this bug, this's the 1st time I hit it, and
can't reproduce it simply.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
