Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA4F3F2D0B
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Aug 2021 15:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240751AbhHTNV2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 20 Aug 2021 09:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238228AbhHTNV0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Aug 2021 09:21:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 34E1261152
        for <linux-xfs@vger.kernel.org>; Fri, 20 Aug 2021 13:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629465649;
        bh=kocrMkd5vkBdX+OlKsXOg4r5lwek9T2b3HoKvPy2NzQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Kg5MQhIzXhZS2GC9hH0vbIjyPRzyPX9otlglTG1hRci4mJDlKoV6M515KdUU/jH6F
         JdEsAXLhOeaxJNU/IjKvRCHdY5nmiQmH9tXM46wi4yynyDrm/GoNl8deqYcCpDWbKr
         0O7Ob4aiC4ubF568THcU9MR1OsTot+ZD0oEQWD/WNyujoGVHJWtT+jRK/fdDV5+StO
         SDfH+8Vwvv7bytgeCZi8AW5B3Aj5budFyEZgKvfkMxsMENb7b74U2jK56s5TJ9c1dy
         n+DYUAu+aOek6x4d/rHo+jzjbMDNimitophMi8OVnh2SQxoEwpSLTLG8H5OLeHuFHM
         fb0zOVemibbJQ==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 3242260ED3; Fri, 20 Aug 2021 13:20:49 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214079] [xfstests xfs/168] xfs_repair failed with shrinking
 776672
Date:   Fri, 20 Aug 2021 13:20:48 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status cc resolution
Message-ID: <bug-214079-201763-V1ajOHAApc@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214079-201763@https.bugzilla.kernel.org/>
References: <bug-214079-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214079

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |aros@gmx.com
         Resolution|---                         |DUPLICATE

--- Comment #2 from Artem S. Tashkinov (aros@gmx.com) ---


*** This bug has been marked as a duplicate of bug 214077 ***

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
