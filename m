Return-Path: <linux-xfs+bounces-2495-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 135AC8229C9
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Jan 2024 09:53:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B303C1F23DCA
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Jan 2024 08:53:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 188D5182A7;
	Wed,  3 Jan 2024 08:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hfQrnoSR"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC87182A4
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dXWGgo1NoUPSogDBR/bk5SuA4AEpQTTkRtHCZ8p8/ic=; b=hfQrnoSR0ztatV7X99xBF1TUC1
	laYHPNQmXc43Z/7b258nf+etLfjlnnmm1/VGuPeO0FKDQjYgxmrJ3M6BEbvfkqaz3ZnfARPCFj0JA
	64Jcs8gxzjkx4//MZ5B8X22wu53zk9OGAQ2mW3Dq8Ik2o8DVN+OELaqNWyFtyGafc69U7tI/9rh9X
	Mc56WA6EXFpIZbZUrqvQX9nC5lTj+SzVv/yuJgKsdhXTMmsz1C3Yh0EwsjdOnuLijSNng4CrKAVel
	x9qVRDYaRgsxbuMYmsyJ55Kjl1V+/fIFCuusggoumbMa7Ovh4/esWLKxNTwXVD2rqQ0Y2zuJ1+BCn
	uN344w9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKx01-00A8MY-13;
	Wed, 03 Jan 2024 08:53:17 +0000
Date: Wed, 3 Jan 2024 00:53:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 6/9] xfs: consolidate btree block freeing tracepoints
Message-ID: <ZZUgfWT3ktuE9F5j@infradead.org>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829675.1748854.18135934618780501542.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404829675.1748854.18135934618780501542.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:15:07PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't waste tracepoint segment memory on per-btree block freeing
> tracepoints when we can do it from the generic btree code.

The patch looks good, but what is "tracepoint segment memory"?


