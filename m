Return-Path: <linux-xfs+bounces-30397-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id jFZ6CgxneWmPwwEAu9opvQ
	(envelope-from <linux-xfs+bounces-30397-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 02:31:56 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 99B149BEAD
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 02:31:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9036F300B471
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 01:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 394AD1DED4C;
	Wed, 28 Jan 2026 01:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t9KU4lYO"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1640619CD1B
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 01:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769563914; cv=none; b=ODkbWqFGZmNYF2ynk8ESW/rTymwSXXLvUjMDNGDoqoyVyT8Blrj9yZPmR53G0CAjKczElVkL8uAZM77hWYcoEHO85ObJyNw++rxrCTj+gAs7wY0lCLYpplUxU1TmBkYbVOFagV2lzv3xWqBCl3Jw/Jdxe/IVlu74v5wMroFfUQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769563914; c=relaxed/simple;
	bh=RqTe8CxBQPB4pV9MfgYLEm75CTa7e0Ap/xY/IRhoAKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RhJkRPnZdy+QLXYMDiReGg2Itj9Ck57q62J49+xgAxCOn6Tr4tMWn1qgcyJ9K6FLrQ38EWNXSQkO9o/5tQDqjjYQYZtsIF8ZytTnbeOEctVMyTwq7fO93oLudREqwCdL8BiPnGwOtQ125QybD5Fu1isKbrv2cx6HEeLZdD0AySo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t9KU4lYO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C19C116C6;
	Wed, 28 Jan 2026 01:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769563913;
	bh=RqTe8CxBQPB4pV9MfgYLEm75CTa7e0Ap/xY/IRhoAKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t9KU4lYOA4ItaTTNR9cVaRNPFfIPykGminwY3v3Z2eNLGx1yVl+TZz4XHDBZLyx9K
	 ecFgI/CfFzcbqpm052/NYJTMBxvVC9m5N6kPTK7YJFkjSxzCfzWVbmNuNNB6XlSBJ/
	 wDJekNgG1PP3rzuYDh7lixwaUyhPpc3RJCF+xlE+Fduz/9S0f+ovF/ZVBPrpg/X/F2
	 sX9tdqNWm/CXtJ6+1SclHRMm1Wb7q18JXPJ2bXkJp++DNj+5VAU8i9Z4BGolb+4qPd
	 jGflTcYQ3JHzfZC5CvHWtr2N22BkLe80bZK7NhG4+Gei8cwgOUwelYevOSUh1+VfDH
	 oWvlmwIKBpa8A==
Date: Tue, 27 Jan 2026 17:31:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] xfs: fix the errno sign for the
 xfs_errortag_{add,clearall} stubs
Message-ID: <20260128013153.GA5945@frogsfrogsfrogs>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127160619.330250-2-hch@lst.de>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30397-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 99B149BEAD
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 05:05:41PM +0100, Christoph Hellwig wrote:
> All errno values should be negative in the kernel.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yeah, that always seemed like a logic bomb waiting to go off...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_error.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index fe6a71bbe9cd..3a78c8dfaec8 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -60,8 +60,8 @@ int xfs_errortag_clearall(struct xfs_mount *mp);
>  #define xfs_errortag_del(mp)
>  #define XFS_TEST_ERROR(mp, tag)			(false)
>  #define XFS_ERRORTAG_DELAY(mp, tag)		((void)0)
> -#define xfs_errortag_add(mp, tag)		(ENOSYS)
> -#define xfs_errortag_clearall(mp)		(ENOSYS)
> +#define xfs_errortag_add(mp, tag)		(-ENOSYS)
> +#define xfs_errortag_clearall(mp)		(-ENOSYS)
>  #endif /* DEBUG */
>  
>  /*
> -- 
> 2.47.3
> 
> 

