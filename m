Return-Path: <linux-xfs+bounces-30644-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kE/TFfbDhGk45QMAu9opvQ
	(envelope-from <linux-xfs+bounces-30644-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 05 Feb 2026 17:23:18 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A5152F52A3
	for <lists+linux-xfs@lfdr.de>; Thu, 05 Feb 2026 17:23:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D20E6301C15A
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Feb 2026 16:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CFCA436358;
	Thu,  5 Feb 2026 16:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fLQfJpUs"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF164421A13
	for <linux-xfs@vger.kernel.org>; Thu,  5 Feb 2026 16:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770308462; cv=none; b=tS2HvZBddDzK+3ahQ+IRtDC4wFq9iUvhiWRklPjyflMGwFy2vZMJfsJCVUjyA5fPiZ3KD8tvLjCgWYIttc03dgrhOjSMxxrKzpR1pbZtD75HVFhsgvwDbv7zTFQL/2ur062bnIE15+9USBUgnZ0lKVm1Ilfdl7FcsxO4J+JMFwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770308462; c=relaxed/simple;
	bh=AjbghU0ubQTE8ZKu159bRGTYqFMJ68YDBAuyP0l6SME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fQx9LQXDqIqlwgT9ABpY+02vFkrzXRPDgnNCi+DQF2PHoaWISfPsixXUYv6ubgdfVwFVL4sPnrrt2KN/eliYHPsSp1n8yvFWexOdzStIEFspGM4dkviQbUkSf6AFDSJPj4Ppf5SZuFdcOiJTgWdadcCqG+SAFm5T/Igt5MEwVr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fLQfJpUs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8E6C4CEF7;
	Thu,  5 Feb 2026 16:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770308461;
	bh=AjbghU0ubQTE8ZKu159bRGTYqFMJ68YDBAuyP0l6SME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fLQfJpUs5++oi5GTL4BooETPTeVoQhpQueHgXYezumUkk0pZ0nBEqO6YRJlKYZkgT
	 eVgNhc2SZqEOa20pYoLCUycxRqV8rgUaRZepYq8SFuZLJBhFQEhzOWiYbnxmKxcueW
	 dhZzvM37dCz3/Ifa3dHr0VAPt1NUJsYx0183OLoyQ2ahJwI3NVEpxx9FEyGZThwWeY
	 bhI8H1vsqoGzqGJRTZC/Z/Tn7qcwyV7BEXvO/hMqNdgAw00L/khrMLEt72JupNP0kS
	 PFHskkYFshBxQSjFN3If1zW+aXMGEwrRn82MUSz8lq8tSLZMSB1+ti2h9bN9x7uXA/
	 9JI84MdX9KOYA==
Date: Thu, 5 Feb 2026 08:21:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: hch@infradead.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com, ojaswin@linux.ibm.com
Subject: Re: [patch v4 1/2] xfs: Replace ASSERT with XFS_IS_CORRUPT in
 xfs_rtcopy_summary()
Message-ID: <20260205162100.GO7712@frogsfrogsfrogs>
References: <cover.1770133949.git.nirjhar.roy.lists@gmail.com>
 <4b37c139595fdb9af280496f599f6bb43ae5a9b3.1770133949.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b37c139595fdb9af280496f599f6bb43ae5a9b3.1770133949.git.nirjhar.roy.lists@gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30644-lists,linux-xfs=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	FREEMAIL_CC(0.00)[infradead.org,kernel.org,vger.kernel.org,gmail.com,linux.ibm.com];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A5152F52A3
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 08:36:26PM +0530, Nirjhar Roy (IBM) wrote:
> Replace ASSERT(sum > 0) with an XFS_IS_CORRUPT() and place it just
> after the call to xfs_rtget_summary() so that we don't end up using
> an illegal value of sum.
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>

Looks good to me now, thanks for your persistence!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index a12ffed12391..3035e4a7e817 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -112,6 +112,10 @@ xfs_rtcopy_summary(
>  			error = xfs_rtget_summary(oargs, log, bbno, &sum);
>  			if (error)
>  				goto out;
> +			if (XFS_IS_CORRUPT(oargs->mp, sum < 0)) {
> +				error = -EFSCORRUPTED;
> +				goto out;
> +			}
>  			if (sum == 0)
>  				continue;
>  			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
> @@ -120,7 +124,6 @@ xfs_rtcopy_summary(
>  			error = xfs_rtmodify_summary(nargs, log, bbno, sum);
>  			if (error)
>  				goto out;
> -			ASSERT(sum > 0);
>  		}
>  	}
>  	error = 0;
> -- 
> 2.43.5
> 
> 

