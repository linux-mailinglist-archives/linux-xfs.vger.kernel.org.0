Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4E2562FA0
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jul 2019 06:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbfGIEaM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Tue, 9 Jul 2019 00:30:12 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43614 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725818AbfGIEaM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 00:30:12 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 04F1128650
        for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2019 04:30:12 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id EC6D428660; Tue,  9 Jul 2019 04:30:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=ham version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 203947] [xfstests generic/475]: general protection fault: 0000
 [#1] RIP: 0010:xfs_setfilesize_ioend+0xb1/0x220 [xfs]
Date:   Tue, 09 Jul 2019 04:30:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-203947-201763-c0RSRdU5IW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203947-201763@https.bugzilla.kernel.org/>
References: <bug-203947-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=203947

--- Comment #11 from Zorro Lang (zlang@redhat.com) ---
(In reply to Zorro Lang from comment #10)
> (In reply to Darrick J. Wong from comment #9)
> > Zorro,
> > 
> > If you get a chance, can you try this debugging patch, please?
> 
> Sure, I'll give it a try. With this bug together ... they both triggered by
> g/475. You really write a nice case :)
> 
> Both these two bugs are too hard to reproduce, so I only can try my best to
> test it, but I can't 100% verify they're fixed even if all test pass, I'll
> try to approach 99% :-P
> 
> BTW, if this's a separate bug, I'd like to report a new bug to track it, to
> avoid confusion.
> 
> Thanks,
> Zorro

Updata: By merging the patches in comment 2 and comment 9, I can't reproduce
this bug and https://bugzilla.kernel.org/show_bug.cgi?id=204031, after running
generic/475 on six different machines 3 days.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
