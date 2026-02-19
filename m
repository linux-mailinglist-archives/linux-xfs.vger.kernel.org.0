Return-Path: <linux-xfs+bounces-31110-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CK16Oe8yl2kcvgIAu9opvQ
	(envelope-from <linux-xfs+bounces-31110-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 16:57:35 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D9AC16070A
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 16:57:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9826C3002B6E
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 15:57:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9148933D6FE;
	Thu, 19 Feb 2026 15:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gwqO8tFS"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E41A336EDB
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 15:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771516651; cv=none; b=P6efDe+TILax9BJijoX7j1nAKN4bxHl6MYt0LqVxQg7xxxBAcYcgwOrqXSOdQEVDcITcLefydAu8Q+F6CzPgkm2KgOoRJhvH0KjQpzEmxfeUKiN901E5Zp3XYVoOsvSCx1CafTxpfuUOVMuBgnk46e23/uEpZKgPCULesPe5jvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771516651; c=relaxed/simple;
	bh=xB40SY9cFcykUPbiCoJz4stZbW8RmVpJkj6fmwWI92c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I5gwMg+xfOOqAVk+9d2n07dB7TnHX8edVdiwUh18jwLwn/ovK1LKIQCdPBmhjuQGrL8zjlT+FA2aK/YxvX3AF8TCs8CyhbIzd4Y5GgI24+QAYe8WvvB3nTX9xRDTK53NFljQj4YhT5EHYmRdYHO/5OHMVTNKg19zs/2Xsr8xxNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gwqO8tFS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4224C4CEF7;
	Thu, 19 Feb 2026 15:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771516651;
	bh=xB40SY9cFcykUPbiCoJz4stZbW8RmVpJkj6fmwWI92c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gwqO8tFSrbRIYT9UF8MrKjQ57X9GYahSq6kGdjw7yw9jBLS/uyqo+zcMBSHxl/ULJ
	 uOSiTVKdMC1/BAqSyZmPksmBH9Am8GW8GncTvCho8ydjC5zuj1/2anhrQoCHIHwFBv
	 LJ6UN+EOIbCmgAH8clFS/Jt0k0djU+LIrJlYDrQkv6Q/TpeWV08XGmZqCa/uJHp/ut
	 cLorwIMFAoNWWBm3H3QvRzwPUPQsYdsjyXGLVWUQ/zmXcNbvTdSURv6sVJ9XjZGqi8
	 dJ5K5afmRLiUApfxdCiQr3Q0q/RuOzc12iD8RfVymA5JlOkXJqcmMTZOcN54OBUVFS
	 pvbK1fjN1UNGQ==
Date: Thu, 19 Feb 2026 07:57:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
Cc: hch@infradead.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	nirjhar.roy.lists@gmail.com
Subject: Re: [PATCH v3 2/4] xfs: Add a comment in xfs_log_sb()
Message-ID: <20260219155730.GI6490@frogsfrogsfrogs>
References: <cover.1771512159.git.nirjhar.roy.lists@gmail.com>
 <54eccbea06953a46f37c376814a9a85539231a25.1771512159.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54eccbea06953a46f37c376814a9a85539231a25.1771512159.git.nirjhar.roy.lists@gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-31110-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[infradead.org,kernel.org,vger.kernel.org,gmail.com,linux.ibm.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,lst.de:email]
X-Rspamd-Queue-Id: 1D9AC16070A
X-Rspamd-Action: no action

On Thu, Feb 19, 2026 at 08:16:48PM +0530, Nirjhar Roy (IBM) wrote:
> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> 
> Add a comment explaining why the sb_frextents are updated outside the
> if (xfs_has_lazycount(mp) check even though it is a lazycounter.
> RT groups are supported only in v5 filesystems which always have
> lazycounter enabled - so putting it inside the if(xfs_has_lazycount(mp)
> check is redundant.
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_sb.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 38d16fe1f6d8..47322adb7690 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1347,6 +1347,9 @@ xfs_log_sb(
>  	 * feature was introduced.  This counter can go negative due to the way
>  	 * we handle nearly-lockless reservations, so we must use the _positive
>  	 * variant here to avoid writing out nonsense frextents.
> +	 *
> +	 * RT groups are only supported on v5 file systems, which always
> +	 * have lazy SB counters.
>  	 */
>  	if (xfs_has_rtgroups(mp) && !xfs_has_zoned(mp)) {
>  		mp->m_sb.sb_frextents =
> -- 
> 2.43.5
> 
> 

