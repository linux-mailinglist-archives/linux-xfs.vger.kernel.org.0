Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B612F1C53
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Jan 2021 18:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731104AbhAKR2k (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 11 Jan 2021 12:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbhAKR2j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 12:28:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABD3C061794
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 09:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DjStxDhqQJmhzVhJzsZicI8kdZFsX/CCumySB8+GUh8=; b=BMc5f8I7JRRqS2jeO0pPfjApF0
        P4Lpn5vS6SLSQiro5DBgDqblZvShY6Yk8oH0VbJKku+OwD6rVuurQWm0N/DR/BRGhh4QUaKoMh4P2
        tT0veShR8/818GteoEJzC5Ds3f2W9f5AKgvUS5DiM5ZR7pj3QpXCf4v1UTF3Mta1JhswkxHEphsl7
        wHsiLV3Y5gXGN5wTlJlp63V7jiFz6JD95fDGFJ3HBnl9QQvr8RFWABip2rAG9MfuE7Asce4Hm0uuS
        A6UMJjTa7zeYw9urfadZgg4DXWGCweJtXmt0kPAfbSMRQ4BpMH6PljXydGQz8qt38t8zo0oed2rw3
        F3kQJc+A==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kz0yo-003YkQ-Sa; Mon, 11 Jan 2021 17:27:47 +0000
Date:   Mon, 11 Jan 2021 17:27:46 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] misc: fix valgrind complaints
Message-ID: <20210111172746.GA848188@infradead.org>
References: <161017371478.1142776.6610535704942901172.stgit@magnolia>
 <161017372088.1142776.17470250928392025583.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161017372088.1142776.17470250928392025583.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 08, 2021 at 10:28:40PM -0800, Darrick J. Wong wrote:
>  	char		hbuf [MAXHANSIZ];
>  	int		ret;
> -	uint32_t	handlen;
> +	uint32_t	handlen = 0;
>  	xfs_fsop_handlereq_t hreq;
>  
> +	memset(&hreq, 0, sizeof(hreq));
> +	memset(hbuf, 0, MAXHANSIZ);

Using empty initializers at declaration time is simpler and sometimes
more efficient.  But either way will work fine.

