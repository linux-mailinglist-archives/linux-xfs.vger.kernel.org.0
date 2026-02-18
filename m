Return-Path: <linux-xfs+bounces-30922-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mCglJFBUlWnXOgIAu9opvQ
	(envelope-from <linux-xfs+bounces-30922-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Feb 2026 06:55:28 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EAC901532EE
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Feb 2026 06:55:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CD4063020A64
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Feb 2026 05:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 518222FE060;
	Wed, 18 Feb 2026 05:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EtFnXp1e"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5071A2FD1DB
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 05:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771394125; cv=none; b=U8kz7vZEWRFAlJTPCq8TVHrhdCKL00EWfznq1dw1mkU5fmlsq5eDwuVCd4HNC2c+Uya8pzAnU2SuDNvjI8oa3VES8e+aH2RgiG7wpF/E9TravZOAWuEi32dKdVUL8qtRRzemIEoO1hSuYFFpVjR4prbm1UYqtq6iwx5L0/oPEoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771394125; c=relaxed/simple;
	bh=aaPEgV8eYu1K8Bcmvkk0qNfXfUND7D1S2UVJgnUTN3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mj3+VsQA1/zjCXrYwznGL4fEFm7WXXpOf9lUOeMAXkpm4MGC0gLDLP3VydPdk02z3xrpdBYQ0FvaUT0L9sIHL2yor6xOFeO8gqUTG7Caro226gW+dGPBAtoinh7w32GACR1HTQ5ZOxSUVhILHmeYOzpsWrZzLJaUM3YZCwQ+0fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EtFnXp1e; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4JctS4OpWamxB98XRg5kHRgapsB3o2XLGMyW5mSsCqQ=; b=EtFnXp1eZJ8cYCOGhuk4rk3pR4
	wz6bBn8BWZ4+T2N0Pa6BZWXpEnqB5Togm7rcADgA2jfnkk96HsV6IwDcTNAuv/TfrNmi7mxWLiIiv
	ruaeFxhtZDfUweuRqz1sq/nwm7pyg1eT8CtgHTpr5oo59N4Buc91Bs09xRLyifYydhQnA5CFxrebh
	zEarjwBsGEQ3nb8hqwuimmLmrzQ4cFDE+H43tVZ+CwE54nlcZVcm3d3iyOWT1W9n2vstxLb5bvVG0
	7wu70wCQiYD5edihQPkvN/13AgUR19oi4MI75TxHydCSkLfLXMlPtv6xZRY5tPqKBJJL7Wj57PKoO
	3hglC7DQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsaWx-00000009KvB-3lSd;
	Wed, 18 Feb 2026 05:55:23 +0000
Date: Tue, 17 Feb 2026 21:55:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: djwong@kernel.org, hch@infradead.org, cem@kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com
Subject: Re: [PATCH v1 3/4] xfs: Update lazy counters in
 xfs_growfs_rt_bmblock()
Message-ID: <aZVUS2ed5FF6H65H@infradead.org>
References: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
 <edd86fb5739483fb016fbde304d72bb7325782a0.1770904484.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edd86fb5739483fb016fbde304d72bb7325782a0.1770904484.git.nirjhar.roy.lists@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30922-lists,linux-xfs=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.org,infradead.org,vger.kernel.org,gmail.com,linux.ibm.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[linux-xfs];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:mid,infradead.org:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EAC901532EE
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 07:31:46PM +0530, Nirjhar Roy (IBM) wrote:
> Update lazy counters in xfs_growfs_rt_bmblock() similar to the way it
> is done xfs_growfs_data_private().

Please explain why you're doing this.  I think it would also be helpful
to bring over a comment similar to the one in xfs_growfs_data_private.


