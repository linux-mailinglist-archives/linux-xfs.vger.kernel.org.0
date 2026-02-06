Return-Path: <linux-xfs+bounces-30662-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YN0/I0uFhWmqCwQAu9opvQ
	(envelope-from <linux-xfs+bounces-30662-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 06 Feb 2026 07:08:11 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A67FA909
	for <lists+linux-xfs@lfdr.de>; Fri, 06 Feb 2026 07:08:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 39D1D301184B
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Feb 2026 06:08:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAAF429AB00;
	Fri,  6 Feb 2026 06:08:07 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD3D3EBF05;
	Fri,  6 Feb 2026 06:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770358087; cv=none; b=c9KXKKHClUBZej/E1sqOLG32Z6X+SwQvUgFUL2h+49C3TmzjApbMqBWYdnE9YUvxxv+9TWktF62qcydv/rgTeTzpryMf6c8WouP6zU7W0F3I+kKngy1dLmUoftvuzBvzPB7V/7tSX8P8dIq5Rfv033UKoOUR5AzmYNyQnfOCoSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770358087; c=relaxed/simple;
	bh=uFxbObv8epAdju/JMu6ho1Jmw6Bw33+w15ZXZ1F2Cgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ehaBTbcDgU3VzQ3o4x4zNPVGofS2DHL2sol8AhBVgBkq30HqYDzV4eGow3ySi6j7Dtld6B69wowIGSGq4911FEFANm/L7n4fgZdHqqKISL3ZE85eBVm/VNtZSjfsRBWyihH+T03VDDYcBZ10jYgaVb55jXEIo0rvhKRb6t8CrzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F171E68D0E; Fri,  6 Feb 2026 07:08:03 +0100 (CET)
Date: Fri, 6 Feb 2026 07:08:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH] xfs: add static size checks for structures in xfs_fs.h
Message-ID: <20260206060803.GA25214@lst.de>
References: <20260206030557.1201204-2-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206030557.1201204-2-wilfred.opensource@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30662-lists,linux-xfs=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.986];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	R_DKIM_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TAGGED_RCPT(0.00)[linux-xfs];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,wdc.com:email]
X-Rspamd-Queue-Id: 97A67FA909
X-Rspamd-Action: no action

On Fri, Feb 06, 2026 at 01:05:58PM +1000, Wilfred Mallawa wrote:
> From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> This patch adds static size checks for the structures in
> libxfs/xfs_fs.h.

That's very useful, as adding new fields can mess them up, thanks!

Nit on the commit message: "This patch ..." is redundant and get some
maintainers enraged. Maybe also amend this blurb to mention why we want
the size checks:

Add static size checks for the ioctl UAPI structures in
libxfs/xfs_fs.h..

> The structures with architecture dependent size for
> fields are ommited from this patch (such as xfs_bstat which depends on
> __kernel_long_t).

Good point.  Maybe also add this as a commen in the code?

> Also remove some existing duplicate entries of XFS_CHECK_STRUCT_SIZE().

Oh, good on.  This should probably be split into a separate
patch.  I'd also keep the first occurrence and remove those under
the "/* ondisk dir/attr structures from xfs/122 */" label.

> +	/* direct I/O */
> +	XFS_CHECK_STRUCT_SIZE(struct dioattr,			12);

It probably make sense to keep the uapi ones a bit separated from
the on-disk ones.  I.e. add a

	/* ioctl UABI */

comment at end end, move xfs_bulkstat/xfs_inumbers/xfs_bulkstat_req/
xfs_inumbers_req there and add all the new ones.


