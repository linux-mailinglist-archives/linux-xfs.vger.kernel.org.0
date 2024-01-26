Return-Path: <linux-xfs+bounces-3058-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1703A83DC91
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Jan 2024 15:43:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C840A288127
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Jan 2024 14:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFE3B1CF9C;
	Fri, 26 Jan 2024 14:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wLXHe4BC"
X-Original-To: linux-xfs@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4561B1CF98
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 14:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279990; cv=none; b=AAiCiKCaApilkGirVjDCiOjjZBofDnXkFdYIKMkeJUyAYdIppvEzn5eA1QCcXFog2AXu/f10PJmLTTLGzMYXbxJDIJrLlFpyj2zlR2ftHjefvrdzin1e3i73u2M9fF1PsrcmqZtv0bhFQLb2HX6952gMLRhvw5qZjidPODGK94A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279990; c=relaxed/simple;
	bh=7XKbec2LcnU987o8pw8iua9wzpKtf0DohpYvKHaf5Ec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MLJXvL+WVT0RkQ/pU28hMqzoaha32EyrVsfjxQ7oN5vByuIXnAys5EKmuPJzVOhjxczLH6+O29MtkbsQ7xuhJ2rJk53w820h5XSgn4dpIgYQQZK90WuIwXSg2wLOmk7+o2se6zJV4zn8dE4FeKkNmmL5rVzxySbqsvq32ECiP04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wLXHe4BC; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AYbY5MD9srbQyAvnaEHSQYRi9+c23EwzC+PzOiScw0Y=; b=wLXHe4BCP1vDtN6f1hdJpgs+tf
	2Q2gyYp1EOxLaDKUCb3vKUx+mfTbZY7e1HI4zrhU2aau5jjJzxSpKQHqVYgBAu3xT43cqOO+grJSg
	wsspbaH4J8z8zFSZKydMSDZ54RkVRr0ZGV2PU5vDQ6UvqaxCxQ3B6uQRJKJZrX2uQjfk7fxR+zjzY
	727GIlMEBLCUenRsepIXTK6VbZkO7g0gZ3/Uc2i+hGZK8FYYvFSRLyiUGdcfrpue2Xn4nAk5LBlZw
	jDLQfZOMTObqWE/bUzBB9laqFupx6mT+w6lDvoafgMHRlpN2g0LBCTfQQSzlY5fRT1u7K+6YH7SDg
	4WWID4ow==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTNMu-0000000DtpC-2XzI;
	Fri, 26 Jan 2024 14:39:44 +0000
Date: Fri, 26 Jan 2024 14:39:44 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 01/21] mm: move mapping_set_update out of <linux/swap.h>
Message-ID: <ZbPEMOTHZ1NoDOoe@casper.infradead.org>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126132903.2700077-2-hch@lst.de>

On Fri, Jan 26, 2024 at 02:28:43PM +0100, Christoph Hellwig wrote:
> mapping_set_update is only used inside mm/.  Move mapping_set_update to
> mm/internal.h and turn it into an inline function instead of a macro.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

