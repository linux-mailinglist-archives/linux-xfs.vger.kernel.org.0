Return-Path: <linux-xfs+bounces-31312-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EE5ZOU/Yn2lAeQQAu9opvQ
	(envelope-from <linux-xfs+bounces-31312-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 26 Feb 2026 06:21:19 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 76F7D1A105F
	for <lists+linux-xfs@lfdr.de>; Thu, 26 Feb 2026 06:21:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CE07430330DE
	for <lists+linux-xfs@lfdr.de>; Thu, 26 Feb 2026 05:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E38028507B;
	Thu, 26 Feb 2026 05:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZcnxAooQ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00791946C8
	for <linux-xfs@vger.kernel.org>; Thu, 26 Feb 2026 05:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772083276; cv=none; b=Krty6JeL0F3K9tLsr1aE0D7ZFIWwkQeRRYk+vjMeMFNVlPLUuYwE5LIBTgBm2XNLCKYWP7Np3uY6yQr7Jg3Hx9zWSUUB3COvEwz+jnMsQzfckBZ/vGLCrNUxgsSiBkNBVSb1iLef8AonO49OkVi6l5jcCAF8L9Mw7A/Iobh0/HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772083276; c=relaxed/simple;
	bh=Z71bM/qwQXIVOG+hKusdTmuk4XaC2SBTguRPDmjDL4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oJadSgvPabGTalOPir3/5/hSUDtGO0dsKKQPfB6be0toSLsjxt1BU9zSZexO8cxdWajupzmtJfvd2+pbEGZ18MfK1BRtvIi+/0cOHumoTsMUSp9Y2p2XG59coS1JRXa/M4zZmji4+b2bTI0iQUqDByjiN+/4ejAdUIfhqr1/o/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZcnxAooQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D606C19422;
	Thu, 26 Feb 2026 05:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772083275;
	bh=Z71bM/qwQXIVOG+hKusdTmuk4XaC2SBTguRPDmjDL4Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZcnxAooQEnXrJj8P9nIUweQhExmrpVgrUKIi8+IBN4+uXWW6PtaqjG1vrr8dMeMPM
	 cbcw0KylqkYO9qPZsPmrGFDW+Eq93+u7wcx2oifSang0luvvn3B7G+riXWngeLQEVZ
	 aq9oopb/8b/CX4inIBO6evpBRH+54HdzXZffFspbV73FDq58udFXmGY6pN009OaNTV
	 z0MS4GX/BScIzcnG7pHsTCUTRC0cMeDtsbxm6Dz9zlDhXEWA6qKJqV3ubzZW4k4unh
	 +DF/mgHSIiwh87pXFcZaKdSYTcnu5CiKMxl0L/6sv3ECauUNlR75DYNASQd9wyBD7N
	 0gibbG9iVD7nw==
Date: Wed, 25 Feb 2026 21:21:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH] xfs: remove scratch field from struct xfs_gc_bio
Message-ID: <20260226052115.GD13853@frogsfrogsfrogs>
References: <20260225224646.2103434-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225224646.2103434-1-dlemoal@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31312-lists,linux-xfs=lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 76F7D1A105F
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 07:46:46AM +0900, Damien Le Moal wrote:
> The scratch field in struct xfs_gc_bio is unused. Remove it.
> 
> Fixes: 102f444b57b3 ("xfs: rework zone GC buffer management")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Looks good to me and assuming the bots don't scream,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_zone_gc.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 48c6cf584447..d78e29cdcc45 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -96,7 +96,6 @@ struct xfs_gc_bio {
>  	 */
>  	xfs_fsblock_t			old_startblock;
>  	xfs_daddr_t			new_daddr;
> -	struct xfs_zone_scratch		*scratch;
>  
>  	/* Are we writing to a sequential write required zone? */
>  	bool				is_seq;
> @@ -779,7 +778,6 @@ xfs_zone_gc_split_write(
>  	ihold(VFS_I(chunk->ip));
>  	split_chunk->ip = chunk->ip;
>  	split_chunk->is_seq = chunk->is_seq;
> -	split_chunk->scratch = chunk->scratch;
>  	split_chunk->offset = chunk->offset;
>  	split_chunk->len = split_len;
>  	split_chunk->old_startblock = chunk->old_startblock;
> -- 
> 2.53.0
> 
> 

