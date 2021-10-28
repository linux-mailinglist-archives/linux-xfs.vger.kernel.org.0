Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B49443D713
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Oct 2021 01:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbhJ0XFA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 27 Oct 2021 19:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhJ0XFA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Oct 2021 19:05:00 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F34FC061570
        for <linux-xfs@vger.kernel.org>; Wed, 27 Oct 2021 16:02:34 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so3207109pjb.3
        for <linux-xfs@vger.kernel.org>; Wed, 27 Oct 2021 16:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TIqjtDMduKwUTBKX+tBygnWIDjEpMEr2bhy/yT20mZY=;
        b=REyhBK6tQZDsAnyKckv+GTqli7ewznlsn87vyBbY5f9febMQ9OwtuAQWJhdicQr38K
         K1RmGd24wmhycGjPGNyFLV1NcRjXV0YOMJgCvWwD1u2op9FVS5Ne01Ma8I3/7N/vKG+L
         Nf/tcy6ZTKg9EdZlESmgy/KdDpwwSItb4MeferFvOhl0fHKDs4iLoNdhifCWx1/jKI7k
         we4R1sn71TU5C2vgTscBN2f7yTZYEbFO4nfi+2G6AAM+9u32OYSh0jX2w1H4FzdcM3Ry
         12G6L2JWGDbLkKio2wNGWYlGKXiSVAEj+xqYbUihB4TpfsaefQ6c0TKQ0AY7vxbKpFnC
         uryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TIqjtDMduKwUTBKX+tBygnWIDjEpMEr2bhy/yT20mZY=;
        b=V0ILY1b0jOUuvvM4R7vgm3X4Ycfwyj+FEigL+JzdWc0GW3TyTq6CqQ229vD4+dYVqn
         oX6xSfcp01Q2d8+/KdQza2gejAZJ1qVj7HB8RIIE/puwJymMwlzGum7kByk9o8NWsKqp
         /yBnmawPjwpi+D1U4TGTtex3w2L0Blr/PNUZM0rzlafGlgl7w1OY0jRjTtDt0bmo4cut
         I2rjM2F6xpo7Nf0V/sfTfFBOCKuhfKt+mL/4zJOjFNXnJG8cxb5M6OmTKoWqlsISdMlo
         XsttrFYSt2wYTjDPnQPEBBwpxZhFTIV0AJVmXhZ4muJh81/QUT2kD2I3JIoer/oMrk+C
         CWzw==
X-Gm-Message-State: AOAM531dNTrSHIEHQ6qat+VWpn36X+G/ZCxSSr8JRlQBY3hbZMQcHPQu
        WmbSNGF7zTXLzW84VXhisOZxArMjBw9pOeYBWhyDEg==
X-Google-Smtp-Source: ABdhPJxUwYpsZPDBKuNiovYR0U6XMhxIiDSjLBJJ1e6zz5gkWe8hCvGUK6ph3bxfDtcB6AFtR1bn5v1MGpOhiVcMhIY=
X-Received: by 2002:a17:90a:a085:: with SMTP id r5mr8858216pjp.8.1635375753946;
 Wed, 27 Oct 2021 16:02:33 -0700 (PDT)
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de> <20211018044054.1779424-5-hch@lst.de>
In-Reply-To: <20211018044054.1779424-5-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 27 Oct 2021 16:02:22 -0700
Message-ID: <CAPcyv4gUU1D25XSY32oDEbpLXRCvQ_q34sL86xmQ_cH0q5PjZQ@mail.gmail.com>
Subject: Re: [PATCH 04/11] dax: remove the pgmap sanity checks in generic_fsdax_supported
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Drivers that register a dax_dev should make sure it works, no need
> to double check from the file system.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/super.c | 49 +--------------------------------------------
>  1 file changed, 1 insertion(+), 48 deletions(-)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 9383c11b21853..04fc680542e8d 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -107,13 +107,9 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
>                 struct block_device *bdev, int blocksize, sector_t start,
>                 sector_t sectors)
>  {
> -       bool dax_enabled = false;
>         pgoff_t pgoff, pgoff_end;
> -       void *kaddr, *end_kaddr;
> -       pfn_t pfn, end_pfn;
>         sector_t last_page;
> -       long len, len2;
> -       int err, id;
> +       int err;
>
>         if (blocksize != PAGE_SIZE) {
>                 pr_info("%pg: error: unsupported blocksize for dax\n", bdev);
> @@ -138,49 +134,6 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
>                 return false;
>         }
>
> -       id = dax_read_lock();
> -       len = dax_direct_access(dax_dev, pgoff, 1, &kaddr, &pfn);
> -       len2 = dax_direct_access(dax_dev, pgoff_end, 1, &end_kaddr, &end_pfn);
> -
> -       if (len < 1 || len2 < 1) {
> -               pr_info("%pg: error: dax access failed (%ld)\n",
> -                               bdev, len < 1 ? len : len2);
> -               dax_read_unlock(id);
> -               return false;
> -       }
> -
> -       if (IS_ENABLED(CONFIG_FS_DAX_LIMITED) && pfn_t_special(pfn)) {
> -               /*
> -                * An arch that has enabled the pmem api should also
> -                * have its drivers support pfn_t_devmap()
> -                *
> -                * This is a developer warning and should not trigger in
> -                * production. dax_flush() will crash since it depends
> -                * on being able to do (page_address(pfn_to_page())).
> -                */
> -               WARN_ON(IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API));
> -               dax_enabled = true;
> -       } else if (pfn_t_devmap(pfn) && pfn_t_devmap(end_pfn)) {
> -               struct dev_pagemap *pgmap, *end_pgmap;
> -
> -               pgmap = get_dev_pagemap(pfn_t_to_pfn(pfn), NULL);
> -               end_pgmap = get_dev_pagemap(pfn_t_to_pfn(end_pfn), NULL);
> -               if (pgmap && pgmap == end_pgmap && pgmap->type == MEMORY_DEVICE_FS_DAX
> -                               && pfn_t_to_page(pfn)->pgmap == pgmap
> -                               && pfn_t_to_page(end_pfn)->pgmap == pgmap
> -                               && pfn_t_to_pfn(pfn) == PHYS_PFN(__pa(kaddr))
> -                               && pfn_t_to_pfn(end_pfn) == PHYS_PFN(__pa(end_kaddr)))

This is effectively a self-test for a regression that was found while
manipulating the 'struct page' memmap metadata reservation for PMEM
namespaces.

I guess it's just serving as a security-blanket now and I should find
a way to move it out to a self-test. I'll take a look.

> -                       dax_enabled = true;
> -               put_dev_pagemap(pgmap);
> -               put_dev_pagemap(end_pgmap);
> -
> -       }
> -       dax_read_unlock(id);
> -
> -       if (!dax_enabled) {
> -               pr_info("%pg: error: dax support not enabled\n", bdev);
> -               return false;
> -       }
>         return true;
>  }
>  EXPORT_SYMBOL_GPL(generic_fsdax_supported);
> --
> 2.30.2
>
