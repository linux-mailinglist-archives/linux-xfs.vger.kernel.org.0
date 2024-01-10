Return-Path: <linux-xfs+bounces-2606-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A62B8824DF0
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 06:03:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 559772865E0
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 05:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C0D15251;
	Fri,  5 Jan 2024 05:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b4FTANYZ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402675243
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=b4FTANYZRVXPIg4KwmW9rYHKA5
	zEk4wvn71i/w4iHOSVISlkNqT7wuRiGo4yzm9jrkBGTk7IY1NqLfpIlYfOkZzdq5EQU2rEIMcOcHZ
	SdTAywTRQuV2btc7HNZ6U/50XZ98F094joXksrGHyg2dTo0YgEJG0O86iLjCEF700H9XD4rYgOJpU
	hWlqi9ngLdJrKA59wC7wsbpgOx6WV6B/3JQ2eJpe5K/2/f9QgBV+GU8uSEROlXotr8awpsMVQaL7W
	AoqqE7eIWVkP0Ysh6WyPFG471wlW7GRONaLSmWPC6Gb3qk+3dUBQFpLtJ4NRQSHHBAR9XETbySgLZ
	eyVdzacA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcN6-00Fwss-00;
	Fri, 05 Jan 2024 05:03:52 +0000
Date: Thu, 4 Jan 2024 21:03:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs_scrub: retry incomplete repairs
Message-ID: <ZZeNt0ub8htXj5Vh@infradead.org>
References: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
 <170404999552.1797790.13157454061191356913.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404999552.1797790.13157454061191356913.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

