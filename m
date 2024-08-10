Return-Path: <linux-xfs+bounces-11509-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E60D94DE82
	for <lists+linux-xfs@lfdr.de>; Sat, 10 Aug 2024 22:06:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60DA61C215B6
	for <lists+linux-xfs@lfdr.de>; Sat, 10 Aug 2024 20:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19F511311A3;
	Sat, 10 Aug 2024 20:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SGSnLHds"
X-Original-To: linux-xfs@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18A913D537
	for <linux-xfs@vger.kernel.org>; Sat, 10 Aug 2024 20:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723320381; cv=none; b=sYIrBoo+ZvNuyGkUbGtSHDTymAKmk+OTasGiRW1XPSZuIq+uS+fviLXuQiVsxK9hJhcG9OQY15VjM+nTXC5VUsamD3U9tVgWCbGKu7Gi026hVq+1LKBFWz8FtDgFKpnY8hTDNSd2LSKI7zvB+SVsIN3rLBuptGjhHv6yUZ26F0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723320381; c=relaxed/simple;
	bh=0UjAByiaV0eB2+VMMPaN1Ny7thgGU+R/zZJgYCdJrHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FVdL7/ZRIi9ep2MT/E57myQQGetkWDZeYdzAnCFGuMeL0VNuBuReVleAeOIn/M/+ETi75ZvhRZf22dm9MXbU5zwmS1faDWOG7oDAYPtdX/v9Zz7M20gDNq97CNzUIRaceOCOduTUViXHifId5oHo+FM37bXnL+GDvqZkIW30NDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SGSnLHds; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 10 Aug 2024 16:06:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723320375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LeBZWdCN8kSjWpt8gCYfww5FgSViw1IoXXV04Dmrz5A=;
	b=SGSnLHds2uCnmW+s/Jl74nsI9Kufhm4WPqMtbPpxLZBre627GhymsJy4iZ4TLnRul0CdZd
	Jyqu/D1jQjwF5XlcyN+WlNqs8NFbrJhwfdchBj/9FOsQy6gV5kLqMC5n89zf2eU0sYmj0U
	+9qp7Sy67xX825xo6qiqRGmNjHT2LYM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, 
	amir73il@gmail.com, brauner@kernel.org, linux-xfs@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v3 14/16] bcachefs: add pre-content fsnotify hook to fault
Message-ID: <vcolzzrnlun6rrtm54bnrwd4cwlhz2n2xfc25jkkxfk56q5de2@3j44632t4z63>
References: <cover.1723228772.git.josef@toxicpanda.com>
 <b3fc6d63e23626033ff2764a82d3e20a059ac8a4.1723228772.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3fc6d63e23626033ff2764a82d3e20a059ac8a4.1723228772.git.josef@toxicpanda.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 09, 2024 at 02:44:22PM GMT, Josef Bacik wrote:
> bcachefs has its own locking around filemap_fault, so we have to make
> sure we do the fsnotify hook before the locking.  Add the check to emit
> the event before the locking and return VM_FAULT_RETRY to retrigger the
> fault once the event has been emitted.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Acked-by: Kent Overstreet <kent.overstreet@linux.dev>

Josef, are you testing this on bcachefs as well? I'll get you an account
for my CI if you want it (which has automated tests for more than
bcachefs).

> ---
>  fs/bcachefs/fs-io-pagecache.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/bcachefs/fs-io-pagecache.c b/fs/bcachefs/fs-io-pagecache.c
> index a9cc5cad9cc9..1fa1f1ac48c8 100644
> --- a/fs/bcachefs/fs-io-pagecache.c
> +++ b/fs/bcachefs/fs-io-pagecache.c
> @@ -570,6 +570,10 @@ vm_fault_t bch2_page_fault(struct vm_fault *vmf)
>  	if (fdm == mapping)
>  		return VM_FAULT_SIGBUS;
>  
> +	ret = filemap_maybe_emit_fsnotify_event(vmf);
> +	if (unlikely(ret))
> +		return ret;
> +
>  	/* Lock ordering: */
>  	if (fdm > mapping) {
>  		struct bch_inode_info *fdm_host = to_bch_ei(fdm->host);
> -- 
> 2.43.0
> 

