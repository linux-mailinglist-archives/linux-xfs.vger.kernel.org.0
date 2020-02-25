Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF1E16ED35
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Feb 2020 18:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgBYRzZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Feb 2020 12:55:25 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59194 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728119AbgBYRzZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:55:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+v8EG//n+FPz9hvDJKyOrWyumJLLo+7MIDaMvpHJ8HU=; b=B50Sdx6ukBB/6gptUXuN2se8LV
        KpFyPwdAzZzFrNo+GmlVG5JBuor5z8Te2TVQPV/10XH/wOyIbILz+xVWBQxFZknUqlBx269JGDsQL
        UCQEDM/sLFqQ8RkPymv/GSuT4bUqNZXl0u/jO/4efpTKR8s2QTU19pgkD9NiV/YED0/e0XlOwMjOO
        zgFEp8rCK4FpuJ9JcbvZn1fUincAan8vEM97fZKKxwMBXukA6iHlcX79GgHp4TDf+/Na1j1PLymCC
        XJm/XS8sruebPikR4rrw/zVpiNb9DBc+UwW5UlcYFAgeWOzoFpb2ZVUPKCniF/bLgSnkbAGbqOM8a
        TFDmstLA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eQW-0002UO-8E; Tue, 25 Feb 2020 17:55:24 +0000
Date:   Tue, 25 Feb 2020 09:55:24 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/14] libxfs: make libxfs_buf_read_map return an error
 code
Message-ID: <20200225175524.GA4129@infradead.org>
References: <158258964941.453666.10913737544282124969.stgit@magnolia>
 <158258968040.453666.4902763032639084601.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258968040.453666.4902763032639084601.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:14:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make libxfs_buf_read_map() and libxfs_readbuf() return an error code
> instead of making callers guess what happened based on whether or not
> they got a buffer back.
> 
> Add a new SALVAGE flag so that certain utilities (xfs_db and xfs_repair)
> can attempt salvage operations even if the verifiers failed, which was
> the behavior before this change.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/io.c            |    4 +--
>  libxfs/libxfs_io.h |   25 ++++++++++++------
>  libxfs/rdwr.c      |   71 +++++++++++++++++++++++++++++++++++++++++-----------
>  libxfs/trans.c     |   24 ++++--------------
>  repair/da_util.c   |    3 +-
>  5 files changed, 82 insertions(+), 45 deletions(-)
> 
> 
> diff --git a/db/io.c b/db/io.c
> index b81e9969..5c9d72bb 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -542,8 +542,8 @@ set_cur(
>  		if (!iocur_top->bbmap)
>  			return;
>  		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
> -		bp = libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
> -					bbmap->nmaps, 0, ops);
> +		libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b, bbmap->nmaps,
> +				LIBXFS_READBUF_SALVAGE, &bp, ops);
>  	} else {
>  		bp = libxfs_buf_read(mp->m_ddev_targp, blknum, len, 0, ops);
>  		iocur_top->bbmap = NULL;

I think instead of ignorining the error and checkig b_error further down
that should be moved to work based on the return value.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
