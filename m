Return-Path: <linux-xfs+bounces-22688-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D8AE2AC1AFA
	for <lists+linux-xfs@lfdr.de>; Fri, 23 May 2025 06:35:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CE3C17A5185
	for <lists+linux-xfs@lfdr.de>; Fri, 23 May 2025 04:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10A5222156D;
	Fri, 23 May 2025 04:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bZt2BW2B"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95F02F41
	for <linux-xfs@vger.kernel.org>; Fri, 23 May 2025 04:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747974928; cv=none; b=b1+HPvytAV0vgid5bpNV2sQcdF/1ShtEwc4qJSD73jWAmsO5GpAmLGVCAGINLZfWFeaDk7yMpkg6OHCMXWxIzcndggAeqKT9QHgUZkGw6ErpGB2mtCC21vUSAWWpfQ2kKKy03LsoHYy+C3RKX0/ibVVfKcWqWS+yVP/PsjvmNFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747974928; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tSwCYjjnIoo+GyFusbmGWSOMv817E+QqJ/C2v32szcUTdcjH/tmbJ2cp1zxpoOgkdqdvUnN4MsPUv2CUa6gyOBV1Tg6/UOU2bTr1clK9RDI9FpDpX3Gy3H1qQ3pvRL6ejB8kPlcEiuJ2xFhyC9gH6QS9J334LAuNNkNFNlYZaFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bZt2BW2B; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=bZt2BW2B6BCvvh7JWnIOJYUSJc
	GJ/m3tytejjBxZBxtFCmKIGGd4Jzvncn50lm0cbVJquzg5aNMFRSXRT6DQ3icU49lyYmWPuDD3LqS
	muYfC1uQUTbuGEIteClBRs+GlHgZbIdoFsINjb8hj7u1Azixme+iBrVS1KQdUU3QCiavfFP26eBe0
	AzsKMX4XMQr4Hi6BZIi8yRzO9pE8wH8tONUMTRyt3pAXYMiowYQ4L5fFiOoNZj13Y8eMAaV2/aHSg
	LCPfCZjCA+obFcLrLN1R1jKVpwhj89PMxSlBkHMH7WopccJvfoocDHRg4uFmOS1icxU9zco2An5sG
	VmuLO5Eg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uIK7w-00000002tjc-2Rh8;
	Fri, 23 May 2025 04:35:24 +0000
Date: Thu, 22 May 2025 21:35:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort
 deadlock
Message-ID: <aC_7DI3dPm4rs8BY@infradead.org>
References: <20250515025628.3425734-1-david@fromorbit.com>
 <20250515025628.3425734-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250515025628.3425734-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


