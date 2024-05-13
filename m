Return-Path: <linux-xfs+bounces-8311-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C98B8C3A4C
	for <lists+linux-xfs@lfdr.de>; Mon, 13 May 2024 04:58:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D79C1F21155
	for <lists+linux-xfs@lfdr.de>; Mon, 13 May 2024 02:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8035A145B39;
	Mon, 13 May 2024 02:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cKQHOIMx"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695D2145B0A
	for <linux-xfs@vger.kernel.org>; Mon, 13 May 2024 02:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715569085; cv=none; b=U24z4rcwelZz401kAIC623iJBmi7NHA7PwUx1lTpp/XHI3oIGcylYM8AFuqHSBE6esmWtH8lNtGo3qDuZ6uN/AYPLW0j0KUcrhBRi8WmS5lg68a3fxe7+Br/yiZz+bpZ5OYa+mPQIHlub0M9OdJXLXfM8oI+l/VeoDmd7qnC+No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715569085; c=relaxed/simple;
	bh=5/Wrwj94XGzMh/USGtQK2NQHsvhIlya9spYECq7GesU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MOC/Q8kfqkrkyejMd4YRJ9wbXsxs9qxhpL2ZPY+ppABpeRnXz+Bfh1B/NP630VgKIJtJzykdqWE4qHg1KZzmLZnRdDRvWYd6HDF/TLe6yjfF8x9mnW2EJaPK+X2bEgkBxWKC+lGFMPhzBUOMPIgJO2uLPruOiMsJBy/kZENim4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=cKQHOIMx; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6f457853950so3241472b3a.0
        for <linux-xfs@vger.kernel.org>; Sun, 12 May 2024 19:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1715569083; x=1716173883; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y/lu5TaLovMBUI69zhtefvoAbFIExvkJe/gVrMPa9Rs=;
        b=cKQHOIMxV78kC1JWKtcW80dRgdB66xbP0vf8dHiMTk2wRECFhIL+vO5Tq5bphu3oa5
         fe2qdkchDkYkUTXPTMpn+DAmNH0SoCsezfwHGGg/tqTTzJC1wot+R1jQnIXmoZSIFxHX
         ZKgx13sjqPUHQT1PV04bFxtlUQwIkvEsyIyRA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715569083; x=1716173883;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y/lu5TaLovMBUI69zhtefvoAbFIExvkJe/gVrMPa9Rs=;
        b=I0OdwKt1yBTFxdlMyKy87/Kx63Pt7lCYj4dF6SkYHMbTr2PaIp+Ndap+B3qz0k0der
         /iK1ucBf9qxepjIjUMeNVkZI1WIWwgE/sldwst2yLHd+20YNluCT9me90qoJwSz1N8aG
         b8A3ddT8y3eETsUXVxpLkB5ZnrsVDUavx+9lAzUPkFkXhutZOP6xsp98sL6trs+sHnEA
         GXRtQmK831tBWkBMUCborTWs3Hq1gg3ZK6OtNApz5WB3TUMgswilcQygUvAwEEWLBjp7
         vLU47JQve2W57SjEdCqPbrkafIsRacmXOsZ2HglErwsQ/WsaDem4rRRrhmc7UknlYe2F
         3VhA==
X-Forwarded-Encrypted: i=1; AJvYcCWSmoyatYmSs53SyLsnsXBlZBW7Abqid7PmkOFI2IBSP4xKOj9T1ZijOPhkkM438C1+K7s8CpyMS/Nlu+NiFq3NmV/sbkjeENND
X-Gm-Message-State: AOJu0YwobTBZH42UFeryoHB95ggme90Rj1JJFY1sAg2WLl+HqaY4I6v3
	FtyptGjxaXcZDSnGBjYo28Gff38H803XeI62lUj0pAJ8zaXpzoN+9RKtG89VxQ==
