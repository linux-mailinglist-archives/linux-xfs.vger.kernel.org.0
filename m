Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D14037F8B9
	for <lists+linux-xfs@lfdr.de>; Thu, 13 May 2021 15:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbhEMNY6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 May 2021 09:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234301AbhEMNXv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 May 2021 09:23:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8838C6143F
        for <linux-xfs@vger.kernel.org>; Thu, 13 May 2021 13:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620912161;
        bh=dehrlYOTWlz/vvEwUlY1NYWz0IwydUB6IvYfhUF5cvE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=UGAnhAykyqBfjrZ5Lm7NyJUN2dy8IBb1qDn19SCBrf0EgMlKVia3fMVhN/9BpE4M1
         m5g5vQazLzoHvBOrEQ1dnmd0Ay0WhC7aCP1c3ZoVP+mGwsPm6hhfd97OI2pcDMZOvg
         5yia99bKhbYWNbshCbSBieJEnQLKw1hzfNmL09kXQdGtoIHDJ2P0kwTyRBSOyypwP/
         sRQEu5yVyCxICeH0SMTlUW6mDryezPZyaGNLerNqeNtu2XWd/pIjLPyhmGgay1aqHK
         icYXXF6Gml4kX4VelLKIe1FNfgp0GNl0smvBA9mYVDLDIZmEjxtXKyLQU1y8QqZSYm
         uuaZroF2ZwcNw==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 849FA6128B; Thu, 13 May 2021 13:22:41 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211605] Re-mount XFS causes "attr2 mount option is deprecated"
 warning
Date:   Thu, 13 May 2021 13:22:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: preichl@redhat.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-211605-201763-1wa6QppWGS@https.bugzilla.kernel.org/>
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

--- Comment #13 from Pavel Reichl (preichl@redhat.com) ---
Hi Victor,

I'm not sure I follow - but as you can see the bug status is: 'RESOLVED
CODE_FIX' and the fix is in upstream tag v5.13-rc1 .

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
