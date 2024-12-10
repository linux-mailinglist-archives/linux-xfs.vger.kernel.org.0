Return-Path: <linux-xfs+bounces-16379-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BC4A9EA814
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Dec 2024 06:47:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A766283A1B
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Dec 2024 05:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD09D1547D2;
	Tue, 10 Dec 2024 05:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CL+WbcIr"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FD5A94D
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809646; cv=none; b=Co9gHIhyCo/xHlaYwfpHtTQtB+82aYCkBGHQ7eOxsIQN5NulUFzHexO8cplOy5HHyVf1UJME7CI6XIlqsHtRYDj0tVRqdn9yc7f7pmuhajfWaSASiCk/uh/PlX5xpL7J1clcwNVO8m6+DkpFt2sJtvpCdbG9GmGkOfTFMbgAuj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809646; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bUvACQ1hxhq3fNeSUGP1W8FZDTMeOjDor61QBZSJaIgQJYvdhCf3YXrEFKwQBxBlYkNqpitRaC6NKR1GzGwO75ZAkL9bi94+X8eE/Q39XZKZCrC1Uz7+4dNhiQYuJ1+fVmaTRlenLGsPXTsqcD8kvvw7MsI8zm+TT4ldieeDx/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CL+WbcIr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CL+WbcIr28phY5bm7wOuXQZWv1
	H3HvIOOCT22nBufvKAPN+T4mb/A8BfcLqVvOC7ySV3VWSmQSAuvCcrja4lMbUy3UG0XTJcSQtWmYW
	SpItnhfjbmqMFgVU/b5TRO7ZY72su94tPpAs25YiyVYKIqMuFYzBDDcRXZJ3go888SYxVDEvXS3Vg
	aXFh40hpzHM8tc0msCaAYQl52iJXLNx66BL5NQJPZ87Tkp3t9srtJXdugmVn5mRgAa0dP99sl4Kja
	zSZMNZmw7gBeqLuPnCMEyVpNTQqrmraM7UBmQDGHbxBuf+1HVVLhY4+KA16nmeWt2gHGTI4gPZrR2
	GyAJUMWw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKt5h-0000000AJ88-073d;
	Tue, 10 Dec 2024 05:47:25 +0000
Date: Mon, 9 Dec 2024 21:47:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/50] xfs_db: dump rt bitmap blocks
Message-ID: <Z1fV7TE712RpetBU@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752449.126362.12190261909488631960.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752449.126362.12190261909488631960.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


