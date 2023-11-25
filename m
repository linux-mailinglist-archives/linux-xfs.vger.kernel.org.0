Return-Path: <linux-xfs+bounces-90-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D62B27F8892
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Nov 2023 07:14:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74D09B212B1
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Nov 2023 06:14:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B956B4435;
	Sat, 25 Nov 2023 06:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Zzvv7K0s"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C161723
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 22:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Zzvv7K0sPJEcpE5zWNYwP5YF4M
	jhXsd9R5MRXMj2qkhDTTVlhjwYJHHxTa3L+2i3VYqO1uwePrHuR1uLza64nNh38yr75F3KGbvKA11
	q5fzNp2oM718F9hLvV9kqOylOnLECIeCGhcQsjIWhv8wCRfzcos5gfba+KXNhnrjT0lEN1zas912J
	d3fHGfwYucyOLQdhW0BfvL215jAqSrYmhuin+EcYm+vVppnPPn3TyF8NX/CkTo2kCiaFVCDbyzGpu
	twkxVehB+BRybCDmQjVNKy+R5dquknlRLuXvMBnes2c9BaCS8Pkt12RVzFj3v5TxZzDewZ0a+d8Na
	eBE67OlA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6lvg-008f6r-0k;
	Sat, 25 Nov 2023 06:14:12 +0000
Date: Fri, 24 Nov 2023 22:14:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: try to attach dquots to files before repairing
 them
Message-ID: <ZWGQtJf0IPIsECTw@infradead.org>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927472.2771142.3254084672776828738.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086927472.2771142.3254084672776828738.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

