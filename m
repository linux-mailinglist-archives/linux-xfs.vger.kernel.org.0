Return-Path: <linux-xfs+bounces-16334-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7DCC9EA799
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Dec 2024 06:15:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F12991888EEB
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Dec 2024 05:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28E681A01C6;
	Tue, 10 Dec 2024 05:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WcGtadsS"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DEA168BE
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733807721; cv=none; b=UWMO+wqL8r+UUjMl4lGbeDB3mj0odYdLKyxC1YEnSjWJIjC+PuiP85yKN9lofLM1WkRFHWiHWuaoKKTXGoxPpM3XTE26LNvAn4m4bpzwZpcaaAZ6x+cbgwzpOh8UtMELyvSn8FmzfHBx1a4Tf4KwygkkdvSnGGjbcH5GdvKFUhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733807721; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WBo/27mapQLSTa/XMFhg13JrjYAyUggyag9w2aHPeWhDeWKtM7ZfEoeQ37pQhajt1WMyPWKchtJVxMH9P0U8ymfHVuPFFBf/lOpXO7VC4EsvboNCr/ItJ9oLPGt0ueez03U+ZCnu/spKIOqP9U0pb9IWhfatP8agt+IIMwtKR5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WcGtadsS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=WcGtadsSOr26frebu2d/qrksOJ
	SOWK05AL3aIdhBzyQ2/UAVcDKcwu7FbIF1kIYs7PFSfKDdtEFcOlQrfLlXvQvVkyJA0cFIZinC7X8
	hZFLv77vlt6SmWeyFppW1gS4bXG3/x7bb1lyx/0tdntbgjPyU28jmSoRcQKoAmNi5y7DgoYnBb9yh
	Pom0HdEe0GDfxuwcslFwIOX9GqcSFkpTs5S7UzD4FEVncN3DNoXdcu4BEj4+J5AkX9B4sXwPJnIwr
	vuwS++9nzDE1F7aNsTIf/rrj4iHSfePKxd4zRwTgEABEiGQY1AHubxcV6Wz6XbFMHyfZ8NvOBeQOd
	lnKatetg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsac-0000000AG6K-0O5u;
	Tue, 10 Dec 2024 05:15:18 +0000
Date: Mon, 9 Dec 2024 21:15:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/41] xfs_repair: refactor grabbing realtime metadata
 inodes
Message-ID: <Z1fOZihySZjby3Cy@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748634.122992.15126227280100846699.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748634.122992.15126227280100846699.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


