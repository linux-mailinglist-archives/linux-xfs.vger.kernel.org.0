Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF0C6D58A
	for <lists+linux-xfs@lfdr.de>; Thu, 18 Jul 2019 22:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390982AbfGRUAp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Thu, 18 Jul 2019 16:00:45 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33498 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727687AbfGRUAp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 16:00:45 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 208CB28857
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2019 20:00:44 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 153C02883D; Thu, 18 Jul 2019 20:00:44 +0000 (UTC)
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
Date:   Thu, 18 Jul 2019 20:00:43 +0000
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
Message-ID: <bug-204049-201763-VtyfTEt7Rt@https.bugzilla.kernel.org/>
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

--- Comment #1 from Luis Chamberlain (mcgrof@kernel.org) ---
I reported an immediate v4.19.58 vanilla crash  with generic/388 but with the
"xfs_nocrc" and "xfs_reflink" configuration as per oscheck's testing:

The "xfs_nocrc":

# xfs_info /dev/loop5
meta-data=/dev/loop5             isize=256    agcount=4, agsize=1310720 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0, sparse=0, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=5242880, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

The "xfs_reflink" configuration:

# xfs_info /dev/loop5
meta-data=/dev/loop5             isize=512    agcount=4, agsize=1310720 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1
data     =                       bsize=4096   blocks=5242880, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=3693, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

This is being tracked on this bug report:

https://bugzilla.kernel.org/show_bug.cgi?id=204223

The configuration above has rmapbt=1, you have rmapbt=0, at least in
discussions over which types of configurations to test for stable long ago on
the mailing list using rmapbt=0 with reflink was not one which we set out to
cover, so curious what the motivation was for tracking problems with it were
now. I'll just refer to this configuration then as "xfs_reflink_normapbt" and
I'll consider tracking it for stable depending on why you set out to cover it
as well.


I cannot reproduce your crash on v4.19.58 with your same configuration,
""xfs_reflink_normapbt", at least so far I've ran the test 15 times in a loop
and I see no failure. The other crashes occur within 1-3 times of running the
test. How many times did you run the test for it to crash on the system?

I'll leave the test running a bit longer just in case.

Given what I am seeing though, it seems likely there may be a regression here.
Could you bisect? We at least now have an idea of what to expect around the
v4.19 for different configurations including yours.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
