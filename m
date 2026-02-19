Return-Path: <linux-xfs+bounces-31045-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +I5BI/6vlmmejgIAu9opvQ
	(envelope-from <linux-xfs+bounces-31045-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 07:38:54 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E7FE715C683
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 07:38:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7990D301571B
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 06:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 468902D9EF3;
	Thu, 19 Feb 2026 06:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y1/FYAP2"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D811EB5F8
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771483131; cv=none; b=tmjoNkIN/npmn7SD56r4RLY/D4xgsHE7NsXHIRUMFIn9+hPn6VMPaAOCZHUAU15//thM2l9O+1OHKSxvx+Pk1rFuiUghMQLRKGsxc8jGnkHZYMajqCJca5nncGgqnAMnmy+tizPvKjTzr1aXKfq2zUKcWFp7ILbxMZHkFtaZWpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771483131; c=relaxed/simple;
	bh=9VT+6HKWvsJ12tOTo4HnObzWDR3ZmajpcblbcimzRMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X0X99Iq9z2eqpi2gY+m8PvxRhLOiPOVs4F5b6aT0YGiFBUZPOsQTrgq+fD4cATdP23kV2uUrGsFcVpW3HYo+chqyKw3fjrRXgHUVgEmhSrW2ixYwy6NNZlOzNSrruPzUE6oBEuOGDKn7XVGc29ZtS3fqWYnAlpa/5qfvRnjXhk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y1/FYAP2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZEracBpiVoqqDNKGp2iUsI5t5VJ6ZllpgETI6m+7aY4=; b=Y1/FYAP2Gp1CLHSBgbZUL664Bk
	oFQy0kgzpE7lbDwRRUZdP4xdGNLjT+lcfs/EN+VqhNOAq9mi7D0VBlfFgu6+qLrvqNHoenRqT0rRg
	XkSR4ihqU8viY+TFoqrTWSJcxYNl+pE3ImFY8Snp139tOD8EcjBjuQR2tLpo/I0/BuprkqyUSe5i7
	b3uuleMbINYSMQjlewCwRSN3MSBdDcI8qjLZwx2dSzfDof7HX9QVOI+xXC1dunAOnH04wLBkOPw0N
	kTyDAjcJWtrl2PwZPphdlrhfqX8ozPRWMMiq5MqIoDAOeSUbbuS04vpADm24Xa6q+fOcYk/oEPRNA
	Cozye8lQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsxgX-0000000AydH-3F17;
	Thu, 19 Feb 2026 06:38:49 +0000
Date: Wed, 18 Feb 2026 22:38:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, djwong@kernel.org,
	cem@kernel.org, linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com
Subject: Re: [PATCH v1 2/4] xfs: Update sb_frextents when lazy count is set
Message-ID: <aZav-QE1L87CKq5L@infradead.org>
References: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
 <3621604ea26a7d7b70b637df7ce196e0aa07b3c4.1770904484.git.nirjhar.roy.lists@gmail.com>
 <aZVUEKzVBn5re9JG@infradead.org>
 <91050faaf76fc895bbda97689fd7446ad8d4f278.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91050faaf76fc895bbda97689fd7446ad8d4f278.camel@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31045-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[infradead.org,kernel.org,vger.kernel.org,gmail.com,linux.ibm.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:mid,infradead.org:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E7FE715C683
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 02:19:21PM +0530, Nirjhar Roy (IBM) wrote:
> So I just moved the comment and the updation of sb_frextents from
> outside of "if (xfs_has_lazysbcount(mp)) {" to inside of it since
> sb_frextents is a also a lazy counter like the sb_fdblocks, sb_ifree.
> The comment talks about using the positive version of freecounter i.e,
> xfs_sum_freecounter(). Do you mean to say that the updation/sync of the sb_frextents should be
> outside "if (xfs_has_lazysbcount(mp)) {" i.e, done irrespective of whether lazy count is set or not?
> Please let me know if my understanding is wrong.

rtgroup support requires lazy counters.  So we don't really need that
clause, and the extra indentation makes the code harder to read (
to the point that I mised that you actually kept the correct check).


