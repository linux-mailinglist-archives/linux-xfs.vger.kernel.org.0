Return-Path: <linux-xfs+bounces-280-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6028D7FE882
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Nov 2023 06:10:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77FB91C20B77
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Nov 2023 05:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D35F3134A8;
	Thu, 30 Nov 2023 05:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mIiims6S"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7184F10D7
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 21:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mIiims6SbmeG6GpqB6xKPPbzj7
	4I9J0S7WKUOgP88OYVQLMdxDRs6auH84tDt3Wap44rV8h/AtDB9ZkcwL4XSBo4tMS2X1ozOW/vb8n
	RY0YZ4q4DF+qxcOmnale2KMSDGf2bxvuavMRYloVeA1l0O3ULVTU6QLA76c59DXIKKXQG3aAUeqHi
	K0YFlflOKe5rXiFMuNn/mAe+ky3YqyOfO2V/2JHbiRMeR9B5j4f4hQEAT52EEg51dmqBu2ky2dB72
	duVnrwVlWvXlx1gTdzmbftzm8cfGuffgYV+v90fpLsDc2KsTYD1uYc+TobraZ7K060lGqeUIeCitS
	uYKtLoTg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8ZJs-009x7F-16;
	Thu, 30 Nov 2023 05:10:36 +0000
Date: Wed, 29 Nov 2023 21:10:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: repair problems in CoW forks
Message-ID: <ZWgZTABZYWmIXogi@infradead.org>
References: <170086927899.2771366.12096620230080096884.stgit@frogsfrogsfrogs>
 <170086927990.2771366.1771440587476913997.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086927990.2771366.1771440587476913997.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

