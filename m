Return-Path: <linux-xfs+bounces-31811-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0JuIAWEGp2k7bgAAu9opvQ
	(envelope-from <linux-xfs+bounces-31811-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 17:03:45 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A6C1F32B1
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 17:03:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D56B2300DF60
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 15:58:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FBB437B018;
	Tue,  3 Mar 2026 15:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gabj/aA8"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF59288D6
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772553516; cv=none; b=SYbADw5Xt1cVX9Xq/GiD/EV1390VPpeiDu9Aq8Qt70eEtq4KqhohE97iQ6Ji9Hs/flaGS77qfIO28R0Y3q8cHkqKBXFMN7OsxYD382xcwdwfaFJ1IPNHHAXkN0jQSFrJtKpvy2/AJCg2mouEVaRTtHjshGb5L0KKSqfokrX4ibs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772553516; c=relaxed/simple;
	bh=BcWWEOwMhTd+4cwHsYwwRU3GvsM6Kzx7H7Ds6eR8ovM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NSteZ/2XOAbcEHzZBiYDBmdUy86pIP5i85HHfKuE0z3bmLyrQNpfCtVa2FJSIjkIJvHrYcG4nTHMEzlKADPCxj5O/9BMVho3kio/Vm9F9nwAL/TCQ0tZ1c47v8YEbN6YjfIBDzI2vGysGInwo3uN/z7/r6cJg+qV/grYKSPCspw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gabj/aA8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7Um5u0l3Oae9Orazex1DwCkSC22fZR3ouQY8wZ8r9mU=; b=gabj/aA8PQdlzq+HtHX0gZqgwS
	UhMviEiOKA6KFpX0UtpAAw4RsKZEoL43LBFDNULXEs2DSf49iyHiy90PCk7UXs/5abqQoA4fXXG7A
	GXM/9vG6Y6Yhc84aVFYiiEgFFj0xyH5jmh9mrPmrOU1p0+tjswoOLi8RxAvib0AVxy5ikc5lFb8m7
	b7GRl4ylknLJZYRPM6+7WTS/D5RfGE6zT/DKhGxOY6y8xQMYNSwL/Rlr214x4UAbhP/ICP/IB9Iho
	uP0YH2H913QwQsmoQjz2veLx2aDK4bRz7ADgeaF2f32NV/LtDNlJDhih7PYKdiFbjxuND1YsaDOCZ
	VmauVA/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxS8o-0000000FUfY-444H;
	Tue, 03 Mar 2026 15:58:34 +0000
Date: Tue, 3 Mar 2026 07:58:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/26] debian: enable xfs_healer on the root filesystem
 by default
Message-ID: <aacFKgnRvvhSVsH_@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783748.482027.8553755838914398859.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783748.482027.8553755838914398859.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 97A6C1F32B1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31811-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RSPAMD_URIBL_FAIL(0.00)[infradead.org:query timed out];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[linux-xfs];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 04:40:20PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we're finished building autonomous repair, enable the service
> on the root filesystem by default.  The root filesystem is mounted by
> the initrd prior to starting systemd, which is why the udev rule cannot
> autostart the service for the root filesystem.
> 
> dh_installsystemd won't activate a template service (aka one with an
> at-sign in the name) even if it provides a DefaultInstance directive to
> make that possible.  Use a fugly shim for this.

Given that this is brand new code it feels a bit too early.  But maybe
that's just me.


