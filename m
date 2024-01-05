Return-Path: <linux-xfs+bounces-2591-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B139824DDC
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 05:58:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B31C91F22EB1
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 04:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49BB55243;
	Fri,  5 Jan 2024 04:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WDe2frWH"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1443E524B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 04:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=WDe2frWHYLdBZ6wKPLHr86zqtx
	73huGZ25wDXE58EKgczPKZLCsQ/b3TvoDKKF1MEPS/H4KUkZuepx1Jol3/mS5xIarG6H7vrr86ASS
	2jnDmC9lvT/U/tIIUx4jFSyjoDUBFwo3OYDJoxVPjxfG47tLVI281vjtXv84/nZ8RnJDH1qheKjZs
	t3vLWq+WRksGFk30WiEYO+0j8qwstcua6T1sOZuVc7aH2QSP/sp7y84JMOoWngekBpukxCLpgIPcl
	jndX7zuPt4w/zy8ShAjj7P27cRmWU4ALHuqgHxQcHR8FsEcROl6oCdQW0fy4l3j1DoBZrsSae8nNB
	hofzdrvg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcHh-00Fwcs-2d;
	Fri, 05 Jan 2024 04:58:17 +0000
Date: Thu, 4 Jan 2024 20:58:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs_scrub: fix missing scrub coverage for broken
 inodes
Message-ID: <ZZeMaXeEZ7qdD3il@infradead.org>
References: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
 <170404999048.1797544.5322672088708731038.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404999048.1797544.5322672088708731038.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

