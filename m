Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39CD3311AA
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Mar 2021 16:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhCHPHl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Mar 2021 10:07:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231417AbhCHPHV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 10:07:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 21AAD6522A
        for <linux-xfs@vger.kernel.org>; Mon,  8 Mar 2021 15:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615216041;
        bh=qYnLCeXnJRYXMOm3QlITUTmqOY3r1NwXLKVH3SWUoRc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=kw6vxe2jP3jq4YWVADjy+KQzXKtINfDZxMhfJWB4oXHqaDSuOp3aKFmPuY+j6BdPr
         LkbUrUaxIqyGiTM1cckuGLjfxTwOZuq/UWPg9dpsIKRqV1dQ0MIZXorYxupl1+ROJd
         J8OJ1pnzd/XT9VUCxyPgOqyjzTGDnhqX+nzoOZ6V7rTRGaGlpQpTtdwPN5hXcVdF94
         JxpQj5OpKS6fz/AzBvc4qiSQb5342GT0tCPdMW+/g4RA5bw2g5CfsGrdRol5eVEkzx
         8NdYDlc8JfgPULt8NuuELES9i8JAGYKCPy2ZpEv6gYZCb06XaS6Vgu9zuaipTZQHBF
         2vNaBKrtc/AZw==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 1CFDF65343; Mon,  8 Mar 2021 15:07:21 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211605] Re-mount XFS causes "attr2 mount option is deprecated"
 warning
Date:   Mon, 08 Mar 2021 15:07:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: sandeen@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-211605-201763-eq2QJn7VMe@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211605-201763@https.bugzilla.kernel.org/>
References: <bug-211605-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211605

--- Comment #9 from Eric Sandeen (sandeen@redhat.com) ---
Having "attr2" in /proc/mounts is OK. We will have a fix to suppress the
warning on remount.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
