Return-Path: <linux-xfs+bounces-30668-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +LkgD6KPhWkODgQAu9opvQ
	(envelope-from <linux-xfs+bounces-30668-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 06 Feb 2026 07:52:18 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CD46EFAC62
	for <lists+linux-xfs@lfdr.de>; Fri, 06 Feb 2026 07:52:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 763B1300FEF6
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Feb 2026 06:52:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16F5D2EC0A7;
	Fri,  6 Feb 2026 06:52:16 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88B42D73B6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Feb 2026 06:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770360736; cv=none; b=nuG3kyHm1CUQhm/28vdGZkA5q0OvBt2seH7rWh0+87qcev483+FotNbT8g3KvaLJSNSgqEPUTGonz0nqveXoWIptPESBi7CZEwXRLKGrwmBaxTz311pl2wgP/zgDWG0+qme9GOBc2+Win3QndsuyFkRiIu5XPrdblNLGbqc1PYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770360736; c=relaxed/simple;
	bh=qW2GqSSksn7CPduMlITTJ4plq4VE80nQh+eW2OOe4ro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HTq5HQBF2mqyU10K01C/44twkUbtUrnVdTZYBLypxvh4kWQbIjOmYLQ+sDtN345Xe3ppMjfh/m2ox1fLz9nppyOYCxwlh8yNJXqzPKjGZ/bkC43GYcatr+u1TdO+ZZMMWwHbau5CckNXB5KLmkmyK1NXhln6dpsOMRMfi4uciJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 414D068D0E; Fri,  6 Feb 2026 07:52:13 +0100 (CET)
Date: Fri, 6 Feb 2026 07:52:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: remove metafile inodes from the active inode
 stat
Message-ID: <20260206065213.GA26772@lst.de>
References: <20260202141502.378973-1-hch@lst.de> <20260202141502.378973-3-hch@lst.de> <20260206064342.GX7712@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206064342.GX7712@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-0.994];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:mid,lst.de:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30668-lists,linux-xfs=lfdr.de];
	RCPT_COUNT_THREE(0.00)[4]
X-Rspamd-Queue-Id: CD46EFAC62
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 10:43:42PM -0800, Darrick J. Wong wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks ok to me, though I wonder slightly about the atomicity of the
> percpu counter inc/decrements.  But it's been that way for a long time
> so

It's not atomic, but the percpu summing is by definition never fully
atomic anyway.  So it might add a bit more of error margin than the
pure summing, but it removes the much larger error margin of having the
metadir inodes accounted in the first place.


