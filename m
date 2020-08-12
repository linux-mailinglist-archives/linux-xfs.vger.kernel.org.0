Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083DF242C24
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Aug 2020 17:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgHLPYT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Wed, 12 Aug 2020 11:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgHLPYP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Aug 2020 11:24:15 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208827] [fio io_uring] io_uring write data crc32c verify failed
Date:   Wed, 12 Aug 2020 15:24:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jmoyer@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-208827-201763-fJvAe2VlDU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208827-201763@https.bugzilla.kernel.org/>
References: <bug-208827-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208827

--- Comment #24 from Jeff Moyer (jmoyer@redhat.com) ---
Jens Axboe <axboe@kernel.dk> writes:

> Yes, it would ideally wait, or at least trigger on the last one. I'll
> see if I can improve that. For any of my testing, the amount of
> triggered short reads is minimal. For the verify case that we just ran,
> we're talking 8-12 ios out of 820 thousand, or 0.001% of them. So
> nothing that makes a performance difference in practical terms, though
> it would be nice to not hand back short reads if we can avoid it. Not
> for performance reasons, but for usage reasons.

I think you could make the case that handing back a short read is a
bug (unless RWF_NOWAIT was specified, of course).  At the very least, it
violates the principle of least surprise, and the fact that it happens
infrequently actually makes it a worse problem when it comes to
debugging.

-Jeff

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
