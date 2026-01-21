Return-Path: <linux-xfs+bounces-30071-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eDBNFJEKcWmPcQAAu9opvQ
	(envelope-from <linux-xfs+bounces-30071-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 18:19:13 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 831965A6F7
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 18:19:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 55BCE96C515
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 15:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C372410D1F;
	Wed, 21 Jan 2026 15:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IAEKa//S"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357113B8D5B;
	Wed, 21 Jan 2026 15:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769008134; cv=none; b=F79zZUY6DJQVl0uRnrFXiisD3emWpFrs6L/hZpjQCj0ZYgOUfDDZg6XKIoQuXjXmBzalDzs31WhhBeHSMHHFv/5tPUTY79ukf0RYJ6ACTS/qbsilPBo2gCQd7hR5sR2n4rA0YZB2LPVH/ozQSY6ZZyFoSdS1x1y4afC9dR6wW94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769008134; c=relaxed/simple;
	bh=2jlxnXQOuxkcWyQYaYYmzJvtjbtA7ODi/Nc7dFNMJpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gb1N3M+BB4EZBAbwBZeIQlXbXbEVKatvlKIc1SBOcjZBLQTkP+TF1tyO5zvpQtn0X443RzHxEPu9BwmlpsBxS+h53Z8q3cxdmN/ILyDlne42CuIjf4Qp3Y73+DbsGaYKWqoQJGK5KNM0b7JhT5c+WqOzGGeDeMZ3r12jcp8Y4vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IAEKa//S; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ef98/rGETd1uDXLXy+oOQeWey3qqHGTFjW8uPfnb9dA=; b=IAEKa//SDuqqa4U8zzf5Eh76py
	nMs612ivpQfB/QlE4fZJnDlB91xAaOARMc15aias6v/kBbiddTPKDBTRZC0xSxZIAZrmo24ujkkgY
	khIhtPTOodN+0a5mCKuwlmBSMv5T4pbVuYuDrB1XQGs9uBXT/KhgkWaEXrmMcjl7tYQtBvWgL6UT/
	hcjeXW939+7dQNieYLNh3BTKLpt6OQoP7PHwLkqwZlsdjr/GNwFHdw65xXJDDcFGPmOSrbJR6PJgi
	LvFwHTIxTlLKwMGwfC/b65jwp0ai7eBSirEHZv4Pw4azlSLVJw/ciyzipaTi77ftg+mbnd03a+IQd
	Qc77k1rA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viZpE-00000005hOB-1w4k;
	Wed, 21 Jan 2026 15:08:52 +0000
Date: Wed, 21 Jan 2026 07:08:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: fix remote xattr valuelblk check
Message-ID: <aXDsBBJCc5Kx7UwM@infradead.org>
References: <176897695523.202569.10735226881884087217.stgit@frogsfrogsfrogs>
 <176897695685.202569.16435015345442663590.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176897695685.202569.16435015345442663590.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-30071-lists,linux-xfs=lfdr.de];
	DKIM_TRACE(0.00)[infradead.org:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_POLICY_ALLOW(0.00)[infradead.org,none];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TAGGED_RCPT(0.00)[linux-xfs];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,infradead.org:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: 831965A6F7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Jan 20, 2026 at 10:39:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In debugging other problems with generic/753, it turns out that it's
> possible for the system go to down in the middle of a remote xattr set
> operation such that the leaf block entry is marked incomplete and
> valueblk is set to zero.  Make this no longer a failure.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


