Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DCC2506D6
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Aug 2020 19:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgHXRs3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Mon, 24 Aug 2020 13:48:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726804AbgHXRs1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Aug 2020 13:48:27 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209005] xfs_repair 5.7.0: missing newline in message: entry at
 block N offset NN in directory inode NNNNNN has illegal name "/foo":
Date:   Mon, 24 Aug 2020 17:48:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: sandeen@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-209005-201763-XVvGKNUMgF@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209005-201763@https.bugzilla.kernel.org/>
References: <bug-209005-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209005

Eric Sandeen (sandeen@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com

--- Comment #1 from Eric Sandeen (sandeen@redhat.com) ---
Can you attach the whole xfs_repair log?

In most of these cases, we set "junkit=1" and later, if that's set,
we complete the string with something like:

                /*
                 * Clear junked entries.
                 */
                if (junkit) {
                        if (!no_modify) {
                                dep->name[0] = '/';
                                *dirty = 1;
                                do_warn(_("clearing entry\n"));
                        } else {
                                do_warn(_("would clear entry\n"));
                        }
                }

but the logic is pretty tangled up in this function. It might help to see the
full xfs_repair output if you can provide it.

Thanks,
-Eric

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
