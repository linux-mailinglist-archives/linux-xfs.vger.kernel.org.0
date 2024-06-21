Return-Path: <linux-xfs+bounces-9727-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D2489119D0
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2024 06:53:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E4571C22169
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2024 04:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0708D12BF23;
	Fri, 21 Jun 2024 04:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lDQNyg3r"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32B1EA4
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945592; cv=none; b=LYyrPPN2hRgIfZW51+n/+IOb/4WIjqxWBP1uG9+Xek5jACY49+9pqwM1JRtDj/ZYBpGTKvqXtn4e32IZmhWV/0D/JvN73MhSAewaZ/sVx5gaQtCzSj13ivhTyKk5NYpmK95tZ/4sIXsg3zQ/xyRUI9Ug1L+mIqya5kRevO4g6fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945592; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NJqXrPKvLIjZpycjQVBeGeRTYdkBFu8nL2a3XWvf4OamBbUg/pxYVmshuXjNUKkioWNrPlcPX34ObnZEDjkO7o/OV9TW/avhmSLdB/KxVEwqwi2xl1RD3f7jbTtK7Unopzm7ROpNKQrbXeRZUjD3rVnXuvGeBPMbCEKLqZhXjrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lDQNyg3r; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lDQNyg3rDlpli5S+7jwjohxUw4
	k/NjrcdAXWec+YR09E46G2mtITOsVKspGxP2/+mxY9IOh/SXq6/607gAu0fshXCmg2qFqO9ODcFv/
	UoyrcXxnCZxDB+KuuMbapB05vKATz5eloXkra6DRBxDPZC/uEUdCxHFg+tbHxS+obmwS9djAB/W21
	GzmypXkL5ftFmht8tCMHAlLjNgkds13S+mAqgmRGHKRVsYUHxyljH1RqXL+lu4P747zrxLTCbruzy
	qQ71Y8969H4AENBDtHYQ0seXK40ZcFbetvElnkAGipiR0QaDMpLqBe763cL0EHEt+BGI0clGNxvuv
	6vRXW6Aw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWGt-00000007gtm-1VMb;
	Fri, 21 Jun 2024 04:53:11 +0000
Date: Thu, 20 Jun 2024 21:53:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: remove xfs_trans_set_refcount_flags
Message-ID: <ZnUHN-7zhm0tuWKO@infradead.org>
References: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
 <171892419858.3184748.8956724086429567211.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892419858.3184748.8956724086429567211.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


