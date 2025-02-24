Return-Path: <linux-xfs+bounces-20107-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99DBFA42754
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Feb 2025 17:06:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F9DA188E700
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Feb 2025 16:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C87725A2AD;
	Mon, 24 Feb 2025 16:02:19 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375D03DBB6;
	Mon, 24 Feb 2025 16:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740412939; cv=none; b=bq051w5ItwzzWI24+YJWsYEYSh6hYxYZOCvHrnkoxlZDT4MD8iqMJUWVZu8taqxaFdaY7dGDA/zfiASgWF0WebBfJo0yNkW18suQQqRqDN8aKR3yzfsOrzoqZVKXZnXfLem94k5+4Bw8mJqyPhzhog/p+zzL2aenjn/5Nku9RmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740412939; c=relaxed/simple;
	bh=KGTWjvtb+6Tnwgqf+kMV6m/4VPxG7L1QgxU5BeApu80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PiYUdDUL4qX4s+WAxjLtagKMSMQs+FVjdoDdA6aNreyv5aKfehKz9K2vFZDsCxEy++8sZtJ0r376o3iMdZkWpryvgk9XxqS6BjjZRANdASFZF35Cvd41EyrHGX+yWZXtvsOCjcKL71bOIbAll91GzAueLfzIRyRsnWOhdVtR4kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7B47268BFE; Mon, 24 Feb 2025 17:02:10 +0100 (CET)
Date: Mon, 24 Feb 2025 17:02:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>,
	"Raphael S. Carvalho" <raphaelsc@scylladb.com>,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	djwong@kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] mm: Fix error handling in __filemap_get_folio()
 with FGP_NOWAIT
Message-ID: <20250224160209.GA4701@lst.de>
References: <20250224081328.18090-1-raphaelsc@scylladb.com> <20250224141744.GA1088@lst.de> <Z7yRSe-nkfMz4TS2@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7yRSe-nkfMz4TS2@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Feb 24, 2025 at 03:33:29PM +0000, Matthew Wilcox wrote:
> I don't think it needs a comment at all, but the memory allocation
> might be for something other than folios, so your suggested comment
> is misleading.

Then s/folio/memory/

