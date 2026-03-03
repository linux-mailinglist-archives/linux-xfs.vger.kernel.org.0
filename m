Return-Path: <linux-xfs+bounces-31768-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kDmmK2D0pmmgawAAu9opvQ
	(envelope-from <linux-xfs+bounces-31768-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 15:46:56 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF761F1C06
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 15:46:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 65CF5307F0BA
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 14:40:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DC6643CEEC;
	Tue,  3 Mar 2026 14:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rTad74x6"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7001C3EB80B;
	Tue,  3 Mar 2026 14:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772548842; cv=none; b=Tm3cD7jku3R7+IM+FwTpL3MW/keymZtwF277gmIkls2/FjJg/hAZ/3CAb7quXPQwIdH8EXll7mxbkCZovy027y2/vq/kAhH0nWk2gR2F1Kzd1wTtTbqcRfrOscwUDy4z9QSUHo6g2mjr5X6BeR3dQb6ZezF8QEcIBmC2aoABaIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772548842; c=relaxed/simple;
	bh=h7vzRaW6RrC/Wlm3TWObbp8/My2jx5KrcDfgCJlCX04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OXzcSoJxucC3brImSc0XE2DPwAEZOt6bUwkE/Q3GhRpdt7/8IqjfmSoyHkds0m04JvRaYik9yV1zUWcNa0lMytR2UKFet6+1JA1GLjcstPulrhSek8V56/HNQ2aHYtPsREBhnOFEwrWvwMvwFEmCDulMC/NLIyXUX4w+vs4IK9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rTad74x6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eBMNlMMUtk9cxUfQfy8mG1It7U6Z8Smz8HvIoW76XiI=; b=rTad74x6wuW9DdmfjGckyEFN6F
	jzViN+fJ5q5dCCiYR6JuHLDSenfdDwsARVR0J3NHPSXjP22qVaIuIvv98VEQWRCcV+KwGsEsCv0ZH
	gGQUI+qQIHLJVqHYM/SsmZ/knyskv5odcrHZMKv1rYkLyHjuyS8bhtmJbQM85N5n1zD5zDKzKd7xv
	nLQzY62e/8kAjfp8LGf2NT5Byer17F2L8TmYsV2ozifa+BNl2nVBYu3q+AQWf5xmFMbnRKGHGYxyK
	pJvvu8r9fS23ha7iGLfRjaq8Apk30eAyIFQbm4+yucle39bYcWQApBHpvrkl0pm1IFGmkt+sF0AaF
	X7bxGYBg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxQvN-0000000FLXl-1XpO;
	Tue, 03 Mar 2026 14:40:37 +0000
Date: Tue, 3 Mar 2026 06:40:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Bill Wendling <morbo@google.com>
Cc: linux-kernel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Gogul Balakrishnan <bgogul@google.com>,
	Arman Hasanzadeh <armanihm@google.com>, Kees Cook <kees@kernel.org>,
	linux-xfs@vger.kernel.org, codemender-patching+linux@google.com
Subject: Re: [PATCH] xfs: annotate struct xfs_attr_list_context with
 __counted_by_ptr
Message-ID: <aaby5V0TDMlahSj0@infradead.org>
References: <20260303015646.2796170-1-morbo@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303015646.2796170-1-morbo@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 3DF761F1C06
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31768-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[infradead.org:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs,linux];
	RBL_SEM_FAIL(0.00)[172.234.253.10:query timed out]
X-Rspamd-Action: no action

> -	void			*buffer;	/* output buffer */
> +	void			*buffer __counted_by_ptr(bufsize);	/* output buffer */

Please split this up somehow to keep the line readable, e.g.

	/* output buffer: */
	void			*buffer __counted_by_ptr(bufsize);

Otherwise looks good.

