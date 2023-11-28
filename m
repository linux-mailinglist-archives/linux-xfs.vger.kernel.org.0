Return-Path: <linux-xfs+bounces-176-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 851F87FBC0C
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Nov 2023 15:00:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA963B21642
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Nov 2023 14:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0587C58ABE;
	Tue, 28 Nov 2023 14:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aLxtLjTx"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143B910DC
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 05:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=aLxtLjTx6Y+EuwmKn7Zz0X729X
	w/2OdFYDheugjSVjc1pYjuUhQgCQDE+kj7sKq+qFppw7XrPnca+fIYghJXOTC5OsqY3ESlHgVd8Y8
	LLCRpP//yACU3ppbkZsshhXmsJpctSLnXkmzhtyEaMW7yHcF/kntgnCEzws5VzTNOrc0P1A4bYejM
	LrMtRUqvozr1vT7K3LrOFUntJ5h8Wtxyf9L0ecAgt4Y1NsIO/4X92CcLq3OnS9NRVisJJalRhrOG5
	IFhc5i61s6p2gHZwz+2hHb8PmmtbbG78sxV3SBRm7gt8meppONiZf0b0OV47pc1TNfOTdx5OBzrXy
	ZT0LxWlw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7yd3-005QvJ-34;
	Tue, 28 Nov 2023 13:59:57 +0000
Date: Tue, 28 Nov 2023 05:59:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: create a ranged query function for refcount
 btrees
Message-ID: <ZWXyXZXpMWefu/rU@infradead.org>
References: <170086927899.2771366.12096620230080096884.stgit@frogsfrogsfrogs>
 <170086927974.2771366.8544773411756027840.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086927974.2771366.8544773411756027840.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

