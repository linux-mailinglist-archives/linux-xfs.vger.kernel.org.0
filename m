Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41E6E58A10
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Jun 2019 20:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfF0Sfc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Thu, 27 Jun 2019 14:35:32 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34394 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726384AbfF0Sfc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 14:35:32 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3C9462844C
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jun 2019 18:35:31 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 2E30128475; Thu, 27 Jun 2019 18:35:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=ham version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 203947] [xfstests generic/475]: general protection fault: 0000
 [#1] RIP: 0010:xfs_setfilesize_ioend+0xb1/0x220 [xfs]
Date:   Thu, 27 Jun 2019 18:35:30 +0000
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
Message-ID: <bug-203947-201763-BIraDUAzxc@https.bugzilla.kernel.org/>
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

Darrick J. Wong (djwong+kernel@djwong.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |djwong+kernel@djwong.org

--- Comment #2 from Darrick J. Wong (djwong+kernel@djwong.org) ---
Hmm... so we're clearly in a situation where we have ioend A -> ioend B and
we're trying to merge A and B.  A has a setfilesize transaction and B does not,
but current code assumes that if A has one then B must have one and that it
must cancel B's.  Then we crash trying to cancel the transaction that B doesn't
have.

How do we end up in this situation?  I can't trigger it on my systems, but I
guess this sounds plausible:

1. Dirty pages 0, 1, and 2 of an empty file.

2. Writeback gets scheduled for pages 0 and 2, creating ioends A and C.  Both
ioends describe writes past the on-disk isize so we allocate transactions.

3. ioend C completes immediately, sets the ondisk isize to (3 * PAGESIZE).

4. Writeback gets scheduled for page 1, creating ioend B.  ioend B describes a
write within the on-disk isize so we do not allocate setfilesize transaction.

5. ioend A and B complete and are sorted into the per-inode ioend completion
list.  xfs_ioend_try_merge looks at ioend A, sees that ioend A has a
setfilesize transaction and that there's an ioend B that can be merged with A.

6. _try_merge tries to call xfs_setfilesize_ioend(ioend B, -1) to cancel ioend
B's transaction, but as we saw in (4), ioend B has no transaction and crashes.

I wonder how hard it will be to write a regression test for this, since it
requires fairly tight timing?

Coincidentally, Christoph just posted "xfs: allow merging ioends over append
boundaries" which I think fixes this problem.  Zorro, can you apply it and
retry?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
