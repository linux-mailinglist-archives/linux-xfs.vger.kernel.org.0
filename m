Return-Path: <linux-xfs+bounces-7808-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 890978B5FEF
	for <lists+linux-xfs@lfdr.de>; Mon, 29 Apr 2024 19:18:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28AE91F2120E
	for <lists+linux-xfs@lfdr.de>; Mon, 29 Apr 2024 17:18:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3544B86245;
	Mon, 29 Apr 2024 17:18:45 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B6D83A15
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 17:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714411125; cv=none; b=I2ejiDy9LdUJnlbkBIpSX4v2aapfivTr9AoPvFRbqaHYf3u9fzitAC0I8jYAf9pC9Fj/bB1B0wMfo9pSc/P57L8cLgtK3qlxcc8FIj5P1NLYvY9upOJs/DTnyvOevDi9lc1u81TUCa6w7gBSZ99gM9qUUwDD2QEGtMSVcMvLfzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714411125; c=relaxed/simple;
	bh=2jMDIz7IzHAYsreZ0h0MGoPVodLFnAbBZYd46811a5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T5LTQ6ZtHVtmzpotwikFu2pDvU9BK7Edtmcwi4QUT6I9hRWiAqge4GTmZfC2t3XCOm0sIbOFgXuG0XEuZmsh6VZ7vZFRApNX6G5wY14Cm9/pcElJ8QfjmzEorwkkhb45hxkswDW1+6YWuIUSC4WTtTCJ0J+PiBlEs/aE0O9T4lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D5F07227A87; Mon, 29 Apr 2024 19:18:40 +0200 (CEST)
Date: Mon, 29 Apr 2024 19:18:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: pass the actual offset and len to allocate to
 xfs_bmapi_allocate
Message-ID: <20240429171840.GI31337@lst.de>
References: <20240429061529.1550204-1-hch@lst.de> <20240429061529.1550204-6-hch@lst.de> <20240429154817.GB360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429154817.GB360919@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 29, 2024 at 08:48:17AM -0700, Darrick J. Wong wrote:
> Referencing
> https://lore.kernel.org/linux-xfs/20240410040353.GC1883@lst.de/
> 
> Did you decide against "[moving] the assignments into the other
> branch here to make things more obvious"?

Yes.  I did the move and then noticed that I'd just have to move it
back in the last patch, which feels a bit silly.


