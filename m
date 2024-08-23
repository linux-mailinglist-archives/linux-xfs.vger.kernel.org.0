Return-Path: <linux-xfs+bounces-12107-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3610295C4CB
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Aug 2024 07:20:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DBB371F25D02
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Aug 2024 05:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC2C44D8B8;
	Fri, 23 Aug 2024 05:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XH1qs9ef"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF9C39FD8
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390408; cv=none; b=DkZtul+i+L22Ys3rQTBquJiNT2maVkFuIffmJw0AmYeqcI5c0SDHLlppQFG6sfje/5qJm0cFGtFRflnqIhW1tsMpciSR8DogLXmwC/G4XCbQOus/+BbpYfvjGs6kp166UzBDTLj2btfuDO7DuzTohBd9NJT2lLYc9dg/9Or26RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390408; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qi5FSf7WmvBTD1+dZJX4d5ItddzLmtDVnDHbES+Z2rYIVaby6HG4blT1wQmxEC6c4+3uNRZO03pR7H9vLbhaW3Ks55lyV+U6E63PsHUlQJPY+/OqfVfSiTacWESIhPHVG7LJVtvgVTcD6DgZpUbZrQrkpez17Epb7CPQ8mlUS78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XH1qs9ef; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XH1qs9efBeTRJR2xX9wUHy+hM3
	/lfRlZEuJ6Ky4ICUWYNcnzpgYkHPaPM++Dz9XmucUEnoVHYiGDJq12EENh9jEenCBVonMSTZfe6xg
	3yooL/S2lSdWPBXpmnVZ0eXQe2ylSIleAXlcwmc7oOWAyS4+zbgempK1xI4Q2WBSRGSWrwNzTV2Qv
	uTsU+YWNi1cgxkLMuJs1fRK7JdaACdXyobFNwsCPbMCbKkkG1VZZVhEUaZbDrNBQCfEZ5sARY0eDA
	GQFW2wOS7DiLZi42SQKqATL5x5CvJM7MHmWOK5tF9idJLoq5OC84M3diOhjMv7CxY9eJqmm42Z0yJ
	TR6NQ3VQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMiV-0000000FHts-1Fdf;
	Fri, 23 Aug 2024 05:20:07 +0000
Date: Thu, 22 Aug 2024 22:20:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/26] xfs: scrub metadir paths for rtgroup metadata
Message-ID: <ZsgcB704qWPDY7AE@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088956.60592.4570792855287818081.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088956.60592.4570792855287818081.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


