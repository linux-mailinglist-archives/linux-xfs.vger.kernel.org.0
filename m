Return-Path: <linux-xfs+bounces-6475-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C033889E923
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Apr 2024 06:42:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF0C71C20B21
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Apr 2024 04:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDF0EC132;
	Wed, 10 Apr 2024 04:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KSxSSyn5"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9579610E3
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 04:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712724117; cv=none; b=D8KkhJVwPKBurP+/A1kvp+60ZakeSmtXteFQSS4TVoiZf3V4TuSVhipif/Hhwt25r48uARnx/v0eLgEHlMUUhtGzhdWMpW8O/0rsU2Ua66yWtc9QpHLRdAshv4MUsAYfT0DHB912lPtQB8f+vFQ998M85nXu6dZ1EUhGofO33+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712724117; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mjujvlDj2VBbH3Kz1ZLbddkJ1q+r0tpk4lW/Dg1PHqcz7x9Hxj6d9CVHiAEzAAzTt11oaXCyNEir13IoLs3ZWYNoEtzksPz/ZDbBV+sZuO9Y+YbzoslUaSEDZTCeC+4Kmm/nUUVWZQbm5a6dt2FVrcEytBgjvJLUuLMjmyPvO04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KSxSSyn5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KSxSSyn5UvxQNCbDEkOjNTJFPi
	4HsKcBByMRCL9Irh0CyxLmlllW+uWJgqA0p43+9VyPYwB9UI8eysuD+bhHplhplwNYLoqdb6l9BAx
	D1UeiaB9LJdmQOcxe9S/9hBablld5rVaoNT4JDN6Bm+KfFUKuc0r0gwnylv5/IwH3PTKyy7mHJOp8
	xtKrMYKD+ATA16+b4q16apy42Uii3r/dlFZv85myWaQr9YMnX2Z00b/7nvJV9b50oDIU5Az/GsPws
	yq3KiAzKNS5f7oHOvMO7MIvMNhkXTdtmzYRcd3MHy0Pd2BFnOuAQd1H9JFQ159sZDTTB7INSnzqqH
	ZAWMGHDQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruPmW-000000053n9-0ZAc;
	Wed, 10 Apr 2024 04:41:56 +0000
Date: Tue, 9 Apr 2024 21:41:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	Catherine Hoang <catherine.hoang@oracle.com>, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: Hold inode locks in xfs_trans_alloc_dir
Message-ID: <ZhYYlP0Mg4FY3VlZ@infradead.org>
References: <171270967888.3631167.1528096915093261854.stgit@frogsfrogsfrogs>
 <171270967972.3631167.11876713799653099191.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270967972.3631167.11876713799653099191.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

