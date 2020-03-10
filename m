Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E99D180B75
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Mar 2020 23:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgCJWZC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Tue, 10 Mar 2020 18:25:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbgCJWZC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Mar 2020 18:25:02 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 206807] [xfstests generic/053]: WARNING: possible circular
 locking between fs_reclaim_acquire.part and xfs_ilock_attr_map_shared
Date:   Tue, 10 Mar 2020 22:25:01 +0000
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
Message-ID: <bug-206807-201763-jKOByzlC5Z@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206807-201763@https.bugzilla.kernel.org/>
References: <bug-206807-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206807

--- Comment #1 from Dave Chinner (david@fromorbit.com) ---
On Tue, Mar 10, 2020 at 09:26:11AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=206807
> 
>             Bug ID: 206807
>            Summary: [xfstests generic/053]: WARNING: possible circular
>                     locking between fs_reclaim_acquire.part and
>                     xfs_ilock_attr_map_shared
>            Product: File System
>            Version: 2.5
>     Kernel Version: xfs-5.7-merge-1
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: zlang@redhat.com
>         Regression: No
> 
> xfstests generic/053 always hit below warning. I'm not sure if it's a real
> issue, just due to it can be reproduced easily. So report this bug to get
> more
> xfs developer review.

False positive. Please close.

-Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
