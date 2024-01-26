Return-Path: <linux-xfs+bounces-3071-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A35F783DF20
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Jan 2024 17:48:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4357D1F219A4
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Jan 2024 16:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B29081DDEB;
	Fri, 26 Jan 2024 16:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AradtZLz"
X-Original-To: linux-xfs@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423CE1DDC9
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 16:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706287680; cv=none; b=oe6DHfzfG6R9fuu2vRNBaRZQPALo6lFJN4fxlrQEckyfWHktJauXfA6ji2Sccv1d1GzmBK+DdohKmkzvqdiyLVArRXLSXk6gP4Hd9Olfs1sSh0WyBtHdRAgITbst3FLdbbZdK1OF0bE3BYxYnVODlwSJ0cIriK++Qd8uC3+mkmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706287680; c=relaxed/simple;
	bh=9AwpEy6qYRfmO3+tq6XP9FLPPejA7zIm46FOl1ym7vc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hG14EqAtzF2JpmU4xHJb91aCNSHBuZeOKJGSTUt9KwRrvSTLHFzRJNsb4+mod57FXiDVN3p8Vo3vzg7BIoMFGs9cliHtYB53DCjKeaQ/ZyEQ7U5/QePLUzy6LDz3CGbQp8pHw/7c19i47Zzq2yFytzBOaeD8lQKZAWlYRPY9x2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AradtZLz; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9jCfrEz+uX7VbktVuh7g8Wwg/zmEUFcGpXjFQj1/e30=; b=AradtZLzE5EFRBBMIuipukN5Ks
	V0aQ8rlsOcOgtvrXCNKlzIkTT6WfOqrNDJDZBn6ZJCOBDkHjAF6b4MizDoE311TRqVCj18XwFpuMz
	nL9I5O3bcfFqXVD1KfKmkl1YIy+jsm7GwqhUk4AliJ98Gv5/hddGShiVEF0GOUzqP/Ly1yoQjg3NC
	SDNXwO85hxcW6rxqdMGJJLKKVVDlFhRyaeNR75V56zJ1rwzbVVZ2lNZIEJEy/xrotsp8dumOlWgQf
	ooi2O0WWQNDeVJUxqBBCueV6HpYToNxfbdGJR4f+2ey7gAy7eDkU3fngLlbjchsE1w/AQH4tlQqcx
	rzcpR0qw==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTPMw-0000000EDl8-328J;
	Fri, 26 Jan 2024 16:47:54 +0000
Date: Fri, 26 Jan 2024 16:47:54 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: put the xfs xfile abstraction on a diet v2
Message-ID: <ZbPiOugiEUYRCR1L@casper.infradead.org>
References: <20240126132903.2700077-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126132903.2700077-1-hch@lst.de>

On Fri, Jan 26, 2024 at 02:28:42PM +0100, Christoph Hellwig wrote:
> this series refactors and simplifies the code in the xfs xfile
> abstraction, which is a thing layer on a kernel-use shmem file.

OK, I've finished reviewing the series.  I'm not offering R-b for the
xfiles portions as I feel I don't understand the code well enough
to do a high quality review.

In general it looks good, and I only had minor quibbles; the overall
direction is good.

