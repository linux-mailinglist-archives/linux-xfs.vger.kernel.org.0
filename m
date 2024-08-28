Return-Path: <linux-xfs+bounces-12333-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2A59961A06
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Aug 2024 00:30:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02A0E1C2222D
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Aug 2024 22:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6CB11D3652;
	Tue, 27 Aug 2024 22:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fBdQnbpT"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855211552ED
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 22:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724797855; cv=none; b=RuTasNahMGuc1E90uC/8MBhAst12OvR/4Ja18RLm36D2Q1CNlh3lh4ltPfQpsLFzxE7P+lMZVL+ozzo41Q0WJwmG/VRQ9CfTqhkkJqjyOa45P7dv06B9pjO02LhGdVSKRCajBYkCb0KrNIKP75tBXpAwYpzcF1519o9kS+REpvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724797855; c=relaxed/simple;
	bh=PQby5F4jJ8TD1hlkKAx1MENWOL+JUsSbW2gJZcoAfeU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OTbMrtj3Qxc0vn9pGLEfk0JccO5UENLb9DqhMEvCbZYMM8kQMwssI47fyjyLVX1XGVI0nTpZHdVx26xmlcCZTfXP10hEIgVPU0LLGjiVzFG6gX7TVG0qImEUK1qh+uACdN4sVlaRzL6+Yb7nLGE5h+Bcumhsw1T2tnQlITkT5rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fBdQnbpT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FA76C4DE07
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 22:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724797855;
	bh=PQby5F4jJ8TD1hlkKAx1MENWOL+JUsSbW2gJZcoAfeU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fBdQnbpT192BDWHDkGyZ3/uLM7lHEYwbwcdotxy7vy1LqInfSDeVFHo/WkBMZW1P3
	 sqAMdKkmWSfy79B8v6AkwYhsqU/7tTWP2Xwp+L8yS8tIB4bDSaILjJa2OMZq+oNX/a
	 plFVk3EXWPr75Ct1k3cR59JyLbPgEmSr8uDDEwYbuJFT5i/fCi4ZgB9Qnhutd5JY00
	 lxhiEfGUTUZCSz/U6jcwLkeAG8JJFPBLX4drXTccM3anmNb3Y0hSn+GgQ5U1qqyDPU
	 Qx0I5uGLjMGGbG3+fFP9BtqeprQzpgKH5K/upEt/U2bnhX6V1Hxh/7J6gzrmQ1W/BN
	 BI7iw9AeeJ4fA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0826AC53BC2; Tue, 27 Aug 2024 22:30:55 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 219203] xfsprogs-6.10.0: missing cast in
 /usr/include/xfs/xfs_fs.h(xfs_getparents_next_rec) causes error in C++
 compilations
Date: Tue, 27 Aug 2024 22:30:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: djwong@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219203-201763-9PynOwJ3m5@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219203-201763@https.bugzilla.kernel.org/>
References: <bug-219203-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219203

--- Comment #2 from Darrick J. Wong (djwong@kernel.org) ---
On Wed, Aug 28, 2024 at 07:40:15AM +1000, Dave Chinner wrote:
> On Tue, Aug 27, 2024 at 09:07:03PM +0000, bugzilla-daemon@kernel.org wrot=
e:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D219203
> >=20
> >             Bug ID: 219203
> >            Summary: xfsprogs-6.10.0: missing cast in
> >                     /usr/include/xfs/xfs_fs.h(xfs_getparents_next_rec)
> >                     causes error in C++ compilations
> >            Product: File System
> >            Version: 2.5
> >           Hardware: All
> >                 OS: Linux
> >             Status: NEW
> >           Severity: normal
> >           Priority: P3
> >          Component: XFS
> >           Assignee: filesystem_xfs@kernel-bugs.kernel.org
> >           Reporter: kernel@mattwhitlock.name
> >         Regression: No
> >=20
> > C allows implicit casts from void* to any pointer type, but C++ does no=
t.
> Thus,
> > when including <xfs/xfs_fs.h> in a C++ compilation unit, the compiler
> raises
> > this error:
> >=20
> > /usr/include/xfs/xfs_fs.h: In function 'xfs_getparents_rec*
> > xfs_getparents_next_rec(xfs_getparents*, xfs_getparents_rec*)':
> > /usr/include/xfs/xfs_fs.h:915:16: error: invalid conversion from 'void*=
' to
> > 'xfs_getparents_rec*' [-fpermissive]
> >   915 |         return next;
> >       |                ^~~~
> >       |                |
> >       |                void*
> >=20
> >=20
> > The return statement in xfs_getparents_next_rec() should have used an
> explicit
> > cast, as the return statement in xfs_getparents_first_rec() does.
> >=20
> > --- /usr/include/xfs/xfs_fs.h
> > +++ /usr/include/xfs/xfs_fs.h
> > @@ -912,7 +912,7 @@
> >         if (next >=3D end)
> >                 return NULL;
> >=20
> > -       return next;
> > +       return (struct xfs_getparents_rec *)next;
> >  }
>=20
> We shouldn't be putting static inline code in xfs_fs.h. That header
> file is purely for kernel API definitions. Iterator helper functions
> aren't part of the kernel API definition - they should be in some
> other exported header file if they are needed at all. The helpers
> could be defined in the getparents man page in the example code that
> uses them rather than exposing the C code to the world...
>=20
> I note that we've recently added a static inline function type
> checking function to xfs_types.h rather than it being an external
> function declaration, so there's more than one header file that
> needs cleanup....

XFS has been exporting tons of static inline functions via xfslibs-dev
for ages:

$ grep static.*inline /usr/include/xfs/ | wc -l
103

And the kernel itself has been doing that for years:

$ grep static.*inline /usr/include/linux/ | wc -l
348

...most of which don't trip g++ errors.  This was the first thing that
broke a build somewhere, because neither the kernel nor xfsprogs use
the C++ compiler.

Shouldn't code review have caught these kinds of problems?  Why wasn't
there any automated testing to identify these issues before they got
merged?  How many more guardrails do I get to build??

Or: should we add a dummy cpp source file to xfsprogs that includes
xfs.h so that developers have some chance of finding potential C++
errors sooner than 6 weeks after the kernel release?

So far as I can tell, this fixes the c++ compilation errors, at least
with gcc 12:

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 0613239cad13..8fc305cce06b 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -971,13 +971,13 @@ static inline struct xfs_getparents_rec *
 xfs_getparents_next_rec(struct xfs_getparents *gp,
                        struct xfs_getparents_rec *gpr)
 {
-       void *next =3D ((void *)gpr + gpr->gpr_reclen);
+       void *next =3D ((char *)gpr + gpr->gpr_reclen);
        void *end =3D (void *)(uintptr_t)(gp->gp_buffer + gp->gp_bufsize);

        if (next >=3D end)
                return NULL;

-       return next;
+       return (struct xfs_getparents_rec *)next;
 }


--D

> -Dave.
> --=20
> Dave Chinner
> david@fromorbit.com
>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

