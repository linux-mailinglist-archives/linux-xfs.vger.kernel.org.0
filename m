Return-Path: <linux-xfs+bounces-18612-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE657A20D54
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Jan 2025 16:43:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9864165460
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Jan 2025 15:43:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 751941D5CC6;
	Tue, 28 Jan 2025 15:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="ZzdR8vdI"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8637E1D6DB5
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 15:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738079006; cv=none; b=dVKAp0TYCy1N3PySlRWBgudzkDDi5GhSeKJGTkGOoW2zU+WDUVRZM0sOtyDcaDMyeN/+g588PXhP3hqzt09f1Ddcwc8SMC88gK8uIob6qGhXlGAvyg0JyAphHHmSCDKhs3OfxPEwaG4Wnu7CwddAEtvZm/Drk0pRUzRqz1+fIwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738079006; c=relaxed/simple;
	bh=4CM+Y34LzyqTPbJa964bMKTZoegb6ZCbeVLJYvxkr2Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OMt+AABMPuVgu7ja5s1rp9eLS84Yh5NYyPLm0iPu7GsIbZ0f2vnK3d0oRfBQjVxiRBWBIYpAVVinACgPqtmNY8+3IgWwGUmgbMhg9iqPcSYFTJB3ZtzjJqzGBXpVvTOcsVZodRINwFeSS/c9F8ewctDNEojiQX+Su0l1OzcCsQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=ZzdR8vdI; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e549b0f8d57so9734987276.3
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 07:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1738079001; x=1738683801; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4CM+Y34LzyqTPbJa964bMKTZoegb6ZCbeVLJYvxkr2Y=;
        b=ZzdR8vdIiohnoZ4hKdRsx8vjUSASU/72vdBDURxTPxW6Y5y+xqJe1XFJv37MN3/RSh
         1N9DWACiMe42Ssr+6RyacQYB0mKZF7r9X4dw06gLm3TJ5kXU+QA6Pwxa8XDIazhEp8C0
         9uU7YdXy5cLi0N5EPxtYGd6vErWsFg/mLsK5lwXF/VP7H3vmwwe2R2U45ytaFkUMk6Za
         lp6jed/BVTI9FjvFUI0MN7HYChc3iERhjHp52qu+iW++/bUjLH+wfDW2Jw7AJF6Rr/MJ
         y67AxGiMWpozGojGCejMex/pBvJsfQOTerwdd08tOqwT12ksmB/+EE0jtUDQTB2nY1qi
         QFbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738079001; x=1738683801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4CM+Y34LzyqTPbJa964bMKTZoegb6ZCbeVLJYvxkr2Y=;
        b=uM+0Ux2PQTqism/KIXNWukdZRq/m3xp1IvEGO07opt4V7d80kIO4MrBUN36mlK7vbz
         pQ5jRNY6mKak2rQWG27JlVum7qlhIWfBu4aF7OBR3qCYVjICoDJjm33YQDMDaaIOvjC6
         VgSX0SSHz/D+bnIgi4yGZaKLZkgxjlaQ7PJOV+7hd5gK1+TRJzun9KkfhjkFm1JqQQVp
         8ZWUIr8tursbIEEq4qFPrjsO+RmaYFIFZZgGT7ys0zb0UwlL4HV+rYXwT0wx1biFRJQC
         vhD7iHjz5cJnv7chPoLU59YI1J0jgzolmRqb8AE6a8c5MxUxCbDuxko//yNt+5oqMeJG
         y6PQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHhlNxk2A72msHg0G2liLmCFdiBqwKUmGnOyvBFLfs0a/2xXApDeSllO7bssvFiX+EbKfQ27SePBk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHIKUGvPdvyXe+FQ6BeDwjrnOUe+uAcmj4PTWVEEF8CrE0fIys
	NuYGuHd8f20Z69B4+Tw5bSj5Lr8NHtT9MgimuxktBYBcU3s9zr3fJVB3Z/kS/CVa85K3jOR65TU
	vDl/upi7kNlkqaINI/pbiAqooY/di1YVdxxGY
