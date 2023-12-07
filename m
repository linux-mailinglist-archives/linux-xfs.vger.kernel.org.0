Return-Path: <linux-xfs+bounces-544-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0742808025
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 06:27:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69ACF1F2130E
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 05:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A19C210A02;
	Thu,  7 Dec 2023 05:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iQi9yPFy"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE408D44
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 21:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=iQi9yPFyF++TEgtSNhNPMr3WKH
	rd1+pLymryfusD/xVr7FA79VcsSqyENoqy5pUCu1DBc19pBUL8JTmrQNHU7eZcob+GrdwV2yjKywx
	o3ZnQZvHr1oBfrLeSuiq6hTztLsKdb94C74WnTkZ+7NpeZWTzN/NVe0/XY+tgnXzX/wa3TZRRabF3
	zMWPR0kPOmItccVRMio+PpRpH05klRl6iCz99rjOP4kHpgl0Ox6YnKEwsFoLWNL4KlvMDALWWIK06
	k3e2UsfSNtOqXUo3L2WVaAl0t45jFaX9JI6hMTpwW/wC5FgUD2GFFRcfPrKbhccTqW+TNkphXRsU3
	K0qagWUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB6uy-00Btfs-2l;
	Thu, 07 Dec 2023 05:27:24 +0000
Date: Wed, 6 Dec 2023 21:27:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: constrain dirty buffers while formatting a
 staged btree
Message-ID: <ZXFXvP+HliVX7qyu@infradead.org>
References: <170191665134.1180191.6683537290321625529.stgit@frogsfrogsfrogs>
 <170191665241.1180191.959265790041993224.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191665241.1180191.959265790041993224.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

