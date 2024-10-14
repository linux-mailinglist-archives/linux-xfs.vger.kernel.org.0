Return-Path: <linux-xfs+bounces-14116-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A79A899C203
	for <lists+linux-xfs@lfdr.de>; Mon, 14 Oct 2024 09:51:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8C4E1C21513
	for <lists+linux-xfs@lfdr.de>; Mon, 14 Oct 2024 07:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768E914A4C7;
	Mon, 14 Oct 2024 07:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BK10yCgj"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229DE14D2B3
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 07:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728892310; cv=none; b=CXajAqx42h/PKaFhFo+J+cyW1OJIHpQH0/PT1cEDX6b6UEF0hA90PBbccacl8EbGSSjB50LRlQArxM2yRu18vku9tbpflpXuKzWjcRwiffMtDPk2rSZmYdf5Pz7hTj2v/oGNim8y7QT6PcbTDohZV3LJ6TSbrATg/knZ14htAx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728892310; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t1Z9AVRZCAKFBhCZkKlKB/Pm7qvuBq0QSbfU4DjbatLDXd4A7V+wA/3epxL2W0aE06zuE5dKMs4TBd8rHVk2pjgCeI3vpx0jsYZZnc0rEF1v92gfuruMFr0AFwnL8uxR1yU7QWA0qLMvxfP4BXYuk+UOrwzKqFKdGkwBaLdn2IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BK10yCgj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BK10yCgjbQ58gybJpgyUoEiwMj
	6PtnGE9Vc4HcWW7nWdExk5svJwFbMhOPpbekuqhlLA4s53tA/tf+zkA/GCmLNv5Qtu44AswpulPM3
	N+9gKZ973zZNYhyUWXJA4742BBRoUFSCwY1+gXCHahAA8XxE3rxHt8Si5F3wiIb2XHgS/vEzgdzd1
	918/gzIK6/z4c0DNpJwgNbzuZijGB6Kxld/QQj7gHg7MdvahuVJ6lL0U+eLgBDmRX0HwkNf1EP/xx
	xYvOk+5ym75O3m24z/KviiwEvLi76HZ/Nwi0/keWndNvPplm1MlTcKTZvmT2vbhq7Cx8O1nwPzLa5
	YxS2a0sA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0Fro-0000000497o-1vZx;
	Mon, 14 Oct 2024 07:51:48 +0000
Date: Mon, 14 Oct 2024 00:51:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 02/28] xfs: constify the xfs_inode predicates
Message-ID: <ZwzNlNyIwdOoYwn0@infradead.org>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
 <172860642047.4176876.13639551313907624679.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860642047.4176876.13639551313907624679.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


