Return-Path: <linux-xfs+bounces-2562-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E21F823CC0
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Jan 2024 08:28:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1AEF282865
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Jan 2024 07:28:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1AD81DFF2;
	Thu,  4 Jan 2024 07:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ieFh9ipF"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C011D693
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 07:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=azLn0OmUg0p2cdYfYCja6MSJtKfYcTmdh/tmwB1GAsQ=; b=ieFh9ipFu3FAvP+1V/ehjxVAM8
	1qU2xTg8+wBsJ0yRyABwwg66QqvQf83BWBby66nSxYs4KyJI5xr6uSTAFxLxQttlVwvo0u9u8S0a4
	8fD/EuyF2iSWsp59Z2RP0ImS93SaYmHPS9auVDvoAqBOtudf9iKNmoFcvEnTo7gSlnptmeiEKLT/t
	bsUd6WmFwZT6DTiB+q8X6qL1i4xitR/gAJ49XEqzXCdAWGPSdmWmVyT+DiGezo4dfOp6faHVX/7gN
	+EmdQRtz7EyQ2H0z79DaWRAVqtb7PUFKHRzDqP4ixE5kjO5RRxiuOKyYEsZQmnK1V1wZ228LgCEhP
	17H41Ssg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLI9N-00D5DX-1i;
	Thu, 04 Jan 2024 07:28:21 +0000
Date: Wed, 3 Jan 2024 23:28:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfile: implement write caching
Message-ID: <ZZZeFU9784rD5XsD@infradead.org>
References: <170404837590.1754104.3601847870577015044.stgit@frogsfrogsfrogs>
 <170404837645.1754104.3271871045806193458.stgit@frogsfrogsfrogs>
 <ZZUfVVJSkvDRHZsp@infradead.org>
 <20240104013356.GP361584@frogsfrogsfrogs>
 <ZZZOMiqT8MoKhba7@infradead.org>
 <20240104072050.GA361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104072050.GA361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 03, 2024 at 11:20:50PM -0800, Darrick J. Wong wrote:
> > Sure, I just suspect the commit message is wrong and it's not about
> > mapping the page into the kernel address space but something else.
> 
> Yeah, I only did A/B testing of before and after this patch, so it's
> quite plausible that it's the lookup that's slowing us down.

Can we re-rerun the test once the pending xfile changes are in?
I'd be kinda surprised if the fairly simply xarray lookup for the
page is so expensive.  If it is the patch is a good bandaid for that,
I'd just like to ensure it actually is still needed.

