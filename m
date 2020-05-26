Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A261DD33D
	for <lists+linux-xfs@lfdr.de>; Thu, 21 May 2020 18:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgEUQpf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Thu, 21 May 2020 12:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728539AbgEUQpe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 May 2020 12:45:34 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 207817] kworker using a lots of cpu
Date:   Thu, 21 May 2020 16:45:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: askjuise@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-207817-201763-k4jOyZfee6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207817-201763@https.bugzilla.kernel.org/>
References: <bug-207817-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207817

--- Comment #1 from Alexander Petrovsky (askjuise@gmail.com) ---
After 1 day, it seems like some internal activity calm down kworker at 00:00
UTC, it could be logrotate or smth else. But now, I'm observe the follow (seems
like it has the same root cause):

#df -h
Filesystem                     Size  Used Avail Use% Mounted on
...
/dev/mapper/vg_logs-lv_varlog   38G  -30G   68G    - /var/log
...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
