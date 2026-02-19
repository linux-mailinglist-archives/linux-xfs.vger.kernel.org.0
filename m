Return-Path: <linux-xfs+bounces-31082-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yNY4AIoIl2lmtwIAu9opvQ
	(envelope-from <linux-xfs+bounces-31082-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 13:56:42 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EB4615EC7F
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 13:56:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 20B883002F51
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 12:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B27133AD99;
	Thu, 19 Feb 2026 12:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FSncIbG3"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC95B33AD87
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 12:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771505794; cv=none; b=kgV6U6le8dd9qXE7UPd7QQCdqnS5JfkHKwTBpAqN1QQZSuZ9Re1r83FQYkHd4Z9ON1JlJzy21tvK9iz+2z/p9O0wFOrXQeAlfMqxpdcTFDmogA7ZysKtYPUaPrjYrA4yjcsDFxCNTa1qdVt02Zu60xooQFknryOIowrAevitg4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771505794; c=relaxed/simple;
	bh=8W142O3iont+Uyjdf+38hN63EBzWqKjDgGPU+BZer9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pnZu7I4G2IaAEyyDx3wzcZqTG8ibDuQyF/qdJsiAtCFbAQVrv2n48/W3TI2Hc4v9+8xrUH9RXBLT1+z7/+YJxeMNchygbKUCCfqkY29n+ohSboYBGOIt+Bw50/bLB1vh6RI9M6Y4A6OczNC/X7KE2DhS5g/xu+44WDzjghlbaFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FSncIbG3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781CAC4CEF7;
	Thu, 19 Feb 2026 12:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771505794;
	bh=8W142O3iont+Uyjdf+38hN63EBzWqKjDgGPU+BZer9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FSncIbG3qNlm9izz11Z4k02ZlMvjuQu0NA+022NY4JKcrLHGFn/Kdo2TX/O2zb5cT
	 rnhGRwQPP38oBwMXBcctyA4F5xMH22IHdB2KE7v7nainvG91WdVy4vdspdfKQLeRzW
	 7jtu7CfkE2ltdbYtqi2KGaPc4BbD8rGX53iYc2z8R+h75tqzHLUghuoPGQh1s8YnzQ
	 42RKdnhNfWImR81UTQW0tiVNj4hgg8pXl21Br7qQG/hfpvBLwILbuyzI44kVLZwRU5
	 Pl3o8B56GNtIe7/MHz4kT0XrpGuhpaSMmMlqcBvxfb5DvouRnPJaIvJaMHCvmO1whF
	 2EjLAjC0zfuuw==
Date: Thu, 19 Feb 2026 13:56:30 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: clm@meta.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: fix copy-paste error in previous fix
Message-ID: <aZcIdz13QAxxxSnm@nidhogg.toxiclabs.cc>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
 <177145925431.401799.6241225612324128085.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177145925431.401799.6241225612324128085.stgit@frogsfrogsfrogs>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31082-lists,linux-xfs=lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[3];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,nidhogg.toxiclabs.cc:mid,meta.com:email]
X-Rspamd-Queue-Id: 0EB4615EC7F
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 10:00:58PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Chris Mason noticed that there is a copy-paste error in a recent change
> to xrep_dir_teardown that nulls out pointers after freeing the
> resources.
> 
> Fixes: ba408d299a3bb3c ("xfs: only call xf{array,blob}_destroy if we have a valid pointer")
> Link: https://lore.kernel.org/linux-xfs/20260205194211.2307232-1-clm@meta.com/
> Reported-by: Chris Mason <clm@meta.com>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/scrub/dir_repair.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
> index f105e49f654bd1..6166d9dee90f13 100644
> --- a/fs/xfs/scrub/dir_repair.c
> +++ b/fs/xfs/scrub/dir_repair.c
> @@ -177,7 +177,7 @@ xrep_dir_teardown(
>  	rd->dir_names = NULL;
>  	if (rd->dir_entries)
>  		xfarray_destroy(rd->dir_entries);
> -	rd->dir_names = NULL;
> +	rd->dir_entries = NULL;
>  }
>  
>  /* Set up for a directory repair. */
> 

