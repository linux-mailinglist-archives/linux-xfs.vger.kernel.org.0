Return-Path: <linux-xfs+bounces-2631-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91173824E30
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 06:43:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D91D1F23197
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 05:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C394566E;
	Fri,  5 Jan 2024 05:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mW/zjAwz"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D278D566F
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mW/zjAwzi4x7qHdeMcXo2ADQmL
	r0Au1lWj3xu4YAv7AAh2WUpQuSQeGyVIF8M7T/oKybcdi9MBFWxVNWSwURS1LdYCX0kQuFGC4dNxp
	AQs232WtuQUsqfrokpm3f4VWYK2B6Y1Fzpy0csSLdZzjnOi5lzpN1lfpRATgsvDiWhsgGToPg2cpN
	eAXVhokYC2CRTW9IhOOK3nKV48u7rqtVv+g+fcHENMw/4QRgROzls8IBU0EbHb/OoPeGRp+cUV2Ew
	Wt0ydPH6KQM8UAKNNPtjHCflFAnfR6jmj/q0BdD6IV3Xm/0nr0ah48wopehw5Bc+rAUDgcr3e3XPz
	SenZa9eA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcz0-00G0EC-1V;
	Fri, 05 Jan 2024 05:43:02 +0000
Date: Thu, 4 Jan 2024 21:43:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] xfs: report ag header corruption errors to the
 health tracking system
Message-ID: <ZZeW5u9FwrqUjaSs@infradead.org>
References: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
 <170404828327.1748329.18041979830979155947.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404828327.1748329.18041979830979155947.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

