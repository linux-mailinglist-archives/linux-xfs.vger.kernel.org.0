Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4573781A0A
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Aug 2019 14:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfHEMyB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 5 Aug 2019 08:54:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39562 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbfHEMyB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Aug 2019 08:54:01 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so31135925wrt.6
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 05:54:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=G9E+RgWkVrF+pm0H6Ppn0gCbe3uiM2pDAU7ioSJnk+0=;
        b=c8SgfdFEf61vx9YgaQQaiIdQ9VSIPsFAy1IEVBtW7KzEEb/Y3hpOgRuFY+6TJz7Stb
         amTXBoHDPw/FIObnllKoCFAEh5FKjWOYHsaUZvg/tfEYsQAJkbK74aVi8DVBrkESrno8
         wXEd1iReIAHZ/gpS1IdGM9vHCtQ9BdhDum7mTY+rdGjeg1iRdBdQwpcu5vPoc2lgrA4B
         A/QI+zNnz68zpD+HiEzrcNSQ+Xmk0cFOZu2wCMDj6Mlgg2luTLtHYctqWkfuBlqMHTi5
         Y0PC5XjQdxJYqaKoIFTZiBj+saVQaFuZH4l1hKwmYV2cAgW45qUR7nreY2tg9w174W13
         yR7w==
X-Gm-Message-State: APjAAAWLQ5XVCdwW5GC8nf/FguriWr2mCR8H2pfSM7D1b8AbE6dGGgjT
        38Q7UU3m0vMNLU/d0omIf8ucYA==
X-Google-Smtp-Source: APXvYqyk/4ytgMqL9AOgJJvvw/FNgfXYvx0pYzJ2ioq7xXgDn0GrgOXqqRuYi3jmbU+lvRfuC0aqZQ==
X-Received: by 2002:adf:8364:: with SMTP id 91mr161118192wrd.13.1565009639424;
        Mon, 05 Aug 2019 05:53:59 -0700 (PDT)
Received: from orion.maiolino.org (11.72.broadband12.iol.cz. [90.179.72.11])
        by smtp.gmail.com with ESMTPSA id y18sm81204699wmi.23.2019.08.05.05.53.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 05:53:58 -0700 (PDT)
Date:   Mon, 5 Aug 2019 14:53:56 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     hch@infradead.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Damien.LeMoal@wdc.com,
        Christoph Hellwig <hch@lst.de>, agruenba@redhat.com
Subject: Re: [PATCH 5/5] iomap: move struct iomap_page out of iomap.h
Message-ID: <20190805125356.bv42m4kiszy2ozqg@orion.maiolino.org>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        hch@infradead.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Damien.LeMoal@wdc.com,
        Christoph Hellwig <hch@lst.de>, agruenba@redhat.com
References: <156444951713.2682520.8109813555788585092.stgit@magnolia>
 <156444955325.2682520.4411161096506742768.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156444955325.2682520.4411161096506742768.stgit@magnolia>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 29, 2019 at 06:19:13PM -0700, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Now that all the writepage code is in the iomap code there is no
> need to keep this structure public.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


>  fs/iomap/buffered-io.c |   17 +++++++++++++++++
>  include/linux/iomap.h  |   17 -----------------
>  2 files changed, 17 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 1a7570c441c8..ba0511131868 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -23,6 +23,23 @@
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/iomap.h>
>  
> +/*
> + * Structure allocated for each page when block size < PAGE_SIZE to track
> + * sub-page uptodate status and I/O completions.
> + */
> +struct iomap_page {
> +	atomic_t		read_count;
> +	atomic_t		write_count;
> +	DECLARE_BITMAP(uptodate, PAGE_SIZE / 512);
> +};
> +
> +static inline struct iomap_page *to_iomap_page(struct page *page)
> +{
> +	if (page_has_private(page))
> +		return (struct iomap_page *)page_private(page);
> +	return NULL;
> +}
> +
>  static struct bio_set iomap_ioend_bioset;
>  
>  static struct iomap_page *
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 834d3923e2f2..38464b8f34b9 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -134,23 +134,6 @@ loff_t iomap_apply(struct inode *inode, loff_t pos, loff_t length,
>  		unsigned flags, const struct iomap_ops *ops, void *data,
>  		iomap_actor_t actor);
>  
> -/*
> - * Structure allocate for each page when block size < PAGE_SIZE to track
> - * sub-page uptodate status and I/O completions.
> - */
> -struct iomap_page {
> -	atomic_t		read_count;
> -	atomic_t		write_count;
> -	DECLARE_BITMAP(uptodate, PAGE_SIZE / 512);
> -};
> -
> -static inline struct iomap_page *to_iomap_page(struct page *page)
> -{
> -	if (page_has_private(page))
> -		return (struct iomap_page *)page_private(page);
> -	return NULL;
> -}
> -
>  ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
>  		const struct iomap_ops *ops);
>  int iomap_readpage(struct page *page, const struct iomap_ops *ops);
> 

-- 
Carlos
