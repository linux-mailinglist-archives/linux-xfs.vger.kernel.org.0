Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C6F30203A
	for <lists+linux-xfs@lfdr.de>; Mon, 25 Jan 2021 03:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbhAYCRK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Sun, 24 Jan 2021 21:17:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbhAYCQh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 24 Jan 2021 21:16:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3094D22D50
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 02:15:55 +0000 (UTC)
Received: by pdx-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 29FE482545; Mon, 25 Jan 2021 02:15:55 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211329] XFS related memory leak on ppc64le
Date:   Mon, 25 Jan 2021 02:15:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: cam@neo-zeon.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: component product
Message-ID: <bug-211329-201763-ncdailIAH4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211329-201763@https.bugzilla.kernel.org/>
References: <bug-211329-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=211329

Cameron (cam@neo-zeon.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|XFS                         |Other
            Product|File System                 |IO/Storage

--- Comment #5 from Cameron (cam@neo-zeon.de) ---
Yes, they're all blkg_alloc.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.
