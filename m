Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65BBB5A6AD
	for <lists+linux-xfs@lfdr.de>; Sat, 29 Jun 2019 00:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfF1WC4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 28 Jun 2019 18:02:56 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42691 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfF1WC4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 18:02:56 -0400
Received: by mail-pg1-f196.google.com with SMTP id k13so3155786pgq.9
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 15:02:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vefUelA8hT+A+cBuH79yE7h2DqtDwNwPXmNV0rAieQw=;
        b=gfrFaQpq9HKQHut7unbbtt5u78cs4CfRFYCWJU2/Haj/fvq8Dyzttmbl6daDRaKEeO
         18mOXeTW6ZjHbVG5Yj501Mj8thCmFs9xoqfttNmzsX6pRv1irKj1mn7wde+16S2Odc7i
         8ULj7sesCqTggTSV4PvLYTAoSd642ItbveRghUl9uDdJbtHxqZl3hhAtyEKgCqfn7ff3
         WB5VRxKhO7lvpbPpdkuScKgkB9CWqPZ5Fnc6X00fUBJvyIRuAEuc4LKzXi9c5yWmnST/
         fzDn445x4zvZeVjlWtLcemZQDOJA1VOxdVCzUKvpJe5mJNaCYmKrFRh7rF/aIwkUj0C1
         TAuw==
X-Gm-Message-State: APjAAAVuwWT0rTvMNqhQwudrYec9jLoldtyKykvvEGxOWFaAd4aCWcMZ
        JUv0w8IvBuvbVIZU3z0/ucE=
X-Google-Smtp-Source: APXvYqwZVa1tAr2YGMKiBT6PJvm2bV4MlJFJPzFtBRF8MesOk2n81WLR4I/ClB0Ofy181zU54okEuQ==
X-Received: by 2002:a63:c0f:: with SMTP id b15mr11323873pgl.33.1561759375207;
        Fri, 28 Jun 2019 15:02:55 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id d4sm2774874pju.19.2019.06.28.15.02.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 15:02:53 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 33EF3402AC; Fri, 28 Jun 2019 22:02:53 +0000 (UTC)
Date:   Fri, 28 Jun 2019 22:02:53 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: fix iclog allocation size
Message-ID: <20190628220253.GF30113@42.do-not-panic.com>
References: <20190627143950.19558-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627143950.19558-1-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 27, 2019 at 04:39:50PM +0200, Christoph Hellwig wrote:
> Properly allocate the space for the bio_vecs instead of just one byte
> per bio_vec.
> 
> Fixes: 991fc1d2e65e ("xfs: use bios directly to write log buffers")

I cannot find 991fc1d2e65e on Linus' tree, nor can I find the subject
name patch on Linus' tree. I'm probably missing some context here?

> Reported-by: syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 0f849b4095d6..e230f3c18ceb 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1415,7 +1415,8 @@ xlog_alloc_log(
>  	 */
>  	ASSERT(log->l_iclog_size >= 4096);
>  	for (i = 0; i < log->l_iclog_bufs; i++) {
> -		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE);
> +		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE) *
> +				sizeof(struct bio_vec);
>  
>  		iclog = kmem_zalloc(sizeof(*iclog) + bvec_size, KM_MAYFAIL);
>  		if (!iclog)
> -- 
> 2.20.1
> 
