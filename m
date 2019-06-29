Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24BBE5ACB5
	for <lists+linux-xfs@lfdr.de>; Sat, 29 Jun 2019 19:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfF2Rb6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Sat, 29 Jun 2019 13:31:58 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52150 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726849AbfF2Rb6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Jun 2019 13:31:58 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6C5BD28735
        for <linux-xfs@vger.kernel.org>; Sat, 29 Jun 2019 17:31:57 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 5E2C1287E0; Sat, 29 Jun 2019 17:31:57 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=ham version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 203947] [xfstests generic/475]: general protection fault: 0000
 [#1] RIP: 0010:xfs_setfilesize_ioend+0xb1/0x220 [xfs]
Date:   Sat, 29 Jun 2019 17:31:56 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-203947-201763-3bw6dZMvJI@https.bugzilla.kernel.org/>
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

--- Comment #8 from Darrick J. Wong (djwong+kernel@djwong.org) ---
Ok, so I reproduced it locally and tracked the crash to this part of
xfs_bmapi_read() where we dereference *ifp:

        if (!(ifp->if_flags & XFS_IFEXTENTS)) {                                 
                error = xfs_iread_extents(NULL, ip, whichfork);                 
                if (error)                                                      
                        return error;                                           
        }                                                                       

Looking at xfs_iformat_fork(), it seems that if there's any kind of error
formatting the attr fork it'll free ip->i_afp and set it to NULL, so I think
the fix is to add an "if (!afp) return -EIO;" somewhere.

Not sure how we actually get to this place, though.  fsstress is running
bulkstat, which is inactivating an inode with i_nlink == 0 and a corrupt attr
fork that won't load.  Maybe we hit an inode that had previously gone through
unlinked processing after log recovery but was lurking on the mru waiting to be
inactivated, but then bulkstat showed up (with its IGET_DONTCACHE) which forced
immediate inactivation?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
