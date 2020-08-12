Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD664242C14
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Aug 2020 17:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgHLPT6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Wed, 12 Aug 2020 11:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbgHLPTz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Aug 2020 11:19:55 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208827] [fio io_uring] io_uring write data crc32c verify failed
Date:   Wed, 12 Aug 2020 15:19:54 +0000
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
Message-ID: <bug-208827-201763-FeQfLIVMLw@https.bugzilla.kernel.org/>
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

--- Comment #23 from Jens Axboe (axboe@kernel.dk) ---
On 8/11/20 5:00 PM, Dave Chinner wrote:
> On Wed, Aug 12, 2020 at 07:59:13AM +1000, Dave Chinner wrote:
>> On Tue, Aug 11, 2020 at 07:10:30AM -0600, Jens Axboe wrote:
>>> What job file are you running? It's not impossible that I broken
>>> something else in fio, the io_u->verify_offset is a bit risky... I'll
>>> get it fleshed out shortly.
>>
>> Details are in the bugzilla I pointed you at. I modified the
>> original config specified to put per-file and offset identifiers
>> into the file data rather than using random data. This is
>> "determining the origin of stale data 101" stuff - the first thing
>> we _always_ do when trying to diagnose data corruption is identify
>> where the bad data came from.
>>
>> Entire config file is below.
> 
> Just as a data point: btrfs fails this test even faster than XFS.
> Both with the old 3.21 fio binary and the new one.

I can't trigger any failures with the fixes I committed, so that's a bit
puzzling. What storage are you running this on? I'll try a few other
things.

> Evidence points to this code being very poorly tested. Both
> filesystems it is enabled on fail validation with the tool is
> supposed to exercise and validate io_uring IO path behaviour.
> 
> Regardless of whether this is a tool failure or a kernel code
> failure, the fact is that nobody ran data validation tests on this
> shiny new code. And for a storage API that is reading and writing
> user data, that's a pretty major process failure....
> 
> Improvements required, Jens.

Let's turn down the condescension and assumptions a notch, please. The
fio io_uring engine was originally written to benchmark it, and I
haven't really been using it for verification purposes (as is evident).
In my experience, I get much better validation from running internal
production. And plenty of that has been done.

That said, the fio side should of course work, since others can't
necessarily run what I'm running, and it does provide ways to exercise
it that aren't necessarily seen in prod. But blankly assuming that
"nobody ran data validation tests on this shiny new code" is blatantly
false.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
