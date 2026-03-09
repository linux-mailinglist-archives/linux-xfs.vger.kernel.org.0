Return-Path: <linux-xfs+bounces-32018-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KLyiAML5rmnZKgIAu9opvQ
	(envelope-from <linux-xfs+bounces-32018-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Mon, 09 Mar 2026 17:48:02 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A174023D04F
	for <lists+linux-xfs@lfdr.de>; Mon, 09 Mar 2026 17:47:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9F062305430E
	for <lists+linux-xfs@lfdr.de>; Mon,  9 Mar 2026 16:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A6683B8948;
	Mon,  9 Mar 2026 16:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sPpJryvt"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BAB3ACEFB
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 16:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773074379; cv=none; b=DP6GEVdrC3tAB1jybbomaWQ+xlh/sl1bj6HhzxPd4wt2IuihR04NxWmIAblaathvDwPQ3cL/RCZdtD7J/J+13edr3m9S2/MoxV7en1TqOm78v4Jk3SLJwQ2wpPlDjQSf9HlZKs20v3pYy099XhqsBdsModZpb+EyWRrLbzLp12Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773074379; c=relaxed/simple;
	bh=QXz2LujhdGiDwRCj1UYxrAbl3GGx0C0Ns0yIhDaviAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YMGFlxORAbp+JTL7QLgJqVUaTTgRcQB0JXuhChi1hxVNucEEIis55phTUerhigKLeJyCjncKSgDMzbBJSG9BsK7InFaBfcoIHfOVLZlEYn2o0ePzpBJ4iQzy86dKiYCRfDQCWFBRjyDrj/Z7qeIGRDoqr7PX+RtPkeaF8vaqhRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sPpJryvt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC996C2BC9E;
	Mon,  9 Mar 2026 16:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773074378;
	bh=QXz2LujhdGiDwRCj1UYxrAbl3GGx0C0Ns0yIhDaviAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sPpJryvtJ64uT7khVKkhmqmSJ3VcZBEWIZm5iSRWXBg/9fqcRfI0FxwsviYICRFlz
	 ZKe4+wLc9Ho+O34PD9L7lcng1VCcSAqAyh6oVi33WY6dlCTzvUzLnGigS/jhuL9gJG
	 /tzGgDYUQDM+Eu1SWt3xsyol4ZnQipm6DK/jIxR6E/PKwjhS0dQBTjYVsV9J4aWOhU
	 98R34QEkWHJMJ1txETXb+imBTEqrIO7DxPCDo6EE0aoGDK+GGtC66dlJHVpmPoIFKU
	 Bh1Vdmac2QMZkUoazktH/NGYLX2qrer4v+SCd/rZhZViFADDjZeanZpF9au2XxHm/e
	 jbyV3tG8Si3jw==
Date: Mon, 9 Mar 2026 09:39:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH 1/4] xfs: only assert new size for datafork during
 truncate extents
Message-ID: <20260309163938.GH6033@frogsfrogsfrogs>
References: <20260309082752.2039861-1-leo.lilong@huawei.com>
 <20260309082752.2039861-2-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309082752.2039861-2-leo.lilong@huawei.com>
X-Rspamd-Queue-Id: A174023D04F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-32018-lists,linux-xfs=lfdr.de];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,fromorbit.com,huawei.com,gmail.com];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.990];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TAGGED_RCPT(0.00)[linux-xfs];
	BLOCKLISTDE_FAIL(0.00)[100.90.174.1:query timed out];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,huawei.com:email]
X-Rspamd-Action: no action

On Mon, Mar 09, 2026 at 04:27:49PM +0800, Long Li wrote:
> The assertion functions properly because we currently only truncate the
> attr to a zero size. Any other new size of the attr is not preempted.
> Make this assertion is specific to the datafork, preparing for
> subsequent patches to truncate the attribute to a non-zero size.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>

LGTM
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 50c0404f9064..beaa26ec62da 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1048,7 +1048,8 @@ xfs_itruncate_extents_flags(
>  	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
>  	if (icount_read(VFS_I(ip)))
>  		xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
> -	ASSERT(new_size <= XFS_ISIZE(ip));
> +	if (whichfork == XFS_DATA_FORK)
> +		ASSERT(new_size <= XFS_ISIZE(ip));
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>  	ASSERT(ip->i_itemp != NULL);
>  	ASSERT(ip->i_itemp->ili_lock_flags == 0);
> -- 
> 2.39.2
> 
> 

