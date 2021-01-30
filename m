Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5242E3096DF
	for <lists+linux-xfs@lfdr.de>; Sat, 30 Jan 2021 17:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhA3QpX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 30 Jan 2021 11:45:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231783AbhA3QpE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 30 Jan 2021 11:45:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1991964E13
        for <linux-xfs@vger.kernel.org>; Sat, 30 Jan 2021 16:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612024364;
        bh=nsVOdFqkFz1Ann0zMtV4YpocUa1kMmg8B6elpKMp2u4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=KgpGC1zXSDM2d9+1vsWkKeW88sUOgXTSXzRBs5gkbowtOFCdwWaWFOfUtwONcvNBC
         dMJWHzfN70BRD+Iopwta7Df3XUzLypYk+em5vfA7+/mBhyAdwvJbvo6oWMZKx0Fd9O
         0VSMBZLdBKe7WZSQfUdKsfQz56bKLIVhdqoH0RVOkCPSIZBmywamJIMn9MVJomxkHR
         hrst2hhXM3znUDOSSVelBMw25X8f15gmKIX1V2szjFj2yHizqxuRuAISPN6r43viON
         REuiKOrVBHiUN0k29vAEZYo+IG1Ka2MSntj3zEGX3EHIKfGTNOHMN6mScTgxTqInn+
         kvXLUJUcaOZ4g==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 0F46565311; Sat, 30 Jan 2021 16:32:44 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211329] blkg_alloc memory leak on ppc64le
Date:   Sat, 30 Jan 2021 16:32:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: Block Layer
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: cam@neo-zeon.de
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-211329-201763-obNoTsQYex@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211329-201763@https.bugzilla.kernel.org/>
References: <bug-211329-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211329

Cameron (cam@neo-zeon.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #6 from Cameron (cam@neo-zeon.de) ---
The issue appears to be transient. Leaks are detected, and after a clear an=
d a
a re-scan, leaks are no longer present. I'm thinking these are false positi=
ves.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
