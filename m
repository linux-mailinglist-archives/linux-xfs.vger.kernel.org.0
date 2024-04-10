Return-Path: <linux-xfs+bounces-6507-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E5C789E9C6
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Apr 2024 07:31:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 016771F267A7
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Apr 2024 05:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB6F168CC;
	Wed, 10 Apr 2024 05:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OZ7kxorL"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BB412E73
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712727111; cv=none; b=nTe90xYT3LJJ+sWW4iwcAo4cnon1XGAW7u2eLlfVx+qxYByA+kkV2IuckcQa6Gos9sR3TZkfgzP338Tnf+r/DaSGeAMJAbSmRVAsXUgAQgTgPmIVlZINMjg6k9ZZxqrCzJRNRBKrXn2I3yVllT8EPxJgZg0c1pYBIvSFRoOtTKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712727111; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BjrKfcB+BJEmTs9aEFJ2dmNyJDgVcqzd3Je5LcdUpZAP5GEtOzklkLEr1XF4D3za4NGmU7Q34uxH3LUtwtDKSJ9Oofh+NWWxqc88tBIzJnn+OuX0gFfz86lx8cAF3Lk6XRL7CkoWIpnQ/Heu8l/iphjl8jvEZI7xXEUMWJxbtug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OZ7kxorL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OZ7kxorLroS7TU0PL82c9fXdj/
	+N/JLV3yXk5dudLCk6AUQOCaGp5W0/pcdEN7buDLxJoMMpMkaW27rCIqXI8ZrY17dk+6mQIw1yS/Q
	BmTlB3PsI5SnK7TTDtUlGu7UXuECAAPWVaxP72EAxksK/rSPVo8crBKSwJxP0O/CLZf7TQ575I3vL
	rGuKvpku2tosMcqtYnOiOgEUT4maRMUQvA2oYzbp0jS8s+iIXx/viUT7QLRD766dfgvWyFa7gMSLt
	FUZ0m4GGLcNFoklHTM2LIu5C4HMWyXd53ckVgRuZwC/ec1hXVQ9synQR0FGt1Z83ecnvzrxJp+1Rq
	cpAshdtQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQYm-00000005Cso-2WWb;
	Wed, 10 Apr 2024 05:31:48 +0000
Date: Tue, 9 Apr 2024 22:31:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/32] xfs: extend transaction reservations for parent
 attributes
Message-ID: <ZhYkRJnn-dSTJ3__@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969807.3631889.124629951348206378.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969807.3631889.124629951348206378.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


