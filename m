Return-Path: <linux-xfs+bounces-540-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FF4E80801C
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 06:25:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3867D1C209B5
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 05:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3E5B1095B;
	Thu,  7 Dec 2023 05:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bxeH8sLr"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966C8D5E
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 21:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yLzv5SS1V3aarodncuW30mbRdofFaKWFDKz3pMewS+M=; b=bxeH8sLr4OBydKgMweirBIZcZm
	HphYJE2ixsGM1zMrTUQR4i7z8MsGCxRfs83W/fVa7z8kyv18zeBdmYTg+DMqP07k1TBArmH/z/NLq
	oihUCPYwRseYUcDuvcGKdomKlWbWQkkY9gZQ0exgoy/WGEJbcvCSP4pYLn9tGWILdEYtBa+YArAty
	/5SO0qvyq3suYMftGDq2BYe2tlb0Ub90qhU5XoemUNjE1mP1FhYq//oTBAZ9MGVKxdyCsdf7rl11s
	QyTXeGjoeDKPgCaziRpPmY1ltrDMZCjdWH0GHgaKI7ryYJQ1n+QtuQD21cqULDeILETE/u1QwrpIC
	RP0+09ug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB6sz-00BtSr-1b;
	Thu, 07 Dec 2023 05:25:21 +0000
Date: Wed, 6 Dec 2023 21:25:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: force all buffers to be written during btree
 bulk load
Message-ID: <ZXFXQebKwYci7Qtg@infradead.org>
References: <170191665134.1180191.6683537290321625529.stgit@frogsfrogsfrogs>
 <170191665162.1180191.12974934587540936095.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191665162.1180191.12974934587540936095.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

So as discussed last round I don't particularly like how it is done
caller dependent, but it seems to be the only way forward without
completely reworking the delwri list handling, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>


