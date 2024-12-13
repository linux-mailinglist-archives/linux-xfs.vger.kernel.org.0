Return-Path: <linux-xfs+bounces-16822-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17DB29F07BA
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 10:22:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8806188672E
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 09:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEFAC1B0F18;
	Fri, 13 Dec 2024 09:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DGj8lJRD"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965371AF0CE
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081750; cv=none; b=Gtm05NBFVz8o021oa7nO19jfJiQ/LEzp+CtXBrH+gSP5RFM4PvqfLGE1h4B6oh6ynrtFA8ehWmHM3un+T0h6/2qBneth8YGMBozpm6s75n750uTH8J36n9BB3F0IMW4+tqyjxDRvW0v31flcWJJ7pVuau+g4BePNxmZo92DR5yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081750; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t6rZYTeAm5Pu+5Rirb9D91PjdT4aYlgHvI4qGNlzEZ5JgA8rDv/bhFN/17sweC7uritMs9AWuEy/g1WUC6ds6sncqYnoylGYizTG9uIOdEmqOExEDwy+O07jGX2Ro3iWRS6LeodYQhq0te+CvOuVhbpZfg+esdWZnDWLVTZMm/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DGj8lJRD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DGj8lJRD7BRSiYFnDml0SUxyaD
	oQNGJTn/W98waj1rFLw9QTV9bRiJhZadt0ItBYXz+q3V/qYedRgTyrM4KUWsImG23DD4vCcdD/Jqp
	fqXxM9Rqdv305RKFGVSz5dkaGIWoC9YpOYBvse7bZ8nEjPsbt/5VymX2E1aLyiWYiOPS1R/lRorhP
	GkfSDdlCNAWd94MXGjlulD9r9Zio2tP4QRZqDUDK3tUAeTU1mLnoqBstWyIUobQ3a4fR2GpUgAvrJ
	U7APK9yjcqGNowd+dL7AlyoClSLgDJZbgyao0FOa9jJ/m5h1fl5ygznG7Ttrb94BTfp/Ps+8VOFZd
	CGlfOWaw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1sT-00000003Elu-0G1r;
	Fri, 13 Dec 2024 09:22:29 +0000
Date: Fri, 13 Dec 2024 01:22:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 40/43] xfs: repair inodes that have a refcount btree in
 the data fork
Message-ID: <Z1v81bqd1_2BgZx7@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125252.1182620.17852915977168175150.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405125252.1182620.17852915977168175150.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


