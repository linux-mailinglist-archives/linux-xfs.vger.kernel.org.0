Return-Path: <linux-xfs+bounces-2627-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A1AC824E29
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 06:41:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDCFC285469
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 05:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8A1D53AE;
	Fri,  5 Jan 2024 05:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e0b36ofS"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BE453B9
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=e0b36ofSNv5ZbPa+oJ6Q6A+qHi
	eWw2zwJbZWq7R2cmPuSZkp2NpROVFweKT1huDhd7MfqImRGdWIwwjcAWuRntEvKU/AgActJTH8cfn
	XZindoB5aRb+kRpJ74CMV38GSSLasWopemA/EnWFgWvTop0dKHJYDEmDCbM4R5JOPxnzQPeDNfPCe
	GuVHIw1AEGWdmJ0hId6u2Yc+y7eZsgEHEXtzsLXBVqcpUzzcbIZ4eekJYic2Selo+kb+djnVFfpX1
	ldlquCvG+O3SjzMtlhxMI0UVtvv7TbZEXVVVoVMaGFSjpZCfp7tH0ABtl+THMAwZwbvCn3foDrjbG
	bqvqZl8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcxa-00G07a-03;
	Fri, 05 Jan 2024 05:41:34 +0000
Date: Thu, 4 Jan 2024 21:41:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: track directory entry updates during live
 nlinks fsck
Message-ID: <ZZeWjTRmq1qNBBhE@infradead.org>
References: <170404827820.1748178.11128292961813747066.stgit@frogsfrogsfrogs>
 <170404827879.1748178.9400841627212798788.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404827879.1748178.9400841627212798788.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

