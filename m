Return-Path: <linux-xfs+bounces-30163-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qGoHCXJocmmrjwAAu9opvQ
	(envelope-from <linux-xfs+bounces-30163-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jan 2026 19:12:02 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8747B6C172
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jan 2026 19:12:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 09B77300363B
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jan 2026 18:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06664371074;
	Thu, 22 Jan 2026 18:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LjJuAGcs"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2F5371069
	for <linux-xfs@vger.kernel.org>; Thu, 22 Jan 2026 18:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769105510; cv=none; b=khWkbAkZL/EEf/XkV2hLEznSfghcSn1+OqmluTuJaQhkBmlwJDBEBqgwuxt7cAPTikJjv86PziZNs1IlxY0hMwu1MqIELIMiMV6y3OcgwdFYCctAQIJvy2rC1KGTz7xxgzsW9xcgjvAx/Dxjfnb3e+CXXK96O2ljvSc9LuDbV5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769105510; c=relaxed/simple;
	bh=+REUXYUAsJPQu36oPwiTMA6Ne1Bp5jz2Z7qr4Q5w144=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W4sHK4e+0bpJVV2cP6JpiitbPbiymY5Izdj/wjWM64+yBEvDgabgnTvL+wk0wYrwWm6dgcLUdW1YTatP/cOs2nyV6g/NMVJNLR6GAqfVlC2kmwx380pgcDRrEKN1uWC+t7Ona5g6rZpLJPk848T7ZxN1qq/UbpxJDnqH7MfMvXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LjJuAGcs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A1AC116C6;
	Thu, 22 Jan 2026 18:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769105509;
	bh=+REUXYUAsJPQu36oPwiTMA6Ne1Bp5jz2Z7qr4Q5w144=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LjJuAGcs/xeYVBjIAYsto8aeM6M7buRXuOWLM7s6TJXhCDn/C9lgUJDQqzquYzt8U
	 ZOUH6zkxGzHMImnfLRH3iZUZ5YlC9NKo7OZTb3O1FOIPyhvSU+FkUyJP8fcuHd264Z
	 uuicM5P2yBswr6HPwykSmb56Hn+XT6fwrIAuiChf/Q35Xg4dOJKb+JNwvKmvakQMFY
	 Vi6U5etMB69z1Ge6sy1+geTv79B7tJ0wigAK5H8MdZYRQ7JcsiBF5iCOIDzRLOCpWu
	 aXnQu1u0imRKxwvcGrUTYHD7m57inQ26P48LKx2y50Rasc3YeEgXGiJpGe8waUR0U0
	 +WMCBSBAc2eEA==
Date: Thu, 22 Jan 2026 10:11:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	hch@infradead.org
Subject: Re: [PATCH v1] xfs: Move ASSERTion location in xfs_rtcopy_summary()
Message-ID: <20260122181148.GE5945@frogsfrogsfrogs>
References: <044d2912a87f68f953efcb83607d5cf20b81798b.1769100528.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <044d2912a87f68f953efcb83607d5cf20b81798b.1769100528.git.nirjhar.roy.lists@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-30163-lists,linux-xfs=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.972];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,linux.ibm.com,infradead.org];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8747B6C172
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 10:20:35PM +0530, Nirjhar Roy (IBM) wrote:
> We should ASSERT on a variable before using it, so that we
> don't end up using an illegal value.

Assertions don't necessarily kill the kernel so ... do you want to bail
out?

	if (sum < 0) {
		ASSERT(sum >= 0);
		return -EFSCORRUPTED;
	}
	if (sum == 0)
		continue;

--D

> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  fs/xfs/xfs_rtalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index a12ffed12391..353a1af89f5d 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -112,6 +112,7 @@ xfs_rtcopy_summary(
>  			error = xfs_rtget_summary(oargs, log, bbno, &sum);
>  			if (error)
>  				goto out;
> +			ASSERT(sum >= 0);
>  			if (sum == 0)
>  				continue;
>  			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
> @@ -120,7 +121,6 @@ xfs_rtcopy_summary(
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

