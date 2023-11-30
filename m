Return-Path: <linux-xfs+bounces-281-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 69A697FE885
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Nov 2023 06:12:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23343281F31
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Nov 2023 05:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC6A8134A8;
	Thu, 30 Nov 2023 05:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qnDEcjKg"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D35AD7F
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 21:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qnDEcjKgs4r1dfl9TJW9rEjP9L
	0f5kPLFoRPMGCRUMRP+v7lENaDAad8DnKAtB20Eq8X03Uh75xxCymr4qXT2XQMBGCvdr/Mo3vy5XU
	F3t9PstJM2FKZmXhSFZ0RYSso1kEcdoX3vDO52RQkEFEF2UvSPPXcU0QTLW5cM2Ig5JFq5Bt5ZDpI
	Ajl3ogNUNDpnap4YUXQOstQPGqUHOCdB/etx6sX9A6vtgXGxtUzVPf2S/IY7axd3NEObVsTWOptzz
	EKn6d9RnaT1SjplcKBZLSLrOPUS/AMI5GRJkxUVQ/VYTcAhjtEhbAnmK5g1hxvMnruwcBTA7lEhV9
	OigjOTVQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8ZLL-009xAN-3C;
	Thu, 30 Nov 2023 05:12:07 +0000
Date: Wed, 29 Nov 2023 21:12:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: repair the inode core and forks of a metadata
 inode
Message-ID: <ZWgZpzqZB5ZfP+CB@infradead.org>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
 <170086928407.2771542.9456327157299550315.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086928407.2771542.9456327157299550315.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

