Return-Path: <linux-xfs+bounces-31291-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2NetM2ICn2mZYgQAu9opvQ
	(envelope-from <linux-xfs+bounces-31291-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 15:08:34 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4524E19882A
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 15:08:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5F9F63013CBA
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 14:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D7BF3A1A54;
	Wed, 25 Feb 2026 14:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="It7KtDKb"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45C0284880
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 14:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772028508; cv=none; b=aCgBINgiDYuYuKlMMArXIdg3H+D2XyYyK5mO1prgiFJp3TdENkLLB0Lon39h0hjMzocbl4FUECeYBN2M3oUxdVddUpotdhtqPQZegAF+DH2bHe52jsSYql8eqyVvcOppkQIMsBTZbeROO6AbIUyRzXT+ffY97P2yW8jFYVAVu3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772028508; c=relaxed/simple;
	bh=XQxuM6WppufrtxNO2abdSjl8M+MqGFLJdV2BOS0c4Oo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i3d4oMQ4cHgL/LMIDwYD/JODXy07ui9xUwEvnYbUotvB1iZw+xzQqhFBJNKq2jCd/yiiYvKIIVhUeG4EuafwsplcfzUgTlyNWTpKidsbOYix8tKzFyaiLhH6KrzQ1t79q5cHspUNWfSHdxh4twra73unvPGwk4FgU0QQnzEQ3QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=It7KtDKb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ukpg/LGcV41DLkh7AZSKKLt7nEVvrsnqbxeynt+5Wl0=; b=It7KtDKbcBkSaKIDGNuxeW+Udz
	Ri0+KGZHrVeBijfrjRVpJgQ3rghBbb9oPFBGLHN4vm6LRtwNubqMvkkH6YH0oeVZbEnt0KnPo+inp
	sXCheCZnWHMegxyJ5591wE/wWMurRq+J1cKBS5SqGO2/GEqXUhplhI5p30XWK2gOLSmaYHRYv45UP
	m791sUyxpLPdq7vRgTbYBH1XnS8jzts6QAuTIJa1YlhxQIFZkskWNR5xOofvuKDHcLqfWqHWmp3De
	LUED+KPgP6xZla5EAD7ygfDFtntO63sPnFU7q3rIme8FqNCNTjrftI3+IzYfroi409JhpHhc8tITo
	BtX3112Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvFYn-00000004ALH-0lpo;
	Wed, 25 Feb 2026 14:08:17 +0000
Date: Wed, 25 Feb 2026 06:08:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Wang Yugui <wangyugui@e16-tech.com>, linux-xfs@vger.kernel.org
Subject: Re: struct xfs_zone_scratch is undefined in 7.0-rc1
Message-ID: <aZ8CUfVRaG4w3dly@infradead.org>
References: <20260225153923.47B2.409509F4@e16-tech.com>
 <42a5498b-31dc-4ad9-aa76-3d332d6113bc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42a5498b-31dc-4ad9-aa76-3d332d6113bc@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	TAGGED_FROM(0.00)[bounces-31291-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:mid,infradead.org:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4524E19882A
X-Rspamd-Action: no action

On Wed, Feb 25, 2026 at 06:01:59PM +0900, Damien Le Moal wrote:
> On 2/25/26 16:39, Wang Yugui wrote:
> > Hi,
> > 
> > struct xfs_zone_scratch is undefined in 7.0-rc1.
> > 
> > # grep xfs_zone_scratch -nr *
> > fs/xfs/xfs_zone_gc.c:99:        struct xfs_zone_scratch         *scratch;
> > #
> > 
> > Could we change 'struct xfs_zone_scratch  *' to 'void *',
> > or just delete this var?
> 
> This should do it:

Can you send a formal patch?


