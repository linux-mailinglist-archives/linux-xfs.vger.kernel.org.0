Return-Path: <linux-xfs+bounces-24878-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 09848B33832
	for <lists+linux-xfs@lfdr.de>; Mon, 25 Aug 2025 09:50:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED72B1B23332
	for <lists+linux-xfs@lfdr.de>; Mon, 25 Aug 2025 07:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE6629A9C8;
	Mon, 25 Aug 2025 07:49:18 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315F72737FC;
	Mon, 25 Aug 2025 07:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756108158; cv=none; b=cgOlve3JHOMDDcVXH+eEunqaboONmjiDDu6CY2lvkA7QQzTHaK8L0Rw+fHeAatD5fi4IhwR6Ikr0cQwCUNaLkiaY9HmLck/xK+wRgFmrBlgF+4oLPkIRHjBP5E4/2Ml9+Lx0fs5lJ5Orjp2N0h8OCXle8+YkhlSigAcyeRnhcHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756108158; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sISvMAC4bipzVK51Y3LKG551G56jfgDUPqqRSBDwRNbduOQItLNVpIH4qm32BBsXHdgjJ3iCFf6XComEIb6shyjGB9OY1TY9yTBt/TIsXZ9iLbTJxZzAv6urmL0xKhVEIvjZhSyxXyjeG6hVdgTPf1c4JiThKimsADAiKWyiHtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7934168AA6; Mon, 25 Aug 2025 09:49:13 +0200 (CEST)
Date: Mon, 25 Aug 2025 09:49:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, snitzer@kernel.org, axboe@kernel.dk,
	dw@davidwei.uk, brauner@kernel.org, hch@lst.de,
	martin.petersen@oracle.com, djwong@kernel.org,
	linux-xfs@vger.kernel.org, viro@zeniv.linux.org.uk,
	Keith Busch <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 7/8] blk-integrity: use simpler alignment check
Message-ID: <20250825074913.GJ20853@lst.de>
References: <20250819164922.640964-1-kbusch@meta.com> <20250819164922.640964-8-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819164922.640964-8-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


