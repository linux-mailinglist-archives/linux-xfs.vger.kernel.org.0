Return-Path: <linux-xfs+bounces-24090-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D3A29B07BDE
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Jul 2025 19:18:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C5B31C22CA9
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Jul 2025 17:18:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17CF52F5C3B;
	Wed, 16 Jul 2025 17:18:17 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from nt.romanrm.net (nt.romanrm.net [185.213.174.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECB3277030;
	Wed, 16 Jul 2025 17:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.174.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752686296; cv=none; b=Ly3WO1uM4zjuFINS3GpNzBG8pfsk7o9J0ARcHjyJ+2RH9Mmu32PkhhLMdRjU6rPF4oLW87zQFruBWwI8+DI8fykGYCwiYlsu/pXcgJBaKEPpNuz5Uq+Ss09psR63LKUJX33CMcXtJt9dSoOKoNiiiuOaz/xJz0d/Geh7I/FSL6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752686296; c=relaxed/simple;
	bh=P0sF5VuhaqUZAj28DrH5tRCkNG1xReMGWxBhjyvslfI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=INXX6YA+BTsDvlQz3q5sEz2EQ4rp6q4aQ+RntMCo4cdkREkKlswq5VErVb+mmPsiiNYMU594tztH96UacEwKLtQxHB21/sezqWSG0TE5MHIBF9xpxRcHnRdmLY6er5Mjct8w0Ruf3XAvixbSnZ2SEEJoDfVLwhoIJy6xd8TWVoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=185.213.174.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.0.romanrm.net [IPv6:fd39:ade8:5a17:b555:7900:fcd:12a3:6181])
	by nt.romanrm.net (Postfix) with SMTP id 4DC084099F;
	Wed, 16 Jul 2025 17:10:05 +0000 (UTC)
Date: Wed, 16 Jul 2025 22:10:03 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Filipe Maia <filipe.c.maia@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: Sector size changes creating filesystem problems
Message-ID: <20250716221003.0cda19e3@nvm>
In-Reply-To: <CAN5hRiUQ7vN0dqP_dNgbM9rY3PaNVPLDiWPRv9mXWfLXrHS0tQ@mail.gmail.com>
References: <CAN5hRiUQ7vN0dqP_dNgbM9rY3PaNVPLDiWPRv9mXWfLXrHS0tQ@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 16 Jul 2025 15:30:20 +0100
Filipe Maia <filipe.c.maia@gmail.com> wrote:

> Hi,
> 
> When a 4Kn disk is added to an mdadm array with sector size 512, its
> sector size changes to 4096 to accommodate the new disk.
> 
> Here's an example:
> 
> ```
> truncate -s 1G /tmp/loop512a
> truncate -s 1G /tmp/loop512b
> truncate -s 1G /tmp/loop512c
> truncate -s 1G /tmp/loop4Ka
> losetup --sector-size 512  --direct-io=on /dev/loop0  /tmp/loop512a
> losetup --sector-size 512  --direct-io=on /dev/loop1  /tmp/loop512b
> losetup --sector-size 512  --direct-io=on /dev/loop2  /tmp/loop512c
> losetup --sector-size 4096  --direct-io=on /dev/loop3  /tmp/loop4Ka
> mdadm --create /dev/md2 --level=5 --raid-devices=3 /dev/loop[0-2]
> # blockdev returns 512
> blockdev --getss /dev/md2
> mdadm /dev/md2 -a /dev/loop3
> mdadm /dev/md2 -f /dev/loop2
> # blockdev still returns 512
> blockdev --getss /dev/md2
> mdadm -S /dev/md2
> mdadm -A /dev/md2 /dev/loop0 /dev/loop1 /dev/loop3
> # blockdev now returns 4096
> blockdev --getss /dev/md2
> ```
> 
> This breaks filesystems like XFS, with new mounts failing with:
> `mount: /mnt: mount(2) system call failed: Function not implemented.`

If you dd the XFS image from an old 512b disk onto a newly bought large
4K-sector HDD, would it also stop mounting on the new disk in the same way?

Perhaps something to be improved on the XFS side?

-- 
With respect,
Roman

