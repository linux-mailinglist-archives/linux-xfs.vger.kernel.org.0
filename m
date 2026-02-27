Return-Path: <linux-xfs+bounces-31457-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oP+uBuLFoWkVwQQAu9opvQ
	(envelope-from <linux-xfs+bounces-31457-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Feb 2026 17:27:14 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E00E61BAC84
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Feb 2026 17:27:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 92605307140C
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Feb 2026 16:27:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2D643C050;
	Fri, 27 Feb 2026 16:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CfcueGEb"
X-Original-To: linux-xfs@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F253A44CAEE
	for <linux-xfs@vger.kernel.org>; Fri, 27 Feb 2026 16:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772209623; cv=none; b=Xy8mpePCe0b/0UJj3iysIAatcVh6rqgwnfiLRlEmxik0Rr7U2RFp8u1MO/tZYX54heCGZoTcS0rOA/qjDheYgItdkm9SYnJzyA1qxwXjrf9xkypuVHzlbKQNhX2tm+oRkS6ISpBxOwf0z6N0siSE9TS1Y1oDrOWHHumXPUcHwtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772209623; c=relaxed/simple;
	bh=eUGlgvBw2sqpiR2bHyJ+kUaK1vBEurR9UQTx/gH8ot0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sBTbA5ElcSizmMfFd77kcppBwRtOBWZxa4QPhqY59d6FQeRTbUrz89NkRi8zMVECKzsJhaWQJg+yoWqQCQpa3yjfW//B2zn1l1YozVPlxa5MoTV/n3Gqey2BiTY601eCElCJq6x2g/QYConucaUhXqDKAZTRplZTl4AvwWO1fK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CfcueGEb; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 27 Feb 2026 16:26:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772209616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rnMCmZv1P1jQsccPtDJTW+HFX8QIxa/WaKjighx8usE=;
	b=CfcueGEbAXhpN/ZVfzrpXgnsikM2GXCa5d9pQQFdeQ8gvOmJlJtF2ZRhNL8XfVgkpubdoH
	IE1QktGL2n/tHZ85prWTA+ma3MlIJE4RcgaoNywgggYMrW/Y561a1Z1BMai5aUyVJqzRnT
	bKNEi3z8m1V4nS3kdqBC2Jmi2ciwMIY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, dchinner@redhat.com, 
	"Darrick J . Wong" <djwong@kernel.org>, gost.dev@samsung.com, andres@anarazel.de, cem@kernel.org, 
	hch@infradead.org, lukas@herbolt.com
Subject: Re: [RFC 0/2] add FALLOC_FL_WRITE_ZEROES support to xfs
Message-ID: <5fdwrd2sxgc635tf7yihzhwpbfcjlhcizhcmf2j6vnk4nmu36h@gyqktd2fbu56>
References: <20260227140842.1437710-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227140842.1437710-1-p.raghav@samsung.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31457-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linux.dev:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pankaj.raghav@linux.dev,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[10];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:dkim]
X-Rspamd-Queue-Id: E00E61BAC84
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 03:08:40PM +0100, Pankaj Raghav wrote:
> The benefits of FALLOC_FL_WRITE_ZEROES was already discussed as a part
> of Zhang Yi's initial patches[1]. Postgres developer Andres also
> mentioned they would like to use this feature in Postgres [2].
> 
> Lukas Herbolt sent a patch recently that adds this support but I found
> some issues with them[3]. I independtly started working on these patches
> a while back as well, so I thought maybe I will send a RFC version of
> this support.
> 

CCed the wrong Lukas by mistake.

cc: s/lucas/lukas/@herbolt.com

--
Pankaj

