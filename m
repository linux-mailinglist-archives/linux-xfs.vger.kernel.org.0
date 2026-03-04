Return-Path: <linux-xfs+bounces-31907-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ALYiGC2NqGmbvgAAu9opvQ
	(envelope-from <linux-xfs+bounces-31907-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 04 Mar 2026 20:51:09 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D4A6920736A
	for <lists+linux-xfs@lfdr.de>; Wed, 04 Mar 2026 20:51:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 87B20303717C
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Mar 2026 19:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17DAE38645C;
	Wed,  4 Mar 2026 19:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uHNJbrCD"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D3D288514
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 19:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772653867; cv=none; b=Na6VbdAkQmEIoS4aU6G2yvo32XUDdb9KNrVrwL3EnSpdCjbrlgSrYWuzw6AIsg1Nn+q6ObPdffCUTPDwfQ6XNglvgJnxNdyNcCPG6RjJYR4GC4uHYeqkISmJxCE2gWYFWojM6z7+NCNtTH3rzxzWEC5EwlO/ZKRwQCRJHVG5Ph0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772653867; c=relaxed/simple;
	bh=6I7OmsNJyWwUG2k6ahUaokDK0fadc0bF45m+a5PMwzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j9KE5P6WcvQ8iJ/7B1ZvPJ3D+otTeMFKIT49CmjlXfmUy21KRslEhwn5zTRpOX5g3l7sH2RapzqObS7JvrJbTprG6kin5P45naDHR3tpklgOc1hdu8jR2vQ/yMMDEdsRLaAzjfdjQc336tLWJvqU7NdUkrKzp7lEQq85u2LCdd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uHNJbrCD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840C5C4CEF7;
	Wed,  4 Mar 2026 19:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772653866;
	bh=6I7OmsNJyWwUG2k6ahUaokDK0fadc0bF45m+a5PMwzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uHNJbrCDgFb+t6DvsU7ul3ChPHmwMW9CnCcmd8h31IBJI1dpQB4qjlpedF2AI/J+U
	 pCpfAa7AepQXwhHsdM1BjYymjZdNFj68z80ghtl7V9ZLvuFMQpul52NPIQG8P/OeKr
	 Akg5LavPc/xzUijaU0bFtM0VC4OvpMIlBIaRQIkNAexLSZPgtDR59ZmpQb/FUaeG15
	 kt3sQaQA/HuPm2NYLxRMhx019GpJU7mdDwYRh+ZaXueBF2G+3ZByC+YXVVxVhe3jZh
	 5wbeVXLy9ehEsku+JRbmZDKzifIGd9TaHE2liS4O9NusIrpOvDBnW4iCSszPWFTtHb
	 9MXKmYfXbV0Rw==
Date: Wed, 4 Mar 2026 11:51:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix returned valued from xfs_defer_can_append
Message-ID: <20260304195105.GZ57948@frogsfrogsfrogs>
References: <20260304185441.449664-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304185441.449664-1-cem@kernel.org>
X-Rspamd-Queue-Id: D4A6920736A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31907-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026 at 07:54:27PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> xfs_defer_can_append returns a bool, it shouldn't be returning
> a NULL.
> 
> Found by code inspection.
> 
> Fixes: 4dffb2cbb483 ("xfs: allow pausing of pending deferred work items")
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Signed-off-by: Carlos Maiolino <cem@kernel.org>

Yep, that's a bug.  Fortunately a benign one.

Cc: <stable@vger.kernel.org> # v6.8
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_defer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 472c261163ed..c6909716b041 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -809,7 +809,7 @@ xfs_defer_can_append(
>  
>  	/* Paused items cannot absorb more work */
>  	if (dfp->dfp_flags & XFS_DEFER_PAUSED)
> -		return NULL;
> +		return false;
>  
>  	/* Already full? */
>  	if (ops->max_items && dfp->dfp_count >= ops->max_items)
> -- 
> 2.53.0
> 
> 

