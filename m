Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7A1168B5
	for <lists+linux-xfs@lfdr.de>; Tue,  7 May 2019 19:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfEGRFc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 7 May 2019 13:05:32 -0400
Received: from shelob.surriel.com ([96.67.55.147]:41174 "EHLO
        shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbfEGRFc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 May 2019 13:05:32 -0400
Received: from [2001:470:1f07:12aa:6e0b:84ff:fee2:98bb] (helo=imladris.surriel.com)
        by shelob.surriel.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.91)
        (envelope-from <riel@shelob.surriel.com>)
        id 1hO3Wz-0007hS-IA; Tue, 07 May 2019 13:05:29 -0400
Date:   Tue, 7 May 2019 13:05:28 -0400
From:   Rik van Riel <riel@surriel.com>
To:     linux-xfs@vger.kernel.org
Cc:     kernel-team@fb.com, linux-kernel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "David Chinner" <dchinner@redhat.com>
Subject: [PATCH] fs,xfs: fix missed wakeup on l_flush_wait
Message-ID: <20190507130528.1d3d471b@imladris.surriel.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The code in xlog_wait uses the spinlock to make adding the task to
the wait queue, and setting the task state to UNINTERRUPTIBLE atomic
with respect to the waker.

Doing the wakeup after releasing the spinlock opens up the following
race condition:

- add task to wait queue

-                                      wake up task

- set task state to UNINTERRUPTIBLE

Simply moving the spin_unlock to after the wake_up_all results
in the waker not being able to see a task on the waitqueue before
it has set its state to UNINTERRUPTIBLE.

The lock ordering of taking the waitqueue lock inside the l_icloglock
is already used inside xlog_wait; it is unclear why the waker was doing
things differently.

Signed-off-by: Rik van Riel <riel@surriel.com>
Reported-by: Chris Mason <clm@fb.com>

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c3b610b687d1..8b9be76b2412 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2710,7 +2710,6 @@ xlog_state_do_callback(
 	int		   funcdidcallbacks; /* flag: function did callbacks */
 	int		   repeats;	/* for issuing console warnings if
 					 * looping too many times */
-	int		   wake = 0;
 
 	spin_lock(&log->l_icloglock);
 	first_iclog = iclog = log->l_iclog;
@@ -2912,11 +2911,9 @@ xlog_state_do_callback(
 #endif
 
 	if (log->l_iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_IOERROR))
-		wake = 1;
-	spin_unlock(&log->l_icloglock);
-
-	if (wake)
 		wake_up_all(&log->l_flush_wait);
+
+	spin_unlock(&log->l_icloglock);
 }
 
 

