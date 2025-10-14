Return-Path: <linux-xfs+bounces-26404-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D7E54BD73E5
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Oct 2025 06:28:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C5CE19A15B3
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Oct 2025 04:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B621530B518;
	Tue, 14 Oct 2025 04:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OPaTjmmx"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B16430B504;
	Tue, 14 Oct 2025 04:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760416078; cv=none; b=u8M1uSxAGAlhHfEfSfxMXGa38mEsGOqd20jBy7n4SpuFG6Ec4WrIBhY9sRaaSanld6ZChtfCCHNrasx/oVBslAnGXcWLc9NDwP+Yv2JHrAdcEoq4XMl0fXgzq4wSaMZa0DFUlmaX8TaahhZnrw2azObmf0Xx3PVAw6m5gAGIxjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760416078; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I90UUWIagBVAWG3GIpqc82qAUn+RoZbClVXK715E+ia0V222lXoXWR/3/mqm46Ll4ebXHKnLefRnxq3bQhd0VqETQtSUreda3MgbMGEdGRwVqX9QEiRGWZqZYgEvEXYZGrFYqfzLCVN8r163J3kKWZ6l57TSPiI68n3FGb+3390=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OPaTjmmx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OPaTjmmxwJZ8wABSkJDcIzsnLW
	QC2VPKIhdmmN1ClIayNLyDnLdV4GaZ2LJVnJewpLEweEZUETx+Ca8EFoc2Wm2BtBLdhRTXt8ntoWA
	l8Se8Hz28AeHjtAfPwhRWF1KMWIKEE+fvVRD2KWbh4SewBlYodqr81vxJK2Ns6kSw+Sn/brxUIjOl
	N/gU7/yYG8eXRKQ94aTqCyMKTVBwNR1Ifc2hyjLuQyZlzdfONyvMi5304vh36RKugOuVETgsk+ALT
	J/vHlwYmvmQcrjrDTlKVA9gdyE10S3FCY+hiAlk9LLJGQtjzZYQ4H+TOHVaf8ul/8HTT54PWCuELl
	1ODJS4BQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v8Wdg-0000000F6pT-3Wtb;
	Tue, 14 Oct 2025 04:27:56 +0000
Date: Mon, 13 Oct 2025 21:27:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, Pavel Reichl <preichl@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: Re: [PATCH 2/2] xfs: always warn about deprecated mount options
Message-ID: <aO3RTDjEjz3Lpi8A@infradead.org>
References: <20251013233229.GR6188@frogsfrogsfrogs>
 <20251013233305.GS6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013233305.GS6188@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


