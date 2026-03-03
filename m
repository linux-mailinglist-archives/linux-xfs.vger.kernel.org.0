Return-Path: <linux-xfs+bounces-31775-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ENZ4N8D0pmmgawAAu9opvQ
	(envelope-from <linux-xfs+bounces-31775-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 15:48:32 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 463CB1F1C42
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 15:48:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F176C306A31D
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 14:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C9A47D94F;
	Tue,  3 Mar 2026 14:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0aI7IjXB"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD63F47D93A
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 14:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772549250; cv=none; b=kzehA9Aa3rI3/kULHnqNpd7EcTLM83vM2hocipZ3IQcBgLD4HSL9juKOOEFshGzoBn/aS9f6JwD4eO5D72vGTKFmuPOY7/o14Hl/xE8aymPvNBaJdEi9uOtyysRBjRfmXuDFMHdUQ3f3nNbsfkOU027UkGVWmqHCvIyo2OxU5SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772549250; c=relaxed/simple;
	bh=d2rXIeEzq6KrvoLw/TA0JsOh1g4p47bo0nYnt0d+Avw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f5TOjmkyZ1nIS+InVCxVbKF2uIqEgMUvSAt9Zl5npjMbI+8a8EQUKWuyaX3gbKNI4C9vS/5VQwt0DjUzbu+8Mw/RX6H6PBvRf/TABRCxcqVda/cKaN1w50gceaCN9CJ9UwyH6/MFokEbYTWDFiWmIXM3e2m93f4AovJ+/4RLuJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0aI7IjXB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JMP0ykFoCNvlZpRWrfYuA8YCcV+DZJZKa4nXYLbfkis=; b=0aI7IjXBprEoyuoSlPo3s6EEEM
	SBOdkUZgytU0S0GVNMNPKFBuXWFDypGYgsDinJ4Gzo9EHA9Fl/9w80yAgVXKRNq1e1PR7ZjLqwPBs
	infH9bu7Yop77lKaLqOjkCU4CadJgtt8csEeMbXco0qoKv3Cv2hDjgitXWBhzW9tGPIrBbmn799kV
	L1W7dfrm0wlEpYRSD/pQoCtLte8N+Qmf6SjKL6s9Sj9TC55m0Zz+Els0J6zlNSI8LKTjGxHMXKyPq
	eO+/MFwlhd5oFOmsY5WfwC5yWNajk5u51SPs1j4H1/9zfKFBHTpsjs4Cri4oASI9Fm1l18OMrkkM1
	k1K9KrRg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxR20-0000000FM9m-0rDL;
	Tue, 03 Mar 2026 14:47:28 +0000
Date: Tue, 3 Mar 2026 06:47:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, torvalds@linux-foundation.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/36] Convert 'alloc_obj' family to use the new default
 GFP_KERNEL argument
Message-ID: <aab0gDCTnuxWbkAo@infradead.org>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
 <177249638330.457970.1851487051288611819.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249638330.457970.1851487051288611819.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 463CB1F1C42
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	TAGGED_FROM(0.00)[bounces-31775-lists,linux-xfs=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,infradead.org:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

Yikes, and Linus found a way to make the API even worse.  Why didn't
anyone review this?


