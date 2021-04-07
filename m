Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED53356401
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Apr 2021 08:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbhDGGdt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Apr 2021 02:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbhDGGds (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Apr 2021 02:33:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF809C06174A
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 23:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OvzATXhYZwzqBKeaaLvewwJlr8Dv4A/0F22BOelqFLs=; b=sf3otFhvV11+RcVZalvmxZtxWc
        Cy8u/QZ+aXTvu7mWdVSijTa+D45r3Aws+vPjFNxCYnvewtRjl0S25F7fNIFzVh98QLiEodbHu2gzj
        Y5qEC1ALhVnL5zTWwBHMdU9lq60gIeoR8kZBUq57zKDur7StSMxDCZAD2hnCyv5NZR23JJOeAXCj7
        Ge0bQR16D03ghYBx2KEnkUDyIdpneYALNmm6LbNDICYgiCBDz0wv/o9KIciY2MajHsGRUt/G0Cte1
        ud/Dp0YfhK8qbVYUnTk6u4WMI/EvrWhAPs0spzr3modQ478Oal0ug+7tqDBNQDjE0Taf1BsY1Yze8
        N9K5nH7Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lU1kf-00E18S-0a; Wed, 07 Apr 2021 06:33:29 +0000
Date:   Wed, 7 Apr 2021 07:33:21 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: drop submit side trans alloc for append ioends
Message-ID: <20210407063321.GB3339217@infradead.org>
References: <20210405145903.629152-1-bfoster@redhat.com>
 <20210405145903.629152-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405145903.629152-2-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> @@ -182,12 +155,10 @@ xfs_end_ioend(
>  		error = xfs_reflink_end_cow(ip, offset, size);
>  	else if (ioend->io_type == IOMAP_UNWRITTEN)
>  		error = xfs_iomap_write_unwritten(ip, offset, size, false);
> -	else
> -		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_private);

I first though we'd now call xfs_setfilesize for unwritten extents
as well, but as those have already updated di_size we are fine here.

As a future enhancement it would be useful to let xfs_reflink_end_cow
update the file size similar to what we do for the unwritten case.

>  done:
> -	if (ioend->io_private)
> -		error = xfs_setfilesize_ioend(ioend, error);
> +	if (!error && xfs_ioend_is_append(ioend))
> +		error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
>  	iomap_finish_ioends(ioend, error);

The done label can move after the call to xfs_setfilesize now.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
