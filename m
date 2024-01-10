Return-Path: <linux-xfs+bounces-2640-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A6EF824E3A
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 06:46:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9AA7DB22ADD
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 05:46:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3274566A;
	Fri,  5 Jan 2024 05:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HN34sjqm"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90CF53B9
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HN34sjqmAyo2874keEgQF5hmX6
	QkgTsmgwlyc4aCEZ7I2cSFU5N9mkBAooZyWTXNdTvcTlulSmesYXj7Gf9Zk3rsd0JGDc/uzBeL0DG
	SUsa+SUEgJrvqACCdQoVuOQQI57ak61mzDMOLfSA7hJna9hMXuyVYQ/IlaWzoPe9rod795b1CGVhC
	+IJoZaOy9sFepxqARzvB324ezmjl0NS6eHgFs7F79BhYE7ud7rFHKDueTVB70NesuV/VoPecnz71z
	8Sk8yGo3MhvQ04jhdgPTNda0ckD0S6QsBCz8daoJEF6X+u9hkwldkGmH89lL9vzhjztO1NJg0OWKn
	Mfthu5eQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLd21-00G0QS-1Y;
	Fri, 05 Jan 2024 05:46:09 +0000
Date: Thu, 4 Jan 2024 21:46:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add secondary and indirect classes to the
 health tracking system
Message-ID: <ZZeXobMLuBMhb9yW@infradead.org>
References: <170404828806.1748648.14558047021297001140.stgit@frogsfrogsfrogs>
 <170404828829.1748648.4029931620882730072.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404828829.1748648.4029931620882730072.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

