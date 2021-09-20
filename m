Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB2541265F
	for <lists+linux-xfs@lfdr.de>; Mon, 20 Sep 2021 20:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387278AbhITS5A (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 Sep 2021 14:57:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354358AbhITSxx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 Sep 2021 14:53:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A922D61221
        for <linux-xfs@vger.kernel.org>; Mon, 20 Sep 2021 18:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632163723;
        bh=ejL0cbBGUHF25ckSRzuDOys+YIJV3B2D1ZYvWuW52c0=;
        h=From:To:Subject:Date:From;
        b=akoUAcCEG3Cr8/JovaOtLBBJaIa+uEr09uMGFENAHcphe93yfTVmjzmWZXsxiKalu
         rjtU3Aa3C0WKiWyUxsEhkAcSDeeMtuLogmGuejhvQI8tVIevfzDwrWjbJdT0SPgCbv
         9qPFvr0WAbR3445LWypxa4BtoOmYIZHSEkWdLZ5WnaGPpIVVorz9L+EwrImGMxaZzc
         b3h+Iscka7AhWuDDWoJ6Bt8tixOAZcKNUuVyVnEH7pbRh07uTo/TlOCc/jB3CrfdGJ
         YAa6gzzlKdJ8iZwYoxkwXt94ULF5dAVT+PwXOcKJ3tsUFLkm78caTTo/y2aegB0W93
         W2aXYoJiFoyJw==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id A66E760E4A; Mon, 20 Sep 2021 18:48:43 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214475] New: xfs filesystem not mountable and xfs_repair hangs
 at function call futex
Date:   Mon, 20 Sep 2021 18:48:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dieter.ferdinand@gmx.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-214475-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214475

            Bug ID: 214475
           Summary: xfs filesystem not mountable and xfs_repair hangs at
                    function call futex
           Product: File System
           Version: 2.5
    Kernel Version: 5.10.40
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: dieter.ferdinand@gmx.de
        Regression: No

hello,
today i have a crash of one of my systems. at this time, i copy files to a
xfs-volume.

after restart of the system, i can't access the disk und try to repair it w=
ith
xfs_repair. first time i have problems because the system crashs, i only de=
lete
files and can repair it with xfs_repair. but this time, the program hangs (=
no
io and no cputime). i can't find a reason for this. i try run it with -n and
this process don't hangs. i can send you the log (ca. 1 1/2 MB). because i =
have
no important data on this drive, only backups, i reformat it with btrfs to =
test
this filesystem. all other disks are formated with xfs. i try to find out, =
why
the program hangs, but with strace i can only see, that all three threads h=
angs
on ca futex call to wait for something.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
