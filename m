Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A448112F10
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Dec 2019 16:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfLDP4R convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Wed, 4 Dec 2019 10:56:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbfLDP4R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Dec 2019 10:56:17 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 205465] [xfstests generic/475]: general protection fault: 0000
 [#1] SMP KASAN PTI,  RIP: 0010:iter_file_splice_write+0x63f/0xa90
Date:   Wed, 04 Dec 2019 15:56:16 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: djwong+kernel@djwong.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-205465-201763-rmzPs9iIBl@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205465-201763@https.bugzilla.kernel.org/>
References: <bug-205465-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205465

Darrick J. Wong (djwong+kernel@djwong.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |djwong+kernel@djwong.org

--- Comment #2 from Darrick J. Wong (djwong+kernel@djwong.org) ---
Could you please post the source line translations of the relevant functions? 
I don't have your kernel build.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
