Return-Path: <linux-xfs+bounces-31977-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2McXB63iqmkTYAEAu9opvQ
	(envelope-from <linux-xfs+bounces-31977-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 06 Mar 2026 15:20:29 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AB36722281D
	for <lists+linux-xfs@lfdr.de>; Fri, 06 Mar 2026 15:20:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0E7903029243
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Mar 2026 14:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19EBC3A963C;
	Fri,  6 Mar 2026 14:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N8EYT3sM"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C9237B41F
	for <linux-xfs@vger.kernel.org>; Fri,  6 Mar 2026 14:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772806827; cv=none; b=at7TtnSNFAl658//CmyNsHELkc0OdKAmLSmhtmcQPgd/QDmU80uovLf+0hNzi7B66Ul5UD66KsakPuID+S8flzNT8qn0oLmrOsvuxXSr6E/NAZV88c4MPziz/B2wQnOdCDQin1c/YWzGlot7hfeSuUULK/72Pi9GNujPv7eMflE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772806827; c=relaxed/simple;
	bh=GsmiZJ5u04ajA748IkQY0IMrNgdmmjeHMe3TeB3GV1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qR8jv4O5szRYC8Vtv6tVJOY/eOem0h573PfOGdz+eqcnxz1RJYuYgJtm9+/HsOXkdcN+I9FEh2emiL5cGck7RbnsGlDgKi1NrJHz6ocZcKnMtQOBm5PdtMFbzOzcy8rwFtPWv1PErrHxhh4hYU46g3nXsVM/WiSqt1K7b0DpYu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N8EYT3sM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SVTTVO0j6/MpR1LboTqX4XbDNzuyeKPEScAXtWQZUP4=; b=N8EYT3sMvT+kt7bRCYT5ByH5sT
	giJVlxaFJukcFYCNy9r/oUL5ckByXMA1DbBKxHSxIU/86MKHrYn2ygHnN3AGH019mv7fpgoNtug3D
	LefHLe68RoRYbVv2snWfMwtZgThxy3bLJ8tRyG+YfpCHmgGzH+ePZEMe1qCLQqBg7iXGuNvpZrqFZ
	RBV6TDzoqWojGrik6PtiKBoTADIR6OTzOuosrSQTwHHeKs+ndmvw33VXPXl6/GSQkAiR4kNOOURjz
	VQCyceBbZ8KLgCMoaUkWnsH8HF3WDEM5yUt+VZUzfERks8LAQOH5Alwx62G+aQnD8oBG2ccjGFldx
	GeT12vHg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vyW2P-00000003tbf-2E2s;
	Fri, 06 Mar 2026 14:20:21 +0000
Date: Fri, 6 Mar 2026 06:20:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/26] xfs_io: print systemd service names
Message-ID: <aaripVrvxgo003ya@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783711.482027.11261039889156364110.stgit@frogsfrogsfrogs>
 <aacE3gW9j6pKrspy@infradead.org>
 <20260303172916.GR57948@frogsfrogsfrogs>
 <aagt0pZTkqysyjQJ@infradead.org>
 <20260304163502.GV57948@frogsfrogsfrogs>
 <aamLP5UnWiPhvKqh@infradead.org>
 <20260305220051.GG57948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305220051.GG57948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: AB36722281D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31977-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,infradead.org:dkim,infradead.org:mid]
X-Rspamd-Action: no action

On Thu, Mar 05, 2026 at 02:00:51PM -0800, Darrick J. Wong wrote:
> > Still seems totally out of place for something not touching the
> > on-disk structures.  What's the problem with adding a new trivial
> > binary for it?  Or even just publishing the name in a file in
> > /usr/share?
> 
> Eh I'll just put it in xfs_{scrub,healer} as a --svcname argument.

I think I proposed something like this before, and I really like
that!


