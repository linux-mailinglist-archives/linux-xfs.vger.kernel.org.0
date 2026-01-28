Return-Path: <linux-xfs+bounces-30436-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SKozKrHseWkF1AEAu9opvQ
	(envelope-from <linux-xfs+bounces-30436-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 12:02:09 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 059CA9FE11
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 12:02:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F2A84300CFC2
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 11:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE3E8270552;
	Wed, 28 Jan 2026 11:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bDeyaUU3"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDBD21FF2E
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 11:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769598126; cv=none; b=OjKnYhIveOe5P61vc1lhSu2Y5u5zUpweR3Pfp6lnvYTfiTog3hrNJ4+dCdyOHfaF+13XkPh+irFrqR1KYWiPNX9BUwmI1xAFVEAqJqVjFTv7Hx1uFv/Eosd5mdir8zn+KYGlZEpJIx1l4dhS0BYQIDMFiR6iWDuU3LnDNzkcxak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769598126; c=relaxed/simple;
	bh=yTyRdtlM1EK4xj8CQzw8OfBuIfhII8J2LKfw8Y5dHF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MZUz+qEnbvsG7NWYNu97ZbhG66lHtlL05ECfpzPHpuiDOSt8FWtMQrzoDhBbY9AkCbA3IxZDOjpOsQv5sKW3bIBXakcZ5JK4yetlyJv+LD0KA9kLkmpS58CquNYtRWUxC0j3yHnnXy3DpvgJdc7gfSVYlxEZIYVm0aex3QHGFK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bDeyaUU3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B578C4CEF1;
	Wed, 28 Jan 2026 11:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769598126;
	bh=yTyRdtlM1EK4xj8CQzw8OfBuIfhII8J2LKfw8Y5dHF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bDeyaUU3O6FdeK8Uw7TgVbf9iWSMJ+KRrPsDQm4M24XP9LEwpuA/6llscnW4Jc3Qb
	 qYV114iXxYkXQTDWGSnXSRZmS7/Ao1zAklpSO8zKEr1DfRB6urORX86XLCoDXL3j15
	 Dwuo8hmJ7MFa+ICLfF1vTfUUcfYZXLXRNG3vMuUygiHzRsjL9/VW+WW1VwlNsmnBE7
	 jZcbsES/SkXdEog+iTZVccHST4zG8Olp5U6CcpwdU4BCdadIXe/obDfC3IRZH0083M
	 APsJGiSvJljEhusBQh2QuH/pbbfVBJYhiIY+yE6wCihyM0xBG8khqJSIwbHnc+gvWv
	 CZ3vkEJoa+NtA==
Date: Wed, 28 Jan 2026 12:02:02 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: allocate m_errortag early
Message-ID: <aXnsOAzrclE6zW8X@nidhogg.toxiclabs.cc>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127160619.330250-3-hch@lst.de>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-30436-lists,linux-xfs=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 059CA9FE11
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 05:05:42PM +0100, Christoph Hellwig wrote:
> Ensure the mount structure always has a valid m_errortag for debug
> builds.  This removes the NULL checking from the runtime code, and
> prepares for allowing to set errortags from mount.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_error.c | 26 +-------------------------
>  fs/xfs/xfs_super.c | 12 ++++++++++++
>  2 files changed, 13 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 873f2d1a134c..dfa4abf9fd1a 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -114,18 +114,8 @@ int
>  xfs_errortag_init(
>  	struct xfs_mount	*mp)
>  {
> -	int ret;
> -
> -	mp->m_errortag = kzalloc(sizeof(unsigned int) * XFS_ERRTAG_MAX,
> -				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> -	if (!mp->m_errortag)
> -		return -ENOMEM;
> -
> -	ret = xfs_sysfs_init(&mp->m_errortag_kobj, &xfs_errortag_ktype,
> +	return xfs_sysfs_init(&mp->m_errortag_kobj, &xfs_errortag_ktype,
>  				&mp->m_kobj, "errortag");
> -	if (ret)
> -		kfree(mp->m_errortag);
> -	return ret;
>  }
>  
>  void
> @@ -133,7 +123,6 @@ xfs_errortag_del(
>  	struct xfs_mount	*mp)
>  {
>  	xfs_sysfs_del(&mp->m_errortag_kobj);
> -	kfree(mp->m_errortag);
>  }
>  
>  static bool
> @@ -154,8 +143,6 @@ xfs_errortag_enabled(
>  	struct xfs_mount	*mp,
>  	unsigned int		tag)
>  {
> -	if (!mp->m_errortag)
> -		return false;
>  	if (!xfs_errortag_valid(tag))
>  		return false;
>  
> @@ -171,17 +158,6 @@ xfs_errortag_test(
>  {
>  	unsigned int		randfactor;
>  
> -	/*
> -	 * To be able to use error injection anywhere, we need to ensure error
> -	 * injection mechanism is already initialized.
> -	 *
> -	 * Code paths like I/O completion can be called before the
> -	 * initialization is complete, but be able to inject errors in such
> -	 * places is still useful.
> -	 */
> -	if (!mp->m_errortag)
> -		return false;
> -
>  	if (!xfs_errortag_valid(error_tag))
>  		return false;
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e05bf62a5413..ee335dbe5811 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -40,6 +40,7 @@
>  #include "xfs_defer.h"
>  #include "xfs_attr_item.h"
>  #include "xfs_xattr.h"
> +#include "xfs_errortag.h"
>  #include "xfs_iunlink_item.h"
>  #include "xfs_dahash_test.h"
>  #include "xfs_rtbitmap.h"
> @@ -822,6 +823,9 @@ xfs_mount_free(
>  	debugfs_remove(mp->m_debugfs);
>  	kfree(mp->m_rtname);
>  	kfree(mp->m_logname);
> +#ifdef DEBUG
> +	kfree(mp->m_errortag);
> +#endif
>  	kfree(mp);
>  }
>  
> @@ -2254,6 +2258,14 @@ xfs_init_fs_context(
>  	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
>  	if (!mp)
>  		return -ENOMEM;
> +#ifdef DEBUG
> +	mp->m_errortag = kcalloc(XFS_ERRTAG_MAX, sizeof(*mp->m_errortag),
> +			GFP_KERNEL);
> +	if (!mp->m_errortag) {
> +		kfree(mp);
> +		return -ENOMEM;
> +	}
> +#endif

Looks fine to me

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  
>  	spin_lock_init(&mp->m_sb_lock);
>  	for (i = 0; i < XG_TYPE_MAX; i++)
> -- 
> 2.47.3
> 
> 

