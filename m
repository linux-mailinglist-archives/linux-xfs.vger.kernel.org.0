Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18E02D309C
	for <lists+linux-xfs@lfdr.de>; Tue,  8 Dec 2020 18:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgLHRLJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Tue, 8 Dec 2020 12:11:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbgLHRLJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Dec 2020 12:11:09 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 210535] [xfstests generic/466] XFS: Assertion failed:
 next_agino == irec->ir_startino + XFS_INODES_PER_CHUNK, file:
 fs/xfs/xfs_iwalk.c, line: 366
Date:   Tue, 08 Dec 2020 17:10:28 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-210535-201763-FfTMv1aRNx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-210535-201763@https.bugzilla.kernel.org/>
References: <bug-210535-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210535

--- Comment #4 from Zorro Lang (zlang@redhat.com) ---
Created attachment 294049
  --> https://bugzilla.kernel.org/attachment.cgi?id=294049&action=edit
g466-xfs.metadump.tar.gz

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
