Return-Path: <linux-xfs+bounces-6496-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B25889E979
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Apr 2024 07:11:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3D191F24058
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Apr 2024 05:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E548C1C0DE0;
	Wed, 10 Apr 2024 05:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JLOVBlC2"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8037118AE4
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725869; cv=none; b=GmaeUKwSRw0m5ELPB/L7Uul6uFjcT5mmzj082PezjG51DKw3afsJ47wn3/2pObynwuVvTjb2k3NuWXxQclurudkdn50UxAXWtwGWVN9BmpefR1TY9/6vTrb8CBzMq1V3cNTZiH9SkOEDIsLd/BQShBjA137X/nJlJiTfznAvDDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725869; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f7aWNU0KBp/r0GvGaUYHFX/WlojcSiwNf4qS2E48zGPJDWeip5FTTJqj7RG/mrW5osHcJnj1anPkLXaTgK+k4p0NzYUjTXLn67pWpI1U3Khq2CK0OT4nodsDXLIZDYRnuHD+mpG919T94QIL/s2onIzZ4g4xIGzFylwi3NoMIv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JLOVBlC2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=JLOVBlC2jZeQUc77Lf7H/OZ+hw
	eIktDOoxM75DF2U52VUGkzKhF8UzOU38wnrbPRJ26IZ4je8Y5+XZWfpEEngT24yybvrzT7tkKw1a1
	NyL5fZdmyTDz0kRh+vyWsty4tVpdUI2GZiZ8PQAZe9ESBq2NiqSx1qd/1nMyTe6TF80m+K8kh7I24
	YTrJlQKwjTQvu9g6aX+5J7ZWMGYfpFZVFUODrWERRo8LZTOoSrkHFzgdiR5bo4cIS5ylzCQyH6OpJ
	U3Huor+E+RcXgX895Sf3yquGA6IMzBLFkyjCfSb4QKjDe7cdk8gwf/TfwX8db9scRQ10QDxRv9+n0
	GAipLiXQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQEm-0000000587n-01z4;
	Wed, 10 Apr 2024 05:11:08 +0000
Date: Tue, 9 Apr 2024 22:11:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/32] xfs: move xfs_attr_defer_add to xfs_attr_item.c
Message-ID: <ZhYfa3LTfzaeAi8p@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969608.3631889.469698599262996242.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969608.3631889.469698599262996242.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


