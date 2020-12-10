Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817EC2D65EC
	for <lists+linux-xfs@lfdr.de>; Thu, 10 Dec 2020 20:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404201AbgLJTHM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Thu, 10 Dec 2020 14:07:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:39156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390668AbgLJTHF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 Dec 2020 14:07:05 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 210577] [xfstests generic/616] kernel BUG at
 lib/list_debug.c:28!
Date:   Thu, 10 Dec 2020 19:06:24 +0000
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
Message-ID: <bug-210577-201763-c8AX9IpaxI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-210577-201763@https.bugzilla.kernel.org/>
References: <bug-210577-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210577

--- Comment #4 from Zorro Lang (zlang@redhat.com) ---
(In reply to Jens Axboe from comment #3)
> What underlying device is being used?

The underlying device is general disk partition. But they're virtual machine(by
qemu-kvm), I only have VM ppc64le/aarch64.

> 
> Not fully clear to me what kernel is being used?

The kernel is:
# git clone https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
# git checkout -b for-next origin/for-next

Thanks,
Zorro

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
