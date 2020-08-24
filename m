Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21A2250BB9
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Aug 2020 00:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgHXWfR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Mon, 24 Aug 2020 18:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726519AbgHXWfR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Aug 2020 18:35:17 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209005] xfs_repair 5.7.0: missing newline in message: entry at
 block N offset NN in directory inode NNNNNN has illegal name "/foo":
Date:   Mon, 24 Aug 2020 22:35:16 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: sandeen@redhat.com
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209005-201763-AdsIHeRB5G@https.bugzilla.kernel.org/>
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

--- Comment #7 from Eric Sandeen (sandeen@redhat.com) ---
Thanks for the info, and sorry for missing the 5.7.0 in the title.  And no
reason to apologize for sleeping in .au during my day in the US ;)

I think I can recreate the problem now, and the code is just kind of messy in
there, I'll see what I can do to make it a bit saner (with sane messages too).

Thanks,
-Eric

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
