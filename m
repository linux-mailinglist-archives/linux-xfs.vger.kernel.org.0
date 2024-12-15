Return-Path: <linux-xfs+bounces-16752-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BCA09F04C8
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 07:26:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D8E116A0D3
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 06:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7CFF18A92F;
	Fri, 13 Dec 2024 06:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZKDHZGOP"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559FE13DDAA
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734071202; cv=none; b=P8jMTCphdrAUemTYZC8CMdUiAoCZ6bSU8OPaH4JkwNUG1FqrIRm8mLPjp07eLmQP3ewC0WH26DeUZIK0f0DY3DC/87TsP4AZPf14Gg1PnhlJ0olchfKFBVq+BKDPOtQfDw0UIXS9+e/gSwkdLjcN7/x3N0YwvvfZiEBUZBrpc8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734071202; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cszf0VAxdt3PCyFX16Qc1W+5Rhkmxkt4U2uCiikxB3n1vgqiRjsQ9YHL0i1O1IJaKfZP+AtagejveKj7AGmPIPVYW77eVb/2W4k+w4azbton6kNCusaOAYk5B3PZ4IDMPRT8RiT3JKiu3qhlFevyzZ0i5Vcwx2wEK9Fbb5us4Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZKDHZGOP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZKDHZGOPQXkyzTdSZ6kUgSSfts
	dweLoHMCK2q3sACs7AT+j0VRKS5bKLSXAToWKkXso9OSPQ+v7DJ9nZADOs69ajHSop9N5TbX+ceM0
	AmyTrGIEgAay2LXoYKdkoTPUKecbdkRA6fLSJEZ9gWIcG38sbyCTCAlzlz9dVvh5BIKn5UygX3Fia
	FcgEvnHYggd7Wmx9ZEImZfzfgaV0S91JOgouCelKm7+qh8fHdgjt/VTsLk3OrL3aPXQThNzrXlHAF
	7+zyz59oTqIuHfH4Nr7lkmfMxLqds2jKVQhk1fJktDv51kqQtxBHOqmyq0mAtE38dpHrHGG9BcQF0
	TeKkAzEQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLz8L-00000002rnj-0Td8;
	Fri, 13 Dec 2024 06:26:41 +0000
Date: Thu, 12 Dec 2024 22:26:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/37] xfs: add a realtime flag to the rmap update log
 redo items
Message-ID: <Z1vToUXmnx0IBJYm@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123451.1181370.1057797621602382553.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123451.1181370.1057797621602382553.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