X-Gm-Gg: ASbGncuuSL2BP23h7uLMxhQVSlCvrs70sjH1ragtO+ucWP+nPNTW9oI2a7UEInHJp4R
	O+UW0oakOAxDqA/JaRB4IKAvNpMUOO2cYS9bnJ5SBW4P6i2fpRKAQ85KR7mxgHHrjarxXnG8=
X-Google-Smtp-Source: AGHT+IGuLqrmdoXiE8apV7tzhOJZ5Xm1OF/NxWm8Kjkh7RMoG05FR1MdO9WMx2ebniwyt0o5rEC0Jv+xP432BtVJDY0=
X-Received: by 2002:a05:690c:4d02:b0:6ef:6646:b50a with SMTP id
 00721157ae682-6f6eb6b2881mr361409457b3.20.1738079001445; Tue, 28 Jan 2025
 07:43:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250110-jag-ctl_table_const-v2-1-0000e1663144@kernel.org>
 <Z4+jwDBrZNRgu85S@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <nslqrapp4v3rknjgtfk4cg64ha7rewrrg24aslo2e5jmxfwce5@t4chrpuk632k>
 <CAMj1kXEZPe8zk7s67SADK9wVH3cfBup-sAZSC6_pJyng9QT7aw@mail.gmail.com>
 <f4lfo2fb7ajogucsvisfd5sg2avykavmkizr6ycsllcrco4mo3@qt2zx4zp57zh>
 <87jzag9ugx.fsf@intel.com> <Z5epb86xkHQ3BLhp@casper.infradead.org> <u2fwibsnbfvulxj6adigla6geiafh2vuve4hcyo4vmeytwjl7p@oz6xonrq5225>
In-Reply-To: <u2fwibsnbfvulxj6adigla6geiafh2vuve4hcyo4vmeytwjl7p@oz6xonrq5225>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 28 Jan 2025 10:43:10 -0500
X-Gm-Features: AWEUYZkHRaUuCTQsu1U9C5jhigmIE9c2_8OmkE_i2Qv7ILXtAaTfDLC5EcLBZNk
Message-ID: <CAHC9VhQnB_bsQaezBfAcA0bE7Zoc99QXrvO1qjpHA-J8+_doYg@mail.gmail.com>
Subject: Re: Re: Re: Re: [PATCH v2] treewide: const qualify ctl_tables where applicable
To: Joel Granados <joel.granados@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Jani Nikula <jani.nikula@intel.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
	Kees Cook <kees@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org, 
	openipmi-developer@lists.sourceforge.net, intel-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
	linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-serial@vger.kernel.org, xen-devel@lists.xenproject.org, 
	linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev, 
	codalist@coda.cs.cmu.edu, linux-mm@kvack.org, linux-nfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, fsverity@lists.linux.dev, 
	linux-xfs@vger.kernel.org, io-uring@vger.kernel.org, bpf@vger.kernel.org, 
	kexec@lists.infradead.org, linux-trace-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, 
	Song Liu <song@kernel.org>, "Steven Rostedt (Google)" <rostedt@goodmis.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Corey Minyard <cminyard@mvista.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 28, 2025 at 6:22=E2=80=AFAM Joel Granados <joel.granados@kernel=
.org> wrote:
> On Mon, Jan 27, 2025 at 03:42:39PM +0000, Matthew Wilcox wrote:
> > On Mon, Jan 27, 2025 at 04:55:58PM +0200, Jani Nikula wrote:
> > > You could have static const within functions too. You get the rodata
> > > protection and function local scope, best of both worlds?
> >
> > timer_active is on the stack, so it can't be static const.
> >
> > Does this really need to be cc'd to such a wide distribution list?
> That is a very good question. I removed 160 people from the original
> e-mail and left the ones that where previously involved with this patch
> and left all the lists for good measure. But it seems I can reduce it
> even more.
>
> How about this: For these treewide efforts I just leave the people that
> are/were involved in the series and add two lists: linux-kernel and
> linux-hardening.
>
> Unless someone screams, I'll try this out on my next treewide.

I'm not screaming about it :) but anything that touches the LSM,
SELinux, or audit code (or matches the regex in MAINTAINERS) I would
prefer to see on the associated mailing list.

--=20
paul-moore.com

