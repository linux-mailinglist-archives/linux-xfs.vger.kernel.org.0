Return-Path: <linux-xfs+bounces-30547-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gEwgHVQ+fGkxLgIAu9opvQ
	(envelope-from <linux-xfs+bounces-30547-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Jan 2026 06:15:00 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C8E1B73E3
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Jan 2026 06:15:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0A3D3300460E
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Jan 2026 05:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5CCB33D4E4;
	Fri, 30 Jan 2026 05:14:56 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE7433C534;
	Fri, 30 Jan 2026 05:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769750096; cv=none; b=VkryvPCPKK5M3P2PnetE7AYWA6kedV99gHWttrDSoQrSzkXisT72Ymv0uGEHVSp8xwfFYIEY5GXoPB3lCPX08Cl0tHTknTpfe43X7oAtsIXFa9xouvQEV2fkH0gAD26pWdSI1D2Xczfo51eJRvPMFTYLP1CHfvV1JJ4YfFogHS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769750096; c=relaxed/simple;
	bh=KH/zOLdHihwfwDNEb1amYcKOkWfqLYJIY3/IqZFqY+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lNy1l0OM4R2ht5njKQ0KEgbLKGm5jYIUjyc3UbTbv3e9Bxa/oSc+Nam53GOpWnulZTBFj2G8lD+Tnky7wDnHbIRmSBUPekwbq9UFr/UkaCNOnpin+UCrooK5hARj0BCr4wIBYbLoD3V0slh96liVLxNEWrvfgxEw3l2Pjfjjlpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7A02868AFE; Fri, 30 Jan 2026 06:14:52 +0100 (CET)
Date: Fri, 30 Jan 2026 06:14:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/15] xfs: support T10 protection information
Message-ID: <20260130051452.GA32597@lst.de>
References: <20260128161517.666412-1-hch@lst.de> <20260128161517.666412-16-hch@lst.de> <5xaomhu2q2jf3w2hbtkh22dytfiqc6wqyslcfoiqdcwgsud5wk@4ykdof27ntxb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5xaomhu2q2jf3w2hbtkh22dytfiqc6wqyslcfoiqdcwgsud5wk@4ykdof27ntxb>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30547-lists,linux-xfs=lfdr.de];
	R_DKIM_NA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[]
X-Rspamd-Queue-Id: 1C8E1B73E3
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 03:51:58PM +0100, Andrey Albershteyn wrote:
> > +	struct iomap_read_folio_ctx	ctx = {
> > +		.cur_folio	= folio,
> > +		.ops		= xfs_bio_read_ops(XFS_I(file->f_mapping->host)),
> 
> Hmm, can we use folio->mapping->host here instead? Adding fsverity,
> read_mapping_folio() will be called without file reference in
> generic_read_merkle_tree_page() (from your patchset). This in turn
> is called from fsverity_verify_bio() in the ioend callback, which
> only has bio reference. 

Yes, deriving the mapping from the folio should work just fine.