X-Google-Smtp-Source: AGHT+IEKZ/LshmwPejdGxanAmq+x/Okf3LXGs+1GNXJLM4QWlBn90rXQR1Oeyq1KkYKRq0CgAkrYow==
X-Received: by 2002:a05:6a21:1505:b0:1ad:7e68:570c with SMTP id adf61e73a8af0-1afde07d801mr12977761637.4.1715569082704;
        Sun, 12 May 2024 19:58:02 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2b2fa86sm6335827b3a.213.2024.05.12.19.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 May 2024 19:58:00 -0700 (PDT)
Date: Sun, 12 May 2024 19:57:58 -0700
From: Kees Cook <keescook@chromium.org>
To: Joel Granados <j.granados@samsung.com>
Cc: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org, bpf@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-xfs@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, kexec@lists.infradead.org,
	linux-hardening@vger.kernel.org, bridge@lists.linux.dev,
	lvs-devel@vger.kernel.org, linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com, linux-sctp@vger.kernel.org,
	linux-nfs@vger.kernel.org, apparmor@lists.ubuntu.com
Subject: Re: [PATCH v3 00/11] sysctl: treewide: constify ctl_table argument
 of sysctl handlers
Message-ID: <202405121955.BC922680BA@keescook>
References: <20240423-sysctl-const-handler-v3-0-e0beccb836e2@weissschuh.net>
 <20240424201234.3cc2b509@kernel.org>
 <202405080959.104A73A914@keescook>
 <CGME20240511095125eucas1p1e6cd077a31c94dcdda88967d4ffc9262@eucas1p1.samsung.com>
 <8d1daa64-3746-46a3-b696-127a70cdf7e7@t-8ch.de>
 <20240512193240.kholmilosdqjb52p@joelS2.panther.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240512193240.kholmilosdqjb52p@joelS2.panther.com>

On Sun, May 12, 2024 at 09:32:40PM +0200, Joel Granados wrote:
> On Sat, May 11, 2024 at 11:51:18AM +0200, Thomas Wei�schuh wrote:
> > Hi Kees,
> > 
> > On 2024-05-08 10:11:35+0000, Kees Cook wrote:
> > > On Wed, Apr 24, 2024 at 08:12:34PM -0700, Jakub Kicinski wrote:
> > > > On Tue, 23 Apr 2024 09:54:35 +0200 Thomas Wei�schuh wrote:
> > > > > The series was split from my larger series sysctl-const series [0].
> > > > > It only focusses on the proc_handlers but is an important step to be
> > > > > able to move all static definitions of ctl_table into .rodata.
> > > > 
> > > > Split this per subsystem, please.
> > > 
> > > I've done a few painful API transitions before, and I don't think the
> > > complexity of these changes needs a per-subsystem constification pass. I
> > > think this series is the right approach, but that patch 11 will need
> > > coordination with Linus. We regularly do system-wide prototype changes
> > > like this right at the end of the merge window before -rc1 comes out.
> > 
> > That sounds good.
> > 
> > > The requirements are pretty simple: it needs to be a obvious changes
> > > (this certainly is) and as close to 100% mechanical as possible. I think
> > > patch 11 easily qualifies. Linus should be able to run the same Coccinelle
> > > script and get nearly the same results, etc. And all the other changes
> > > need to have landed. This change also has no "silent failure" conditions:
> > > anything mismatched will immediately stand out.
> > 
> > Unfortunately coccinelle alone is not sufficient, as some helpers with
> > different prototypes are called by handlers and themselves are calling
> > handler and therefore need to change in the same commit.
> > But if I add a diff for those on top of the coccinelle script to the
> > changelog it should be obvious.
> Judging by Kees' comment on "100% mechanical", it might be better just
> having the diff and have Linus apply than rather than two step process?
> Have not these types of PRs, so am interested in what folks think.

I tried to soften it a little with my "*close* to 100%" modifier, and
I think that patch basically matched that requirement, and where it had
manual changes it was detailed in the commit log. I only split out the
seccomp part because it could actually stand alone.

So yeah, let's get the last of the subsystem specific stuff landed after
-rc1, and it should be possible to finish it all up for 6.11. Yay! :)

-Kees

-- 
Kees Cook

