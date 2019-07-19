Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F09DC6EC11
	for <lists+linux-xfs@lfdr.de>; Fri, 19 Jul 2019 23:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbfGSV2t convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Fri, 19 Jul 2019 17:28:49 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46876 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727603AbfGSV2t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jul 2019 17:28:49 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BA6182892A
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jul 2019 21:28:48 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id AC333289BD; Fri, 19 Jul 2019 21:28:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 204223] [fstests generic/388 on xfs]: 4.19.58 xfs_nocrc /
 xfs_reflink null pointer dereference at xfs_trans_brelse+0x21
Date:   Fri, 19 Jul 2019 21:28:47 +0000
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
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-204223-201763-sg1Gc6zQFK@https.bugzilla.kernel.org/>
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

Luis Chamberlain (mcgrof@kernel.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|CODE_FIX                    |---

--- Comment #7 from Luis Chamberlain (mcgrof@kernel.org) ---
Not fixed yet, it just takes longer with this commit to trigger.

-- 
You are receiving this mail because:
You are watching someone on the CC list of the bug.
