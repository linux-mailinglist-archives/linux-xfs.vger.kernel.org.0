Return-Path: <linux-xfs+bounces-19858-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7494AA3B110
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Feb 2025 06:49:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A1363AFAAC
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Feb 2025 05:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3623F1B4245;
	Wed, 19 Feb 2025 05:49:21 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3C28BF8
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 05:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944161; cv=none; b=izSQ44HNsT5Z5q6syK0uYiQ6YSCClRkdBps8G+GoL/QvaTJuogpGYiskBfXLl2pZyg4ujlGok9GbNVE3tmuxRw+6uVrW7Y4qJqy72PJCWjby4ILYv1IDuWeGr1xZ05fQ90X1PRRKpeiFCOz+YqAjmVDRHbM2vPKyIsYr/JSsz+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944161; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=utYrrbEIK03H1fNrwtDrjPT68gGz/5/rRskXvpoctwV7pH+ALKifpwstx0Ms1AcTejWtHqnkcDuaeg/bszDSEaRZV0lN4oBKtbwvzJSRGtap+3HZ7rvR0ULLEyewreOjdoio8rYLNxlzFgw8WzwnnHUZPOY3qzx2TvKz+U0C+Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 22DBF67373; Wed, 19 Feb 2025 06:49:16 +0100 (CET)
Date: Wed, 19 Feb 2025 06:49:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH v1.1 1/2] mkfs,xfs_repair: don't pass a daddr as the
 flags argument
Message-ID: <20250219054915.GB10520@lst.de>
References: <20250219040813.GL21808@frogsfrogsfrogs> <20250219054659.GO21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219054659.GO21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


