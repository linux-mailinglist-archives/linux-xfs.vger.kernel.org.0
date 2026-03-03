Return-Path: <linux-xfs+bounces-31774-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eAiJGcX1pmmgawAAu9opvQ
	(envelope-from <linux-xfs+bounces-31774-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 15:52:53 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C06441F1CEF
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 15:52:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 76776300D949
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 14:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6462B36EA87;
	Tue,  3 Mar 2026 14:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="5G3yvyHO"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D21B47D92B
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 14:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772549222; cv=none; b=FmjH9VYu2m22jfOOc2DoZGrrW3kE2tTekIu73U0fT6ay+vwbK/Pl86r/mifXlysKbeT6iq4x92r307LU8/e7a4GpscIm6JfUPeXYXpipPLmTBlPaM+ZsbUxpRYhJo0srxSuXb22E1J712nSTLyeHHlDQ0S5mqy40cflQmRs0Eho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772549222; c=relaxed/simple;
	bh=HUOdW7Rqb2wohDALb5yxuSDXw4qHwFMkWfJIyBFtpvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eYaYzGojjOfs5esUiXkt5C29ySMiRITfmiDlo77x9/KaocqRXTp+PX+5fuIJq+5iBt2DQaiR+gUaYz9MS7MGmhcCcEy4M7V5eXzKPMESreTfXVujiwMEoLVLGwWj0Fp02f00os+B291j5AgRvJLndO3MwlwjCqXdXpvjTQYtfK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=5G3yvyHO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HUOdW7Rqb2wohDALb5yxuSDXw4qHwFMkWfJIyBFtpvo=; b=5G3yvyHOtItb/cdCRM7zhpts0n
	qhFXGWChb39kB7Gw0QjSOHk6dZQdWO4KcaBd7poIwrG37AQyhddhDEXGF3aq/qbXO4mAIW2CwvbpC
	g4Xrn0RN24LDLPCyYa2Z16w6fbTTCeoaumdL9Vb2iVeRuLocc7pvzV2bCO25PLwcUrWV/K7itHLRR
	QGFbsTqoEM5XYuK75EodbQHB/fo2ePauZ1dHJsQSEFXR/jipQaBRV5FJqYydMbOKlHs/FtTbQEJD6
	ArLLbI4tN9vfJK99SsIv43cdTajhKHLOjMq7xsJlE936dia5vUuDXEkzqwCN2tv8/aY7BLLHGzljb
	8RQlbo9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxR1X-0000000FM6s-2LzD;
	Tue, 03 Mar 2026 14:46:59 +0000
Date: Tue, 3 Mar 2026 06:46:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, kees@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/36] treewide: Replace kmalloc with kmalloc_obj for
 non-scalar types
Message-ID: <aab0Y5ZMfuvylSD3@infradead.org>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
 <177249638311.457970.11002432782642333341.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249638311.457970.11002432782642333341.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: C06441F1CEF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	TAGGED_FROM(0.00)[bounces-31774-lists,linux-xfs=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,infradead.org:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Again, splitting out adding new helpers is probably a good idea.

And boy do I hate this new API that was just sneaked in without
any review :(


