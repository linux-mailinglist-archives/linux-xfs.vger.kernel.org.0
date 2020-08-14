Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B883244FEA
	for <lists+linux-xfs@lfdr.de>; Sat, 15 Aug 2020 00:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgHNWlP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Fri, 14 Aug 2020 18:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbgHNWlO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Aug 2020 18:41:14 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208907] [fstests generic/074 on xfs]: 5.7.10 fails with a hung
 task on
Date:   Fri, 14 Aug 2020 22:41:14 +0000
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
Message-ID: <bug-208907-201763-kHPdQlDTLz@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208907-201763@https.bugzilla.kernel.org/>
References: <bug-208907-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208907

--- Comment #2 from Dave Chinner (david@fromorbit.com) ---
On Fri, Aug 14, 2020 at 06:43:18PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> Just ssh to kdevops-xfs and run:
> 
> cd /var/lib/xfstests/
> ./gendisks.sh -m
> ./check generic/074
> 
> Aug 14 18:27:34 kdevops-xfs-dev kernel: XFS (loop16): Mounting V5 Filesystem
> Aug 14 18:27:34 kdevops-xfs-dev kernel: XFS (loop16): Ending clean mount
> Aug 14 18:27:34 kdevops-xfs-dev kernel: xfs filesystem being mounted at
> /media/test supports timestamps until 2038 (0x7fffffff)
> Aug 14 18:28:16 kdevops-xfs-dev kernel: nvme nvme1: I/O 128 QID 2 timeout,
> aborting
> Aug 14 18:28:16 kdevops-xfs-dev kernel: nvme nvme1: Abort status: 0x4001
> Aug 14 18:28:47 kdevops-xfs-dev kernel: nvme nvme1: I/O 128 QID 2 timeout,
> reset controller

Hardware lost an IO. I'm guessing the error handling that reset the
controller failed to error out the bio the lost IO belonged to, so
XFS has hung waiting for it...

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
