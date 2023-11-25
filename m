Return-Path: <linux-xfs+bounces-78-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F2AD57F886C
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Nov 2023 06:05:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 956C3B21378
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Nov 2023 05:05:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A2A24433;
	Sat, 25 Nov 2023 05:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QHh8ZF7s"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CF31720
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 21:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QHh8ZF7skp9S2BskWqCWVSKwqt
	2oDcvxGXXQ7qjxWeLsuz8cOgcQdZXO0f0PHlbGzv31rX784j/5s1HC01xhI3QgosYvZIPOIup/pyn
	V67NOUcIEYIqehp2AP+GZTKqfjymQfPfvvEUPguG3JfJL0sZbd3RH9adRIGvFsLgG3q+7pnlxTIDI
	uogJ9ozUm7XJE6KVwPnTmXvvjocb29WD3i/huyrfaahZK0/0VVXamUp/PAm6Vj5s+NOEJNHDvg+vz
	5PORRP8qtzRbAAu1bIz2IvMqUPESpJ0pGnBjjI0fu7fsuM+xneFh60bySxos2O0Oy9ytn1g4jwh4I
	CMfRAIhw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6krG-008ZwF-2B;
	Sat, 25 Nov 2023 05:05:34 +0000
Date: Fri, 24 Nov 2023 21:05:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: remove __xfs_free_extent_later
Message-ID: <ZWGAnlfHhW/JsBlp@infradead.org>
References: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
 <170086926175.2768790.12526519062399034942.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086926175.2768790.12526519062399034942.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

