Return-Path: <linux-xfs+bounces-9693-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E7CF911994
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2024 06:38:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C71F28607F
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2024 04:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0C87839F7;
	Fri, 21 Jun 2024 04:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R0vboKVh"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A17912C48B
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944680; cv=none; b=ZtUEmBEnRD8us/V+Wk6/hCuZRRNAMp2Ycc6f1lgahD0uICc5Zmwv9/d3UBmQiGkBpS+MESmyg4+Gr19Jwn+wo46JEBT0M92z4+FU669axVS7TTajHxAnAvf5anuaXMzSr3pvFnhxe/6Bo6VwI0jKhZEyZIFYh6AynoFxGXxwT+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944680; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e9jnWpamT6p2o5g2fG5NWi+tueBpJ8Z2DW3UlOXygdSA6WDCDCDoliimg2vC3oRYnLfRNlIzbQ0zJ2yD/L1JEjXXCibDSr26YXYxhYb7ZxxyHltrYz4+Y1N8bRNMepPsL94fmq1tJ86gjUzSexNN6P/xlxO22BZrLQDnmlhRK/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R0vboKVh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=R0vboKVhbgw+c/XZHwCaK2KmvL
	yiM/CgMCWHVt/n3+CYruqEI+tJ+5jMljztPjW0/P4QqYOuxllRP++WYLpZs69u5X9oO7tgr74ZM/Q
	6jmMe+OxHtPtKu77W/2y0chg3gPJE5oIqWopHvnx5p22ovLX6/hR45mg4OJyc7nAjeis4GM3mdW7J
	kp04rJujUY4crzTVoqu7mtSgWPkjTdhbgqf47B+LWd4016iuAa8koHQ+WRK5zohkm2jVWvtDZigYz
	hqHHmos/k8IBzDl+G08W5/UR+8hDd1o00d53zEyU3+WY3kkXSTmblf4V2RnOdA7CEAJdqqiS20HMP
	E1tAq0Zw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW2A-00000007fCg-3CiQ;
	Fri, 21 Jun 2024 04:37:58 +0000
Date: Thu, 20 Jun 2024 21:37:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/24] xfs: hoist extent size helpers to libxfs
Message-ID: <ZnUDpkWVR4s-Ug-L@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892417945.3183075.16613633853216031887.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892417945.3183075.16613633853216031887.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


