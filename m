Return-Path: <linux-xfs+bounces-30745-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AO8cDRFRi2nwTwAAu9opvQ
	(envelope-from <linux-xfs+bounces-30745-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Feb 2026 16:38:57 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC8CA11C9CF
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Feb 2026 16:38:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CBF87309AD0A
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Feb 2026 15:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C185938A9C9;
	Tue, 10 Feb 2026 15:34:49 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2458E385526;
	Tue, 10 Feb 2026 15:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737689; cv=none; b=KWJcdY/mBt3+N+oE4yo1lz4HfZk1afXbjEn0HKqB56yRVnCADCYpbQUjLUThYscb8aL/GyL62D8WjrWPW7IPJsqAlLkndnRy7xzKExdkI0QPA/QXZ+mRlr7RkgWQmRLrvvQR7oUdIGTKylSW01IcVkbuzaKkU2YOKDfqZPhp8VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737689; c=relaxed/simple;
	bh=EEPkgTner+uThlcWIJo7lzklokUlur2thDRKzEhY0h4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hl01PJ8dszbjwjSXR4QnsQ0X3ehutTUgBu2R7a0lv34g3VCuJ/Gx2UsziKTUFw0R1mRXJQrETfJ5ztBWiat1aSziyoQqW5a6LM7GVzD61pi1HY/F/mdKlOiUp5pnTEoKatenaF3pK4VqTpwqPpk7w/myJvBK8gm85vhKw/fW2SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A1E7E68CFE; Tue, 10 Feb 2026 16:34:37 +0100 (CET)
Date: Tue, 10 Feb 2026 16:34:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH v2 1/2] xfs: remove duplicate static size checks
Message-ID: <20260210153437.GA31245@lst.de>
References: <20260210055942.2844783-2-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210055942.2844783-2-wilfred.opensource@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30745-lists,linux-xfs=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	R_DKIM_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TAGGED_RCPT(0.00)[linux-xfs];
	DBL_BLOCKED_OPENRESOLVER(0.00)[wdc.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,lst.de:mid,lst.de:email]
X-Rspamd-Queue-Id: BC8CA11C9CF
X-Rspamd-Action: no action

On Tue, Feb 10, 2026 at 03:59:41PM +1000, Wilfred Mallawa wrote:
> From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> In libxfs/xfs_ondisk.h, remove some duplicate entries of
> XFS_CHECK_STRUCT_SIZE().
> 
> Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


