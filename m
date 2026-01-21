Return-Path: <linux-xfs+bounces-30033-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SD7aJqB9cGktYAAAu9opvQ
	(envelope-from <linux-xfs+bounces-30033-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 08:17:52 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4411752B23
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 08:17:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CFD57348484
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F9293A9606;
	Wed, 21 Jan 2026 07:16:25 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208833385B5
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 07:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768979785; cv=none; b=W9OTof0vwpLxpoxIlMy11RNw8Tuax372VbAZV5j7/H8lEt4QNJpwkjHvpFJZIghruiDt+bQIyUkbwCJ6tdqqEqD4xxhgn8h0/0Z8DDbSDx7t1dIFufE3ltQlqFzG6iCsRuJSp9pqTy0pnSO+HktuvjG+tGu+yPMVrRqIe0FCH1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768979785; c=relaxed/simple;
	bh=5aJulP/Ixd6TX6trPDKdqv+RUGspDF7LS3pY0w8BaW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bLLGkeZDszjGpYNr1U6rsFKyEqWNcfLE1KRDy8sSQP2kkU0VgrGhwq+GteflKrlZahb/ciGS3/mpz5KGTjDGuhUWQOkDV+BaC8UmlMaiOvYyEFdJHItqYMBs22T2HLhvpeqYhhzq3Kv4v+1gdvF/XwkeZMyiirle9+4vidj88hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 14D08227AAA; Wed, 21 Jan 2026 08:16:20 +0100 (CET)
Date: Wed, 21 Jan 2026 08:16:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
	dlemoal@kernel.org, johannes.thumshirn@wdc.com
Subject: Re: [PATCH] xfs: always allocate the free zone with the lowest
 index
Message-ID: <20260121071619.GA11963@lst.de>
References: <20260120085746.29980-1-hans.holmberg@wdc.com> <20260120155329.GM15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120155329.GM15551@frogsfrogsfrogs>
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
	TAGGED_FROM(0.00)[bounces-30033-lists,linux-xfs=lfdr.de];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 4411752B23
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Jan 20, 2026 at 07:53:29AM -0800, Darrick J. Wong wrote:
> On Tue, Jan 20, 2026 at 09:57:46AM +0100, Hans Holmberg wrote:
> > Zones in the beginning of the address space are typically mapped to
> > higer bandwidth tracks on HDDs than those at the end of the address
> > space. So, in stead of allocating zones "round robin" across the whole
> > address space, always allocate the zone with the lowest index.
> 
> Does it make any difference if it's a zoned ssd?  I'd imagine not, but I
> wonder if there are any longer term side effects like lower-numbered
> zones filling up and getting gc'd more often?

ZNS SSDs have to do wear leveling by mapping from logical to physical
zones or even recombine the internal arrangement from NAND blocks to
zones.  The interface does not expose wear counters, and for modern NAND
the numbers might be different for different cells in the SSD anyway
and/or depend on various other things.  Even read disturb where frequent
reads require a rewrite is a very real problem now.

So in short: no.  That's probably the biggest difference between the
old Open Channel SSD concept and ZNS or other zoned interfaces, and
what makes using them directly from a normal file system feasible.


