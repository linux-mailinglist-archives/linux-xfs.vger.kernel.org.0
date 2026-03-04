Return-Path: <linux-xfs+bounces-31862-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6N5yG2UAqGnynAAAu9opvQ
	(envelope-from <linux-xfs+bounces-31862-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 04 Mar 2026 10:50:29 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D71F1FDE3A
	for <lists+linux-xfs@lfdr.de>; Wed, 04 Mar 2026 10:50:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BFED2300FEC8
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Mar 2026 09:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8AD5372B41;
	Wed,  4 Mar 2026 09:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jp5nlqcD"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958E5372B37;
	Wed,  4 Mar 2026 09:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772617824; cv=none; b=ltHl0KDEa8fX+5Cn1upyGN1pMe/5COTgfncl3kRCPPZwVtclpj+Dn/I6GUHuYhapmxIHHVp5IbGcOWOgOllY17b8+a/nSnFt9EWYZDpfM4HSy+05m6jCmQEkNolXey9zKoehz/3eFZjIreobK8pCQzZhicCN7oWKlsbRKEXMHuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772617824; c=relaxed/simple;
	bh=UteEWLa+WGEB/Yo1ZYzwCCmf6E5ehNheUSSg3e/++po=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kRKBaFY3UUTJ+cWbKbTqkZaePa69V3QmvHZp7dUcCK0vSB2k87rK/2HnSuoF7Kt8RmI07m6uYUVgyZlh8GeFQWnvZcbH3vJ2BbUERvp7lUqvu+bJHl2urXNPTuYO+dG7fEj85pmT1pqfyRvNJ2FojPjRMPEEKwHp296mh0XdniU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jp5nlqcD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB80BC19423;
	Wed,  4 Mar 2026 09:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772617824;
	bh=UteEWLa+WGEB/Yo1ZYzwCCmf6E5ehNheUSSg3e/++po=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jp5nlqcDXwre95FlMBLnEq6esXRn99C3e+JteQ3qd10V+kX1tD5j/nqjl/U9hZuvg
	 LSwd7PjrOQ9mETSl0Y2Z2Cxy4eeJI95v8oMs2bQHqFZdoleI8LqBI2piL88EqbjLms
	 qq9kRLA8basbte/NFfnBUsBCEKr1VAnAh9PIqRPjGzo15eYW+u6qjxe5nlWRpDa5hn
	 66/Ho5WEImsHWtnCQoQJfOoClNmW774jyxcr3zqCFw83GlgzeO1xms7DhnskYgDrZY
	 VIrKc4EhEmUGb7fcCgYRWpjq0irjkn2BKDpDwKwnE3fp7PIeEmxCOaTuoLPJkLWY8Y
	 KR+ESOCXe7suQ==
Date: Wed, 4 Mar 2026 10:50:18 +0100
From: Carlos Maiolino <cem@kernel.org>
To: hongao <hongao@uniontech.com>
Cc: djwong@kernel.org, sandeen@redhat.com, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Remove redundant NULL check after __GFP_NOFAIL
Message-ID: <aagAOTTpcdRKUmBs@nidhogg.toxiclabs.cc>
References: <B6935AE39B8FFBF2+20260303033332.277641-1-hongao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B6935AE39B8FFBF2+20260303033332.277641-1-hongao@uniontech.com>
X-Rspamd-Queue-Id: 8D71F1FDE3A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31862-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,uniontech.com:email]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 11:33:32AM +0800, hongao wrote:
> Remove redundant NULL check after kzalloc() with GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL.
> 
> Signed-off-by: hongao <hongao@uniontech.com>
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 766631f0562e..f76dfc8f4e1a 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2718,10 +2718,6 @@ xfs_dabuf_map(
>  	if (nirecs > 1) {
>  		map = kzalloc(nirecs * sizeof(struct xfs_buf_map),
>  				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
> -		if (!map) {
> -			error = -ENOMEM;
> -			goto out_free_irecs;
> -		}
>  		*mapp = map;
>  	}
>  

+1 for kcalloc.

feel free to add:
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> -- 
> 2.51.0
> 
> 

