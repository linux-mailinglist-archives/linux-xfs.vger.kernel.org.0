Return-Path: <linux-xfs+bounces-4-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3E3E7F583A
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Nov 2023 07:32:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DC09281780
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Nov 2023 06:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F186A15AC7;
	Thu, 23 Nov 2023 06:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WNGrmFBr"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3E41A5
	for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 22:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=b2NNgstJhJZV54tE0dsZMgYcHhYgVFBN5e7GvDqvxYU=; b=WNGrmFBrITVJNzsQiUbWndD2sk
	dC7cOp0QTLYbbN8ds208dj28yGeLPlCGyc9aTY8UOQrSOUvyTdrc6HD1AqTYmfxgKiyU+mFidrP4d
	gkLhlUgCeB0GfxY4BOZyAchQ9n2nQLE/4gU4tDIcjj+ENVdftxJUZQt9CmplIWJDmv14g+0XimjxG
	PRTVE26UMOzrj4xHtwpo7PsCth+LcJ3d8+qCCcbMcxf0BQfylnnC3HSIJukhrtpijq5+0tj1Xf+so
	2q64gPy//ATyc158gg6jazYck+XL55t3Wk5u5MK75ELf1spyAaddrgITNKxZqQU+e2JEu1c4pr4rp
	GvUMBf/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r63G9-003ukr-2N;
	Thu, 23 Nov 2023 06:32:21 +0000
Date: Wed, 22 Nov 2023 22:32:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Carlos Maiolino <cmaiolino@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_scrub: don't retry unsupported optimizations
Message-ID: <ZV7x9QLxV/YliFaH@infradead.org>
References: <170069446332.1867812.3207871076452705865.stgit@frogsfrogsfrogs>
 <170069448029.1867812.17301472136475061729.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170069448029.1867812.17301472136475061729.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 22, 2023 at 03:08:00PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If the kernel says it doesn't support optimizing a data structure, we
> should mark it done and move on.  This is much better than requeuing the
> repair, in which case it will likely keep failing.  Eventually these
> requeued repairs end up in the single-threaded last resort at the end of
> phase 4, which makes things /very/ slow.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

