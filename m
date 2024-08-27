Return-Path: <linux-xfs+bounces-12219-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A2EE96002D
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Aug 2024 06:08:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63BCD1C2216E
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Aug 2024 04:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A239B3C099;
	Tue, 27 Aug 2024 04:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1Y9tJ2Oi"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0854FEAF6;
	Tue, 27 Aug 2024 04:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724731677; cv=none; b=CN9Vk/JGEb0PMCOFLhaR1LfZft47jSqYlNo0d4+KFIDSuINaJlWhyVhWSQMLtEOYFogOcxogm1+DtQSGd5Q9YXcNw14wan8RwzfcYvEeMRBs0EsWiXt0iRTM11tRiAcattdO84uGaI2HKXHqeNF8V/5L6Zpotgqh+CeKEvMW6MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724731677; c=relaxed/simple;
	bh=RtUA6cq7N9QmBBZxtw9JQjTCZ4WN/zo2ZWjZeftflNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cbr+mkBxFdBcGip6XMijEH8LV6ay0XlQ4rh7OsphraCJWlQX+Je3djPFRFPV/r7LszKI3nNKM+BEzI6/XophUC7r6avCjw2q25dKrBW52HQNa5FB6a5eMcv7XeC/LhF/Xk7d0Nt65eJ2ZBkxflM2Uxd9e/evS3ztd4oknRvPHio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1Y9tJ2Oi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RtUA6cq7N9QmBBZxtw9JQjTCZ4WN/zo2ZWjZeftflNA=; b=1Y9tJ2Oi/J4f69kPCbpWSCDjv+
	zifJLauBV+9m365svWPvGL1dxgLhmaTGndTMGaDaVYMRVeY7+EbadmfK9TyDjAnr5l10C5bzAipPH
	g6AdCDXe3nCglX8sgodr8bw+CgcK43juXW0COmrq9O9kuE+osMZBLVyiqQO+/7sFgWkO0qw5In2l9
	ljeoGaiRsB1rgc4gEyKj9T55Z+Vzzuu+AJYKpuYbaTfeX2MmPfjnDSL+yLyIg6v7vcW/C7Cfx6BYq
	JNicPMx4i8iNn6tq2fOR6OXpY+vTAx5P3P1W5kmUW6OY0TVC1cOBIbeG/f3tRj2+CxXfhvG9LV9rR
	EEftR/FA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sinUl-00000009fTG-19Ti;
	Tue, 27 Aug 2024 04:07:51 +0000
Date: Mon, 26 Aug 2024 21:07:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: brauner@kernel.org, djwong@kernel.org, sfr@canb.auug.org.au,
	p.raghav@samsung.com, dchinner@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] iomap: remove set_memor_ro() on zero page
Message-ID: <Zs1RFxM9tW1-O4rg@infradead.org>
References: <20240826212632.2098685-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826212632.2098685-1-mcgrof@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 26, 2024 at 02:26:32PM -0700, Luis Chamberlain wrote:
> Stephen reported a boot failure on ppc power8 system where
> set_memor_ro() on the new zero page failed [0]. Christophe Leroy
> further clarifies we can't use this on on linear memory on ppc, and
> so instead of special casing this just for PowerPC [2] remove the
> call as suggested by Darrick.

I've already asked for it not to be added multiple times, but I'm
glad we're getting there now:

Reviewed-by: Christoph Hellwig <hch@lst.de>

