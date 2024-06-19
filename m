Return-Path: <linux-xfs+bounces-9473-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CDB890E31A
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Jun 2024 08:10:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB657B2255E
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Jun 2024 06:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AFBB5B69E;
	Wed, 19 Jun 2024 06:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Esnr70MO"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAFB4A1D;
	Wed, 19 Jun 2024 06:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777437; cv=none; b=P7SbBHes2I50qNxZr555T0wQDSInDtPAUH0J9Ifp3GeEdn39j3l51qVmLajlQHvgMuT1XXA1JOGYtud3WkD/FiH5uHUT3VXdE+XQkpfPzQ9HxvUbEpItY1Dn2phC8tV9o90IdBtpzs1rpf1+7s86sQqGuvtWtOMcoClxshrkNOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777437; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SiHY3RCZgKR6pXWkuZ1WJPiwyHo8SMzMjGi3KTXHiE3YKOZyTvvFOd1VXQ9kYB0E8pbcYDYUxxhHMoqgSRpRckrOhHvteonbP4RngmbG8g5n0oyRV1nfrYXTicX4b312O42Kw0SnP0HkYxPW029MqW+ycv2g6ELPabwk8PvN2P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Esnr70MO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Esnr70MOMb1JkSHTfRvbISM0+e
	n++7hazSXsp75wDXTPQFGrqiH3EMMZahC5G7LeUGZKPWzMVQD+0JXxR7jfScNz2R124j8dSE/wj1h
	nkQ/ZASITQ9Wt1Tl0lc1BRUj/fnaTsZGaF99Q6gRZ3zD/p1h0+yxdlYBOOWTz37NeCFwQsH5FCE6j
	nESKtWOfFM6TAqN4zkfX4XmKf1ZD7w6b2iL0bneU+dBQw8jTnHqytrswk7MpoCfnrgNeh/6sPCvbc
	zXtnu35ylA26pZ9YCPQRoXY6hAC6jo0zxXT2dycY3C3e7Carni6xCMNVdI1FE9vPeCYsg4+AOwZc6
	jzEozSyA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoWi-000000001Ck-0g6v;
	Wed, 19 Jun 2024 06:10:36 +0000
Date: Tue, 18 Jun 2024 23:10:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/10] xfs/122: fix for exchrange conversion
Message-ID: <ZnJ2XHpeVXE9bh9q@infradead.org>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
 <171867145421.793463.13590004698802326563.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145421.793463.13590004698802326563.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


