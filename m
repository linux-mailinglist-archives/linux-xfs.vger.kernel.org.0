Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA7A1D057B
	for <lists+linux-xfs@lfdr.de>; Wed, 13 May 2020 05:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgEMDVG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Tue, 12 May 2020 23:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbgEMDVG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 May 2020 23:21:06 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 207715] New: xfs: data race on lip->li_lsn in
 xfs_trans_ail_update_bulk()
Date:   Wed, 13 May 2020 03:21:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: baijiaju1990@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-207715-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207715

            Bug ID: 207715
           Summary: xfs: data race on lip->li_lsn in
                    xfs_trans_ail_update_bulk()
           Product: File System
           Version: 2.5
    Kernel Version: 5.4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: baijiaju1990@gmail.com
        Regression: No

The functions xfs_trans_ail_update_bulk() and xfs_inode_item_format_core() are
concurrently executed at runtime in the following call contexts:

Thread 1:
xlog_ioend_work()
  xlog_state_done_syncing()
    xlog_state_do_callback()
      xlog_state_do_iclog_callbacks()
        xlog_cil_process_committed()
          xlog_cil_committed()
            xfs_trans_committed_bulk()
              xfs_log_item_batch_insert()
                xfs_trans_ail_update_bulk()

Thread 2:
xfs_file_write_iter()
  xfs_file_buffered_aio_write()
    xfs_file_aio_write_checks()
      xfs_vn_update_time()
        xfs_trans_commit()
          __xfs_trans_commit()
            xfs_log_commit_cil()
              xlog_cil_insert_items()
                xlog_cil_insert_format_items()
                  xfs_inode_item_format()
                    xfs_inode_item_format_core()

In xfs_trans_ail_update_bulk():
  lip->li_lsn = lsn;

In xfs_inode_item_format_core():
  xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);

The variables lip->li_lsn and ip->i_itemp->ili_item.li_lsn access the same
memory, and thus a data race can occur.

This data race was found and actually reproduced by our concurrency fuzzer.

I am not sure whether this data race is harmful and how to fix this data race
properly, so I want to listen to your opinions, thanks :)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
