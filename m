Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 840FD23C9E
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 17:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389007AbfETP4A convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Mon, 20 May 2019 11:56:00 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34274 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389005AbfETPz7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 11:55:59 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3C075288DC
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 15:55:59 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 2E97E288E0; Mon, 20 May 2019 15:55:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 203653] XFS: Internal error xlog_clear_stale_blocks(2) at line
 1794 of file ../fs/xfs/xfs_log_recover.c
Date:   Mon, 20 May 2019 15:55:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sandeen@sandeen.net
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: INVALID
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status cc resolution
Message-ID: <bug-203653-201763-SF4zZVyDZB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203653-201763@https.bugzilla.kernel.org/>
References: <bug-203653-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203653

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |sandeen@sandeen.net
         Resolution|---                         |INVALID

--- Comment #2 from Eric Sandeen (sandeen@sandeen.net) ---
Yup, this is a crafted image, with intentional corruption.  XFS is simply (and
verbosely) telling you that it's corrupted.  This is expected behavior.

(I'd prefer NOTABUG to INVALID, but I hope you get my meaning) :)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
