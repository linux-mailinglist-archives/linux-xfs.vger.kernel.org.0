Return-Path: <linux-xfs+bounces-2629-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BBCF4824E2D
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 06:42:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D6001F2303E
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 05:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FE851DFD1;
	Fri,  5 Jan 2024 05:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KiPBg0uZ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A741DFC5
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KiPBg0uZt42+PJS8n7fBr6nLwL
	jr2bJFqyYD2vG7FRPEkbZoV4ljfwssNPSy6qaS+KFBfXHNGazIXU5xdOWTyMhExXWyl2CwgsIfYGh
	b/AGVzvJHT0xrG1oxhx4jBKlCGoeexopUyD1vtZHn5npXAp7Gye4XDntZPPz8VCGxq3kxkXvLMYvL
	tKMC23Tp6B5TYHon+LCBv0EiSsJuuINaBtYihGM64iMSAQCEneQ1x+4+R9YD8KQpf30sFW8/+yWkY
	rSmywK1MCjqUojni0bVFwamTyg4ThFqezVsHdUSXl4zXu10fnMLmdXAYKCTGvyIsoVM5M1xLsgiwG
	UALnTI/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcyX-00G0Cg-2C;
	Fri, 05 Jan 2024 05:42:33 +0000
Date: Thu, 4 Jan 2024 21:42:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] xfs: separate the marking of sick and checked
 metadata
Message-ID: <ZZeWyUgkTU10PAeD@infradead.org>
References: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
 <170404828297.1748329.1404672108438664305.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404828297.1748329.1404672108438664305.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

