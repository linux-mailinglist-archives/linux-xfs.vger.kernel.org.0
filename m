Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDC26D5C4
	for <lists+linux-xfs@lfdr.de>; Thu, 18 Jul 2019 22:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391510AbfGRU3T convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Thu, 18 Jul 2019 16:29:19 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44700 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391484AbfGRU3T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 16:29:19 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 60D8B2889E
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2019 20:29:19 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 54BF128894; Thu, 18 Jul 2019 20:29:19 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 204049] [xfstests generic/388]: XFS: Assertion failed:
 ip->i_d.di_format != XFS_DINODE_FMT_BTREE || ip->i_d.di_nextents >
 XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK), file: fs/xfs/xfs_inode.c, line: 3646
Date:   Thu, 18 Jul 2019 20:29:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-204049-201763-sqxMi1T70G@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204049-201763@https.bugzilla.kernel.org/>
References: <bug-204049-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=204049

--- Comment #3 from Luis Chamberlain (mcgrof@kernel.org) ---
And, do you not get a crash with the "xfs_nocrc" or "xfs_reflink"
configurations? What if you run the test in a loop. To test in a loop I use
oscheck's naggy-check.sh [0]. Provided you have configured your sections named
in the fstests configuration as I have on oscheck [1], you should be able to
use it as follows until a failure is found:

./naggy-check.sh -s xfs_reflink_normapbt -f generic/388

I just added xfs_reflink_normapbt to the upstream oscheck demo config.

[0] https://gitlab.com/mcgrof/oscheck/blob/master/naggy-check.sh
[1] https://gitlab.com/mcgrof/oscheck/blob/master/fstests-configs/xfs.config

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
