Return-Path: <linux-xfs+bounces-31953-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6AHhIMqtqWn+CAEAu9opvQ
	(envelope-from <linux-xfs+bounces-31953-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 05 Mar 2026 17:22:34 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 16BA921560B
	for <lists+linux-xfs@lfdr.de>; Thu, 05 Mar 2026 17:22:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E5D47304806D
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Mar 2026 16:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 371A63CF681;
	Thu,  5 Mar 2026 16:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bskykuSK"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57A63BED5E;
	Thu,  5 Mar 2026 16:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772727664; cv=none; b=C0P/3J53U8EXnbxiIeCxLsnRozPugLq/02xoZcNm3tvYIud1FLQLMx9OViZHc7CHRvhp4Hd3O3zj1r4J/bHvdm611UkCjbf1QxEbz1bRyg2LZlme5Q9pyuFDwmT/vPQcJ60bY1xCz14hLNc0u+YbYxaT8hUD0Ih10dAxupB3Y0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772727664; c=relaxed/simple;
	bh=mczRhjYMeXSlgmFunKwEInL6PHag54s74KFFOb95N5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ojTiAae5VvhiWXw/i5TZlxP+eHgNIkj9HO+7SwFp8fu3AyJ0gccJzCPPcP7RyoK9HWhvssNmIE1LAVCXW01Goaa9pKQ9gP8KMhbeBji34HfU8nEJ/JbUVOePzdDftkWp10dNsm6hdOofzyV/+qPwRcaoMfK833S+GOwIiIj6oSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bskykuSK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED77C116C6;
	Thu,  5 Mar 2026 16:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772727663;
	bh=mczRhjYMeXSlgmFunKwEInL6PHag54s74KFFOb95N5M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bskykuSKMANUt16C8ePZBBl5YQPSeAEnVggLCK49Sov3oJhNf6UzS+tt9m/Ynvp9b
	 lQ53QlFaW7J456jcCOgjoIajDGTdGaW7Fl8SfrwWYQX3vkRpeWDAcQTMuNyaCNhJhN
	 fKJNawwi8EwQXWLrQeIhoZgkNnj0ZeSCbpBxMJy/JfnC7IkokbVcDKFaN9bI/kxLdC
	 yE1AHWA7SeU9pwyYUD7z9+wtsYQoiaxUyLq73tMAhdHvJE9sBzrfJyPGaA/CUJH067
	 FU3MKusRPklbZTjUBCQX5trgfMjobRCt1PqVRLgwn/aUAPpRqZ1g3OyWH744XjauLn
	 yryWgSuYGt32g==
Date: Thu, 5 Mar 2026 17:20:58 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: don't clobber bi_status in xfs_zone_alloc_and_submit
Message-ID: <aamtVVapQpISrQHV@nidhogg.toxiclabs.cc>
References: <20260304185923.291592-1-agruenba@redhat.com>
 <aamNC9JwxBNBBTmW@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aamNC9JwxBNBBTmW@infradead.org>
X-Rspamd-Queue-Id: 16BA921560B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31953-lists,linux-xfs=lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Mar 05, 2026 at 06:02:51AM -0800, Christoph Hellwig wrote:
> On Wed, Mar 04, 2026 at 07:59:20PM +0100, Andreas Gruenbacher wrote:
> > Function xfs_zone_alloc_and_submit() sets bio->bi_status and then it
> > calls bio_io_error() which overwrites that value again.  Fix that by
> > completing the bio separately after setting bio->bi_status.
> 
> Looks good, but can you drop the pointless goto label renaming?
> I'd also be tempted to just open code the split error case instead
> of adding a label for it.
> 

/me goes pull it off the next pull-request

