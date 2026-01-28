Return-Path: <linux-xfs+bounces-30463-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YECZB7YaemlS2QEAu9opvQ
	(envelope-from <linux-xfs+bounces-30463-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 15:18:30 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B960EA2A0F
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 15:18:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CF3B830BC0D1
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 14:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 427ED25F7A9;
	Wed, 28 Jan 2026 14:11:16 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88585258CE7
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 14:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769609476; cv=none; b=PLdZxDGUa691wUC+7afM/mZTkdC8P2dhxrWLpjSKAcmOexMSS0IaQb79xNxHuWlTSSmvsDylKnmAE1OIR7HV+yN7aEFlCIbJcbj99XB4lgl0s0ms/V7FIKtjsaSQOn52eceUxqzSn3dO4VKG7lSxp2gjCJVXK6TmJgG3M0DxH0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769609476; c=relaxed/simple;
	bh=WsNlbnD+oYY6wTNYxbFE/t3esfSGGD3e2SujOQJOgXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jiu60jOJA/jq/PUiTvsr7yHrLK9FhY6YtY00m6rYzHJlpRZC48Pc25Hcu3pqs+a/BuS5l5GFBfP2EtsdX+XAQvNeH+HMsY4FXFlhbZTL6yCexmvvMNbt7yxy9xPReN7e+pFVAd6H6NqSkCRGOQrdOs4skadFRIwgJFOJij8FGco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 78105227AAE; Wed, 28 Jan 2026 15:11:12 +0100 (CET)
Date: Wed, 28 Jan 2026 15:11:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: allow setting errortags at mount time
Message-ID: <20260128141111.GB2054@lst.de>
References: <20260127160619.330250-1-hch@lst.de> <20260127160619.330250-7-hch@lst.de> <aXnyfoEDhdHTIf-E@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXnyfoEDhdHTIf-E@nidhogg.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-0.999];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30463-lists,linux-xfs=lfdr.de];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: B960EA2A0F
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 12:30:05PM +0100, Carlos Maiolino wrote:
> I think this should include the fact it is only supported with DEBUG
> enabled.
> I'm sure we'll get user complains about why 'errortag=foo' is not working?
> And, in some unfortunate case somebody has DEBUG enabled when they
> shouldn't have, at least the documentation says so this shouldn't be
> used...

Yeah, there should be blurb about that.  Right now for !DEBUG it
will return an error, but even that needs an explanation.

> 

