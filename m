Return-Path: <linux-xfs+bounces-30034-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mM+mN659cGmxYAAAu9opvQ
	(envelope-from <linux-xfs+bounces-30034-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 08:18:06 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A2BCC52B32
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 08:18:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B83F24A23B2
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:17:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E0F9363C4F;
	Wed, 21 Jan 2026 07:16:58 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65ED53A63FD
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 07:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768979818; cv=none; b=uIw5iFlyW98JUG/4rXDURSwKX1bc27ElDmKsIOfrpc9gq8uTeQSsSSDbJxohG//v+NIFkyl0m2XbhEFbJwYqdBjinqv7dDEEHF/RDCR96FQawaezn04TJsdJOcfjzLZHi33B0JwfniJA6IvjEns/5Q4k+4ZqPEo5MZx5aPSMMyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768979818; c=relaxed/simple;
	bh=dMFLkkPsgdXoy/83+LrrIYtMFRMTMFScB3S/UYrfDyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kLu6ktOhRhgjUW4d4kRC9js62v0FXhsrsknvO9syOauAA8Hz//lQVkbs9OHF0ZkaMXwFsE/OmfxgnVJDZZTe1auYlzUlfGxNKbIAGac5EucGeK9OfwvpAZ3WGDj3IcDAe1/FXfAIQRBxbFsHXHwRB6E6APASc3AZR3tSuXGX1Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7BC86227AAA; Wed, 21 Jan 2026 08:16:53 +0100 (CET)
Date: Wed, 21 Jan 2026 08:16:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, dlemoal@kernel.org,
	johannes.thumshirn@wdc.com
Subject: Re: [PATCH] xfs: always allocate the free zone with the lowest
 index
Message-ID: <20260121071652.GB11963@lst.de>
References: <20260120085746.29980-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120085746.29980-1-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : No valid SPF, No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	R_DKIM_NA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-30034-lists,linux-xfs=lfdr.de];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: A2BCC52B32
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Jan 20, 2026 at 09:57:46AM +0100, Hans Holmberg wrote:
> Zones in the beginning of the address space are typically mapped to
> higer bandwidth tracks on HDDs than those at the end of the address
> space. So, in stead of allocating zones "round robin" across the whole
> address space, always allocate the zone with the lowest index.
> 
> This increases average write bandwidth for overwrite workloads
> when less than the full capacity is being used. At ~50% utilization
> this improves bandwidth for a random file overwrite benchmark
> with 128MiB files and 256MiB zone capacity by 30%.
> 
> Running the same benchmark with small 2-8 MiB files at 67% capacity
> shows no significant difference in performance. Due to heavy
> fragmentation the whole zone range is in use, greatly limiting the 
> number of free zones with high bw.

Cool, thanks!

Reviewed-by: Christoph Hellwig <hch@lst.de>

I always like patches that speed things up by removing code :)


