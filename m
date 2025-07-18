Return-Path: <linux-xfs+bounces-24129-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00A4DB09944
	for <lists+linux-xfs@lfdr.de>; Fri, 18 Jul 2025 03:39:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A431A7A2E9F
	for <lists+linux-xfs@lfdr.de>; Fri, 18 Jul 2025 01:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1A3514A0BC;
	Fri, 18 Jul 2025 01:39:18 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from out28-80.mail.aliyun.com (out28-80.mail.aliyun.com [115.124.28.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6EB46B8
	for <linux-xfs@vger.kernel.org>; Fri, 18 Jul 2025 01:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752802758; cv=none; b=A1ygMYifgCcNJnoyOFktGV/knUmcCheUrH5I19D2rFW3u2NBpEesQeqPidnlIvqpEjc+bLLHhfTrEREjTTFRG3J4bpVnMf/xl2O7xoBQwN9ouqNxqbp5trMQry9sAIZIVXQrdXaiI4k9D3kMNV8QlAulSrXH3Gwh5gHu0TOoVYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752802758; c=relaxed/simple;
	bh=97yhLLaHNtr51kdZUWYFZROWGT1Z/6CEn7CojhcjxU8=;
	h=Date:From:To:Subject:In-Reply-To:References:Message-Id:
	 MIME-Version:Content-Type; b=sqfFoXToISCwmhxSvGpnWHLNNeNgXKRAB4tZsiry/NhONVOAfCxe72NZ6UwczUe9S0LqjkDv32t9pHrl2HQZo72/rO1T6qX3S/pKEBOxJUTJpEin1VNpoOFWC4IEo+JfGhiNXVdwC2a/9R4KwlIUPr0h4WDRShD33GOW4TBFE5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=115.124.28.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.dqTPzzY_1752800897 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 18 Jul 2025 09:08:17 +0800
Date: Fri, 18 Jul 2025 09:08:18 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: "Darrick J. Wong" <djwong@kernel.org>,
 linux-xfs@vger.kernel.org
Subject: Re: a deadloop(?) when mkfs.xfs -o rtdev
In-Reply-To: <20250718085829.CA35.409509F4@e16-tech.com>
References: <20250717160357.GQ2672049@frogsfrogsfrogs> <20250718085829.CA35.409509F4@e16-tech.com>
Message-Id: <20250718090817.A951.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.08 [en]

Hi,


> Hi,
> 
> > On Thu, Jul 17, 2025 at 08:13:33AM +0800, Wang Yugui wrote:
> > > Hi,
> > > 
> > > There seems a deadloop(?) when mkfs.xfs -o rtdev.
> > > 
> > > # mkfs.xfs -r rtdev=/dev/disk/by-id/ata-MZ7KM1T6HAJM00D3_S2CXNAAH600026 /dev/d
> > > isk/by-id/scsi-SHITACHI_HUSMH842_CLAR100_0LX0JWVA -f
> > > meta-data=/dev/disk/by-id/scsi-SHITACHI_HUSMH842_CLAR100_0LX0JWVA isize=512    agcount=20, agsize=1221072 blks
> > >          =                       sectsz=4096  attr=2, projid32bit=1
> > >          =                       crc=1        finobt=1, sparse=1, rmapbt=0
> > >          =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
> > >          =                       exchange=0
> > > data     =                       bsize=4096   blocks=24421440, imaxpct=25
> > >          =                       sunit=0      swidth=0 blks
> > > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
> > > log      =internal log           bsize=4096   blocks=41799, version=2
> > >          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > > realtime =/dev/disk/by-id/ata-MZ7KM1T6HAJM00D3_S2CXNAAH600026 extsz=4096   blocks=390703446, rtextents=390703446
> > > Discarding blocks...Done.
> > > Discarding blocks...Done.
> > > 
> > > It did not fishish after 10 mins.
> > > 
> > > # pstack 5785
> > > #0  0x00007f8df5efc01a in pread64 () from /lib64/libc.so.6
> > > #1  0x0000557b7bbfe9c3 in __read_buf.constprop.0 ()
> > > #2  0x0000557b7bbc3030 in libxfs_buf_read_map ()
> > > #3  0x0000557b7bbfe1ae in libxfs_trans_read_buf_map.constprop ()
> > > #4  0x0000557b7bbee7ef in xfs_rtbuf_get ()
> > > #5  0x0000557b7bbf03d8 in libxfs_rtfree_extent ()
> > > #6  0x0000557b7bbbb322 in parseproto.lto_priv ()
> > > #7  0x0000557b7bbb7643 in main ()
> > > 
> > > And,
> > > 1) more chance happen when kernel 6.12.36, but yet not happen when kernel 6.6.93.
> > > 2) it happen on both xfsprogs-6.11.0 and xfsprogs-6.4.
> > 
> > You /could/ strace the mkfs process to see if it's really stuck, or just
> > issuing IOs really slowly.
> 
> Today the mkfs.xfs with rtdev all finished in 110s-160s on kernel 6.6.93/6.12.38.
> 
> the result of strace show that pread64() with 4K size so it is just slow.
> 
> pread64(3, "\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377"..., 4096, 868352) = 4096
> pread64(3, "\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377"..., 4096, 864256) = 4096
> pread64(3, "\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377"..., 4096, 860160) = 4096
> pread64(3, "\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377"..., 4096, 856064) = 4096
> pread64(3, "\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377"..., 4096, 851968) = 4096
> 

the offset of pread64() is in DECE order, not in ASCE order , so the readahead
does not help too.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2025/07/18



> Thanks a lot.
> 
> Best Regards
> Wang Yugui (wangyugui@e16-tech.com)
> 2025/07/18
> 



