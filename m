Return-Path: <linux-xfs+bounces-31067-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IExpNF+/lmmslgIAu9opvQ
	(envelope-from <linux-xfs+bounces-31067-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 08:44:31 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3835215CC64
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 08:44:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 859FD30166FF
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 07:44:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74FB02D1907;
	Thu, 19 Feb 2026 07:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="avU8uxLp"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538AF2D3A93
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 07:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771487052; cv=none; b=XPWXB2yIIhEIhrWw3zweViVNd/6E/CsPJdbBRTj2/XP9bJas8bqntZacSJnzIGob5ATL2XXDlYLK/EwORgyM+E555NZmH1OBuN1C224YD3VKLgCcNDMh29R0+hW429RXwQ7oNlYin15jarsqFnH9PUWwiYZNkmsy95yRMeTlpvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771487052; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qHRQbsCjcDS5XU/50mMIsO6hofeGhOsWfec4Iz5pE/Naf/SMfhFbw7Jn7z/h8B1ifQhiTnkZBWmzRZU9xFMBEFWXrnr2IXU8t4+tHxiHgH5WLXFjl3K5bcZJHPO/zQPqlwsIo95Rq5gfUdA1wut4p1TlP30tuvttvxcNIbk9WgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=avU8uxLp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=avU8uxLpnBamveDzNU5AiU5EwC
	xuHkckgWt3T562oJRz1lr+Xv1L5MY5GhBnogw/8cUJxeNTJ1B/5eAXSz6Xyl77yIon/H6iyQfsDA0
	9oEOmCs5c34Xb1WVjb7U5iQOVl8aWmBq1bTYVkVHMCc66Yy84YmLEogoXeZ62JMaRLn6WpUE/ayz6
	478rtc1t0inNurfoIj1GAcnWmaEdJy+PqK6ALf1nfwXNpBlyZKPAg1pVRto7dt5H9gM7S8aMM1UXC
	vze+9ECQD7Y/FLJhHjE4nee1SJLtqgxOEIGR8SUsuk6hiiDEFJCOaWs+vBueiDhEy3K1iZiCh/82K
	cdy8LKsQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsyhl-0000000B3zh-3Wpa;
	Thu, 19 Feb 2026 07:44:09 +0000
Date: Wed, 18 Feb 2026 23:44:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
Cc: djwong@kernel.org, hch@infradead.org, cem@kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, nirjhar.roy.lists@gmail.com
Subject: Re: [PATCH v2 2/4] xfs: Add a comment in xfs_log_sb()
Message-ID: <aZa_SUZxHAcdJ3Zu@infradead.org>
References: <cover.1771486609.git.nirjhar.roy.lists@gmail.com>
 <c01b69dba660fb31a3cd1bceeb534bc0e3d813e1.1771486609.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c01b69dba660fb31a3cd1bceeb534bc0e3d813e1.1771486609.git.nirjhar.roy.lists@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.org,infradead.org,vger.kernel.org,gmail.com,linux.ibm.com];
	TAGGED_FROM(0.00)[bounces-31067-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: 3835215CC64
X-Rspamd-Action: no action

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


