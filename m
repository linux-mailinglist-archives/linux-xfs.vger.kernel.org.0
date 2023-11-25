Return-Path: <linux-xfs+bounces-91-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BB507F889C
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Nov 2023 07:17:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32A7C1F20F6D
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Nov 2023 06:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C775E443D;
	Sat, 25 Nov 2023 06:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qY85X/ko"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9897D1727
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 22:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FJscI1fNQD6IezU1kdZDCK44stotQ7eD02eA6NrKq2A=; b=qY85X/ko2Mnt59wH5ODZqunDBp
	zbMHhVzepWewGYBF7pkLXSifKSlAWukE7TB4WPruXgxuPDE+sNqVBlahulRgBgZb5Dr6RT8bAcHO/
	Q7GTEB0OtAePHsSIBSkpIGztOBKkBaBpoTDOGDW7bXTJAunbhjvpNTTnxg/FXFqvOfoTXk+Ke4EUN
	fszR3AED9ZzJHFQpjmUVD/yqNa2KWN3Yc/Hj35bx9SA23BdRzMALpDjSmJnM/6Cb0w8w+tasQGmcU
	69eqJ8fc+nXdcc2rq4VgDW7/gBGUPD9Jer4+KSon34zd2rzklEho+MUXGJ8UVR8PDC0d6Ac+c/5fM
	5gz3UW+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6lyz-008fPt-1d;
	Sat, 25 Nov 2023 06:17:37 +0000
Date: Fri, 24 Nov 2023 22:17:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: create a new inode fork block unmap helper
Message-ID: <ZWGRgQB1SYiU9uYR@infradead.org>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
 <170086928423.2771542.5465422173713890786.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086928423.2771542.5465422173713890786.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 24, 2023 at 03:55:30PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a new helper to unmap blocks from an inode's fork.

Look good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

With this __xfs_bunmapi an be marked static in xfs_bmap.c, as there is
no user outside of it (and neither in xfsprogs).


