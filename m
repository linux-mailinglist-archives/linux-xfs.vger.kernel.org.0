Return-Path: <linux-xfs+bounces-31185-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oKIlFZKLmGmeJgMAu9opvQ
	(envelope-from <linux-xfs+bounces-31185-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 17:28:02 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A5D75169527
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 17:28:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E54853016B07
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 16:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DDA6331A70;
	Fri, 20 Feb 2026 16:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qqG+0gdy"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9B2330662
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 16:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771604878; cv=none; b=DR7QFOZkikqceGADknx5OTEaXzXqtk/6JAaXutb+kmh8hDm/u3JkJzkyFs5z8jzV+wPcw1Oa8mDpwxt1WFC1r7rUCT2IgFGmGycIqOYI8ZKEUcn0H7nAssFupkmAI45kT5n6czYNrf6EBm5z9v1ZTNsZIK248cP4BZBtgpUPY6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771604878; c=relaxed/simple;
	bh=BnPU8Qcm379EMYhDmHWTMf5bKu5/b9L7u+/ZNXcpcfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rluD6ipcepl5GBg5w/oZN6JNcUd1bVZebodYegR8HBnsCbHnYut8QDeKgSbd9HNsHXhbleUBDVXaQ2E/TQKdMqTY3dvR6jRo9i/2ykMylR6gvGOMlx27Eg3rmX+KQEzeB/nlxsFDQFc46obYRkMr8anE8/OUu2mo8OjYdiKsEGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qqG+0gdy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB57DC116C6;
	Fri, 20 Feb 2026 16:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771604877;
	bh=BnPU8Qcm379EMYhDmHWTMf5bKu5/b9L7u+/ZNXcpcfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qqG+0gdyLluQ+KtzQq47pxg+ItyIwRGSMMMCN/ItauiKN1xgrrgoEa8wgdQQXetH7
	 XKWnGHvGenQfQBdCsVUGouPIHiFRrUXL0Y2pTaHyPrn2DV9VePkY6aqkzD3s4rM6ro
	 4W+Gs15AXU1K59rJU+o9rdz0S5RckSTk0sN+wEcjuS6uECVi+YnyF4WC0RpJrH7IKu
	 fBrPgIpq4o1I64wJcAZm4tYfyc6sLNEnyHa8AaJEDtnY+m0923g5SeCDrMpLwTEXlX
	 +/iolvSw/Ld6Q/d8iEeDG1qX/pJMYu0eqSQrMIt3KRP7dWnUOOyLVo5coTZZSh0Gcy
	 4brz2GAAjbT6A==
Date: Fri, 20 Feb 2026 08:27:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 2/2] xfsprogs: various bug fixes for 6.19
Message-ID: <20260220162755.GX6490@frogsfrogsfrogs>
References: <177154457179.1286306.5487224679893352750.stgit@frogsfrogsfrogs>
 <aZh_Rb7fGsXek6GE@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZh_Rb7fGsXek6GE@infradead.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31185-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A5D75169527
X-Rspamd-Action: no action

On Fri, Feb 20, 2026 at 07:35:33AM -0800, Christoph Hellwig wrote:
> This all (or at least mostly?) seems to be in xfsprogs for-next already.

Oh, I must've missed the announcement.  And then I also missed that
gitweb shifted because that stupid Anubis thing usually won't load due
to its 300K of web artifacts also 503'ing due to excess load.

Will rebase and resend whatever's necessary.  Sorry about the noise.

--D

