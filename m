Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0610933215D
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Mar 2021 09:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhCIIxD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Mar 2021 03:53:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229720AbhCIIww (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Mar 2021 03:52:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A249264FDF
        for <linux-xfs@vger.kernel.org>; Tue,  9 Mar 2021 08:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615279972;
        bh=6hr5W6YGFI5Kv0/6u/Pct3myPn8+HxA3h1LmsLtzd8g=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=nkTtFuaY+ol6lON42UL//fEfMnH7tSjoTBpFAoSFanxcSB4VITZMBuwWfjEJZnYdl
         oZF5vv/LiQHI/o9t10YcVhQ8tPcGXqX73HKvNQJe1i4DVu0IPZhXQ2rky+sfhma6qE
         JMjP565NOJ7HVsB7CXHAyNdBWHrs2gPckhpqZW2knVmIpWjeYFm7GmP+Fj+iUytnXA
         gEOssfMAQHuKzSqE0SbCF1Xc+QK8O2yENoXK3mcJjLaL5OjRIvj4dk4tqFuK+REWl6
         rtNEnQQWwHHbjWXPfWddWJAZ4VQJDuBKceJuByt9QD88KL+y5vLsshJI+gpniAjh9X
         bjlvE5zcJ93mg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 9D30065343; Tue,  9 Mar 2021 08:52:52 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 212123] kernel BUG at mm/filemap.c:1499, invalid opcode: 0000
Date:   Tue, 09 Mar 2021 08:52:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: tm@dev-zero.ch
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: component product
Message-ID: <bug-212123-201763-qcEm1PfSBr@https.bugzilla.kernel.org/>
In-Reply-To: <bug-212123-201763@https.bugzilla.kernel.org/>
References: <bug-212123-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212123

Tiziano M=C3=BCller (tm@dev-zero.ch) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|XFS                         |Other
            Product|File System                 |Memory Management

--- Comment #1 from Tiziano M=C3=BCller (tm@dev-zero.ch) ---
As per the discussion in #xfs, this is most likely a bug in the page
cache/writeback state tracking. Changing component to Memory Management.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
