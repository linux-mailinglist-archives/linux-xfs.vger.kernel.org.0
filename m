Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0648734F649
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Mar 2021 03:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhCaBjA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Mar 2021 21:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhCaBiv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 21:38:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 733AB619D2
        for <linux-xfs@vger.kernel.org>; Wed, 31 Mar 2021 01:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617154731;
        bh=IFZo2tB7ZrVxCOyW/ZH0ZtyaMbz8XoTQix2fNVSaB0w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=nqZl2pm1fsFXyoCu+L4Olb6NONqeR6VJ2cgsStlnZ+BqYQKviebdnp1n0fMuomNWb
         bagdDgSR9tZ8Yfgnzv9LK1M2Ja9HLYWaqL6A4t8jPdKn+a8CW24sMsIcvMsnkbYYqy
         IDnNs/KwPq3nAZ9z7MThOmk/RXoCniThnvB0Am0iaxkko4pljnOagN4P4hlxNTwpWg
         VKzYrMNIZEXFQaFAvg64Zl5EwO3dob/BZz8BUEsDbEHLtKstpp8x4IDG65fD3cf/qD
         +bxIkmnCr2UMuG8P+SdkYTc4nDKBAMQnt2+i6CvVuBZllulSvy2dRoKfiX9HVzUeBe
         yW5H4w/m8XzEg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 6F2CE62AB9; Wed, 31 Mar 2021 01:38:51 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 212495] xfs: system crash caused by null bp->b_pages
Date:   Wed, 31 Mar 2021 01:38:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: djwong@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-212495-201763-Rc2ssQ1D1O@https.bugzilla.kernel.org/>
In-Reply-To: <bug-212495-201763@https.bugzilla.kernel.org/>
References: <bug-212495-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212495

Darrick J. Wong (djwong@kernel.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |djwong@kernel.org

--- Comment #1 from Darrick J. Wong (djwong@kernel.org) ---
See the discussion at

https://lore.kernel.org/linux-xfs/20201224095142.7201-1-xi.fengfei@h3c.com/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
