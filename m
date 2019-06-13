Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620484386A
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 17:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732439AbfFMPFr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Thu, 13 Jun 2019 11:05:47 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39698 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732435AbfFMONK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 10:13:10 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 585EA1FFE4
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 14:13:10 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 54A07204BF; Thu, 13 Jun 2019 14:13:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=ham version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 203887] New: CGroup writeback is not supported by `xfs`
 filesystem leading to errors when using containers.
Date:   Thu, 13 Jun 2019 14:13:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: axel.borja.login@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-203887-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203887

            Bug ID: 203887
           Summary: CGroup writeback is not supported by `xfs` filesystem
                    leading to errors when using containers.
           Product: File System
           Version: 2.5
    Kernel Version: 4.14
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: axel.borja.login@gmail.com
        Regression: No

I am currently working on a Kubernetes cluster, which uses docker.

This cluster allows me to launch jobs. For each job, I specify a memory request
and a memory limit.

The memory limit will be used by Kubernetes to fill the `--memory` option of
the docker run command when creating the container. If this container exceeds
this limit it will be killed for OOM reason.

When writing on disk, pages will be written-back on the RAM before being
written to the disk. To do this the system will evaluate how many pages could
be written-back using the sysctl `vm.dirty_ratio` (20 % by default) and memory
from the root cgroup.

In case of intensive IO operations, it leads some containers to OOM errors.

xfs should be able to writeback using cgroup.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
