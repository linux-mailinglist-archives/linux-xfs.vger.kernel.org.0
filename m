Return-Path: <linux-xfs+bounces-22722-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ACAFAC6429
	for <lists+linux-xfs@lfdr.de>; Wed, 28 May 2025 10:21:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CAA07A905F
	for <lists+linux-xfs@lfdr.de>; Wed, 28 May 2025 08:20:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47F9626A1BE;
	Wed, 28 May 2025 08:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="f4PSo7PE"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B959E253F3D;
	Wed, 28 May 2025 08:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748420159; cv=none; b=rIzxV0m/w7a+kExLn0MFajdkc5qOpMey5fyk2YMt3SJMS/zFYdoEzPivqo5jIDKMyznM2DAQrur9dqcGlVa9VvrDURYb/lNwU5iiWiYY/87hjh5X6eFckXQPJNHyw9Lpqy8TXT++mK2nk6hHjMXzYzu8YPU6R7MZCdyan88vJJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748420159; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YAuaF04I3If5RsKAgG8Ej9BNLTY7AAo2+GHR+3BYTMiFDUptiBcyR5UjFgFL0RLCPONn5JM3q6gFPoxTTe13zY/Twa2ugb+QkzpWKtCaWc5vlYRwp+QqJP1sHAmhzCLU2OOnbUm6RCj2fFCEXQ+TTwm9TDa3FFxD4LQDQhCs16M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=f4PSo7PE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=f4PSo7PEH4dhJf38fbDVnbnLAS
	a/DWAz0VsCwz0NrKRWFHFMjX96m91YAL4zzBpbsU1DtfG9+JTGVaTSsOAo8eKDHwd+bxrBChOoMt8
	hNNtfB3MWhMl88jtiqhyWPr1j19exvyqDsFULNEyhQ1ONfSXEyHRSrxWqcHH68uGECx0AdInhiZKY
	AxJj2Gr9Xp4XdzXm5DIlCkvRSqpJip4rcHx9xOrTSGrUk5QJHHSOLAGYBxo+paeV+s3BUQOdj021w
	1LENWtKve5OnpLBjp/t5HFCNICMCh1Cn2yPxcc6oO02WLr78Y4bhCveRRqZztWosb7cac/HW5OVTZ
	8YB/3o3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uKBx6-0000000CXWH-1gz1;
	Wed, 28 May 2025 08:15:56 +0000
Date: Wed, 28 May 2025 01:15:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] iomap: don't lose folio dropbehind state for
 overwrites
Message-ID: <aDbGPACRJ9D3aXp-@infradead.org>
References: <5153f6e8-274d-4546-bf55-30a5018e0d03@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5153f6e8-274d-4546-bf55-30a5018e0d03@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


