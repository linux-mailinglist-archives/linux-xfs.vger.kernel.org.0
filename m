Return-Path: <linux-xfs+bounces-6491-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 69EA689E972
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Apr 2024 07:08:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24644281A5E
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Apr 2024 05:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C09210A2C;
	Wed, 10 Apr 2024 05:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xCPqk9He"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145438F44
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725707; cv=none; b=PAqOqDB5uv8lCfRe7y5XMdcGOvFNcc472ga/pIhP7tLwf5GTuH80CPyjzYYRMuBj8aJJC1fDpfgCOwi+59aduVXnBz0A01KSXRQRnJ9GugCKm++JTnS6VADwxjX9sc9jOdht1+ZivJwsIbZyxBm4WilZqi1zOg4M1FlL4UxY1+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725707; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=alCektGO20yHBcsffc/LqMJdIIhOE9JCdwERlNWcSiyh0gFEQjqUC5TbzbIr3TUBETS4+B/Z1DmMreosfvB5cVlausr3j3OzredTC0Rq/eWlR70t2i11watgogHkcBStBdgXo9b7fTrARyKBdVJyKFa+BogYrNk1+UWgddwiFjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xCPqk9He; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xCPqk9HeHbDkgqTPYG/owfBILq
	nMZYQlfZZiUFTbxqHycKw3xeTkeOenJtqI21YgJoEpF2Fq3jsxS2dAHucTT1kUI8W/HLr3KxrJSGA
	z7OCAQ05uUyAzXVf+Xc7Z9SOnFpru0ZvTc3f8p6m7xHb5OoOXrw3/FSLpUY2AeF5M92pqu88ChJYC
	qbm5OaDnNIKNZ2Q5rR3bNbRxSf2T45uTPqUNeYOYfhZzCvJIyGrhYZvzG4RnvK+8T42HWcUnRGpyo
	r0HhgBReWstvu8M0WM97Cm+yQyjdUnlvzGftg4a+mb8YSAe3Dpl7peoRrCh1jRySmQSrmtrbKJBde
	MNg0+CXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQC9-000000057m6-2klc;
	Wed, 10 Apr 2024 05:08:25 +0000
Date: Tue, 9 Apr 2024 22:08:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: always set args->value in
 xfs_attri_item_recover
Message-ID: <ZhYeyZ1bv2BMs_Wz@infradead.org>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
 <171270968999.3631545.8805460036255507720.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270968999.3631545.8805460036255507720.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

