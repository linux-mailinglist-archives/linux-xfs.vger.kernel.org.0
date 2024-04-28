Return-Path: <linux-xfs+bounces-7731-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7005B8B4AA3
	for <lists+linux-xfs@lfdr.de>; Sun, 28 Apr 2024 10:08:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 06F99B212B9
	for <lists+linux-xfs@lfdr.de>; Sun, 28 Apr 2024 08:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE17F524AA;
	Sun, 28 Apr 2024 08:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="EhH1i29i"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649C12206B
	for <linux-xfs@vger.kernel.org>; Sun, 28 Apr 2024 08:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714291720; cv=none; b=W/YvP7O5qxn+wYzi3jpjqgEl6tqKJUjv9szSD9uJaC8oFGma0bBjHMxGL5sAgUXU7XVJuSGPApQZETmryUZHms7/cTsV6JgagbRs0EaIg0SVcBlOpJUHkesXXjFKzROZGDqKvIC+CHhW9BOQKLfounq8c1r8xYoOTuYGSGfraRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714291720; c=relaxed/simple;
	bh=dSY6VgHGBbMBKvEGRevVf1GZCM4YOb5TU3V7NL4pnSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HZQResmJ0HIIQnMTmAAKMWG6AE70eqJixaxrUPRs269qlNN05D9yZEUoYqPRQce4pAwobSigZlwCUKO/hQixDFaFntiXBcoWPxIBlDhtkY+3RWV58cadKIYdWQpPPpzhypkVhw8iHXK5r6IUc16uHYK6TghIhA6SNcXa4hn9cl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=EhH1i29i; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6ed9fc77bbfso2813581b3a.1
        for <linux-xfs@vger.kernel.org>; Sun, 28 Apr 2024 01:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1714291719; x=1714896519; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QvveInWpkkJVI1kMdY+t9XXysYkIGquu+XSLYBxptHs=;
        b=EhH1i29iDHV0Skosw+4YK8OfnIKiVi26nhdRWsa4DrTvHrAp3fZOMVuBTSJFmUFg1q
         NQIQy2z+bjVkXwPguV3kPiIiENce00R/R2m1VECnZ0eCCTadWIBKKYoEf3zyUkwe0ohh
         6dDgxUIPxh4YC6A4eB59JzSDmioQpN8lvmAIp5LETV0QgBzDoGzp1YsKzjWRdkixo0y7
         qW7KlnwNPQK0ft2b2s8l2BeCsY/liGbI+Xt5E9wB4fI7gNNoVIr30fyxnClAS5t284qV
         sW+1M+10QMple1oV1D0jou24JtmkfOxJA6XfJLbS3DvAXriVd/bXbc6DlD4FiA2SG4La
         Pd/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714291719; x=1714896519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QvveInWpkkJVI1kMdY+t9XXysYkIGquu+XSLYBxptHs=;
        b=sv3goI7BDKIkBLJ68S4X3yeSJ/QcsjHm2ZjoOCaD75tCyiyU5kEADdEYuVYN99kwbF
         /d2AhqMEreeBXCV6uDLFdoaJh679MFUmsNTyOpDawgWjM9HeZrl6OaJJbtDF9LXgLVye
         GkSAvs1nTXYi+tBQ12DalpX7Y9YFJWNaNR5d1DQodDbsF2AGhtlyuEuZCY7quEAIR06g
         YO6/aJzgHVqvSlhFUzQqhiEgYPR1z+xIINdZBNrbvtdkqcD8cpwaPMc3VOmuc7e7aIzA
         Uj5TYo03i18nWtdWUi8J9BhPLkg3JXrGxW5JOFmnyCS6xfbMWjLp4x+6KfDm547gRaGs
         RvCg==
X-Forwarded-Encrypted: i=1; AJvYcCUWUHoxnJupyk42WtIK+FZN4qXMP29awxwlxx44gA3gr/GkOUFar0uXL79OreTiNzBfAUoEpoA4NMeTLWlxlg5Q2O3mgEndM6Kz
X-Gm-Message-State: AOJu0YxmiMtij0tk/IQq4aiGqEfJjwxwThhjbCx2kgPfefzsiYQ8xAj1
	6R8Zzl9G94yn8Gpuk1Y74XQcd7hGgY5bIzNiHw9CG/NwHDonKLY7R/SIGIxXXQc=
X-Google-Smtp-Source: AGHT+IE9rezMEVCJI2AgOLgm0NbSH5QVRsB1R59NgAnJhWz1z9wdBOj6S1k3TX1SSqf16fZBM7GEyw==
X-Received: by 2002:a05:6a21:2d85:b0:1a7:a3cb:7901 with SMTP id ty5-20020a056a212d8500b001a7a3cb7901mr7712149pzb.61.1714291718477;
        Sun, 28 Apr 2024 01:08:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-29-7.pa.nsw.optusnet.com.au. [49.181.29.7])
        by smtp.gmail.com with ESMTPSA id l9-20020a170903120900b001e3e0aa9776sm18052951plh.27.2024.04.28.01.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Apr 2024 01:08:38 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s0zaN-00DfYm-0z;
	Sun, 28 Apr 2024 18:08:35 +1000
Date: Sun, 28 Apr 2024 18:08:35 +1000
From: Dave Chinner <david@fromorbit.com>
To: syzbot <syzbot+a191ccc95425c3409faa@syzkaller.appspotmail.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_qm_dqpurge
Message-ID: <Zi4EA0jFQADLo/3n@dread.disaster.area>
References: <00000000000094b0b8061722f448@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000094b0b8061722f448@google.com>

On Sun, Apr 28, 2024 at 12:19:19AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9d1ddab261f3 Merge tag '6.9-rc5-smb-client-fixes' of git:/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=131236e3180000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=19891bd776e81b8b
> dashboard link: https://syzkaller.appspot.com/bug?extid=a191ccc95425c3409faa
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> userspace arch: i386

#syz dup: possible deadlock in xfs_ilock_data_map_shared

-- 
Dave Chinner
david@fromorbit.com

