Return-Path: <linux-xfs+bounces-31827-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qK3gHnITp2mfdQAAu9opvQ
	(envelope-from <linux-xfs+bounces-31827-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 17:59:30 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BDB31F43F6
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 17:59:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7B37A300B750
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 16:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C2883E5574;
	Tue,  3 Mar 2026 16:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NjmKS08a"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F133947B2
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 16:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772557147; cv=none; b=m23ugy+xRmaPMIZnp5Veozs/l3V5nvM92WfOPSoCpH1S1i6TazYRDZao7ESCuxHtxn9QZovULiNtuP7OYIOj6eZZ061TSApweOMSxgXTOu+eIF3FMncD9j+JMFqiNSNvyjb4X/gWwsk+dbdxS/Ml4u/WZkvKsVGVoSGx8blMzBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772557147; c=relaxed/simple;
	bh=oFoCyFZ5ehkB1O4taA8hF422In9WAP4AGMBoiIHMjhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uQaoHeZpqD5Z6fIm2zptoyA4lK4rivd9h8P0JkX0Ep+leU/s469FOgyjbscIzVezWQ17C8J8ATR1G6UlGa3wOZCLHBwoZM37Zjw8YoS03sLG7YW28J4JldHSfEYWF8NBYj/UPv36ZWMYDKB3RgsCHiUNLLfTuuBX/gPQbOXLlcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NjmKS08a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A26C116C6;
	Tue,  3 Mar 2026 16:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772557147;
	bh=oFoCyFZ5ehkB1O4taA8hF422In9WAP4AGMBoiIHMjhw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NjmKS08aE1vA2/HIZJAfdf4n3eoLkgB4qC2q8osghWQ2DctZDYVBNL5rhkr8ujXzw
	 MDsISX6s7T8+kKFRrFNhgnKpiXUawlJ9LI6ueqC4X1ED+S0Ec5ZvTWG+sJIkfQiUTW
	 oWOVz8RNxYBItVJJqC/ApRTwpdw3ngX2YmsCWLZU0opoupcl4xsLv8jypgvVTt57Ow
	 PkyYprLWU2Hsm+HJGZGLUx98Hc1X0/FKztYbCs1MKWzkzCuajE78NCq+G99l9x0cYs
	 kvb/xbPWx2nHzLgEk7IT3L3PfuVXNlZvIJ0qldZmR0fohpMXoXu5xlHOAENhKeFNh+
	 UG7vImUw1Wj0A==
Date: Tue, 3 Mar 2026 08:59:06 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/26] xfs_scrub: use the verify media ioctl during phase
 6 if possible
Message-ID: <20260303165906.GL57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783656.482027.946865669068210433.stgit@frogsfrogsfrogs>
 <aacECdb8HaCNYb4N@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aacECdb8HaCNYb4N@infradead.org>
X-Rspamd-Queue-Id: 1BDB31F43F6
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31827-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 07:53:45AM -0800, Christoph Hellwig wrote:
> >  	if (disk->d_fd < 0)
> > @@ -266,6 +267,18 @@ disk_close(
> >  #define LBASIZE(d)		(1ULL << (d)->d_lbalog)
> >  #define BTOLBA(d, bytes)	(((uint64_t)(bytes) + LBASIZE(d) - 1) >> (d)->d_lbalog)
> >  
> > +#ifndef BTOBB
> > +# define BTOBB(bytes)		((uint64_t)((bytes) + 511) >> 9)
> > +#endif
> > +
> > +#ifndef BTOBBT
> > +# define BTOBBT(bytes)		((uint64_t)(bytes) >> 9)
> > +#endif
> > +
> > +#ifndef BBTOB
> > +# define BBTOB(bytes)		((uint64_t)(bytes) << 9)
> > +#endif
> 
> Is this really something that should be in scrub and not in
> common code?  And why the ifndef?  the 9 and the derived from that
> 511 would also really benefit from symbolic names.

Hrmm, that's a good question, why /did/ I duplicate that from xfs_fs.h?
I have no idea why and it builds fine without it so I'll drop it.

> > +	if (disk->d_verify_fd >= 0) {
> > +		const uint64_t	orig_start_daddr = BTOBBT(start);
> > +		struct xfs_verify_media me = {
> > +			.me_start_daddr	= orig_start_daddr,
> > +			.me_end_daddr	= BTOBB(start + length),
> > +			.me_dev		= disk->d_verify_disk,
> > +			.me_rest_us	= bg_mode > 2 ? bg_mode - 1 : 0,
> > +		};
> > +		int		ret;
> > +
> > +		if (single_step)
> > +			me.me_flags |= XFS_VERIFY_MEDIA_REPORT;
> > +
> > +		ret = ioctl(disk->d_verify_fd, XFS_IOC_VERIFY_MEDIA, &me);
> > +		if (ret < 0)
> > +			return ret;
> > +		if (me.me_ioerror) {
> > +			errno = me.me_ioerror;
> > +			return -1;
> > +		}
> > +
> > +		return BBTOB(me.me_start_daddr - orig_start_daddr);
> > +	}
> 
> split this whole block into a helper for readabiltity?

Will do.

--D

