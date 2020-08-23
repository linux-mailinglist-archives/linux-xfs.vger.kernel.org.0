Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26FE24ECA9
	for <lists+linux-xfs@lfdr.de>; Sun, 23 Aug 2020 12:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgHWKHB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Sun, 23 Aug 2020 06:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbgHWKHB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 23 Aug 2020 06:07:01 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209005] New: xfs_repair 5.7.0: missing newline in message:
 entry at block N offset NN in directory inode NNNNNN has illegal name "/foo":
Date:   Sun, 23 Aug 2020 10:07:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: cs@cskk.id.au
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-209005-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209005

            Bug ID: 209005
           Summary: xfs_repair 5.7.0: missing newline in message: entry at
                    block N offset NN in directory inode NNNNNN has
                    illegal name "/foo":
           Product: File System
           Version: 2.5
    Kernel Version: #1 SMP Debian 3.16.59-1 (2018-10-03)
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: cs@cskk.id.au
        Regression: No

Here's an example:

entry at block 0 offset 1728 in directory inode 21997239545 has illegal name
"/gnome-dev-harddisk-1394.png": entry at block 0 offset 1768 in directory inode
21997239545 has illegal name "/gnome-dev-harddisk-usb.png": entry at block 0
offset 1808 in directory inode 21997239545 has illegal name
"/gnome-dev-harddisk.png":

I presume there's a missing newline or some missing trailing message component.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
