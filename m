Return-Path: <linux-xfs+bounces-31050-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 15FgMSexlmmRjwIAu9opvQ
	(envelope-from <linux-xfs+bounces-31050-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 07:43:51 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 24D2015C6D7
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 07:43:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C983330166E8
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 06:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A2C03033D2;
	Thu, 19 Feb 2026 06:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UeQaIbfA"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C4D2F1FFE
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771483429; cv=none; b=uDnb5KzB95p1BWGGHcO78bSZ/BmuYG8r7UUYddGuGG5KHGUj7U8yZfKIuSQ1sPVrm+qejSSx0PcCaqEK9ReKTnxPeRVb0mO2uehMcO7phvTjVSVsR0TaU3lZVgd2DXRmtkOIoxIdl5F0bO0/eYpb0tqhwMsoTcDYBpR5vcecJt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771483429; c=relaxed/simple;
	bh=pHKBho55LugVkbBx3X+B1sZ2AMZCHbaACk0hIBphm6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m/t51MClru/z1we5jOetJm0ICW38cTfgBNVP/uPvk/SxwAPiEN/mGclPZXYGyQTmxkNiq4BqOeXDElqn4QAboC81pDhZuCRhQ8NLqJD+MO9B4NLB0ltHQ7EIejXCw7oymhlutdc0Nj/J73zqpPGiE4J9dpiZXqgXBD3nuemBySs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UeQaIbfA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=x8gzi43A2fuvu2A33tzA9xJTYWdurM9JoktLGJsWW94=; b=UeQaIbfAUQLv9UR7It28AnVds0
	lJPHbxB1SCBWMkMFWabE1LGVkgtUmxK2S+XnB+f3yFLnw1Z2kMYw68DNV1Xcz3xln4YiUiKnWcqRm
	NeaSqGaMmgpUkEeoT1/2PhtijRg1H9C9jRv7tqdSc4xmW7o6zwVdbDdrTFTJa9CEvLkTLk0D0DBJY
	wCgmFyULomYhOiL8ZKfHBrEa8rpU2y6+ghn5kffNOF0Mq41iDW9JcOhwXNgNJ7+itDY9y1FoTKi2f
	p9ob7p/nOMomPJ7H0XYhalRbNrDaMkKRfsl1bH5XnyqlG2MU/6Y3eFKyABscqWqPmwgVdUWpeJ61r
	6OCpkb4Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsxlL-0000000AyxQ-430A;
	Thu, 19 Feb 2026 06:43:47 +0000
Date: Wed, 18 Feb 2026 22:43:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, pankaj.raghav@linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: fix potential pointer access race in
 xfs_healthmon_get
Message-ID: <aZaxI4PzJKqUc7a_@infradead.org>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
 <177145925494.401799.17980890890269795712.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177145925494.401799.17980890890269795712.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	TAGGED_FROM(0.00)[bounces-31050-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,lst.de:email,infradead.org:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: 24D2015C6D7
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 10:01:45PM -0800, Darrick J. Wong wrote:
>  
> -	XFS_M((struct super_block *)hm->mount_cookie)->m_healthmon = NULL;
> +	rcu_assign_pointer(XFS_M(
> +			(struct super_block *)hm->mount_cookie)->m_healthmon,
> +			NULL);

Just a nitpick, but factoring the cookie to sb thing into a helper
or at least separate assignment would really clean this up.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

