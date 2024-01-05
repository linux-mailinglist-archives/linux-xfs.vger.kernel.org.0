Return-Path: <linux-xfs+bounces-2648-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11643824E49
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 06:51:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEA02285F69
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 05:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDEE9566F;
	Fri,  5 Jan 2024 05:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SerCGD2Y"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB69566A
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SerCGD2Yjn918LsYjdDv2AlJJx
	P3H/PGTr9abB+jWg7jQc8O7dJNz+ZuFF6Ng+rijZeTVeBMDaTqIjPPLsQCgrJWd7hvs50XY6wQcqA
	urrKdSEhGL3DspZCulFEuK5nzxJvV9khgN6G9f3q/n8o//jaxqZU8AICAChqiJrEKzQd7w78OCrVE
	mzXEl6UsmiCob4GY51Y9OfV1fK3dXoZnwt0Z67643smCUULrIKiJkLGKhsSEUDfg7hpNDLNhRT1/w
	RjoWjh+R7N9QdgQ8LXjdWDKGjwmVOoIVSr3BDdtPj4N8zc/wXJz73OEy74d98Hf9UY7jb9HuDywpf
	5IBuus+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLd7D-00G0nk-1g;
	Fri, 05 Jan 2024 05:51:31 +0000
Date: Thu, 4 Jan 2024 21:51:31 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: move remote symlink target read function to
 libxfs
Message-ID: <ZZeY4/KvsUj2YOHU@infradead.org>
References: <170404832640.1750161.7474736298870522543.stgit@frogsfrogsfrogs>
 <170404832680.1750161.6114741655557405167.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404832680.1750161.6114741655557405167.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

