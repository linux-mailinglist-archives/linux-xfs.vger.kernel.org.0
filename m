Return-Path: <linux-xfs+bounces-30746-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +OqjHm9Ri2nwTwAAu9opvQ
	(envelope-from <linux-xfs+bounces-30746-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Feb 2026 16:40:31 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D41C311CA46
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Feb 2026 16:40:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E89853081A2E
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Feb 2026 15:36:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D64C12ED164;
	Tue, 10 Feb 2026 15:36:03 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9232EDD40;
	Tue, 10 Feb 2026 15:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737763; cv=none; b=KANMBp1QPKAo7I2TF9wNgswjBY5o5Mwp8vWS/AuaasQnNonpRDceaoz/VGpup3HJxz8F93B9OD+qUO2q7cXMC/VV5JDp4qhRubq/BsOagt4O9goTVrTiOMpb2WljaolBKumcmw5H4stG1XM/DxAGINypPOXMMBRl0USrkyTu8yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737763; c=relaxed/simple;
	bh=OXHeSid7E2DAuRdT6tbqff8RT3oU8mNyQUhvtWYyDKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RfAqYpdcVcIzMB2K2zYi1Shk468F9azayMt9dc+nLsVW5a3JaJUEOxvlEsTQqWOIhCj9ocEmZJb0JQAyJXiI5KWbnyiyMuq55Juu8/evhFhtCbMG5Ah61rx3h019tSPznN55vfeK7VirAdSPTG8Jf5fRDikLt3BcaM0R7n5DxAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3607968CFE; Tue, 10 Feb 2026 16:36:00 +0100 (CET)
Date: Tue, 10 Feb 2026 16:35:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH v2 2/2] xfs: add static size checks for ioctl UABI
Message-ID: <20260210153559.GB31245@lst.de>
References: <20260210055942.2844783-2-wilfred.opensource@gmail.com> <20260210055942.2844783-5-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210055942.2844783-5-wilfred.opensource@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30746-lists,linux-xfs=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	R_DKIM_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TAGGED_RCPT(0.00)[linux-xfs];
	DBL_BLOCKED_OPENRESOLVER(0.00)[wdc.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,lst.de:mid,lst.de:email]
X-Rspamd-Queue-Id: D41C311CA46
X-Rspamd-Action: no action

On Tue, Feb 10, 2026 at 03:59:44PM +1000, Wilfred Mallawa wrote:
> From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> The ioctl structures in libxfs/xfs_fs.h are missing static size checks.
> It is useful to have static size checks for these structures as adding
> new fields to them could cause issues (e.g. extra padding that may be
> inserted by the compiler). So add these checks to xfs/xfs_ondisk.h.
> 
> Due to different padding/alignment requirements across different
> architectures, to avoid build failures, some structures are ommited from
> the size checks. For example, structures with "compat_" definitions in
> xfs/xfs_ioctl32.h are ommited.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I couldn't spot any whitespace issues either, although I'd personally
drop the last empty line if I had to nitpick.


