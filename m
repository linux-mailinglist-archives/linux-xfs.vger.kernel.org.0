Return-Path: <linux-xfs+bounces-26558-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BCF0BE2169
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Oct 2025 10:05:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FB093A5A25
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Oct 2025 08:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE892FBE1C;
	Thu, 16 Oct 2025 08:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YWOk29yC"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D678129A78
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 08:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760601930; cv=none; b=D8Bikf3eWbgmK7mqryMcUqdCXZ6rAfbM3PFvo2Fo3R+gpp0ZFihJzlfUUCN/iVCbQu0caQNBk/H4NtWiWjqFi1jyLKvwReGoXJLCBWzwdSmKtBPdG6CJ6K5svHfN0Te/jhrKjHGva5Y51Oo/QJCjF123CxCQZu9kbNi7NLI0by8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760601930; c=relaxed/simple;
	bh=L92Zk5SZVqcX4Pi/0kIuID4fRxojTpBgzyoSPMVdYbU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eoayGr8/pAi60cBsPorYtEGbupjhGE1Y6/DxyvPuzpZ3zPbFfNnBvc6smrY6J5UDHhwj1+a9wZuEDzItWkq11+Vukyx4Er+x//6f1Itfy09M1nxxDLyCyQjMgshVq/kJCBCXwt/37YZgnvHXZm1INCSmf3Ybykvz1Nn+zRhwMWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YWOk29yC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id E948FC113D0
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 08:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760601929;
	bh=L92Zk5SZVqcX4Pi/0kIuID4fRxojTpBgzyoSPMVdYbU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=YWOk29yCyTiV1HM1EbCBZiXsLpGlbyX35JNIabc4yY+Y++FyYDXXpbn7qZ10fcVjP
	 r1lF02j9QmHBRa3d5VS4prHT0ZQkMqTOq5t9557mxF+0VW0AZs/nQB6YVmcKTX1I8d
	 iE/l8loN4bZdt666ykeWfhrmYNB8KvvyytYgRn8PcEcS8b7BFgvyPDWUzuDl9CLgJT
	 pF2R8W89dpQDv06B2JgnjxTVCb3cs0XuyRITcFSUEFNWtK6X02bFlIWL+c53xR9vMF
	 0NZ44NsHcCnBOnMMkQfrbT8f7SnNXZHeunkBIso9q/YboDQLnUs6hqLvDIUBumUyBM
	 suBRTQO2WPwFg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E2F1EC53BC5; Thu, 16 Oct 2025 08:05:29 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 220669] Drive issues cause system and coredump and reboot
Date: Thu, 16 Oct 2025 08:05:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: WILL_NOT_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-220669-201763-XB5LNO9skF@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220669-201763@https.bugzilla.kernel.org/>
References: <bug-220669-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D220669

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |WILL_NOT_FIX

--- Comment #3 from Artem S. Tashkinov (aros@gmx.com) ---
Please request support from RedHat.

Vendor kernels are not supported here.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

