Return-Path: <linux-xfs+bounces-31820-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CCihEIULp2kDcgAAu9opvQ
	(envelope-from <linux-xfs+bounces-31820-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 17:25:41 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E66661F3BE8
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 17:25:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 626E030DD579
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 16:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3592C4D990D;
	Tue,  3 Mar 2026 16:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DVssZSUB"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B831C4D90C8
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 16:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772554921; cv=none; b=IXKxIfZkqCYVh8SH7APlyJSLnXuCrA2rfAcq2dnO4KlbfWuNbBOCFbYJaTw0XIRp5ai85+iMmviZ3qdP/MXuk7fJ6ZX9oTzwk0ywKSCY8zBrfE7paUY5C/biEFmDOERLVMePc8F4gf24zNJ5rIh/+5fGihdGZCO0yZO4u68TWNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772554921; c=relaxed/simple;
	bh=4NpWeJdxaxwsQzi57cjKH3xS5+3V9BUI9hV7QRskhoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TkmwjZzRProHjRyhgS1y5/ca6ad21YGzVE/PPj8yBmFRGXxH92Tkgy9IZiZNGf/lgTnaC2yoM8STnTUTXoHCi0bvWzFGWMxq5qBrKiDdvLXkqQ9+m1hodb7DD8SnD5sEGNsID48Ut5zmlf/95XIniXjcOhOxUX2IqM/ctASPqm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DVssZSUB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAAAC19422;
	Tue,  3 Mar 2026 16:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772554921;
	bh=4NpWeJdxaxwsQzi57cjKH3xS5+3V9BUI9hV7QRskhoo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DVssZSUBgAxKIbF3cH77FxEbkD4UXk3Xj7qeNK8UfgV9T73g4a7mISWQoRBLTIpbE
	 5FHhEn7Zd9FC31McgwZNZaT0xLPUzr/pLV6ZiLvS44us3gHHpdtUV2WT+Ixrh00Kyd
	 Tsnk2ZzMdAhetJP4uDia0+81lo32inZmTs+zQHeF92Dzf4iTBk+6TbZTJTUB1aNopy
	 TsF2FdF/LUgwZGBfySUbCEAZNwx8un9NUP5awkmXBvjnWZz+xtnhNkifGCGukXBP0t
	 m1Jl9m8RK2XCRD+r+/qUhoMH8/bBkY8gfkGc/Njo+V89HJATSBB/YFjp9e983dXecn
	 eKS7Vf0emipKw==
Date: Tue, 3 Mar 2026 08:22:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, kees@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/36] treewide: Replace kmalloc with kmalloc_obj for
 non-scalar types
Message-ID: <20260303162200.GF57948@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
 <177249638311.457970.11002432782642333341.stgit@frogsfrogsfrogs>
 <aab0Y5ZMfuvylSD3@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aab0Y5ZMfuvylSD3@infradead.org>
X-Rspamd-Queue-Id: E66661F3BE8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31820-lists,linux-xfs=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 06:46:59AM -0800, Christoph Hellwig wrote:
> Again, splitting out adding new helpers is probably a good idea.
> 
> And boy do I hate this new API that was just sneaked in without
> any review :(

FWIW I find this new helper rather pointless churn, especially since the
argument can be either a type or a pointer to a type.  Great, we now no
longer have to type 'sizeof()', which is a boon because I now rent DRAM
by the byte.

--D

