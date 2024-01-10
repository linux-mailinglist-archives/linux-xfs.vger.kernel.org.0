Return-Path: <linux-xfs+bounces-2442-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F211C821AF9
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jan 2024 12:30:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A09CC283196
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jan 2024 11:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14E1FE572;
	Tue,  2 Jan 2024 11:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0PUwmwy0"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7905E554
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 11:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0PUwmwy0d5i8LSNfmVwleqlvQj
	u+Rhzej0JPKEIpYM7SngjkaqdOumUBAP3qcRCxTkwVptvmbjA+5M8u2ab3zsqDU1V0SwdXk5jmV/n
	dg1Kt8cLiME7+ZRewpC3rNkb1aNx3g0JgVYA/XjvXXXLaa7eKmRyUw8VApKEwqMkhWqoHOuwSlpzi
	pca4w0veqLKoSyahDHqTsLzRUwbQ+sU0vX1ca6zSDGbVEZ7Lx88Fzsz3xszNutwLNJYNdk0smh75Q
	kdWmqNGK+oHMq4qFh8c7aN7zPIYkaeyGBdrrkYVqZvziKnQd/GC2pt5cuIvj32oaLL1vVVIe99AMw
	VoT9p9cQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcyt-007itP-1k;
	Tue, 02 Jan 2024 11:30:47 +0000
Date: Tue, 2 Jan 2024 03:30:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: stagger the starting AG of scrub iscans to
 reduce contention
Message-ID: <ZZPz52mO7bQvx329@infradead.org>
References: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
 <170404826587.1747630.14127937810498649989.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404826587.1747630.14127937810498649989.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

