Return-Path: <linux-xfs+bounces-2639-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D20824E38
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 06:45:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C3D11F230D3
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 05:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 014A05680;
	Fri,  5 Jan 2024 05:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CseLrrMU"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C04566E
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CseLrrMUUWdqO6eMSmLvxUL9bA
	iFKO6w5pbXv1f9e9y/pVDRrPQCorCey1cF3uNwxaRGF8+IQbcTO1lKEQWNWHQCtDBK2qMKYX7VKvo
	hU/PrSbTq33hZiyfQSLP15Q2Zcls8So/53gtkBdIu84PEdHr9h0H8gimq4vJTLvy0jxsCQBlFCO2/
	qg1jbyC4RLHXyrnH6DCLrpw6eeP6ustY+4HUykawQVhxuedZQf/XAxxHXcnd0Cl/6luhpsdX+oNKP
	/AGuU4rEOFVtqhSITFbE8XbPk+UvnO/GmKH9rV32FgVJ4YNKC3JK5tapw6WTuN+m24rnqAeKcP1ta
	G+mAxImQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLd1E-00G0Oi-1i;
	Fri, 05 Jan 2024 05:45:20 +0000
Date: Thu, 4 Jan 2024 21:45:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: report XFS_IS_CORRUPT errors to the health
 system
Message-ID: <ZZeXcE/yoRYPIPwz@infradead.org>
References: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
 <170404828458.1748329.17550485294904147495.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404828458.1748329.17550485294904147495.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

