Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB58431280A
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Feb 2021 00:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhBGXHS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 7 Feb 2021 18:07:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhBGXHR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Feb 2021 18:07:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 774E964E32
        for <linux-xfs@vger.kernel.org>; Sun,  7 Feb 2021 23:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612739197;
        bh=1UtupjDGuuyVU5CMen+dZ4rpvGZG2WSi6JHA64oCEO0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=YLYAbJsUc9MJNedGBqDPnFb6EF6sIrix66AZnqQjSTrUm65JdEhKWlSQU5zMxtlXL
         ssiwTjgxFwiSVmI6oknn5gtr1t2gpCpMd6H5k5otI024DeLHJbHkzkAKPG603E825w
         rZAuKxNdDtbLcC6npaGVT5YgOzl4tVFzJyHX2s6Jss/1dL/XToTgDEenlIEbFIQRWW
         TSRa9hp/Ld2p6RxWwF7znvYLx84GpuM9wJpPzwOrUPtWXfQGttH0xOQPi2LxV88ZyI
         AewvFtGxi5UmnjCEo6OqjnOyO1e5Byy9YUqCXGH9bG4ZC6fYYcbq0CA9uwqR+yeBH1
         06jgGSDzL5kJw==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 6CB1B65359; Sun,  7 Feb 2021 23:06:37 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211605] Re-mount XFS causes "noattr2 mount option is
 deprecated" warning
Date:   Sun, 07 Feb 2021 23:06:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: cuihao.leo@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-211605-201763-d9EeWKyTMn@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211605-201763@https.bugzilla.kernel.org/>
References: <bug-211605-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211605

--- Comment #5 from CUI Hao (cuihao.leo@gmail.com) ---
Sorry guys. I realized that I copy the wrong line of kernel message...

I meant to say I got "attr2 mount option is deprecated" warning when "attr2"
option is nowhere used...
not "noattr2"... "noattr2" one is only triggered when I was doing more test=
s.



More information about my mount command. I am using Arch Linux's stock one:
$ mount -V
mount from util-linux 2.36.1 (libmount 2.36.1: btrfs, namespaces, assert,
debug)
$ pacman -Q util-linux=20
util-linux 2.36.1-4

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
