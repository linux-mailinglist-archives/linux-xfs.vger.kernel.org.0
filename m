Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1193F43C6
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Aug 2021 05:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbhHWDP0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 22 Aug 2021 23:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233259AbhHWDOx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 22 Aug 2021 23:14:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 490DB61361
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 03:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629688451;
        bh=1JhYKOb69s2VduWdKb9hQfbWAEABcTC7mDI5UYkL5Cs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=i6BD8pV6AFATse7sGvwbP4GwmuYAmwJ89O00kSa8OvjONuL62s+djHPID4Xv6OWCA
         +VvUZWDVyY1AeRt6PefZXa2+T3EAdua1ucuRgUn9nMGpTCLxjRa7rlaIrWILni3mio
         7w3f1amnJL75KNG75gB7SkvEvodVjRrSQp7es9pLo6wqyjnkRM1WYLMWccWWXNbvAb
         zGFKHbdjZEW+iiWKWsrMSi+5uOA/4VLFKICwKRp4GcKyhIfMbVnyZqqtUqHbi2C5Wg
         CjsMBKDyy5FXDaGbYMDDEoGuapuER4N7kduAucKUkdQQon0QEbfWc+/ClpVHyj3unv
         sTTA6oJ8UQxNg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 45A0960F55; Mon, 23 Aug 2021 03:14:11 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214139] [xfstests xfs/319] XFS: Assertion failed:
 got.br_startoff > bno, file: fs/xfs/libxfs/xfs_bmap.c, line: 4715
Date:   Mon, 23 Aug 2021 03:14:10 +0000
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
Message-ID: <bug-214139-201763-l2VaizdBFV@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214139-201763@https.bugzilla.kernel.org/>
References: <bug-214139-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214139

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
Created attachment 298429
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D298429&action=3Dedit
xfs-319.full

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
