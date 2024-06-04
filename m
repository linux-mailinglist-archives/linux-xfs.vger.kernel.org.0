Return-Path: <linux-xfs+bounces-9034-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CD908FA977
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2024 07:05:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E1C41C22C9D
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2024 05:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BD0B13D516;
	Tue,  4 Jun 2024 05:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="f/y9mrdK"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18F61C294;
	Tue,  4 Jun 2024 05:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717477529; cv=none; b=iLVbVFxgLff9tSt/6GP7J+4s5ZGlqgUyg2MfEHNSqV1T7RCU7NKbrWyfQkjHeFeSrZe+cwE3XyXslHIFwc5WTFxtZ+9k1UVUIM2vI3O++psppso1ZawnPOLjKxUJDflwt9ROkMY2D078csdtuBzLDYdzkeWuZYNZCXv9clnTv6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717477529; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VI8yXUbokQK3gGePv8nLBKydkfjI8F3ByBj4NGY/4IxIUIXO7fJpkMLeIuNeYawSvDrSaOVs2tcil8aYEasFEeiuCY9I8XDi/8h2erZtTAsUOY6lc3ifro3okxxd6bPR0LP00Drs3BksnVQUDYUTwtbAqMHWVtPrHh87wQ3+H5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=f/y9mrdK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=f/y9mrdKk6YXJ7sFuneYlx2xP7
	MywMOpZaljfKat34l8qyIyXkoQ6HnXv2s0h6ldlzgd5QyPFSR2v/jzF93ICYs72CoZxNtdwQhUFP9
	SzN4kRMD43ONC+t+ifhZhdpGq4XXYTZYOTUkwVPGL933WLuYLycCwPe/8Xey5uK/OORQEHejA6R4V
	SFQ/rORDAHNZKHzNnis4hO/mSMk5+FY44AojD0UCrtRXHBN4y6knqzRzvL7Vj/7Sd6X3cJFQKp75A
	1iZSFGi2ZLcn0Bukzxxhtfal4MxmdLiQuy+xzSu2zQ+NRB9Yj6obLSp7tET0pwlkbkEs3OqTg86/x
	EPPFJ+BQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEMMQ-00000001DVz-3V86;
	Tue, 04 Jun 2024 05:05:26 +0000
Date: Mon, 3 Jun 2024 22:05:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	guan@eryu.me
Subject: Re: [PATCH 1/1] generic/747: redirect mkfs stderr to seqres.full
Message-ID: <Zl6glu6igG2kNL6m@infradead.org>
References: <171744525112.1531941.9108432191411440408.stgit@frogsfrogsfrogs>
 <171744525128.1531941.8755552045266618674.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171744525128.1531941.8755552045266618674.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

