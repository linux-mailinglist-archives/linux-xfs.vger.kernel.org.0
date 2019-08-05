Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1C1D81982
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Aug 2019 14:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfHEMka (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 5 Aug 2019 08:40:30 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55632 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728144AbfHEMk3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Aug 2019 08:40:29 -0400
Received: by mail-wm1-f65.google.com with SMTP id a15so74587831wmj.5
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 05:40:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=q7ZVsZ1op4P5GMI7g8p+O9VTqMm9iNPgN5MigtIJzGQ=;
        b=ph6szbDHdQh1kXvpzSgQoR7b0wy5OlhUAWHfh5WZsi8NT61lR3giGaZeR8lx/VoMcM
         y86sJnWQ3sjR/a5iyhUJ4I2pvl7Tj5yUdCRFZdrkGm2i1eikRx2F765j1EBkv+k2xFmK
         EzPpLHOKF8Dmgoat8c6nlOUEighF2VV4z9l446MBmm52eQ5aHYMg7Qz8R6OhZHa1Dr5W
         aadLqQhJ/7anayERnd2rlb5UmCKfngZsjeEt2EAeXN+vIXcEak+laXzhOD+bqaaXTM66
         dAN3aBx9c8bdaRPDA23COrMdWMC1n8qh4+nj0CN2f9GAA53sCxB5N2Wd0/CR6dENB+45
         83iQ==
X-Gm-Message-State: APjAAAWFu5HFFk/rdS1w4qCanUI1Cfll520KhlJk4+OK24H63/9ioqDX
        KdSTB0xvgSKP7jpVUg8mYH8xM6//VCs=
X-Google-Smtp-Source: APXvYqztk2uGkrT64v5sV5mRy1M7YCP0TdldL0mORHEQfBIxc50v72qQZ3ET2HVQfzY0BMB/KB5E3Q==
X-Received: by 2002:a1c:a942:: with SMTP id s63mr18520576wme.76.1565008826446;
        Mon, 05 Aug 2019 05:40:26 -0700 (PDT)
Received: from orion.maiolino.org (11.72.broadband12.iol.cz. [90.179.72.11])
        by smtp.gmail.com with ESMTPSA id i6sm82861038wrv.47.2019.08.05.05.40.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 05:40:25 -0700 (PDT)
Date:   Mon, 5 Aug 2019 14:40:23 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     hch@infradead.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Damien.LeMoal@wdc.com,
        Christoph Hellwig <hch@lst.de>, agruenba@redhat.com
Subject: Re: [PATCH 2/5] xfs: turn io_append_trans into an io_private void
 pointer
Message-ID: <20190805124023.lmmjm4izwvhkdnjw@orion.maiolino.org>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        hch@infradead.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Damien.LeMoal@wdc.com,
        Christoph Hellwig <hch@lst.de>, agruenba@redhat.com
References: <156444951713.2682520.8109813555788585092.stgit@magnolia>
 <156444953370.2682520.16687269798277531218.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156444953370.2682520.16687269798277531218.stgit@magnolia>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 29, 2019 at 06:18:53PM -0700, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> In preparation for moving the ioend structure to common code we need
> to get rid of the xfs-specific xfs_trans type.  Just make it a file
> system private void pointer instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_aops.c |   26 +++++++++++++-------------
>  fs/xfs/xfs_aops.h |    2 +-
>  2 files changed, 14 insertions(+), 14 deletions(-)
> 


Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 8a1cd562a358..12f42922251c 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -150,7 +150,7 @@ xfs_setfilesize_trans_alloc(
>  	if (error)
>  		return error;
>  
> -	ioend->io_append_trans = tp;
> +	ioend->io_private = tp;
>  
>  	/*
>  	 * We may pass freeze protection with a transaction.  So tell lockdep
> @@ -217,7 +217,7 @@ xfs_setfilesize_ioend(
>  	int			error)
>  {
>  	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> -	struct xfs_trans	*tp = ioend->io_append_trans;
> +	struct xfs_trans	*tp = ioend->io_private;
>  
>  	/*
>  	 * The transaction may have been allocated in the I/O submission thread,
> @@ -282,10 +282,10 @@ xfs_end_ioend(
>  	else if (ioend->io_type == IOMAP_UNWRITTEN)
>  		error = xfs_iomap_write_unwritten(ip, offset, size, false);
>  	else
> -		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_append_trans);
> +		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_private);
>  
>  done:
> -	if (ioend->io_append_trans)
> +	if (ioend->io_private)
>  		error = xfs_setfilesize_ioend(ioend, error);
>  	xfs_destroy_ioends(ioend, error);
>  	memalloc_nofs_restore(nofs_flag);
> @@ -318,13 +318,13 @@ xfs_ioend_can_merge(
>   * as it is guaranteed to be clean.
>   */
>  static void
> -xfs_ioend_merge_append_transactions(
> +xfs_ioend_merge_private(
>  	struct xfs_ioend	*ioend,
>  	struct xfs_ioend	*next)
>  {
> -	if (!ioend->io_append_trans) {
> -		ioend->io_append_trans = next->io_append_trans;
> -		next->io_append_trans = NULL;
> +	if (!ioend->io_private) {
> +		ioend->io_private = next->io_private;
> +		next->io_private = NULL;
>  	} else {
>  		xfs_setfilesize_ioend(next, -ECANCELED);
>  	}
> @@ -346,8 +346,8 @@ xfs_ioend_try_merge(
>  			break;
>  		list_move_tail(&next->io_list, &ioend->io_list);
>  		ioend->io_size += next->io_size;
> -		if (next->io_append_trans)
> -			xfs_ioend_merge_append_transactions(ioend, next);
> +		if (next->io_private)
> +			xfs_ioend_merge_private(ioend, next);
>  	}
>  }
>  
> @@ -410,7 +410,7 @@ xfs_end_bio(
>  
>  	if (ioend->io_fork == XFS_COW_FORK ||
>  	    ioend->io_type == IOMAP_UNWRITTEN ||
> -	    ioend->io_append_trans != NULL) {
> +	    ioend->io_private) {
>  		spin_lock_irqsave(&ip->i_ioend_lock, flags);
>  		if (list_empty(&ip->i_ioend_list))
>  			WARN_ON_ONCE(!queue_work(mp->m_unwritten_workqueue,
> @@ -675,7 +675,7 @@ xfs_submit_ioend(
>  	    (ioend->io_fork == XFS_COW_FORK ||
>  	     ioend->io_type != IOMAP_UNWRITTEN) &&
>  	    xfs_ioend_is_append(ioend) &&
> -	    !ioend->io_append_trans)
> +	    !ioend->io_private)
>  		status = xfs_setfilesize_trans_alloc(ioend);
>  
>  	memalloc_nofs_restore(nofs_flag);
> @@ -724,7 +724,7 @@ xfs_alloc_ioend(
>  	ioend->io_inode = inode;
>  	ioend->io_size = 0;
>  	ioend->io_offset = offset;
> -	ioend->io_append_trans = NULL;
> +	ioend->io_private = NULL;
>  	ioend->io_bio = bio;
>  	return ioend;
>  }
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index 4af8ec0115cd..6a45d675dcba 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -18,7 +18,7 @@ struct xfs_ioend {
>  	struct inode		*io_inode;	/* file being written to */
>  	size_t			io_size;	/* size of the extent */
>  	xfs_off_t		io_offset;	/* offset in the file */
> -	struct xfs_trans	*io_append_trans;/* xact. for size update */
> +	void			*io_private;	/* file system private data */
>  	struct bio		*io_bio;	/* bio being built */
>  	struct bio		io_inline_bio;	/* MUST BE LAST! */
>  };
> 

-- 
Carlos
