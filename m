Return-Path: <linux-xfs+bounces-556-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40BA280808B
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 07:10:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F06AF2814DA
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 06:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3A6412E41;
	Thu,  7 Dec 2023 06:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P0RzGclh"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BA4D4A
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 22:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=txEUS6Y96ff3eRRoRNY7MNWlfgQD/PNyIq0pRwp7XMo=; b=P0RzGclh95vVDVYIFxn2E+N5zS
	aF5S0RVVemx2kgaQb1sHZjpjZh38i5DNpDIwRu2gRWIRYvd6meVQp5dNz+pc8y8Kq66RHlN9iHSKx
	BjjN1ymApSlsxtEr5hTsDfZDJ3VmHrgH34r3OWwIfPpRpBE4tIHAfG2eDoze1TFWSmEgfVyXSrgP6
	hBFWxd/0JiDD3H2kMMocwJqcBG10pN3KNrEfaMScanEewqxXHXPuA63pHzvcjpY0GalI3emJTD4yj
	sNOb75iTbPVEoZB3VRy9f1pRKrsZjKGwJTi5AKvcZgujo1xn/auyomzQK7E6mbSFVjapa4/K1/Rj5
	//DTxCpA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB7aC-00BxHJ-11;
	Thu, 07 Dec 2023 06:10:00 +0000
Date: Wed, 6 Dec 2023 22:10:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: repair obviously broken inode modes
Message-ID: <ZXFhuNaLx1C8yYV+@infradead.org>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666254.1182270.6610873636846446907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191666254.1182270.6610873636846446907.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I really do not thing turning an unknown mode, which means potentially
user controlled data in regular files or symlink bodies into file system
metadata in directories is ever a good idea.  Quite contrary, I think
it is a security risk waiting for exploits.  So for anything that takes
an unknown inode and turns it into a directory or block/char special
file: NAK.


