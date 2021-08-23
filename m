Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D9C3F50A4
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Aug 2021 20:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhHWSqr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 23 Aug 2021 14:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhHWSqq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Aug 2021 14:46:46 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF544C061757
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 11:46:03 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id t42so13573416pfg.12
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 11:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bsWLS5Lsvli6/G6DR+M0//W1oeoCxpbroaiM0AweC2U=;
        b=cJwve58u1e5m7sq1m17LOxCx1TWZxIV225n3TyUIWLcuS7wiK3So1eEBRuWJuVlR2f
         ZLXuzA8sLPpwGnGe2Yk1AyXRJZDBWlRISfYsJ8gv6749D39kIF8KnvTCK3EbCOxUaxlp
         LGmfd7P1T4eH9WLpW17RKt0hIP2I/Vhp5q00KhjRS7FCdn/BvKP+nFi/hJKqAUpSBmBQ
         ahmtxdhOeKhEeHJ6iEJJFl9MgIYiM+ZU9UmBohE35lPT+s38Y12qHJ/Yq7JJTx4WQoaB
         L/OYBbRTy1crtTWqUvFh5XbJQGNjKDLPiSiYFz84weHUGmtIs3wik5fXRuL2uugwYOeE
         pLiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bsWLS5Lsvli6/G6DR+M0//W1oeoCxpbroaiM0AweC2U=;
        b=QfQCQ6pUxehoxMZGGwLgu5B8vLyUhCvCHwR1QVF4BgSc23mCSqv72MnimIdaC7N+hF
         DhspXU7G4tYUS55xtQ9f2uebZmV9WQro+punB9QaG4Hvsg0Ol8GTSfoCAzg3M07I2hTL
         JbxvhrSq6k80HWlSu2xVxfhVYPCoYTzRnFTd7PWrI72H9r6Qv7WUUyOyzrnznHKqUZKr
         T5YhZ9GNnF8CI2oZlHz/dhl+4bfgznMSXjRUvT9RFeVTyPf0MykfDPEbCWU93WeJqHMN
         BtOiQNRJbDIIuFSuHHzbgGWtugqifWKcH19Onj8qStzOqfCg0rJl5oKo99NWmv8mnEfw
         jKyw==
X-Gm-Message-State: AOAM532GK9xokMREtjryDWpyELrZrmke+yLAlGdsV/QfT4TroFQ6nxcu
        6bf9bD/vdyPN8d5XE+HNc26GvzOStg8/0o75pEf4zQ==
X-Google-Smtp-Source: ABdhPJxpo0+vyQ+xK7UvVGbCGg974A5JaeqyO5j1qTLhfDJa9Ok2iMc/TS0rPaPh8KlGL59bGBG0Nq+rOhg4vkr2vRw=
X-Received: by 2002:a63:dd0e:: with SMTP id t14mr32040633pgg.279.1629744363336;
 Mon, 23 Aug 2021 11:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-2-hch@lst.de>
In-Reply-To: <20210823123516.969486-2-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 23 Aug 2021 11:45:52 -0700
Message-ID: <CAPcyv4h0QdHi10ngaXtuisxeZ+66wd-oy0F7r9C0FjJmyXBOFg@mail.gmail.com>
Subject: Re: [PATCH 1/9] fsdax: improve the FS_DAX Kconfig description and
 help text
To:     Christoph Hellwig <hch@lst.de>
Cc:     Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 23, 2021 at 5:37 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Rename the main option text to clarify it is for file system access,
> and add a bit of text that explains how to actually switch a nvdimm
> to a fsdax capable state.
>

Looks good, nice improvement. A couple suggestions below.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/Kconfig | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/fs/Kconfig b/fs/Kconfig
> index a7749c126b8e..37e4441119cf 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -43,7 +43,7 @@ source "fs/f2fs/Kconfig"
>  source "fs/zonefs/Kconfig"
>
>  config FS_DAX
> -       bool "Direct Access (DAX) support"
> +       bool "File system based Direct Access (DAX) support"
>         depends on MMU
>         depends on !(ARM || MIPS || SPARC)
>         select DEV_PAGEMAP_OPS if (ZONE_DEVICE && !FS_DAX_LIMITED)
> @@ -53,8 +53,19 @@ config FS_DAX
>           Direct Access (DAX) can be used on memory-backed block devices.
>           If the block device supports DAX and the filesystem supports DAX,
>           then you can avoid using the pagecache to buffer I/Os.  Turning
> -         on this option will compile in support for DAX; you will need to
> -         mount the filesystem using the -o dax option.
> +         on this option will compile in support for DAX.
> +
> +         For a DAX device to support file system access it needs to have
> +         struct pages.  For the nfit based NVDIMMs this can be enabled
> +         using the ndctl utility:
> +
> +               # ndctl create-namespace --force --reconfig=namespace0.0 \
> +                       --mode=fsdax --map=mem

There's still the concern that on systems with small amount of DRAM
relative to large amounts of PMEM that --map=mem might consume all
available memory for 'struct page'. Perhaps just add:

"See the 'create-namespace' man page for details on the overhead of
--map=mem: https://docs.pmem.io/ndctl-user-guide/ndctl-man-pages/ndctl-create-namespace"

> +
> +          For ndctl to work CONFIG_DEV_DAX needs to be enabled as well.
> +         For most file systems DAX support needs to be manually enable
> +         globally or per-inode using a mount option as well.  See the
> +         file system documentation for details.

How about include the link?

"See the file system documentation for details:
https://www.kernel.org/doc/html/latest/filesystems/dax.html"
