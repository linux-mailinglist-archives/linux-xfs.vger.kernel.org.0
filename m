Return-Path: <linux-xfs+bounces-30677-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mHTiMxTjhWk9HwQAu9opvQ
	(envelope-from <linux-xfs+bounces-30677-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 06 Feb 2026 13:48:20 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 58BA9FDB3D
	for <lists+linux-xfs@lfdr.de>; Fri, 06 Feb 2026 13:48:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 434773014C46
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Feb 2026 12:48:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 106493A1A36;
	Fri,  6 Feb 2026 12:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RVF66YgV"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F22125A0
	for <linux-xfs@vger.kernel.org>; Fri,  6 Feb 2026 12:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770382097; cv=none; b=X0E4eAzWo1ZXoE7c4fSTEgLxayZco4DlyetNiEJ2Y8K/PY3Hg2G3qGByfCLOEuFJE97lujw28rBUUYOqOxBescsKwDdZWQg8nchuaEYql9Ka75RLQ1Ocx+X8CoWft24KSbHO84RIzO+dAH8z5nl1QgF5B4U3cSJ3oRwRk3xmlm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770382097; c=relaxed/simple;
	bh=KeJnk+asvojqx2R5E/YLgT74gFPUvi3EFims2yuEypk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JN4FjrihQKm97hxYXl7TVLxI5P915g4KZ3UgZiMAaoXRuZKPAvT7T66bdUSzwYyfXk2j4tJ6Dz/lL+ZPLFuYLr/w9whHsxewAK9XUxWNPri+Yax0VMRiqNNmXz6MZTyUgOwhZZDj2H2w3t31u5CeK4Jf04mBglW0gNv6sNjuS1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RVF66YgV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FFDC116C6;
	Fri,  6 Feb 2026 12:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770382096;
	bh=KeJnk+asvojqx2R5E/YLgT74gFPUvi3EFims2yuEypk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RVF66YgVDDIEl1Vn/v4OYBV9go/NEGRmJvH8DpATH99rupQRHnV6sJ0WAXavi0+ie
	 sfFLwTGsGC1AZfHxkhgJZf3v9k8rtBKsvymDdFjT7PNviy9pHvNmA6+6PkhmoVO2Qv
	 UYsWdEoeVtBtgvHh8iILagCYglF2jtQYQTErU9LK5TECEmd7o50+UTdESZy94/HK6d
	 ga6WqwCqdqepXSY4n0uxd9Qz6xLNAt8aJrX0EVpaxZJK6GSJKUHl8KC58TZw70pRrm
	 4fQYKs27FpWd34yoP9jwli9SNBpps4bgzJZVP7W6qgJ5zu9UUQYGFVSr1CregeZaha
	 HZNanuk7X5UgA==
Date: Fri, 6 Feb 2026 13:48:11 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: djwong@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org, 
	ritesh.list@gmail.com, ojaswin@linux.ibm.com
Subject: Re: [patch v4 1/2] xfs: Replace ASSERT with XFS_IS_CORRUPT in
 xfs_rtcopy_summary()
Message-ID: <aYXi9okzfGzkYK_m@nidhogg.toxiclabs.cc>
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
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30677-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,infradead.org,vger.kernel.org,gmail.com,linux.ibm.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-0.997];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 58BA9FDB3D
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 08:36:26PM +0530, Nirjhar Roy (IBM) wrote:
> Replace ASSERT(sum > 0) with an XFS_IS_CORRUPT() and place it just
> after the call to xfs_rtget_summary() so that we don't end up using
> an illegal value of sum.
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>

Looks good to me know. Thanks for addressing the ugly ASSERT :)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

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

