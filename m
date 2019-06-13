Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3DDA43860
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 17:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732893AbfFMPFS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Thu, 13 Jun 2019 11:05:18 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42084 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732452AbfFMOPx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 10:15:53 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7E4E520134
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 14:15:52 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 7C55620564; Thu, 13 Jun 2019 14:15:52 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 203887] CGroup writeback is not supported by `xfs` filesystem
 leading to errors when using containers.
Date:   Thu, 13 Jun 2019 14:15:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-203887-201763-zmLgdcXSIq@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203887-201763@https.bugzilla.kernel.org/>
References: <bug-203887-201763@https.bugzilla.kernel.org/>
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

--- Comment #1 from axel.borja.login@gmail.com ---
My nodes are running under RHEL with a kernel 4.14 and I encounter OOM errors
when writing with xfs.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
