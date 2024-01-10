Return-Path: <linux-xfs+bounces-2607-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A0C61824DF1
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 06:04:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E3151F22F30
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 05:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F415250;
	Fri,  5 Jan 2024 05:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lyg6LgNy"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82DA5228
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lyg6LgNyKoZfCvOVCQImF+OnKb
	T/GJvdfg4zb1yuoCbNxrrlWy6+oJNU+jOBxK0XGMwmXA6/yhDQ0myiQ2Qdg0u5Lhhlc4AhYPSkKaV
	si8Xl9R9KhrOAeMxzHvRB79vfMPQT7ZD4UMxBOtUroqnf8t1zoHCrKc1XZjfDsY7lITkFHqRTzOYT
	PqomB8NM8WCM8BfJ9wsP3exQUU7uGD7XRoZofC+ZwLFsJtYSfIcpf70T1PqSR3W9tY4bTuyLKcZsf
	3VMr32fKbv0KL4VmR5VJS+qRBBURaxykHtOVz2DKq2jO+RzvPBvDD3EG/ljDaFAkRANpruIjtJNsp
	4zmyDjng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcNI-00FwtO-14;
	Fri, 05 Jan 2024 05:04:04 +0000
Date: Thu, 4 Jan 2024 21:04:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs_scrub: remove unused action_list fields
Message-ID: <ZZeNxPkzJr3vjnk2@infradead.org>
References: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
 <170404999565.1797790.5249264048650632926.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404999565.1797790.5249264048650632926.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

