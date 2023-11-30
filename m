Return-Path: <linux-xfs+bounces-294-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5210C7FEA3D
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Nov 2023 09:11:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D65ADB20EB3
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Nov 2023 08:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B05A02111E;
	Thu, 30 Nov 2023 08:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vtwDxb4j"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87C0A3
	for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 00:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vtwDxb4jKM7/NcIwSlIz24xprI
	bSlB5LjnS/8pICdGN9tEIK5eTQgvs9bDMDjkTB4LeA7SEG249X0skMxwG4V8mh8eKDSgFt8shhhDN
	iRJr0MKGsbPQ4XEwCoutWKdwZUjkwQEwNXcdcZF9Zum9cJ+nHSJkY7qLAl8pzn6jBt0gwSb/bLmIo
	NqEhyYZmFSv+b4kHpI9ap9F/IE3PazWYEoY16A5lbXq09R14YBWMLI0aDTbvpKrpM9Z5Mzx2JFXoH
	6vvBsuQSNsfhYAbgKH8GfmRgYt1LGz87CK2aTJv9pvTSn1nDa1EDQ+5TzlKo5o7I2FwU3MXPmN+IR
	d0QeyCMQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8c8h-00ABHQ-1T;
	Thu, 30 Nov 2023 08:11:15 +0000
Date: Thu, 30 Nov 2023 00:11:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: leo.lilong@huawei.com, chandanbabu@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: move ->iop_recover to xfs_defer_op_type
Message-ID: <ZWhDo0jOPA2+R32I@infradead.org>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
 <170120322874.13206.13311055647910298715.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170120322874.13206.13311055647910298715.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


