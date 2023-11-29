Return-Path: <linux-xfs+bounces-242-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D7C27FCED2
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 07:06:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EEF41C210BB
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 06:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4375CD2ED;
	Wed, 29 Nov 2023 06:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xmQuD9Tj"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7781BD6
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 22:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SJqvfHOcfxzruKxUVEvDjubCiGzr4kGC4GFfPJ1l9Kw=; b=xmQuD9TjzROTER1tm+JFpiBYdP
	NW0S2vHR5Mc9HjpAmg8ctqqKYuPGBB7oZQQYaT2K43J87QxH0hTcM4Zn/xh/gu0HoJDYw+z8NLNmk
	qRg4kJy1O5KLwWerCB1rnA1cIYqF63SXZ7Rz07WanDOVHWOmDkvUnHaPZAJnlCo0inTQa5UsbnwUP
	AYnBrEOHk/bu3nqdhh5Q6gewGAUM9mg3vHMM6SXd6u7kMEmRbDAP/g5QEswfpMhwKNqzZh0jzeQIG
	hJU4Tg7hOAVtPVcfiKFe1sxC7yZAvLjh/UpWL/b58AfvvEPSp0Gt3BnMwE8iD4WVxMT2jpZ+B0Sjm
	xUqu3kGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8Dhl-007B9J-2Q;
	Wed, 29 Nov 2023 06:05:49 +0000
Date: Tue, 28 Nov 2023 22:05:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: check rt summary file geometry more thoroughly
Message-ID: <ZWbUvcVIBROrHVOh@infradead.org>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
 <170086928377.2771542.14818456920992275639.stgit@frogsfrogsfrogs>
 <ZWXzvNHCV6QWeikg@infradead.org>
 <20231128233008.GF4167244@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128233008.GF4167244@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 28, 2023 at 03:30:09PM -0800, Darrick J. Wong wrote:
> LOL so I just tried a 64k rt volume with a 1M rextsize and mkfs crashed.
> I guess I'll go sort out what's going on there...

I think we should just reject rt device size < rtextsize configs in
the kernel and all tools.

