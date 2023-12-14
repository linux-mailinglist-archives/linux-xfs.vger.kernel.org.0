Return-Path: <linux-xfs+bounces-740-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 04E158126A7
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Dec 2023 05:45:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A32A31F21A76
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Dec 2023 04:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA1CB610C;
	Thu, 14 Dec 2023 04:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JumNBhjt"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3950CB9;
	Wed, 13 Dec 2023 20:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XU2rccOahRLzDkCLAoEKuJ26+t93oe6q2nojHArTaoc=; b=JumNBhjt1W/LCuuUGJtM33Yyp7
	/2999VrySAL6BZTloLACM5REIg0DM8gaj7rNTrsJT/6VYEs2xIGHKXX84T5xIqtA8UDCvnoUFbeft
	GmOykY/p83ibz2/CuodvFlVxlGLm39YKk8mWKuHEUfdMp6JOfytGFK5vXJoHlpHIulXs4TcGdpCR6
	/8vhn3YXUtIHjfYx/3YroqEznNHOMwDz+0pTWfqs0ND3VZ4h4AtyLqzDTuwcnKzJHhI8saxuR+7QL
	nu+SdI/01LeT2DjJRrFioFluNuDOczo+125UPlUFCFzPMRAbRctDSRjCfgNikCP49vjeWi/AR87vC
	zAD+NiAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rDdam-00GjPt-22;
	Thu, 14 Dec 2023 04:45:00 +0000
Date: Wed, 13 Dec 2023 20:45:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, guan@eryu.me, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] generic/735: skip this test if we cannot finsert at
 pos 1M
Message-ID: <ZXqITPlA6cmrDdON@infradead.org>
References: <170250686802.1363584.16475360795139585624.stgit@frogsfrogsfrogs>
 <170250688518.1363584.11932716959963736458.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170250688518.1363584.11932716959963736458.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 13, 2023 at 02:34:45PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a _require_congruent_file_oplen to screen out filesystem
> configurations that can't start a finsert operation at file pos 1M
> because the fs block size isn't congruent with 1048576.  For example,
> xfs realtime with 28k rt extents.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

