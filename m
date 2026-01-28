Return-Path: <linux-xfs+bounces-30466-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uBxHDMMoemlk3QEAu9opvQ
	(envelope-from <linux-xfs+bounces-30466-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 16:18:27 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A47DDA3A2F
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 16:18:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 98E8030078F7
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 15:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22FD6369220;
	Wed, 28 Jan 2026 15:12:56 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F311E3596E4
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 15:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769613176; cv=none; b=m/XgqaZ0znvkRbPO1BYpUsUkZs79Lr9tVsRtcNvzsDvA/LRg0Mxmu2llASK0dzCsQMTCKByNE/cEwBXrPmqUO1W5t6pgMEly9IJKcESsG7XhtiFG60JZ+tFL5s69Lnnv+E4blDfY36zAQ+nXAl5Pm/v/5wBASrw+HT98FfxbYxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769613176; c=relaxed/simple;
	bh=DTX7FkKMcn6aJgotxM2VLTiW/RrP0mNW8p8ymXngXCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GWjYv3qgZAnkF/5hDtHPtxNJZpc3LZjmF65GXxeBDMv0PzgClEmp/yZaiOhiJbAd4a1ggO0zCmjLee3/CKioWA7mTWy8CU/N/RzMXBVb/lSOb3NByi2cTqEx4R0F4r+DH11wvNeoPt6DzYzCyOJVPywJGJ0bNUg0SwWdPtZNtgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6CC4A227A88; Wed, 28 Jan 2026 16:12:51 +0100 (CET)
Date: Wed, 28 Jan 2026 16:12:51 +0100
From: hch <hch@lst.de>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 10/10] xfs: add sysfs stats for zoned GC
Message-ID: <20260128151251.GA7277@lst.de>
References: <20260127160619.330250-1-hch@lst.de> <20260127160619.330250-11-hch@lst.de> <8df94cf5-20d0-40ea-8658-d24769faf7fd@wdc.com> <20260128141233.GC2054@lst.de> <a589bf70-883b-43da-a6fa-438b0c0d3467@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a589bf70-883b-43da-a6fa-438b0c0d3467@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-30466-lists,linux-xfs=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,lst.de:mid]
X-Rspamd-Queue-Id: A47DDA3A2F
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 03:11:01PM +0000, Hans Holmberg wrote:
> xs_gc_write_bytes is fine by me as (it is not wrong) but maybe xs_gc_bytes would be a better name?

Fine with me.

> (as it is the amount of data moved)
> 
> and you saw my comment on the xs_gc_write_bytes typo?

No, must have missed it, I'll take another look.


