Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 329095ABB6
	for <lists+linux-xfs@lfdr.de>; Sat, 29 Jun 2019 16:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfF2ORE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Sat, 29 Jun 2019 10:17:04 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47206 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726770AbfF2ORE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Jun 2019 10:17:04 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B29AC287E6
        for <linux-xfs@vger.kernel.org>; Sat, 29 Jun 2019 14:17:03 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 970A12883A; Sat, 29 Jun 2019 14:17:03 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=ham version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 204015] BUG: KASAN: slab-out-of-bounds in
 __bio_add_page+0x1ec/0x2b0
Date:   Sat, 29 Jun 2019 14:17:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: CC filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: Block Layer
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: axboe@kernel.dk
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-204015-201763-lkIYczLWoS@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204015-201763@https.bugzilla.kernel.org/>
References: <bug-204015-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=204015

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---
(In reply to Darrick J. Wong from comment #1)
> I suspect this is fixed by "xfs: fix iclog allocation size" which will be in
> for-next soon.

Great, I'll verify that after the patch be merged.

-- 
You are receiving this mail because:
You are watching someone on the CC list of the bug.
