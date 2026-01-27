Return-Path: <linux-xfs+bounces-30394-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eEIIH3jweGkCuAEAu9opvQ
	(envelope-from <linux-xfs+bounces-30394-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jan 2026 18:06:00 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D927982A8
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jan 2026 18:06:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4243E3084924
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jan 2026 17:02:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E52362128;
	Tue, 27 Jan 2026 17:02:04 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8577B3624C5
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 17:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769533324; cv=none; b=gvppyNMchs8yZ2zSJnG9EyWgQYOF1tAzenhn+Foyzmymf8kCY8olWfBK9pshPuCdWvU4Z/+Yeir0seznB7JFnF7ljVBUHHFee8UzhveKeukYFg62anl5PC0rO8MoBf9jhnBmm+Q7aIJ6bDIqXVMfIbhaOZkB7IlY3Sz7FLzPbcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769533324; c=relaxed/simple;
	bh=2SxX/YHolvRWaSZe5JKug5pP4Si7Ci6sF3RvXYP5/k4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aHUfbLVbINmcfqdF4MM1Yfi/zr6yKymaFArm2upjwQx/MmtnKbILRsZsQ3LnN0jq6Jt5U3wN12K9DJ/0JM5D/Aw5YxGAZqnzjn3dW2HCAv8f026N4SJMKkUgXhk6FnHzj7+uM+1V6IF2r4iZQ9YQ/9OJT7i6AY/zknumHUjSaLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6A987227AB3; Tue, 27 Jan 2026 18:01:59 +0100 (CET)
Date: Tue, 27 Jan 2026 18:01:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	dlemoal@kernel.org
Subject: Re: [PATCH] libfrog: adjust header order for BLK_ZONE_COND_ACTIVE
 #ifndef check
Message-ID: <20260127170159.GA10926@lst.de>
References: <20260121064924.GA11068@lst.de> <20260127163934.871422-1-aalbersh@kernel.org> <20260127164309.GB8761@lst.de> <h65l5eiu73bnc5odsswjmay5vyhn4mjvetinpxxtiw4nykvocg@3eiiix3pb66c> <5oruatch45s6qsurqnzaxhn37ycnunmhj5w5fswgohujzd42ve@ls4bk3fadtub>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5oruatch45s6qsurqnzaxhn37ycnunmhj5w5fswgohujzd42ve@ls4bk3fadtub>
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
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30394-lists,linux-xfs=lfdr.de];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 1D927982A8
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 05:59:14PM +0100, Andrey Albershteyn wrote:
> > I will apply it first
> 
> hmm, actually there's no this header to apply fix to, can you resend
> it with this fix applied?

Sure.


