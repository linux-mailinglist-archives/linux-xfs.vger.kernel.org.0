Return-Path: <linux-xfs+bounces-30464-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yLqgJ0MaemlS2QEAu9opvQ
	(envelope-from <linux-xfs+bounces-30464-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 15:16:35 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E312A29BA
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 15:16:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BB7EE300E5CB
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 14:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E8D026159E;
	Wed, 28 Jan 2026 14:12:36 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BBB255E43
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 14:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769609556; cv=none; b=AfHUAnGNqDq43rPPSatM0wiBdFq4E8hAQkMwKXo3F2Y56ggX/D/bPEGAf/En81n3LTA53CqGhizaB6HEbpmSPhAFhJsin9cBFKolnFJRmrAHU1i+VvQ/rA+fxmIDp5emzs/rnkyZsalPrrg0omDTBOhr89AQ3npZ6oS+P7pDBdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769609556; c=relaxed/simple;
	bh=IC1Cw+iIm7uqi/88lNIKagN3AZ2dQbmbwiYiF+TpyYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DfgIn/5pBjtatFzGaKeB27NOFUuMGOqDMhJ1GHEc+lG+NR0DP9zatkBkqM2MlGlHOMSp0U2vlCcHWFnML247zHkNfLhnG/Ck3xPsUiplCEeBh5h0Lcd4FdDdq9SPSRx5mqGqW8ED55IOcwj9udsQke8V4BWCS1f8gFN5OSq91FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5FD69227AAC; Wed, 28 Jan 2026 15:12:33 +0100 (CET)
Date: Wed, 28 Jan 2026 15:12:33 +0100
From: hch <hch@lst.de>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 10/10] xfs: add sysfs stats for zoned GC
Message-ID: <20260128141233.GC2054@lst.de>
References: <20260127160619.330250-1-hch@lst.de> <20260127160619.330250-11-hch@lst.de> <8df94cf5-20d0-40ea-8658-d24769faf7fd@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8df94cf5-20d0-40ea-8658-d24769faf7fd@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-30464-lists,linux-xfs=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,lst.de:mid]
X-Rspamd-Queue-Id: 0E312A29BA
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 12:53:24PM +0000, Hans Holmberg wrote:
> On 27/01/2026 17:07, Christoph Hellwig wrote:
> > Add counters of read, write and zone_reset operations as well as
> > GC written bytes to sysfs.  This way they can be easily used for
> > monitoring tools and test cases.
> 
> This is great, but I read this as "add all of these counters to sysfs", so clarifying
> that it is only gc bytes written that is added to sysfs would be good.

All of them are added.  But the others are 32-bit counters and
handled by the existing code just by adding the new group to the
array.

> You did not add a counter for gc bytes read, because that is equal to gc bytes written?

Yes.


