Return-Path: <linux-xfs+bounces-31047-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UDsWDsCwlmmejgIAu9opvQ
	(envelope-from <linux-xfs+bounces-31047-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 07:42:08 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AE6A115C6B8
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 07:42:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E246301F491
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 06:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C1053033F6;
	Thu, 19 Feb 2026 06:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VOHFsdcY"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F325A2874E1
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771483298; cv=none; b=GEvHEys89nJ6lREt3gQRl7R6T4wqmQemFauxYf+5HSSsXJD/yMx88jOTqvSnKUhQsDb/jtrMtPgcTE4YVqY0gpsxIsepNKmCJopm0zJVcbG4e+accKvphRqVwLj7KMvtARjJSf0mbuHWapJJsZXtnPNJp5Zova1vDdCj85DUGD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771483298; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VyusnfXAwioL0dEdK9Rj5zcYdcFw3mw0BUtVaCXNl0Udf67LEWK1ezURLWgYxLqZSeiBV4Bh2FyUpS8ghNSLZ2k1MsZ+29qk9WmMpNlEpKALpgNc+NA7jxZr5/Q2+hu1ANBNAYFlUEKy4o0z7uKBKMdTO8RIn2VRThFG6h62qoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VOHFsdcY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=VOHFsdcYT6uh4I3zpqK2kp0j+l
	7GHPljDgDSV0E/ij5qhIiJd/PPOYxUNOunBZCyUy7rIzF28K/r6YuBL7mhfD7zKU2rJlXPR5D1upf
	rHMCLEhYvh6R8qOtPbjh3Zknq7N8jWVO328L1xzsSd8LFgG0JRVv6iwbLad7KrIPZXHPn8kR/5gfY
	uv3H1VC2P3Wh01Cx3sdbPDIONZiiRH2ZCR5KENhzfu0R7zTSXDwGbVkXNaN+WIuuh0Y4avhoiAGdz
	jMapf7JGlr+Rngg8nwiqa3HMp+reNFYzLrrKTkBD3epZCYVdrlZHdKb8RrRu3yoha2m2FmBQVtkrt
	Io1QKZ4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsxjE-0000000Ayoy-2Geq;
	Thu, 19 Feb 2026 06:41:36 +0000
Date: Wed, 18 Feb 2026 22:41:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, clm@meta.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: fix copy-paste error in previous fix
Message-ID: <aZawoLu5b7yHwsra@infradead.org>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
 <177145925431.401799.6241225612324128085.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177145925431.401799.6241225612324128085.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31047-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:mid,infradead.org:dkim,lst.de:email]
X-Rspamd-Queue-Id: AE6A115C6B8
X-Rspamd-Action: no action

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


