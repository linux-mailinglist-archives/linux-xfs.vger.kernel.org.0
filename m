Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17473F43FB
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Aug 2021 05:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbhHWDij (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 22 Aug 2021 23:38:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232362AbhHWDij (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 22 Aug 2021 23:38:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3AF536136F
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 03:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629689877;
        bh=ktqfXw0A3mnCwZgP2bxGjmdrCpEFdip1lMygdPN/6Hs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=HMeThVfm4DyehQbWAW5atDkJHkRDr9+jAj/eWOEafHDn7XbEg0X6E0fDeUstQ7h/1
         ZoN4qWRUnP+KfoYISv1F2QWKhn4FkrMiiUM+UlPYJksIFK8Cae1ei47aMEyTQBqxKc
         UrW0/LiWT3BR+xdCVj/eGJXS1cvq0PJQ/PAh8zSCiyNoYZcHe2MloewNSs8Hld4856
         ANwVcyGfeyBLWmbF1oiZ3rQBUe+7cv8guaNz437hIvK77hzTJBsnDnOzWhB3fuYonm
         B3LFrHyzyIQJMARq/28ANvcsznCTldcqAg/anlZ28aq9yibfs44hnY0XmUDLkEwase
         grHcNCjaYFX8w==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 3770F60F4D; Mon, 23 Aug 2021 03:37:57 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214077] [xfstests xfs/168] xfs_repair failed with shrinking
 776672
Date:   Mon, 23 Aug 2021 03:37:56 +0000
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
Message-ID: <bug-214077-201763-cuckF0Tt63@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214077-201763@https.bugzilla.kernel.org/>
References: <bug-214077-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214077

--- Comment #4 from Zorro Lang (zlang@redhat.com) ---
FYI: reproduced it on mainline linux 5.14.0-rc6+

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
