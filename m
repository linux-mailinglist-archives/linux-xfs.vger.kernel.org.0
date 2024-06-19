Return-Path: <linux-xfs+bounces-9476-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B80590E31D
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Jun 2024 08:12:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19FC51C21CC2
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Jun 2024 06:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F8EC5B1F8;
	Wed, 19 Jun 2024 06:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="olRVqINo"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69254A1D;
	Wed, 19 Jun 2024 06:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777549; cv=none; b=a4yHlxolEmnF2a/6yzjovr0j9kwMz4MA/5DLhebKxiytvj97zL1Rht2valioIF5CWAVGmOiE6e9XCDDCEfiHxVGXApHyhOVvG+6Z/yCsS0TBEnDhcbLdMCww2ZUPW8jKI1bVj6trwtMmSSilKRXJMesDkJbEDIlN6iTan3qR9zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777549; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pZdbaHKxISOfsMZqGfGELXpcSINkERZ2CjGsYUxQMCKIKEtBIWwhXNYtnFwhr5e2nHkNQkdApwTNB/V0TDQylR5D3qWGfaHSz1SLt10KWEghWhafdOAyWsYs4K4SN9ABUk0CdVNjmmvF8Qn2Ssq8id0Vsr934GrjXuZb66m0Shc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=olRVqINo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=olRVqINo/AyZzI5k6fXz4mwpUJ
	R+Hnk0HWbNhtp76J8htzEh3eYm1YDe3xxU5E2N1Hwqhrdy2Xvosksz3ZvwHqAoVecu//+6dCbhXfu
	VAlk7MwwKwMMDhZ/B57/tmj949VKWPnrkBCVlC6is5q2+FDExcvsoGMN1f50xJ+kx9aZE8L7NHRp8
	ajdb5VquZVx1yGNBE3aSMXYalaIKmbmzcPiCyxq5Q/nWLuSGUsgZGAftYV8GXJfXlIkljL3C0r50z
	KDLkzTmWAihJ5eDmWc1WSSRM9BvRwJPzZfDRt00jDxYq5vxluELQXaHmaab+GmeaF+B7QSduNMQIf
	EtJWDIZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoYV-000000001NX-1tJf;
	Wed, 19 Jun 2024 06:12:27 +0000
Date: Tue, 18 Jun 2024 23:12:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
	catherine.hoang@oracle.com
Subject: Re: [PATCH 01/11] generic: test recovery of extended attribute
 updates
Message-ID: <ZnJ2y1Nlj7ymbubq@infradead.org>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
 <171867145822.793846.1215087567830350611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145822.793846.1215087567830350611.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

