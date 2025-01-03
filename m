Return-Path: <linux-xfs+bounces-17824-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F965A00B90
	for <lists+linux-xfs@lfdr.de>; Fri,  3 Jan 2025 16:36:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B988C1884896
	for <lists+linux-xfs@lfdr.de>; Fri,  3 Jan 2025 15:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5143A1FA8E4;
	Fri,  3 Jan 2025 15:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="S7CabgLP"
X-Original-To: linux-xfs@vger.kernel.org
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E941FA174
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jan 2025 15:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735918556; cv=none; b=BKDV+/JSYXtRyYQiD0maEUzZY7emoVy9KRgZSqhT/IHvnWcgsK9se2efc6EfOMmfFsH6OIq6TxBBAQK7D5bFsMbAYi3MbhHkc4XrFZIdrUF9j/zi34AGm0qRAiMzO5X9grtHS3O961XW4v1ICbqX7ftJ9eGYxh/4GIQqVo103dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735918556; c=relaxed/simple;
	bh=uzn8vMg7kITPh0VxLU4kO77n9TxzmByBqR4I+LvrS3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BR5TJAs1e0uGArthr0OXRQVn3KpACbqRMD1QJrANsyiH4Rjh2luNSNKCfFM1Nm4+Dkl1MJ9DC/IkvS2ICCWZjf0tPnMkh8MMP2Bw0tHxjDO9M/x6/pArLRpAbt/LGEsjAXzqFOnVeqxhBHWmoSIR2DcBWh78FLol99PIOYhrABo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=S7CabgLP; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from cwcc.thunk.org (pool-173-48-117-149.bstnma.fios.verizon.net [173.48.117.149])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 503FZHDv016360
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 3 Jan 2025 10:35:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1735918520; bh=Lb2hvApD5N++6CV/cATlh88XqbIqaro5zjFDDb2Z3rQ=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=S7CabgLPKEEYiL6KwZCMf84RsyGI2JTGioImlczknq7RIh4uMuL7/tO3UnfJr7XEN
	 ECHiSfrrUOQq2AwSnTqzN9fyalGe2Az0in20HgSC79/11TKlce6H0RrlJO8L7pV02S
	 l3wUaB0VZRjCvvSWSNS1PXRGhiScIJhb8HlFCCi7cmVlS+obmBOUyzTrPQhZsgcAPL
	 f/ECoGWN9NASKsj6WuTYk+z+C/HccONh6PZ0yrBmRISZnn+38Pf7W220h/hR148aFE
	 dX1yGMRuHcawj+45lZ8juGLMZ7dGT5vlEZhtbgDWNz2ho0nZlH55ckQI9LLnSyifGM
	 GtdG4hBJUMgfQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id 583BF15C0113; Fri, 03 Jan 2025 10:35:17 -0500 (EST)
Date: Fri, 3 Jan 2025 10:35:17 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Baokun Li <libaokun1@huawei.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Christian Brauner <brauner@kernel.org>, sunyongjian1@huawei.com,
        Yang Erkun <yangerkun@huawei.com>, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [BUG REPORT] ext4: =?utf-8?B?4oCcZXJy?=
 =?utf-8?Q?ors=3Dremount-ro=E2=80=9D_has_become_=E2=80=9Cerrors=3Dshutdown?=
 =?utf-8?B?4oCdPw==?=
Message-ID: <20250103153517.GB1284777@mit.edu>
References: <22d652f6-cb3c-43f5-b2fe-0a4bb6516a04@huawei.com>
 <z52ea53du2k66du24ju4yetqm72e6pvtcbwkrjf4oomw2feffq@355vymdndrxn>
 <17108cad-efa8-46b4-a320-70d7b696f75b@huawei.com>
 <umpsdxhd2dz6kgdttpm27tigrb3ytvpf3y3v73ugavgh4b5cuj@dnacioqwq4qq>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <umpsdxhd2dz6kgdttpm27tigrb3ytvpf3y3v73ugavgh4b5cuj@dnacioqwq4qq>

On Fri, Jan 03, 2025 at 11:42:13AM +0100, Jan Kara wrote:
> [CCed XFS and fsdevel list in case people have opinion what would be the
> best interface to know the fs has shutdown]
>  
> > Sorry for the lack of clarity in my previous explanation. The key point
> > is not about removing EXT4_MF_FS_ABORTED, but rather we will set
> > EXT4_FLAGS_SHUTDOWN bit, which not only prevents writes but also prevents
> > reads. Therefore, saying it's not read-only actually means it's completely
> > unreadable.
> 
> Ah, I see. I didn't think about that. Is it that you really want reading to
> work from a filesystem after error? Can you share why (I'm just trying to
> understand the usecase)? Or is this mostly a theoretical usecase?

I don't see how setting the shutdown flag causes reads to fail.  That
was true in an early version of the ext4 patch which implemented
shutdown support, but one of the XFS developers (I don't remember if
it was Dave or Cristoph) objected because XFS did not cause the
read_pages function to fail.  Are you seeing this with an upstream
kernel, or with a patched kernel?  The upstream kernel does *not* have
the check in ext4_readpages() or ext4_read_folio() (post folio
conversion).

					- Ted

