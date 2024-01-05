Return-Path: <linux-xfs+bounces-2622-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD1A9824E20
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 06:31:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 916A51F225E4
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 05:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB3C8566E;
	Fri,  5 Jan 2024 05:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cpqQCRk4"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556CA567F
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=cpqQCRk4duipyhKrBOZveEJUpS
	LoE6a8xsByfbqhoOKKNx9HmSMvDwCgZ/AnidnWvdqkeb/7FbQSaIZTn+/+68eSSd3B+ON8BWFnyFw
	Uv3ieLYMBZ8VCwbNN3UC+6yZ7gQ1f344HLybFPUADn2AaWb2wqGWbx+9ea4vV/sEKwgBJCVLxGGr3
	DKjtV1Qn0+lBk0srThEr+R8o5SvJgcc3ZK1jU8GepeZU49bF5u/66OwragCLQIMJTgja04LWvfzqm
	686CwZYEnDUIXmdjOsGWccn7eCRAGp0JvHY5PGXYftscf4W5tLwiqEbpiCj1+i+DMv7zyh+3QFy1a
	uWgEskYQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcnI-00FzER-2g;
	Fri, 05 Jan 2024 05:30:56 +0000
Date: Thu, 4 Jan 2024 21:30:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: track quota updates during live quotacheck
Message-ID: <ZZeUEHuO/dHTKsIg@infradead.org>
References: <170404827380.1748002.1474710373694082536.stgit@frogsfrogsfrogs>
 <170404827443.1748002.15261136808573289859.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404827443.1748002.15261136808573289859.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

