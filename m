Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEED268EE9
	for <lists+linux-xfs@lfdr.de>; Mon, 14 Sep 2020 17:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgINPEI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Mon, 14 Sep 2020 11:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbgINPEG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Sep 2020 11:04:06 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209243] [regression] fsx IO_URING reading get BAD DATA
Date:   Mon, 14 Sep 2020 15:04:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209243-201763-mnIvMSU3Bb@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209243-201763@https.bugzilla.kernel.org/>
References: <bug-209243-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209243

--- Comment #7 from Zorro Lang (zlang@redhat.com) ---
(In reply to Jens Axboe from comment #6)
> I'll take a look. Do you have a repo of fsstress with your io_uring changes
> included?

Thanks for your reply. Sorry, I don't prepare a public xfstests git repo. But
you can:

1) git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
2) merget below 5 patches into above xfstests:
https://patchwork.kernel.org/patch/11769857/
https://patchwork.kernel.org/patch/11769849/
https://patchwork.kernel.org/patch/11769851/
https://patchwork.kernel.org/patch/11769853/
https://patchwork.kernel.org/patch/11769855/

3) build xfstests with liburing install
4) make a XFS filesystem on a LVM device
5) mount the xfs filesystem
6) run xfstests/ltp/fsx -U -R -W -o 128000 $mnt/foo

Thanks,
Zorro

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
