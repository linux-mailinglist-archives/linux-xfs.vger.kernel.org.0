Return-Path: <linux-xfs+bounces-83-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F3E47F8887
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Nov 2023 06:52:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16F04281A83
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Nov 2023 05:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4E84433;
	Sat, 25 Nov 2023 05:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vmPcdxKh"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E538170B
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 21:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vmPcdxKhRxDI/XHlgXLrfFXVPO
	k6FzXMhxftGPD4gxhP8AWIqnrQXyIlhw4/PDrw097UBxDysUcobQxqrVG0wl9X4TaOvOCdIgoREAA
	EK/rr1kpmW17T2gt+3/zHfupt0DXMMChr4b3InpHCnVzzMvzhDVQAgcj71OCRV48iYS7J1bwEbnYT
	lQvqFnhmkSk3mONuASpvYsAtZ3NhOLwiEadpj/Q/Nsb/fJaf0BMYcTIFFy1bd5DcRPyYqbnNMr5yF
	BpaoeZGI3FIRDTXhqTRhKGXrbjvufuyEg2DdU5WR8imq3kQO97Eq1H2PkmYSuvqqCN2PLXDYSiXh1
	6TMsxV3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6laB-008dNa-0q;
	Sat, 25 Nov 2023 05:51:59 +0000
Date: Fri, 24 Nov 2023 21:51:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: move btree bulkload record initialization to
 ->get_record implementations
Message-ID: <ZWGLf0cedDVxm64t@infradead.org>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
 <170086926625.2770816.4294476046504213562.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086926625.2770816.4294476046504213562.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

