Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4D63ADAA
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Jun 2019 05:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387462AbfFJDkc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 9 Jun 2019 23:40:32 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34141 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387420AbfFJDkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Jun 2019 23:40:32 -0400
Received: by mail-wm1-f67.google.com with SMTP id w9so8051590wmd.1;
        Sun, 09 Jun 2019 20:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qFsgkDd1cYm63QEc69PHNhgRq7z2h6ZGeN9RjYR8A6E=;
        b=ZVacXVDwqq0AfKYMAtgYew+uknY0wX3cUNqUebZIrAGhK6w0JmPLW0vu4d0WnhPFGE
         QIBWVeaXivOQ/XPKUMNyGI/L3nDwD/slndtSJ8cdqz7fGDRqb5O7k1mRaOwCGmPG51dp
         7NEjGwsGvH76n8Wr1MNDEXy+gnFEKkFiQv3j3ByimM4zdIozd/T5VWjbsMuYoTNn9Tno
         wq+kc3VlCRnzH4HECo89J8Z7Jf7pEm7Vlt9fFTMm9XMAGBHITKI4PrcYkVcTz/RXX3aw
         tPgWr17VPpbnwuhtBXfh5N/VsufAQzubH7RVqBMXKpV7Mzsq8FzzY2Vh7W66z2JVlqZW
         whpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qFsgkDd1cYm63QEc69PHNhgRq7z2h6ZGeN9RjYR8A6E=;
        b=RP185lAGbRzfF8ImYgsGXHnVvwfqFZ8ba4XJXbmkUqJX+FyuAgdkk6NtA165RiWXcD
         ermxakO4TJuLBsI54x/Ne/KqLDYjG2ZGNuaGI9l6hPooel8EVoyWm+W+mikOiTrVIzri
         GFtydHauolP5/ktDj4yzmMqzbnuPYmTJNLIZxkIRnRikAhoUBc6cqQDVHggEO/4aW4bb
         IUjTMHWIq0LZ6wQhnIOQVSvxNxqAENnuWtiuy+WKwaUCfXD666oBYd9R21seGwSKF5Ai
         d0GsLgaJ/UyBlqV8HJnh6qAih6xUT522Dj+GPwJW43Izwsu0i0R3swpkHWnibJ5svDbQ
         CFIw==
X-Gm-Message-State: APjAAAWDsL2zMMPaIju9S+wKbQco6CqOkNQEhVw21bW5r+2rBI10yDyo
        eY+FSxAoIHbAw9dL0WC/oswLXpyfxni5LxBETNI=
X-Google-Smtp-Source: APXvYqxFgqnU2Jv0WjPX+YyBML8E8oXl5/fGsZTM+7MyiNvWesA1FtzazN/dZb3lfK6kJgVRguRrw5Jl7pUTkWqNGtQ=
X-Received: by 2002:a1c:8049:: with SMTP id b70mr11400834wmd.33.1560138029926;
 Sun, 09 Jun 2019 20:40:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190608164853.10938-1-ming.lei@redhat.com> <20190608164853.10938-3-ming.lei@redhat.com>
In-Reply-To: <20190608164853.10938-3-ming.lei@redhat.com>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Mon, 10 Jun 2019 11:40:18 +0800
Message-ID: <CACVXFVMt1APzg-4vma+Jw-c5=pJhbYFRETjjw0PkeX_1hw--Qw@mail.gmail.com>
Subject: Re: [PATCH 2/2] block: fix page leak in case of merging to same page
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 9, 2019 at 12:50 AM Ming Lei <ming.lei@redhat.com> wrote:
>
> Different iovec may use one same page, then 'pages' array filled
> by iov_iter_get_pages() may get reference of the same page several
> times. If some page in 'pages' can be merged to same page in one bvec
> by bio_add_page(), bio_release_pages() only drops the page's reference
> once.
>
> This way causes page leak reported by David Gibson.
>
> This issue can be triggered since 576ed913 ("block: use bio_add_page in
> bio_iov_iter_get_pages").
>
> Fixes the issue by put the page's ref if it is merged to same page.
>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Cc: linux-xfs@vger.kernel.org
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christoph Hellwig <hch@infradead.org>
> Link: https://lkml.org/lkml/2019/4/23/64
> Fixes: 576ed913 ("block: use bio_add_page in bio_iov_iter_get_pages")
> Reported-by: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/bio.c         | 14 ++++++++++++--
>  include/linux/bio.h |  1 +
>  2 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/block/bio.c b/block/bio.c
> index 39e3b931dc3b..5f7b46360c36 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -657,6 +657,10 @@ static inline bool page_is_mergeable(const struct bio_vec *bv,
>         WARN_ON_ONCE((flags & BVEC_MERGE_TO_SAME_PAGE) &&
>                         (len + off) > PAGE_SIZE);
>
> +       if ((flags & BVEC_MERGE_PUT_SAME_PAGE) &&
> +                       (flags & BVEC_MERGE_TO_SAME_PAGE))
> +               put_page(page);
> +
>         return true;
>  }
>
> @@ -924,8 +928,14 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
>                 struct page *page = pages[i];
>
>                 len = min_t(size_t, PAGE_SIZE - offset, left);
> -               if (WARN_ON_ONCE(bio_add_page(bio, page, len, offset) != len))
> -                       return -EINVAL;
> +
> +               if (!__bio_try_merge_page(bio, page, len, offset,
> +                                       BVEC_MERGE_PUT_SAME_PAGE |
> +                                       BVEC_MERGE_TO_SAME_PAGE)) {

oops, it is wrong to pass  BVEC_MERGE_TO_SAME_PAGE here, which
should disable multi-page merge.

Please ignore this patchset, and will fix it in V2.


Thanks,
Ming Lei
