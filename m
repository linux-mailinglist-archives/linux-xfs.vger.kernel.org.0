Return-Path: <linux-xfs+bounces-542-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB6D5808022
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 06:26:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 860301F213D3
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 05:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34FD710A2A;
	Thu,  7 Dec 2023 05:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JHHQQkji"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1134010D1
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 21:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=JHHQQkjipHRQJxZ05LOzVcDy7h
	S010rd3RKnihq73zT8aDpuozbEqHlhrkZbh3LbnQT8I+J4MkvHE2tmeUAxK9+dzHUUqf8eKLbcMa/
	VIagnXzakxNLoQatjj4wii1zUfD+K7FrWIqPmm4jvHz6i80Ri57o+RgBGKWbIgf4ikv3M3Y6FNAx4
	vHMftIBm8XTfVdG3F3J2vgKVNM3QaB0oq+oegb1/r9d6/mgHpq9yYcWdOU5GlINj1Fv2evQGMEac9
	jqbJ0rTbz9cORHCz6mTa/wWqBtLQwNfYUPy4gqX881kvxwsdZNARVY8iAzfivppi34gdol9aWMAnS
	id73hHPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB6uA-00Bta5-33;
	Thu, 07 Dec 2023 05:26:34 +0000
Date: Wed, 6 Dec 2023 21:26:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: read leaf blocks when computing keys for
 bulkloading into node blocks
Message-ID: <ZXFXikLEofQgHnnd@infradead.org>
References: <170191665134.1180191.6683537290321625529.stgit@frogsfrogsfrogs>
 <170191665194.1180191.14732920823825360410.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191665194.1180191.14732920823825360410.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

