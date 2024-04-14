Return-Path: <linux-xfs+bounces-6490-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E7B7189E971
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Apr 2024 07:08:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D5C91F21D69
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Apr 2024 05:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A264710A2C;
	Wed, 10 Apr 2024 05:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lM/4EqqC"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BDC10A13
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725684; cv=none; b=SMxYk05imrA/DkLWIrkv/7cVwEdrzyTvGISlmXRbhi17Wp/sJ/Dw+ZMyYujI8HczHQVYqihirMTVadb8GpzCjSmsYjS5vEiGTr0DabmurDz0blZV64iHheq4eEh0HeAUer4u1Q9GIgb/VoJxp36qj6TNBwRxj2cCzld/+5sr/+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725684; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RTfurZB6XGSJ7daG5xDPiubElwzVOmmA0coUdUTN24UQGCS9j5A+L+6C6lUgfObVZpX72AMQAt3DNuGVoAprk7NX+waTAroCuKg5MFlOdzbhj/VIUNpiqv/+6X+jTcbrusUzlw/f/dw7XFm9xMvi2hC4FvA/1eUIB8+i5BI8OgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lM/4EqqC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lM/4EqqC5yMX47+er8MN4CBRHe
	M/HagugGWFzGJ7HpkV/Z3y/cF5jb3YpiKhfHMQJH0qPG0GSWTW+k686TV6faZ4hYvq6bVzuLELiCA
	VyXiypwgyvDucF6xGdQ9iU+k8oz9YoE1alBkeh1m89Nx5xPxtSDf/Q29dzumaByRn8UITUkBMOCAX
	sfPB/oAcVOG8yX2Bs1+CxIapS/2e+vqWtZ50AqnEQIFb8y43sAqh8zdg04LjSbooRuYgr6T1TQeLk
	a+k4mBv07ZvSFnixTLMCf02wZ1E2FratARI0ZsOaOBwSgGiqR06m1CKKQfMm1G2ii4hjlfG1FvK5k
	8Bh72azg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQBm-000000057iB-3tZu;
	Wed, 10 Apr 2024 05:08:02 +0000
Date: Tue, 9 Apr 2024 22:08:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: validate recovered name buffers when
 recovering xattr items
Message-ID: <ZhYesoBe92ATO5BL@infradead.org>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
 <171270968983.3631545.17258405896513987386.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270968983.3631545.17258405896513987386.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

