Return-Path: <linux-xfs+bounces-20144-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 529C4A4332F
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Feb 2025 03:38:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01AF43B0401
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Feb 2025 02:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AD9A15198B;
	Tue, 25 Feb 2025 02:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="PXiJB1RM"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819551448E0
	for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2025 02:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740451090; cv=none; b=im0LIwGeB26HLhAgd4XfSIKsU2U1NVvr3CHJF81f3xFszDlguqHWXtqnJddDd4Hhf7mJ/uJOmBxVSCXekWSai8op3SVp2urPJ9zt9k5JyoEY32l5Cxh+gYtvpran7IMl4TrmtRRPk/FJn9GqgBe96gWcHiC37WSvFO6opI4edfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740451090; c=relaxed/simple;
	bh=oNdZT9w7aQq5QrNlfacj7MIC7lBCM1O2Jgg5tGeZrlc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jnzPdMFW2XGN75dltoRlfflCQnmfmCIAf8T9i8EyjBYNi0Z+qZ9HK7SPXKPrfdMyYJ2w9+tKV4Vw+CAzxJeSuuQFEhUBZBt7GRS5wtvaXvIDdzOo282KidGum9rs3PM4amPcMDzS+hW9z37mHIjuCKnvO/xtoOGT8t9TArwVGRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=PXiJB1RM; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e5dd164f03fso4642053276.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 18:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1740451087; x=1741055887; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UqK9lSPHR3oAe986F8iXqkMz9AYMYHr6QgwL+NcZdiU=;
        b=PXiJB1RMf5Ayu1sFntsMseLpkqRBTF4jtusBDoA7lIOaD1hImCEuB98mD7KjihjNEm
         7fNp/VQCbbklqF+swIeJh6BIUl9R6sM56jyD/ZUgddfOcMyDbhG0GWHimbes3enZW4n8
         Wi7PKbQqFBPZTQJdcyI+bDt9As46rQkJqFlX+E7f/Y87mPkomV50RT15HLVnOd7+Dzod
         UlIJsLAfTVYHytm4RjU4qTTJy3MwaGeTBQ6ZBPrM511unJ82cS99ozdSy1CBi1B4kogB
         ALgwG9OqEUfL4LwlVxlOdSdaUm56MIbb/abk01HTkCEn7e/qAaJBTSsuE4gOyYwdQc5l
         V4cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740451087; x=1741055887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UqK9lSPHR3oAe986F8iXqkMz9AYMYHr6QgwL+NcZdiU=;
        b=OnSeY8Xlke8wEqAUmGobmSOzxlvMu/JhdSgsslvOnBjUrOgiQCGpeEGeSdcZ+2WxWZ
         Xdrf06bujpfbgDOfei/pBUE8cbttkHzonTl1g9puAuSmLIpky0BOdmXhmE4zh+VIbHMY
         83zxFpEBhK0VrsXAU57wUSIGtoBUrh2prqszNzANlaF/qoxoEVncTGxPbRkDx3FOQn1m
         WMv0GwEKw0DxwfWuhqzYNECaU/ViGLz/3zLCaHPqt3a/Z0AAZDkeJsA2fy8AfDZNpt0s
         W2HSHw7hcfOMbnbs00NdXTS0hIR0qdbOIqW96wNi6+rEgPIO1+AZX0a9BwMmSHqdv5Px
         Zm9A==
X-Forwarded-Encrypted: i=1; AJvYcCUU+nh+r/80N3W/qcJaFR6I85l7qcUYBIRzo/SbA/NTlnbaJ2jXCyaVMh2U4+c7KizZEhTz0uC9hQc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWQv32RiEnk2Li+SB7a2JbgHJj2YgxVu2oY4uvbYLmugNPHIjZ
	J7U2pKQUKL6K4TiRKcNf6i/oVvC4iYjmDdonSJbGuNcRfqMP+IiUEozf+ql2x4mCchxRagLIem5
	9gE5mC8R74coVTfvh9Q+Mw/4qRcygEjyA9xFl
X-Gm-Gg: ASbGncteeYp/lFGaxmhmCZQjO7JC9xgNfkgQu0TRmnA/b0JzbVbEwwbRbGWwtGGci5Z
	+BdX7OtNY2Pi9P0ORr4ZDoervVVaz4fQaepR4nKrDK87I4Zg5R8F1AikPj/5tM1zDCR6Qqp98Tc
	rHQDD/dCw=
