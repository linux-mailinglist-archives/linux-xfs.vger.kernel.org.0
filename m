Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005D02A1515
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Oct 2020 11:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgJaKMY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Sat, 31 Oct 2020 06:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbgJaKMX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 31 Oct 2020 06:12:23 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209981] New: Unable to boot with kernel 5.10-r1
Date:   Sat, 31 Oct 2020 10:12:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aaron.zakhrov@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-209981-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209981

            Bug ID: 209981
           Summary: Unable to boot with kernel 5.10-r1
           Product: File System
           Version: 2.5
    Kernel Version: 5.10-rc1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: aaron.zakhrov@gmail.com
        Regression: No

Created attachment 293333
  --> https://bugzilla.kernel.org/attachment.cgi?id=293333&action=edit
journalctl captured till lock up

I have a Dell G5 15 SE with a Samsung PM99 NVME SSD. When I try to compile and
boot with Linux kernel 5.10-rc1 or 5.10 git my computer locks up after entering
the password to decrypt my encrypted root partition. 
Kernels before 5.10-rc1 work just fine. There is no kernel panic but xfs keeps
stalling

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
