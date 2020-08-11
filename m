Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3295241DFC
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Aug 2020 18:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbgHKQQq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Tue, 11 Aug 2020 12:16:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728797AbgHKQQq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Aug 2020 12:16:46 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208827] [fio io_uring] io_uring write data crc32c verify failed
Date:   Tue, 11 Aug 2020 16:16:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bugzilla@colorremedies.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-208827-201763-3pEqiqt0xS@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208827-201763@https.bugzilla.kernel.org/>
References: <bug-208827-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208827

Chris Murphy (bugzilla@colorremedies.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bugzilla@colorremedies.com

--- Comment #16 from Chris Murphy (bugzilla@colorremedies.com) ---
Dunno if it's at all related, but if it is then Dave can blame me for his two
wasted days because I ran into this 3 weeks ago and just got around to filing a
bug today.

Bug 208875 - btrfs checksum errors in guest when virtio device io=io_uring
https://bugzilla.kernel.org/show_bug.cgi?id=208875

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
