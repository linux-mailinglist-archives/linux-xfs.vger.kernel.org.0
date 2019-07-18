Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95DA26D5B2
	for <lists+linux-xfs@lfdr.de>; Thu, 18 Jul 2019 22:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390241AbfGRUVk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Thu, 18 Jul 2019 16:21:40 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40026 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728054AbfGRUVk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 16:21:40 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8F4CC288BE
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2019 20:21:39 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 84366288CA; Thu, 18 Jul 2019 20:21:39 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 204223] [fstests generic/388 on xfs]: 4.19.58 xfs_nocrc /
 xfs_reflink null pointer dereference at xfs_trans_brelse+0x21
Date:   Thu, 18 Jul 2019 20:21:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: CC filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: mcgrof@kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-204223-201763-AP07fQmlD4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204223-201763@https.bugzilla.kernel.org/>
References: <bug-204223-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=204223

--- Comment #3 from Luis Chamberlain (mcgrof@kernel.org) ---
After about ~30 runs I managed to crash a system with the same type of output
on this big with reflink enabled but rmapbt disabled, ie, the
"xfs_reflink_normapbt" configuration Zorro used on kz#204049:

# xfs_info /dev/loop5
meta-data=/dev/loop5             isize=512    agcount=4, agsize=1310720 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=5242880, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

[0] https://bugzilla.kernel.org/show_bug.cgi?id=204049

kz#204049 reveals upstream is also affected by this bug then.

-- 
You are receiving this mail because:
You are watching someone on the CC list of the bug.
