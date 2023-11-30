Return-Path: <linux-xfs+bounces-274-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D3397FE848
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Nov 2023 05:33:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FF651C20C41
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Nov 2023 04:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A925420DD4;
	Thu, 30 Nov 2023 04:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DqpS05ny"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15BFC4
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 20:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=L2J70v8SgjujB46QoicQpTzo9ktlEXnXUA3bWLj7UIM=; b=DqpS05ny50Pas5oQ3b8TEts1fX
	DmpC0f9Tyt2+/DPlN5rcWT3UXx6w6QM6x5V06t2vyJcfJJyVWmdxPda5yN960UWXLH4DL/G2g3I1O
	r1kQtUE0XCVtahj+idV/QeH9dYAzRKPaYdRqWsI9WzDz0CWoHeYnFia/WdhBHxKbKWYe8dZDGniwo
	HNm/ckF26WqmxrsrhRcvLWICJ5kOssyAP8BevskY01ajHSMMgRiYNkFoRaR2yxeAXkzBw7KMcr6Jf
	AbgfJ5Oi24SDc09Q2cI2RTsiurjQC4+/tIGMWfAScIhNYGnUl72k8T1aWjUj4VMQ3MMxaVIyf9Rl6
	Eo+CIrkA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8Yjq-009uZL-2T;
	Thu, 30 Nov 2023 04:33:22 +0000
Date: Wed, 29 Nov 2023 20:33:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: force all buffers to be written during btree
 bulk load
Message-ID: <ZWgQkqe3IefPU1SR@infradead.org>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
 <170086926593.2770816.5504104328549141972.stgit@frogsfrogsfrogs>
 <ZWGK6Ig752wdBvwF@infradead.org>
 <20231128015041.GO2766956@frogsfrogsfrogs>
 <ZWWTJGq1ldOm6inW@infradead.org>
 <ZWYEvqZHj4KX4wqj@infradead.org>
 <20231128170734.GZ2766956@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128170734.GZ2766956@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 28, 2023 at 09:07:34AM -0800, Darrick J. Wong wrote:
> > so I guess we'll need to go with the approach in this patch for now,
> > maybe with a better commit log, and I'll look into finishing this work
> > some time in the future.
> 
> <nod> I think an xarray version of this would be less clunky than
> xfs_delwri_buf with three pointers.

It would, but xarray indices are unsigned longs, so we couldn't simply
use the block number for it.  So unless we decided to give up on
building XFS on 32-bit kernels (which would nice for other reasons)
it would need something more complicated.


