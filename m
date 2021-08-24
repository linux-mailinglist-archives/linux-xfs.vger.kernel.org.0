Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D4C3F5A5D
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Aug 2021 11:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbhHXJDD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Aug 2021 05:03:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235264AbhHXJDC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Aug 2021 05:03:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 18E99613B1
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 09:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629795739;
        bh=tx/OtuWg7GJgwDLa6RXkkBuRu7BVe1t77uoCNgvQFvE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=d32iZHaXNpPSzO32EBq9kYiW+edrUH/jrq9M7ehIKracAOoibOjCk02z3fcxW59o3
         2f9czka0SJYPUbrKPyWQlcK+1rPZJVpapNzYnKk4NTnthQCf0rM1d0cr44hOZMTXxF
         AR24iTm2dkSOmkRXLMDXU/BSLWswA8o1JQRb8GSm5iuQrP3FPE+VhfemY3NjV+BCe4
         jeD5FHTNdh8tb61aOSvrS78jiBBoE6Y+vVMPUmLZ46t5rshEbYyP8NgFmnGdY5rcvT
         h6Rt/u0TTXa0fIPaIdo2/7Sfq7miXcKJE7yCh2H1WnqJQN611+AWmQ0jIfaBVxiLZI
         VSkdZS6NH9v2Q==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 1434F60FF2; Tue, 24 Aug 2021 09:02:19 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 213625] [xfstests xfs/104] XFS: Assertion failed: agno <
 mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c, line: 22
Date:   Tue, 24 Aug 2021 09:02:18 +0000
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
Message-ID: <bug-213625-201763-plhIgMp3g6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213625-201763@https.bugzilla.kernel.org/>
References: <bug-213625-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213625

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---
*** Bug 213941 has been marked as a duplicate of this bug. ***

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
