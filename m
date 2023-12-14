Return-Path: <linux-xfs+bounces-745-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7B658126BA
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Dec 2023 05:59:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DF521F21AB1
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Dec 2023 04:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC8465381;
	Thu, 14 Dec 2023 04:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M/MJ7Ix2"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BD6106
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 20:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=M/MJ7Ix2PwyQhVUUSMVCtPst//
	sDz5mYFp3MkueFHdCswCwssqtp5zzTww7Zy2uov5RDkZRyPggq44VwM2TfUJQRU2D33v9eDXN784y
	xcCa95zO/jJJYllK+ry9zWYfaWgKmG3cQj1Idz5aVxzasP4kzpo740K0QfsalBfbvblvMioidaBpp
	ELguIeqyUMjSXkrnAX6YArijNHotD7PU+TMjSH+REkG/toWdDtZYMLnYaFvgkyefmrVWoAHC+izOq
	c0EJvVJ/YF9ewtiTu8/+dTSZHk5yUE7ycv1jKy2730+BJkuxnG+gAnJC5F5jb3QF/tjCuE3zs7FKn
	UKhysuAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rDdoP-00Gl37-2Y;
	Thu, 14 Dec 2023 04:59:05 +0000
Date: Wed, 13 Dec 2023 20:59:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: refactor repair forcing tests into a repair.c
 helper
Message-ID: <ZXqLmbTwTbRfHbJT@infradead.org>
References: <170250783929.1399452.16224631770180304352.stgit@frogsfrogsfrogs>
 <170250783989.1399452.11806807344830362212.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170250783989.1399452.11806807344830362212.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

