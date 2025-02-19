Return-Path: <linux-xfs+bounces-19924-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6623A3B24D
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Feb 2025 08:26:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9658B3A57BF
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Feb 2025 07:26:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B35741BD9D3;
	Wed, 19 Feb 2025 07:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="js5n+bkt"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D3B12CDAE;
	Wed, 19 Feb 2025 07:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739950001; cv=none; b=oXZbfiCgExjQCRgQ0wS9g1WEs3ZjpswC0zar+MHLPtwGlebKObO6sRxIppcGz2OQcjdiEM+I2KEapF2hWbYAtVvu0PKIQAzE+jPq/1FpOhEf/wHfDySXrbCOe449lO1fxc9GKNg28bgo8tyeNviiN02zPVdxqWdY5YUg+o2D6JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739950001; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y2cmBbiBi64EW2D0mNLIFZWKhFPrItCKYO+jKp+5eN9t2IEgEVHhxqfekmAnHHsBDxKgdH6nNRRl0N6VwBHBvuZFQ+sr66R98x554F+rs2mn+Nk2e36w2e9t1LMSlJsLWA9yr5PB9/SPBq3NDc1S5hOthVTheww+YVLAniRSQWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=js5n+bkt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=js5n+bktZqL2WZj8/8GDba+3uS
	JtxRB1K8N+stNumSMx8Qa7SrRuKgJBdNJAQ74xwGRmW1znBODXyKQ85GCO7AyMAmU+ZOjB2eFA9kr
	Zc2XP98WLKj4Px19s9jU0JoRk6v1oGHotuItotefmuYbNz3+bOovl2NSTQFw/hUTT1aNYOEpGo0LO
	X0399zRT1ulJ7x1Hzl5j/BSn01a9PAFg+X90MSvJbFBMquUxTMmEMCxG1nsuumu6Y/kIfCiWkw+YP
	uS1J+hv1n4tUtcP6Vb0GBSk93r3i0TeXkOuR751sfta5LDGisQCjOZxgTO9CXs/JmnznHeggQc63K
	L/HPojjw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeTf-0000000BEc1-3fNU;
	Wed, 19 Feb 2025 07:26:39 +0000
Date: Tue, 18 Feb 2025 23:26:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs: race fsstress with realtime rmap btree scrub
 and repair
Message-ID: <Z7WHr_Uu4E1n0JRO@infradead.org>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
 <173992591186.4080556.3392046573752829715.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591186.4080556.3392046573752829715.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


