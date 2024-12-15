Return-Path: <linux-xfs+bounces-16824-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 800669F07CB
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 10:24:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 406FD2814AE
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 09:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC7191B0F18;
	Fri, 13 Dec 2024 09:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0o8cnuz+"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718C01B21BD
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081857; cv=none; b=mNMrm+VuAUfom9vseS66i64LlJQDrMgg4N0iLg7EFwVfjrnYndnT4XRLsIwA5OV9m798xnZI9pI/ZUvfPSlki+dBvfE+bI7myn7FBMMCm9o7dtyibyuAzSVBek7E4nZA8n3Fwmqk6HwuVSjNaJe3gGHanzgXktnh3EAwnB/F7k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081857; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hSPRVfDQOoZiesUlshuOqH6LZsRAvAmWRDAUSUgiGL936u9bA5+f1kHOJVUZXg/e1HSvXbf0IfyWVWbr0k6/BYBpGcBsJZQEPoMLr4Bgm4gl0AtrMvkFPDJxhq8jFH1k12l3qHRpjTNLO0/zPYRYdNd8+ID4ivwGf+jD+lsk3Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0o8cnuz+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0o8cnuz+KlWic4eZVeQ2B630bL
	1f70B7AAQpTkWHNMjFN28x3ni1dZgG9ipLK9s+WL1OMvWXWcqhq+IFGX4JeiEBrTibz08w1+0gm0+
	GCQ38fUqozRx2aRhWuQw44UJil00QP26h3eHrv1jFK6tSSYzJKf8hpjbfKpPNodOCVmYrIgfvs+ip
	GCpMZ+sV1yOKF1DtUGO0SCYVmK/GMIsMAouk3sLXFlCw1qGUSJ9HB1UYmVfy628p7+WSnKGRZjgqv
	ra1+di5EfHCX9RLIT3chnwxGG+6MqUiuBO7BXdUiIyoAA6ad1SdPHpXQieJaBXVjQJYZYI5TRm3DT
	kQmNAi6g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1uC-00000003FJD-03LI;
	Fri, 13 Dec 2024 09:24:16 +0000
Date: Fri, 13 Dec 2024 01:24:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 42/43] xfs: fix CoW forks for realtime files
Message-ID: <Z1v9P3s7uWCOHmwz@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125286.1182620.1316346517848021106.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405125286.1182620.1316346517848021106.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


