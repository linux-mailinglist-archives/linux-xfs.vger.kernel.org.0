Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF0C242C28
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Aug 2020 17:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgHLP04 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Wed, 12 Aug 2020 11:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgHLP0z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Aug 2020 11:26:55 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208827] [fio io_uring] io_uring write data crc32c verify failed
Date:   Wed, 12 Aug 2020 15:26:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: axboe@kernel.dk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-208827-201763-vjFt8O8GIg@https.bugzilla.kernel.org/>
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

--- Comment #25 from Jens Axboe (axboe@kernel.dk) ---
On 8/12/20 9:24 AM, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> Yes, it would ideally wait, or at least trigger on the last one. I'll
>> see if I can improve that. For any of my testing, the amount of
>> triggered short reads is minimal. For the verify case that we just
>> ran, we're talking 8-12 ios out of 820 thousand, or 0.001% of them.
>> So nothing that makes a performance difference in practical terms,
>> though it would be nice to not hand back short reads if we can avoid
>> it. Not for performance reasons, but for usage reasons.
> 
> I think you could make the case that handing back a short read is a
> bug (unless RWF_NOWAIT was specified, of course).  At the very least,
> it violates the principle of least surprise, and the fact that it
> happens infrequently actually makes it a worse problem when it comes
> to debugging.

It's definitely on my list to ensure that we handle the somewhat
expected case by just retrying it internally, because I do agree that it
can be surprising. FWIW, this isn't a change with 5.9-rc, io_uring has
always potentially short buffered reads when when the io-wq offload was
done.

While it may happen infrequently with this specific test case, others
can trigger it more often.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
