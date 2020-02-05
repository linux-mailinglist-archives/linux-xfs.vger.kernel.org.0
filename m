Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00774153405
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Feb 2020 16:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgBEPjw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Wed, 5 Feb 2020 10:39:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbgBEPjv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Feb 2020 10:39:51 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 206429] xfs_admin can't print both label and UUID for mounted
 filesystems
Date:   Wed, 05 Feb 2020 15:39:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sandeen@sandeen.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-206429-201763-gudvBTA8SF@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206429-201763@https.bugzilla.kernel.org/>
References: <bug-206429-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206429

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@sandeen.net

--- Comment #1 from Eric Sandeen (sandeen@sandeen.net) ---
The patch is not quite the right approach - the get label command sets both
DB_OPTS and IO_OPTS, as does the set label command, and your patch would make
it fall back to xfs_db for both, which will then fail to set a label on a
mounted filesystem:

# db/xfs_admin.sh -L foobar mnt
xfs_admin: cannot open mnt: Is a directory

# sh -x db/xfs_admin.sh -L foobar mnt
...
+ eval xfs_db -x -p xfs_admin -c ''\''label' 'foobar'\''' mnt
++ xfs_db -x -p xfs_admin -c 'label foobar' mnt
xfs_admin: cannot open mnt: Is a directory

xfs_admin has become convoluted/complicated, let me give this some thought.

Thanks for the report,

-Eric

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
