Return-Path: <linux-xfs+bounces-30749-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IDTrH8tSi2kMUAAAu9opvQ
	(envelope-from <linux-xfs+bounces-30749-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Feb 2026 16:46:19 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9053D11CB32
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Feb 2026 16:46:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2AA033005170
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Feb 2026 15:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 236713815E4;
	Tue, 10 Feb 2026 15:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WB6jC+Pg"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F66031984E
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 15:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770738367; cv=none; b=qYviUQ/uJXpQwL3ytNTMJVZCZ5kOh+0Gvh7LZ+XalvfwohSFJQBM9YOE02k6CdUhhhjkPV+hPH9KXePDhHJwsAfUsAUHQq4WHA6Tzz0zkacPZmHe5GobyBVWdz2jYK0X4r7SyntLYxmuIXpZeiiNiH8dNIf4cZKhCcNyGF8N2AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770738367; c=relaxed/simple;
	bh=3vdv+nyRUv/tsEOWpVFsCWcKxGBbZKKjdzR2Rb3o9ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bS3PNynP0lTMuNUhDLG5eSkpFQRmAlUhfb+zoP6aoGCTodMP8kDdQymX9Y9GG7bwyUtxVJf4EI2GBhZSQKmaD323qMZTCh1uPJTuevgw632Ju2QRkwc92+l3xGd6i5soN+iy0pDR2UJJVyyOY9qxNisxKJVHiAihcitXhjg/+Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WB6jC+Pg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d+o59NCZNoHwSAtOv/yseyt0jbQRTGlFQnxihXNwCzs=; b=WB6jC+PgUPRKVsIMqd5XA2hb4z
	qWwger2lWhZPtqkFjG7Lz9T3B+Zk6QVNefG+myVqQQx71K4ioTI9i73hJ+iLu7ISr9+8gLSbWykum
	W6J4Fjw0sT5LiCGsfHHiis6sF2g4gQha0glzhlDKgPnwnxRCanOivAFBoaOdimZzMaJ2ymWjwskGo
	VFZM6U1nxINuxgXqVqflpPqfXdm4E4WeOxiZo5uF2SbybreIefExYm/C/zaT3a0JJgaWpi7nNzbs0
	r/VEQc4oQ5Yra7Z2tVdRh1bL3izlZvQnXPiHrb6l2feUJZjtpo2p0QzoDdNxPSje9+1wluxq/G2sF
	oDou7PPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vppwC-0000000H9GL-44Dj;
	Tue, 10 Feb 2026 15:46:04 +0000
Date: Tue, 10 Feb 2026 07:46:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: nirjhar@linux.ibm.com
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	djwong@kernel.org, hch@infradead.org, cem@kernel.org,
	nirjhar.roy.lists@gmail.com
Subject: Re: [patch v1 2/2] xfs: Replace &rtg->rtg_group with rtg_group()
Message-ID: <aYtSvJLCAPZXywit@infradead.org>
References: <cover.1770725429.git.nirjhar.roy.lists@gmail.com>
 <3234d5a2693e1c18c2e3d34fc45d59118d503b67.1770725429.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3234d5a2693e1c18c2e3d34fc45d59118d503b67.1770725429.git.nirjhar.roy.lists@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,linux.ibm.com,kernel.org,infradead.org];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-30749-lists,linux-xfs=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,lst.de:email,infradead.org:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: 9053D11CB32
X-Rspamd-Action: no action

On Tue, Feb 10, 2026 at 05:56:35PM +0530, nirjhar@linux.ibm.com wrote:
> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> 
> Use the already existing rtg_group() wrapper instead of
> directly accessing the struct xfs_group member in
> struct xfs_rtgroup.

Doesn't really save much, but I guess we should be consistent:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Nit: your commit message could be condensed a bit by using up all 73
characters.


