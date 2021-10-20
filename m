Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798A44352C2
	for <lists+linux-xfs@lfdr.de>; Wed, 20 Oct 2021 20:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhJTSjY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 20 Oct 2021 14:39:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhJTSjY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Oct 2021 14:39:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B1D8B61212
        for <linux-xfs@vger.kernel.org>; Wed, 20 Oct 2021 18:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634755029;
        bh=nC/bPXaSEMo18KZEAKNn/PrbcW9EBpKanEnBDMqosx4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=esMfXd0pWPgQKxgOCSet6hpy9bjY/GCxzwaYkxHgfTLe570ZVnY+Xe4JExqYUGyMa
         86HKHAZNQ6q188fpGOr5cYpTr3bTs7Y4AWEP9yz1SotcoM5IstpDWWmps8GLJxBv4n
         eeGf6QoI4Z4c/Gr3hHf+smBoQGuyt/GIBpAZEdE8hja9zs6OZLCA4rXrytM3J5BLb4
         R2f/9uNr9WwIK57fatDVCQ2dNyZf1kXpjMoIIXdDvfn7zbeBM1D3N3ErM6EmGmSqe/
         IV0TVkWnRDm6JVyxiPMbjtiE7Tkqfd2AFOPjlqDFffiF2j1ajOe/kqvJd34zc/r1E7
         /iXl+Ex/Z51dQ==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id ADB0D61106; Wed, 20 Oct 2021 18:37:09 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214767] xfs seems to hang due to race condition? maybe related
 to (gratuitous) thaw.
Date:   Wed, 20 Oct 2021 18:37:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ct@flyingcircus.io
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214767-201763-1MKLhv0B5x@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214767-201763@https.bugzilla.kernel.org/>
References: <bug-214767-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214767

--- Comment #5 from Christian Theune (ct@flyingcircus.io) ---
I've also picked this up with the friends from NixOS in case we can shed so=
me
light on what the dance is that the nix-daemon performs here:
https://github.com/NixOS/nixpkgs/issues/142394

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
