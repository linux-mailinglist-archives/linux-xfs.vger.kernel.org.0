Return-Path: <linux-xfs+bounces-19293-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65A85A2BA57
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Feb 2025 05:42:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 043DC166AD1
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Feb 2025 04:42:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10EBD1A317B;
	Fri,  7 Feb 2025 04:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a6sTmSSp"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CBF154439
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738903347; cv=none; b=fN/0VCBYlVZsD0CUrENLG0PUUPU2nKjCbtoDB4puk4fYWz30NV0VZEabg9sVfuUwyZ9MmU9h3uhaFAgUNZyHNOCXQqVfK7eAGSoHINBUlZesxsuB0TNi0IInSbF34rgYqe0mTuGDnkHPwj7YUJDrFx+bvSGTLd01GZE+bQ5jsdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738903347; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dsgWELJ5Ez5ZwJplvmcekrphwOtKmoEUAMbPBTatt038rWkoXHVLSRvVzFHxO2amz6xrvpgJ/Gf4ffrgxe0GTpZEVADVgmEUYjVHfMxtuOban3TXIirxRit9mjwnNAWm4D8trCjSUCBJSNhUxdsiAvAG7GBLwkFKEESBtjCSK2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a6sTmSSp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=a6sTmSSpF0NuIdVVVuihWgfZqp
	O8cB90XRMDa1lRGwIEJ3QZlkVRvPoZmFQkeNnmn9P8PSiz20OLN48cVn82Pn8iV+Z8wQ7ksOtwNDZ
	cV0SmNqXq+6wqvLWJP+MD9h2aoLcitN9cK4MXyGL+jy7nCdRWfRJoeG42bhhYsKMKQvcIxDkDlNDW
	AdkSeBkzn+FpQKlId1zfCNjtuVuJJatDrgg/9vvJd4lKRDNMJGLI8Ag4HeRyM0P0YBUiA6uk6oxuy
	JnxgmTgzfmlm85Cw275810Y/bLWwmH7Z/ZK8jiO3hRqOrCoIBc3so+rF6hltLaicXsE1aaBsp5pVy
	wLuBjKEA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGCA-00000008JJK-1FKM;
	Fri, 07 Feb 2025 04:42:26 +0000
Date: Thu, 6 Feb 2025 20:42:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/17] xfs_scrub: don't complain if bulkstat fails
Message-ID: <Z6WPMhVXERpbbPz7@infradead.org>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086244.2738568.15432642060089262298.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888086244.2738568.15432642060089262298.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


