Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D060258993
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Sep 2020 09:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIAHuG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Tue, 1 Sep 2020 03:50:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbgIAHuG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Sep 2020 03:50:06 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209039] xfs_fsr skips most of the files as no improvement will
 be made
Date:   Tue, 01 Sep 2020 07:50:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: marc@gutt.it
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: OBSOLETE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-209039-201763-8b6hHFukhx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209039-201763@https.bugzilla.kernel.org/>
References: <bug-209039-201763@https.bugzilla.kernel.org/>
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

mgutt (marc@gutt.it) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |OBSOLETE

--- Comment #4 from mgutt (marc@gutt.it) ---
Finally it should be "No improvement possible", but you are right, finally its
not worth. But I will try to send a patch for the man-pages project so the
manual of the command contains more explanations.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
