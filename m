Return-Path: <linux-xfs+bounces-28114-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DE9F3C779C2
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Nov 2025 07:51:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CE0534E54BC
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Nov 2025 06:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 662C63346B4;
	Fri, 21 Nov 2025 06:51:30 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812A4333755;
	Fri, 21 Nov 2025 06:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763707889; cv=none; b=nH/+NKqhjnGhNonjhySge09RRegQcFyOLfxZpRvo7P1huBB0Tl8Jh686tPM+OE3r3cOHAdM8H4AoM94TJCsNeC9EhuSX9wWl8KFim9J+tGkKRB1/jjBU1EAqLkEZi/+vAwuOfIoZRHW8MzjaiO7MczsdTa8Y3J2SphZfvPJ90bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763707889; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fsg4Zk9ZP8s6xXN+BVK7fJCrWQgn3sFoo7/9EWseIrpDN5nv1zhgEPAcck93LI48okp8iMdxjihubyxMhWTw9qeSveUnEaTjxHu5D8HAES8XkiiD5Z6Rq+mXRIX3naRg11mCDN2NBTWdc3KKuezj4spA/p782moLjdztnSfchcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A567168AA6; Fri, 21 Nov 2025 07:51:15 +0100 (CET)
Date: Fri, 21 Nov 2025 07:51:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: zlang@kernel.org, hch@lst.de, hans.holmberg@wdc.com,
	johannes.thumshirn@wdc.com, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Add test for mkfs with smaller zone capacity
Message-ID: <20251121065115.GB29613@lst.de>
References: <20251120160901.63810-1-cem@kernel.org> <20251120160901.63810-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120160901.63810-3-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

