Return-Path: <linux-xfs+bounces-9702-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3B69119A3
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2024 06:41:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43BD6285410
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2024 04:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5EAE12C46F;
	Fri, 21 Jun 2024 04:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VXGmOfU4"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A998EBE
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944864; cv=none; b=LLc2x9V+Dq1zUgZhz8BnB0MzroWkWgfgYSK+GnPeCIctguSVrtSzCzxVVnouLbh1Fel5CRFiy8Voo2xhwX5FDLAD478woA2zr4hrUxNxxbe/J1Cm2Xl+fOhsIgQpZKyt+7AYSpaSwyXvv/8L4fu5UGb+pHaJYuNA3gbqa48RKzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944864; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mBb+ueTBwe3N7ZYnoPv83VVrDsJJf/tgDBSZWKZ30uJrRgYRpZ7os+HD8iRJB14/Dg+8+d2H3WR4fIMXh2PdLIlp6xAyo+vBXrR2mjwRcVBQfGkXLEZNrolfprZWXkSqb9eUgxxr4fdfpkMMrfUCvlynArpHXhW0j6VVb+E8XaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VXGmOfU4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=VXGmOfU4zDQaZ+UCEoxT+BgxY3
	lahm2aXiqD9mkfxPXy8pLjXZzW70vZTSNWzkP5RjrU1LZQmdRkEpWPKFJMYNZwmwS6T1brlI/RoMa
	P04vEb3IpbFcJmaobWfla1tQdaF35FwiQ8HHoIiUAoYVt4B/D5Y6ASU2SFy01cNnTrWqu8r0YB+cG
	YNAumzh/vtNQepEuoa8qYjD2gdwpUBEN9Q23Vac3qEmHXDuzp3siVyNkLbsYefRzPbYPkoC/S97JM
	a9pxad2qj1jlvau8cyNuHaT4yt74uCHQ04rl4+tupVuYccOap1B5PEcr92Hy83GnqEpzBN5mxUWcR
	HlkMAvig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW59-00000007feD-0oNw;
	Fri, 21 Jun 2024 04:41:03 +0000
Date: Thu, 20 Jun 2024 21:41:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/24] xfs: wrap inode creation dqalloc calls
Message-ID: <ZnUEXxx5o6SOQfwC@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892418102.3183075.3384829090907441660.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418102.3183075.3384829090907441660.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