X-Google-Smtp-Source: AGHT+IFEtqZjFjUUtEoV6clplX0tg01lvFBOsWs6wVdmIF0VuIZ0SAwc4zHx33tyK9MjmhuD5ygseR4l9mjGvJrZ59E=
X-Received: by 2002:a05:6902:270a:b0:e57:3c46:fc86 with SMTP id
 3f1490d57ef6-e607a56713bmr1172129276.48.1740451087319; Mon, 24 Feb 2025
 18:38:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211-xattrat-syscall-v3-1-a07d15f898b2@kernel.org>
 <20250221.ahB8jei2Chie@digikod.net> <jvo6uj7ro5czlo5ukw3vtf5mpqgrbuksqq4j63s2i6gwrjpz4m@kghpcqyi7gwb>
In-Reply-To: <jvo6uj7ro5czlo5ukw3vtf5mpqgrbuksqq4j63s2i6gwrjpz4m@kghpcqyi7gwb>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 24 Feb 2025 21:37:56 -0500
X-Gm-Features: AQ5f1JrNItPBrIagfKvZGb3Z7zpj-znT5mFIJQvEadvcpFUdxtbR_1MPSlEQmag
Message-ID: <CAHC9VhRrs=W4JtuphkADPVG9MX8jxQLfmC9=2taj+cfZgNOt3Q@mail.gmail.com>
Subject: Re: [PATCH v3] fs: introduce getfsxattrat and setfsxattrat syscalls
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Richard Henderson <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Michal Simek <monstr@monstr.eu>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Naveen N Rao <naveen@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	"David S. Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	=?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>, 
	Arnd Bergmann <arnd@arndb.de>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-m68k@lists.linux-m68k.org, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2025 at 11:00=E2=80=AFAM Andrey Albershteyn <aalbersh@redha=
t.com> wrote:
> On 2025-02-21 16:08:33, Micka=C3=ABl Sala=C3=BCn wrote:
> > It looks security checks are missing.  With IOCTL commands, file
> > permissions are checked at open time, but with these syscalls the path
> > is only resolved but no specific access seems to be checked (except
> > inode_owner_or_capable via vfs_fileattr_set).

...

> > On Tue, Feb 11, 2025 at 06:22:47PM +0100, Andrey Albershteyn wrote:

...

> > > +SYSCALL_DEFINE4(setfsxattrat, int, dfd, const char __user *, filenam=
e,
> > > +           struct fsxattr __user *, fsx, unsigned int, at_flags)
> > > +{
> > > +   CLASS(fd, dir)(dfd);
> > > +   struct fileattr fa;
> > > +   struct path filepath;
> > > +   int error;
> > > +   unsigned int lookup_flags =3D 0;
> > > +
> > > +   if ((at_flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) !=3D 0)
> > > +           return -EINVAL;
> > > +
> > > +   if (at_flags & AT_SYMLINK_FOLLOW)
> > > +           lookup_flags |=3D LOOKUP_FOLLOW;
> > > +
> > > +   if (at_flags & AT_EMPTY_PATH)
> > > +           lookup_flags |=3D LOOKUP_EMPTY;
> > > +
> > > +   if (fd_empty(dir))
> > > +           return -EBADF;
> > > +
> > > +   if (copy_fsxattr_from_user(&fa, fsx))
> > > +           return -EFAULT;
> > > +
> > > +   error =3D user_path_at(dfd, filename, lookup_flags, &filepath);
> > > +   if (error)
> > > +           return error;
> > > +
> > > +   error =3D mnt_want_write(filepath.mnt);
> > > +   if (!error) {
> >
> > security_inode_setattr() should probably be called too.
>
> Aren't those checks for something different - inode attributes
> ATTR_*?
> (sorry, the naming can't be more confusing)
>
> Looking into security_inode_setattr() it seems to expect struct
> iattr, which works with inode attributes (mode, time, uid/gid...).
> These new syscalls work with filesystem inode extended flags/attributes
> FS_XFLAG_* in fsxattr->fsx_xflags. Let me know if I missing
> something here

A valid point.  While these are two different operations, with
different structs/types, I suspect that most LSMs will consider them
to be roughly equivalent from an access control perspective, which is
why I felt the existing security_inode_{set,get}attr() hooks seemed
appropriate.  However, there likely is value in keeping the ATTR and
FSX operations separate; those LSMs that wish to treat them the same
can easily do so in their respective LSM callbacks.

With all this in mind, I think it probably makes sense to create two
new LSM hooks, security_inode_{get,set}fsxattr().  The get hook should
probably be placed inside vfs_fileattr_get() just before the call to
the inode's fileattr_get() method, and the set hook should probably be
placed inside vfs_fileattr_set(), inside the inode lock and after a
successful call to fileattr_set_prepare().

Does that sound better to everyone?

--=20
paul-moore.com

