Return-Path: <linux-xfs+bounces-31068-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cGFBAX6/lmmslgIAu9opvQ
	(envelope-from <linux-xfs+bounces-31068-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 08:45:02 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B0D715CC73
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 08:45:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 37AC93018D43
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 07:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBEB8333440;
	Thu, 19 Feb 2026 07:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qvqeuxDb"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE9E332EB1
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 07:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771487078; cv=none; b=Wg7LyJmionjclCjUwxl6foMa0d7X3zZpvGnJ3zjZ60Uug6WhcHDepDDkuUwIvpEl2lTSsNTgQJHc4E9OkepZ/JUY2MmtX3AQQuwPhO8u/EF4ibfT5KIbQ0nskxdx8cm7UCGEnc3KvP7jQUIY0nDTPBQa6E5EFq4NVnpkyvTrRW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771487078; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mxRrAcEI+JbyN+utDSZ3Qy7jFuuGcedQumTCWT+I6HRhw682m85tvp3JUMTW/ESBg1mTxZZtYyn+Vs+RCy55Jf3sks87crk+9pMsmMEXda4ivOOEUy/1USP7zJw2Rn3J0+KyunZX4tPp2IVZpLRzge6nu/GFkq4GjoSMv7MH/Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qvqeuxDb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qvqeuxDbJaSWFIiBpV9T5ewXR0
	qYZVQ6jiplZkl02qSLoYXHcM52FRMS39sq+WHw2i2333QhIdh0ui4ldO/Bl+Anuc1Mrp91LWkIbXj
	KferDnIR8VToyWCFDG9eaiOMz2rYtNLcLnLOHuL+liqABFR2ms11Jdi6TPCJhpxQHJt9gt8XPJTRG
	rTLQmbQpn9TQw0ePNebcYpK6uN9FJHOQM+NXPwDZ7oPB3ChyTDA7V2bbz1dRW6JpkL5BUF96LmB7a
	LJqnKPShGFMyCho2NgjL97O9zUYIlP0g7obvnv+2PguRKLdC0GWg2E7DRQsTQGRscP9JQ+6vUHWFQ
	tUsJ3R5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsyiC-0000000B42s-3SNk;
	Thu, 19 Feb 2026 07:44:36 +0000
Date: Wed, 18 Feb 2026 23:44:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
Cc: djwong@kernel.org, hch@infradead.org, cem@kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, nirjhar.roy.lists@gmail.com
Subject: Re: [PATCH v2 3/4] xfs: Update lazy counters in
 xfs_growfs_rt_bmblock()
Message-ID: <aZa_ZAKTm2m380q0@infradead.org>
References: <cover.1771486609.git.nirjhar.roy.lists@gmail.com>
 <9533af5443570edfd63d876baa5d84b7aaad4dc1.1771486609.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9533af5443570edfd63d876baa5d84b7aaad4dc1.1771486609.git.nirjhar.roy.lists@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.org,infradead.org,vger.kernel.org,gmail.com,linux.ibm.com];
	TAGGED_FROM(0.00)[bounces-31068-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_SOME(0.00)[];
	SINGLE_SHORT_PART(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,infradead.org:mid,infradead.org:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4B0D715CC73
X-Rspamd-Action: no action

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

