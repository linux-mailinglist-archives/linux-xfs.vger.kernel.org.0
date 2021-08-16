Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40FD3ED441
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Aug 2021 14:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhHPMrK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Aug 2021 08:47:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229806AbhHPMrJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Aug 2021 08:47:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6E4666327E
        for <linux-xfs@vger.kernel.org>; Mon, 16 Aug 2021 12:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629117998;
        bh=Fwio7y3fUZTWNlxUhKGEO4VbHtdvmtvLcNZbibDH1Vk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IYptlj/xiIyoD1UJOzqMFFcwQ/hrtxC/F7jaQYCnau9V2U2/oxC2itJSY+UivGoA7
         zeITfCxJ3aqbQmIrVakTi3kMV/v97UBcYCKc9om7lwTxYW93UiiNe/9caHTSFaAQ5s
         WEBehcA+c0+02Tu50DsZql7VEa6ZgoQsdl+0iOynoauHC430QeWGNbqEIRmJkwVGoy
         2L/IzpNl3PrYIbRBVvd0KkLX/tAo5rBZNwkxhHSqrJ9w09XRRikwzQqpuA12uusped
         Box3/2pFMigkru5LTw8dLDy4viML1fptAPVtxwpgXwVHokeNvr5+FdvNM/ZkdxBVPp
         FtKCvklBz85ZA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 6AE1D60FDB; Mon, 16 Aug 2021 12:46:38 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214079] [xfstests xfs/168] xfs_repair failed with shrinking
 776672
Date:   Mon, 16 Aug 2021 12:46:37 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-214079-201763-rIQr9HY2lh@https.bugzilla.kernel.org/>
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

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
Created attachment 298335
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D298335&action=3Dedit
xfs-168.full file

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
