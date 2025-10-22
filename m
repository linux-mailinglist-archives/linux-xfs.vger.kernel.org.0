Return-Path: <linux-xfs+bounces-26849-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 250A8BFA7D6
	for <lists+linux-xfs@lfdr.de>; Wed, 22 Oct 2025 09:15:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2BA33B25BA
	for <lists+linux-xfs@lfdr.de>; Wed, 22 Oct 2025 07:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CBC52F60A7;
	Wed, 22 Oct 2025 07:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YXspAZEG"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2B42F3609
	for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 07:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761117326; cv=none; b=QRkXDtPsi3cYdS4sRRSFdvlQLUkrNDA71CDo+PCEOhp5yTuAioBQXXz803eH4RQTLsx+M4NfXJOB1zEvzHkT0l1AxOtCA8lrI5aXj5Z9CGFis0Ah/MxAKmX4sJ6LxSFku//uPvVu+bwPmv+DsClQqqSIVRdCUVLEVwYtdGjIOGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761117326; c=relaxed/simple;
	bh=QEWSM6GxV2Sa/UyOcg4LSoYceML2B/sl8eCw6hYQE4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n+iy20jXp35uQgLSlQnPiXXiXCbwN0DDQN0grXl+mdR7G8koZAIbDfQPLRgIFkTtN64Jgwu5B6wyJl7+Fd+bQi9PHYgVpeggDqCx9m0vuBRaFPI10l2gHmDay1IKz2VS/jWzWYVSeE6GMkw6xb3yfv549rmc0QvA35PsaEuyzig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YXspAZEG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RXkmVwrvR/Zk9V3sRbknKOTtqACqX3rPkiEMfvdmnk8=; b=YXspAZEGBSBAba/IytDsfBK+0Z
	ZZBOxfPfqPAFX3BrV/5ZHcFfylSojWmFHvV2XmcvGBKORv4J4GSRvFab4+oq2XcnFB9/5UktJ/NTG
	ZbaCnhqCA+fHhgfeUznEnvdR5PvsQgwWVxsrmrLL42xp+4Sh9jjVhM4sqRyaNMjQr8OkSJNa86Hjw
	rHisyG8gnAK7gIbYHFjnRDkDX1dj5zSLDE+U3Jx0GhPMQKgchGmIvGEo9D5DVhlCZpyWQCMn8VZSq
	ucsXQI7vOBJU6TcyeHUTuNkqEwXqle6vqXwzAJtoz4yyj3OJrYSyxOXOFZYDtI3ed2pbcckzWSNaa
	3+phjAvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBT47-00000001pne-3j49;
	Wed, 22 Oct 2025 07:15:23 +0000
Date: Wed, 22 Oct 2025 00:15:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Lukas Herbolt <lukas@herbolt.com>,
	Christoph Hellwig <hch@infradead.org>, djwong@kernel.org,
	linux-xfs@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>
Subject: Re: [PATCH] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <aPiEi2onSUfAPSdM@infradead.org>
References: <aPhk1O0TBOx_fl30@infradead.org>
 <f90b0e3e-7734-4e86-8c73-011e71333272@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f90b0e3e-7734-4e86-8c73-011e71333272@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 22, 2025 at 03:13:38PM +0800, Zhang Yi wrote:
> This situation will be intercepted in vfs_fallcoate().

Ah, perfect.

> Besides, it seems that the comments for the xfs_falloc_zero_range() also
> need to be updated. Specifically, for inodes that are always COW, there
> is no difference between FALLOC_FL_WRITE_ZEROES and FALLOC_FL_ZERO_RANGE
> because it does not create zeroed extents.

In fact we should not offer FALLOC_FL_WRITE_ZEROES for always COW
inodes.  Yes, you can physically write zeroes if the hardware supports
it, but given that any overwrite will cause and allocation anyway it
will just increase the write amplification for no gain.


