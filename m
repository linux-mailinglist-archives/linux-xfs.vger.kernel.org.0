Return-Path: <linux-xfs+bounces-20462-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BC08A4ECB2
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Mar 2025 20:04:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9946B882F0A
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Mar 2025 18:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C9B228040B;
	Tue,  4 Mar 2025 17:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yWADDRKw"
X-Original-To: linux-xfs@vger.kernel.org
Received: from beeline3.cc.itu.edu.tr (beeline3.cc.itu.edu.tr [160.75.25.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D31623312E
	for <linux-xfs@vger.kernel.org>; Tue,  4 Mar 2025 17:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=160.75.25.117
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741110743; cv=pass; b=V8rZzpRCxudpp5banJxGwEpl1wk6KOwshdXor26mzJFb9ykRNQJBa84a3BKqm7bj7lH42ju7I/vtJIkyJVg3nyYuOGJeRIgFWw08wmXh8uG9NukPDJPJGSTi7HHWy4uku3ta3G7bIXlg/o1ZNjxDwQWlK381rMi9fMblroL2TpQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741110743; c=relaxed/simple;
	bh=Bz1lkAIfe6XJhf3eq5SVjSBSproAa10eY3/wDj27F2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mW/Mgwwxmxmw5yPU7pIF56nAcvH6NqIXzSvapWeVkGA8HXZfRVB7qgszLvFHaD1qHbASVHG29LVonZdPU6ZLvc4plFIcGPrgNGprjs2UlqdkbVtbmB2JSe5mvM4T6klYDhD0+V6Dc3Hi0s2Kq6oz/nDwOb+pomXmtAYNfZZPSeI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=cc.itu.edu.tr; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yWADDRKw; arc=none smtp.client-ip=198.137.202.133; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; arc=pass smtp.client-ip=160.75.25.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cc.itu.edu.tr
Received: from lesvatest1.cc.itu.edu.tr (lesvatest1.cc.itu.edu.tr [10.146.128.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by beeline3.cc.itu.edu.tr (Postfix) with ESMTPS id 37E4F40D1F4E
	for <linux-xfs@vger.kernel.org>; Tue,  4 Mar 2025 20:52:19 +0300 (+03)
X-Envelope-From: <root@cc.itu.edu.tr>
Received: from lesva1.cc.itu.edu.tr (unknown [160.75.70.79])
	by lesvatest1.cc.itu.edu.tr (Postfix) with ESMTP id 4Z6dK96kFqzFwLl
	for <linux-xfs@vger.kernel.org>; Tue,  4 Mar 2025 17:26:21 +0300 (+03)
Received: by le1 (Postfix, from userid 0)
	id EFB6042756; Tue,  4 Mar 2025 17:26:04 +0300 (+03)
Authentication-Results: lesva1.cc.itu.edu.tr;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yWADDRKw
X-Envelope-From: <linux-kernel+bounces-541884-bozkiru=itu.edu.tr@vger.kernel.org>
Authentication-Results: lesva2.cc.itu.edu.tr;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yWADDRKw
Received: from fgw2.itu.edu.tr (fgw2.itu.edu.tr [160.75.25.104])
	by le2 (Postfix) with ESMTP id 1197B41AE7
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 17:09:50 +0300 (+03)
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by fgw2.itu.edu.tr (Postfix) with SMTP id 9AC3C2DCDE
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 17:09:49 +0300 (+03)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B37713A9CC1
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 14:09:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD612139CE;
	Mon,  3 Mar 2025 14:09:07 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E4C13C816;
	Mon,  3 Mar 2025 14:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741010945; cv=none; b=pFvCipalJp2tkXPBgcXg/4zfwNSwbWpMhA3KxAST5p2y0KXjQUtubtsNAO0vQ6l/nKUigqtvcl+0CRc3WwyBBQEzzqyfiG8x45GQeXRPHFE3o/wiBqxpS/VU4L7nVQXv6y7Nhkh1KcU2b8CwH0wmNQyfsggQIbF3xXUf77JlZMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741010945; c=relaxed/simple;
	bh=Bz1lkAIfe6XJhf3eq5SVjSBSproAa10eY3/wDj27F2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z7hXsMQO6SBP1bEAnvmWUDa6NVJA8pDCuAhDrTl5zUZCgDJrK64pBGXjE+h2taHFhFjjKrbRv41UUH3cgxR4936udKJRkd/+kYAL3UM+p80xcWRhBgrOe3nggc31yKB7oiPDCz4ayxEBBv9sb1+DdFA9sjWJ9MNC21gorNnkK80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yWADDRKw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=da6DZJIEZngOU636aAML7UreXiQIbQlvEAqAV9JlA8Q=; b=yWADDRKwjkLdCq/W/PQvaik30N
	0WruLQPGjrswfXxDKwxx+1WQMUfx750OQAM24RECp2kOZAgjevytteVQNn6PqpP6PzdEr/9U6QUag
	vyXBq7/jum9t2mJcqHLd/9LNFAFluSZRdJobILmJEl4zK83osoYeKSi39U77Qns7TxoZy1an00tYG
	Zfdw/l3rd48uH+2izKyhVKLaHpE1zN+463MrOqLdWHqZwZmt6FEJxtFR3gACrbktm/mV2tKxoqRmb
	HXr3zbkSOn3EExsPDiUAD3ff6bvEwSB87pfzvqHNQxZXyzzqHxeP2RGHJ0PjReJnvraPYRPSnhJbm
	u7ADZJQA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tp6TY-000000011yk-1M1Z;
	Mon, 03 Mar 2025 14:08:56 +0000
Date: Mon, 3 Mar 2025 06:08:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: cem@kernel.org, djwong@kernel.org, dchinner@redhat.com,
	alexjlzheng@tencent.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: don't allow log recover IO to be throttled
Message-ID: <Z8W3-Jni2k_MqmZs@infradead.org>
References: <20250303112301.766938-1-alexjlzheng@tencent.com>
Precedence: bulk
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303112301.766938-1-alexjlzheng@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-ITU-Libra-ESVA-Information: Please contact Istanbul Teknik Universitesi for more information
X-ITU-Libra-ESVA-ID: 4Z6dK96kFqzFwLl
X-ITU-Libra-ESVA: No virus found
X-ITU-Libra-ESVA-From: root@cc.itu.edu.tr
X-ITU-Libra-ESVA-Watermark: 1741715446.8179@3ZmxG9lCgfbitdBul3t7KQ
X-ITU-MailScanner-SpamCheck: not spam

On Mon, Mar 03, 2025 at 07:23:01PM +0800, Jinliang Zheng wrote:
> When recovering a large filesystem, avoid log recover IO being
> throttled by rq_qos_throttle().

Why?  Do you have numbers or a bug report?

> diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> index fe21c76f75b8..259955f2aeb2 100644
> --- a/fs/xfs/xfs_bio_io.c
> +++ b/fs/xfs/xfs_bio_io.c
> @@ -22,12 +22,15 @@ xfs_rw_bdev(
>  	unsigned int		left = count;
>  	int			error;
>  	struct bio		*bio;
> +	blk_opf_t		opf = op | REQ_META | REQ_SYNC;
>  
>  	if (is_vmalloc && op == REQ_OP_WRITE)
>  		flush_kernel_vmap_range(data, count);
>  
> -	bio = bio_alloc(bdev, bio_max_vecs(left), op | REQ_META | REQ_SYNC,
> -			GFP_KERNEL);
> +	if (op == REQ_OP_WRITE)
> +		opf |= REQ_IDLE;

And there's really no need to do any games with the op here.  Do it in
the caller and document why it's done there.



