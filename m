Return-Path: <linux-xfs+bounces-30941-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EKSlI8BZlWnQPAIAu9opvQ
	(envelope-from <linux-xfs+bounces-30941-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Feb 2026 07:18:40 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A7F2153698
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Feb 2026 07:18:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B46FE300A38C
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Feb 2026 06:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DB9C2D46A9;
	Wed, 18 Feb 2026 06:18:38 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD5E287263;
	Wed, 18 Feb 2026 06:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771395518; cv=none; b=PrHpMgGJatQf9u6r1eoS1ZXEDWKEwJDHcCtS6blvyTVXJ95HSzoGQllLrXkEZ5vj01tj3z3TclrVfPzPnHG+9wD3TJe5acpx7DWl1TFkfz/bbbzlZmPKZ1dqyDJ2VY8/kyCkuiIV6aY9aERmDKqWkREL8nzqI0uBoYqujruxe7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771395518; c=relaxed/simple;
	bh=2WBKlICc8vym+a3VShiu3sWpZlKqSwFcNAMgyGD5WaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nxtMHfa2I6ESxgvEWI5OWbBg125p8VSoXPq1nPHFM+IM72jwnrt5ZY5ofdicmfoqq5Qvotx785wwFP4J8CwLsOixpKNEjSXHOsa6E0DPxGuH+fNatPADCV5ZAQ68aRStAMEDWoNDVyx9bhL8RErgHBpxeeYvsmG3DC8SnyOH6fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 17E2568B05; Wed, 18 Feb 2026 07:18:35 +0100 (CET)
Date: Wed, 18 Feb 2026 07:18:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	djwong@kernel.org
Subject: Re: [PATCH v3 06/35] fsverity: pass digest size and hash of the
 empty block to ->write
Message-ID: <20260218061834.GB8416@lst.de>
References: <20260217231937.1183679-1-aalbersh@kernel.org> <20260217231937.1183679-7-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217231937.1183679-7-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[linux-xfs];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	R_DKIM_NA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30941-lists,linux-xfs=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1A7F2153698
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 12:19:06AM +0100, Andrey Albershteyn wrote:
> Let filesystem iterate over hashes in the block and check if these are
> hashes of zeroed data blocks. XFS will use this to decide if it want to
> store tree block full of these hashes.

Does it make sense to pass in the zero_digest vs just having a global
symbol or accessor?  This should be static information.


