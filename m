Return-Path: <linux-xfs+bounces-2633-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 06211824E32
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 06:43:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9CAAFB2297D
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jan 2024 05:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BCB65662;
	Fri,  5 Jan 2024 05:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zmKF4u60"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB91566F
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zmKF4u60QrrH0OK8i7BHLYI0gr
	pDWl7ievBakkvVRke+CDGtHE5N4iD5hBD2ryK5bN2+/f5frR05gAPFRKV15swpxYZzN67UKRKzORn
	b3xZIGRnNe1RC9F5Uptt6ai5+ZPRZc3hFAB3BlystDQeRKyVi+Bm+7UClYumQL2ZpfC8T/5wqd2OB
	ksNYjY2X0eg414fxOI0+SqajQYgWReK6mQHDxSZ2cs43ROO2YAwuqbzYKNECmMsQZf5U9br/DGVX8
	B+WHLkg9wieOEs7Jkdpah3lb2NioCPXlsMjEhzIrFtJh8it7UBYzuyMwj1UpONDN4iDW6/PAJ2g7I
	d0xR2hAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLczh-00G0Hr-1u;
	Fri, 05 Jan 2024 05:43:45 +0000
Date: Thu, 4 Jan 2024 21:43:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/11] xfs: report btree block corruption errors to the
 health system
Message-ID: <ZZeXEZyUbKAk4yD1@infradead.org>
References: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
 <170404828360.1748329.15413546748362572852.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404828360.1748329.15413546748362572852.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

