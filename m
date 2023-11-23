Return-Path: <linux-xfs+bounces-12-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E8B57F587A
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Nov 2023 07:42:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A19A281791
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Nov 2023 06:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F0FF125AC;
	Thu, 23 Nov 2023 06:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2UP0PQ40"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B514112
	for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 22:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2UP0PQ40V4BaYWY/FnDRWBqLts
	Al03s1C54FLrEy488ZX4sEdv8JsfMuBFah7ABzZlL1Y1qJHxQI5qvjQ3rOCgPsUxeXRJRLlK3tmE1
	bocbTnWBnFx6W1q0OYuR/k1HoegVZAlecF+Zfr7bTZtqAQItj1rSboTC8RZ4DFXudCVieNCELgHiW
	LLR7rtrGy+hcaKWv49dJOuLQeGWZedMV+fLSnD35vHIQXKC5mogKt3Ds1j8xzsiSFOr6Fg9uOe/+y
	X8wfISTq8bbVNQWEPbHt/w35iZcOkC4uQLKcdjiSFVGBdpVJxB4vO7SYtG11htYoZM3MK1Anj3O51
	OC4COJDQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r63PL-003w19-1g;
	Thu, 23 Nov 2023 06:41:51 +0000
Date: Wed, 22 Nov 2023 22:41:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs_mdrestore: emit newlines for fatal errors
Message-ID: <ZV70LzVIM8NwnWY0@infradead.org>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069444804.1865809.10101273264911340367.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170069444804.1865809.10101273264911340367.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

