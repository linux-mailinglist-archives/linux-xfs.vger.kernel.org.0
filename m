Return-Path: <linux-xfs+bounces-6471-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9C6989E919
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Apr 2024 06:41:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E7801F2202D
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Apr 2024 04:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D230410958;
	Wed, 10 Apr 2024 04:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iy/AdAsz"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E44F10A35
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 04:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712724048; cv=none; b=hA8jeqZfoXYqeZhc0RjeLaAJuNmMn/cgg/thqbXj4EcgD+hj3afSE6LQKqSgkj45C4J0KEYhKGftXCT/Tp1F7RjxUWUlC1CT8GA0we7NHQg0EL5c/0EkLgjgVIx4B2FmuJvxmDb9hQd0pTQVFQlwFReFDDeJ6xqULjL5ZIKhXB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712724048; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UItp8rvlKXnu44M902xjVA6pxAgPhkcNRVN4NYRB2MOhf+EWAQgeAp/n6oFLQA7DheOCjCZpMrZjj45NxZ6rjDtWtm2lIpIrowzPalPwF+On9ud+XKjzJg9cDFkn/Safd9Ko6u75d6WIisTZf25aLTYJ6+epKS+BoOzXfGp+kqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iy/AdAsz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=iy/AdAszwYip0mQpbvdVh87JXi
	dy6hvSwl4Y+K1A6/alAFkIePKqf0+sE0Fv/LMVSMY3eU5P9zD41cOXNIl9tcFG3r54ljqm5oCxNas
	sOC/RNICavxrXidTHksDfKrct1xqxxVhwVxHHoMGC9dnwzgxO0ABLxM7TEFHqWHdcT+NJIKMIYzl/
	paiLbhIEjTbjHoawhleCTFs7FK+g5tblO4iT53Wn9ImdHooKbhA76ZpIaQyRkiyTbrQClkYaGyqGu
	i+mrWIKVIBCF6ZkXJE96FuSMg8G1N6/aeQ9JGyv3NI+00N47jIsp3dY4PNzo7kx/gX4ey1t/E7dEQ
	BaBmMU5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruPlP-000000053TI-0Ak5;
	Wed, 10 Apr 2024 04:40:47 +0000
Date: Tue, 9 Apr 2024 21:40:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] docs: describe xfs directory tree online fsck
Message-ID: <ZhYYTxyXExx3OCce@infradead.org>
References: <171270967457.3631017.1709831303627611754.stgit@frogsfrogsfrogs>
 <171270967532.3631017.5046025491953457287.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270967532.3631017.5046025491953457287.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

