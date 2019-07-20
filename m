Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0266F0F2
	for <lists+linux-xfs@lfdr.de>; Sun, 21 Jul 2019 00:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbfGTWtl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Sat, 20 Jul 2019 18:49:41 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49624 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725812AbfGTWtl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Jul 2019 18:49:41 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 00A0D28823
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jul 2019 22:49:40 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id DFA2D28837; Sat, 20 Jul 2019 22:49:39 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 204223] [fstests generic/388 on xfs]: 4.19.58 xfs_nocrc /
 xfs_reflink null pointer dereference at xfs_trans_brelse+0x21
Date:   Sat, 20 Jul 2019 22:49:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: CC filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: mcgrof@kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-204223-201763-ZOtqggK0xm@https.bugzilla.kernel.org/>
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

--- Comment #8 from Luis Chamberlain (mcgrof@kernel.org) ---
These commits fix this crash:

xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
xfs: Add helper function xfs_attr_try_sf_addname
xfs: Add attibute set and helper functions
xfs: Add attibute remove and helper functions
xfs: always rejoin held resources during defer roll

I've left generic/388 running over time and it ran up to 247 times
successfully, and failed but at least without a crash in the end.

In particular the last commit has has some fixes to correct bhold callers to
release held buffers correctly merged into the patch, which IMHO should have
been split up into a separate patch.

Trying to extract the exact minor fix is difficult due to the amount of churn
from the prior patches. We'll have to try to do that work somehow or just
consider merging all of these.

-- 
You are receiving this mail because:
You are watching someone on the CC list of the bug.
