Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D9E252885
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Aug 2020 09:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgHZHk7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Wed, 26 Aug 2020 03:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgHZHk6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Aug 2020 03:40:58 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209039] New: xfs_fsr skips most of the files as no improvement
 will be made
Date:   Wed, 26 Aug 2020 07:40:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: marc@gutt.it
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-209039-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209039

            Bug ID: 209039
           Summary: xfs_fsr skips most of the files as no improvement will
                    be made
           Product: File System
           Version: 2.5
    Kernel Version: 4.19.107-Unraid
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: marc@gutt.it
        Regression: No

I checked the fragmentation factor of disk1 as follows:

    xfs_db -c frag -r /dev/md1
    actual 1718, ideal 674, fragmentation factor 60.77%
    Note, this number is largely meaningless.
    Files on this filesystem average 2.55 extents per file

I tried to defrag disk1:

    xfs_fsr /dev/md1 -v -d
    /mnt/disk1 start inode=0
    ino=133
    ino=133 extents=4 can_save=3 tmp=/mnt/disk1/.fsr/ag0/tmp23917
    DEBUG: fsize=30364684107 blsz_dio=16773120 d_min=512 d_max=2147483136
pgsz=4096
    Temporary file has 4 extents (4 in original)
    No improvement will be made (skipping): ino=133
    ino=135
    ino=135 extents=4 can_save=3 tmp=/mnt/disk1/.fsr/ag1/tmp23917
    orig forkoff 288, temp forkoff 0
    orig forkoff 288, temp forkoff 296
    orig forkoff 288, temp forkoff 296
    orig forkoff 288, temp forkoff 296
    orig forkoff 288, temp forkoff 296
    orig forkoff 288, temp forkoff 296
    orig forkoff 288, temp forkoff 296
    orig forkoff 288, temp forkoff 288
    set temp attr
    DEBUG: fsize=28400884827 blsz_dio=16773120 d_min=512 d_max=2147483136
pgsz=4096
    Temporary file has 4 extents (4 in original)
    No improvement will be made (skipping): ino=135
    ino=138
    ...

This means the file would still consist of 4 parts across the hdd platter after
defragmentation and because of that it's skipped. But why isn't it able to
merge the parts of this and hundreds of other files?

More details about inode 133:

    xfs_db -r /dev/md1 -c "inode 133" -c "bmap -d"
    data offset 0 startblock 1314074773 (4/240332949) count 2097151 flag 0
    data offset 2097151 startblock 1316171924 (4/242430100) count 2097151 flag
0
    data offset 4194302 startblock 1318269075 (4/244527251) count 2097151 flag
0
    data offset 6291453 startblock 1320366226 (4/246624402) count 1121800 flag
0

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
