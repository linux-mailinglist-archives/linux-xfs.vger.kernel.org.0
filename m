Return-Path: <linux-xfs+bounces-2419-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28AFF821A0B
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jan 2024 11:39:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EDA01C21D87
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jan 2024 10:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EDDAF4EE;
	Tue,  2 Jan 2024 10:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ou5hwRIS"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553BAF4F7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Ou5hwRISnDVhrRt6qrGZaQwplf
	ruXaHcRNisNw4WElXB0/qfT9QUdzWgfW7p2umYtctZBRM39KbwSOVVLDwnDGGQ5cXPstC8cV2XSAg
	teBmpDM4NqnSKTbkk9QvXox1dT0OnaDVtC177UZzPKguMNzajBaQuCzuZbOwrH7kdxFBlvqo648ST
	xPb5rYldERDBu7YLaBQPryWSlIU/KMI+THPJjf57hE9gwcywks4a4F4+HNUZYy8FN15k2Zd/MNc0W
	fAS8p1damNh6xQg8w3DMC9+uno+Dz93P07zfYu/dCdID5tobMVObQ3w873P98mZR+Yu/H1roZfjUF
	a4GEHjzg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcA8-007cNV-2W;
	Tue, 02 Jan 2024 10:38:20 +0000
Date: Tue, 2 Jan 2024 02:38:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: remove the unnecessary daddr paramter to
 _init_block
Message-ID: <ZZPnnHR1NdxNH6ud@infradead.org>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
 <170404830626.1749286.10458122932703633490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404830626.1749286.10458122932703633490.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

