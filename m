Return-Path: <linux-xfs+bounces-19528-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A757CA336E7
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Feb 2025 05:27:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 24C4B188B347
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Feb 2025 04:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24090205E3B;
	Thu, 13 Feb 2025 04:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ieh2HIIa"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCDB205E2E
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420869; cv=none; b=AxL2S2uXaGpvx19y3+zvpIurREBzepUedTR5/S1LiE5OtGGXTnKO76jneHlcQ5wJo+BpZ0OnqnQQWw7GmAJmdLW0KXpqQpSMjF7lotGQ9ZvSistXpwOh7BnII1Yb3dgfH1RAfy1x2B2SJmqC46eo5rjKXjAgPu1EP/A5y9gBuVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420869; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pa3fjMw31xt08zMwdHHxAC+lQ3d61IcTD2pCiTCexkxKET+9BGMLJ2pDqTsLkydGtG8YacfL1Gcc/l/36CZmU8bD56sPHBHbA3wy6r/o2kpRb8peWySOnayZjRLhxwUvnoINy4h+raaKlNTtl++mTcR5ZLNdl933nc2FLRhIF2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ieh2HIIa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Ieh2HIIaeS2a2h6+wmjKI5fnQ+
	/ODMT0bTrGJ8M4RjyS2ApeHOHacvBVcejyaAv5uvf/Ex7OBB+4VDe79a8jcq/hlSMtRXlVQzBrKQ5
	+jD3pvc2Ckd+efGb3x8t4w0KYprAofYSM2x7YFxMDp5iawUe4mZziGgYI/8HrPPDjyo4NcFneDm39
	ZQg+QtPJ/gpEHMEmYSThIEBwBK/yM304Bxb8bYZb1Rk5CIrXGkp7L2hELL7qjHbJ43pWe29k6gaM9
	8BWYGJ/CjZNukOtgMpWQ2c3bpVgOhJXA96j3dwAyfeTrhO/39+1a9srLfYiJz0ObYHEJ+CpIh22CQ
	o/ixwpJg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQpI-00000009iR0-1tgg;
	Thu, 13 Feb 2025 04:27:48 +0000
Date: Wed, 12 Feb 2025 20:27:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/22] xfs_repair: validate CoW extent size hint on
 rtinherit directories
Message-ID: <Z610xH_bwpBAr-63@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888089222.2741962.6290838942184793559.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089222.2741962.6290838942184793559.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


