Return-Path: <linux-xfs+bounces-543-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E7E9808023
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 06:26:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 494DB1F210A7
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 05:26:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C196E10A0A;
	Thu,  7 Dec 2023 05:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P78YdJ58"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC17D7F
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 21:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=P78YdJ58Mojokf7lHPaXMoluuH
	WjWP+p6eQXXtgjR3NO4t07MZUQB/nJ01P3FWsHggXxVH3B1rmeVfXzl0RhjFvyXXqXnBo9Cg8S7dW
	dRhV447anHsVKr+gqF6yMjK2ZDA9aVMOSSf2bs0SaDr0Hhz+53bH2LXQsKYnbk3kGXlvc/s0tTsUY
	BcBUpXe3G8E+h11ExiMQi7XHLRgp1KtGqYpoIDJps5NzRhaQo04q/JuJPdxhCURk2ogkJ/nIZPYKu
	UVoN9YWINA8d5S3r9xTSpaJZNgAZFT0LC7QpLmZJEL0KfwmknQDHnsxcc+pj541BgYMIcUNd+/4bm
	C3SoIPRg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB6uS-00Btdt-13;
	Thu, 07 Dec 2023 05:26:52 +0000
Date: Wed, 6 Dec 2023 21:26:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: add debug knobs to control btree bulk load
 slack factors
Message-ID: <ZXFXnIspmOMz/gA5@infradead.org>
References: <170191665134.1180191.6683537290321625529.stgit@frogsfrogsfrogs>
 <170191665210.1180191.2699697469994477580.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191665210.1180191.2699697469994477580.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

