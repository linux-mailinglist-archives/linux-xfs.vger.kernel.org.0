Return-Path: <linux-xfs+bounces-31968-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qPkaL5STqml0TQEAu9opvQ
	(envelope-from <linux-xfs+bounces-31968-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 06 Mar 2026 09:43:00 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 17F4C21D39E
	for <lists+linux-xfs@lfdr.de>; Fri, 06 Mar 2026 09:42:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C4A943007F57
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Mar 2026 08:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 216183793B1;
	Fri,  6 Mar 2026 08:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QrOw1CJv"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27C4219FC;
	Fri,  6 Mar 2026 08:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772786515; cv=none; b=oVg5WPE47vKL04bd4rHr5pTmSQmmOj6t8n6hZDbhcquomTEgSE3+pd6bRSM85ciJ83/kBy/3miCzCZFsIuBTCEgatfkCqE7RVKT75VcWAxeCDvBiVFqdIywgJZkA4bwfC9TeYo/u8qI/8/IlThLDV4LlARrFO5BsDLL7aHRH8N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772786515; c=relaxed/simple;
	bh=6ZySdEZurQ6O7lw/Y1dz1KwNVaclfRbd65mo+puA7jU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+CCP+VLAb7Y8kj5yV46T0nx7B7OnvZ3Rvavich2YYmc07Os1cZASlnDSJDiPyGz+kew48fW+T4FZfuFr5nqSi7v+oDBJQXYe+cpESCuwxSiEc8i0vwofrLh10KN3jRT/QvI0bUQgvhUQERXTlN1Huujl1E8RtVC+E2zVodavqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QrOw1CJv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5E7C4CEF7;
	Fri,  6 Mar 2026 08:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772786514;
	bh=6ZySdEZurQ6O7lw/Y1dz1KwNVaclfRbd65mo+puA7jU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QrOw1CJveG2+1OVTPhS9qQdz4rUzO1WRUZb9NMgoPSEFyQjXMxw3XO2im1CClsgQd
	 Rzlgt3+pfLk4u7QMgOHgfXdrGdMkFkMJNDovKulkbILgH588EblubkL22ChvuFyEmo
	 q6zXzxEid1qftRbRNlWjLdSepoOhSCXw1d/LywRrRp7tpXvcbavA0h3nPLZ5G5bRGS
	 iQlUkkjbeoihX4slyQHg3pBX/tLZYF/Wl6FRPSJFTt6bJvzNoGtqbch3FjlD+poxby
	 nZl/IcvLcQE1JTJ0j/K+1rYzr/bIg7uCYguztHdCmYnUQcGDjhefVl76Q+MeBh122E
	 SSPPriqHotmFA==
Date: Fri, 6 Mar 2026 09:41:50 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Chen Ni <nichen@iscas.ac.cn>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Convert comma to semicolon
Message-ID: <aaqTLgr3tueoQUGI@nidhogg.toxiclabs.cc>
References: <20260306014800.1257769-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306014800.1257769-1-nichen@iscas.ac.cn>
X-Rspamd-Queue-Id: 17F4C21D39E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31968-lists,linux-xfs=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,iscas.ac.cn:email,nidhogg.toxiclabs.cc:mid]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026 at 09:48:00AM +0800, Chen Ni wrote:
> Using a ',' in place of a ';' can have unintended side effects.
> Although that is not the case here, it seems best to use ';'
> unless ',' is intended.
> 
> Found by inspection.
> No functional change intended.
> Compile tested only.
> 
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> ---
>  fs/xfs/xfs_aops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index f279055fcea0..79ec98c8f299 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -792,7 +792,7 @@ xfs_vm_readahead(
>  {
>  	struct iomap_read_folio_ctx	ctx = { .rac = rac };
>  
> -	ctx.ops = xfs_get_iomap_read_ops(rac->mapping),
> +	ctx.ops = xfs_get_iomap_read_ops(rac->mapping);
>  	iomap_readahead(&xfs_read_iomap_ops, &ctx, NULL);
>  }

Yup, looks good.
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  
> -- 
> 2.25.1
> 
> 

