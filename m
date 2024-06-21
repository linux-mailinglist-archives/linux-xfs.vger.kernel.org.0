Return-Path: <linux-xfs+bounces-9720-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61EAA9119C9
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2024 06:50:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8D01B2168B
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2024 04:50:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE8C12B169;
	Fri, 21 Jun 2024 04:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UAiCamP9"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29900EA4
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945416; cv=none; b=f3T4Ep+NYu/WQt3+KbjX8IqDte0ST/kCF5M5MQs8GomwFeM2qW+jfGhyc74/PsO46ehSFCVdONes+xpwRtJsp7KuzjmKHRhpZ8einibxfsCIXj3aOdI3MM2ZL+LRH16VFH4x5yPWYEP6FUTeIZLANzZsYDi3CBQELOmunvh0ACA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945416; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c3qgLTGzDXQZ6Ao+aAZfX66h8MRsXDvKAGmxRP5EdpGe9pR7XD7Qu4ZSYGOh7QTX1BR3V5+W9i3tShrDXBjJ4QzZaSNyKC3TUOiFGmMUaoxQZ8ylC68R33zI4fNrbv2v/uKFcA/mA2cw7t5wtIzS/JkA8sBXrzGZ+OlhB1AptGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UAiCamP9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UAiCamP9tpNl32CEWub94HT1rI
	jdz+16pod5cLfDjo2OIBN5lADqO/mR8nHvSeqNJbOnAoUWCw59ex3Qy5FPPoHZ79UX9IvxogsD0CE
	VObfKXpWzL85zjXCNiAOICBb4g1Ec/EQIcg+hdBbxqVG+IpK51DQMcmyDqJgwbMJQ3Xvd1fmyySX/
	8+Bs35sxM7FInoFWHRWLoKV+xGXAAQrGd4c8rb3nSxcO0589fXFPf25CZic4NEMF2HHB6GdqJZ9Ek
	MjZcnkJPl13AkAyM9VfBaPklCmuHsPcPyHvWfDKC+Ax6JYnU8xOzU1KsOJsnntlCosYX8tKT5sVD4
	7FrSbg2Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWE2-00000007ggQ-3CgG;
	Fri, 21 Jun 2024 04:50:14 +0000
Date: Thu, 20 Jun 2024 21:50:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: clean up rmap log intent item tracepoint
 callsites
Message-ID: <ZnUGhk8I2uCDxiP-@infradead.org>
References: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
 <171892419284.3184396.11763392908999434569.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892419284.3184396.11763392908999434569.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


