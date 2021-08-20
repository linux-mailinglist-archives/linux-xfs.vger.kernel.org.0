Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27D03F24D6
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Aug 2021 04:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237677AbhHTCjt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 19 Aug 2021 22:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbhHTCjt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 22:39:49 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94767C061757
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 19:39:11 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id c17so7769642pgc.0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 19:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B1IPaWShRHO+S25ine4LYsuzUXNhBul7A3bHVmcZDqE=;
        b=0gwRYHEqYWePuJCzO2svmy0/lNuaBmSffRSw1ZofYgxmAU/rssfc+J1MepkcG6/okN
         7V8fqOUyi+1+K8GqJ1GgeDmO8mORGRYMVNU9mnG2b171m9Hy/3u4njWDORMDsh5hJ06V
         LNMSW1mDL9CaYbJXLwxx2k2tgtvsz/1cBki1zgdzoCq799wzfIPJLoJLsR2geNBdRzzf
         iVkedpOQXO0SHka0x3RqsLVCzVRDc/tYrK3D43xKZQF5ffMDIRRJNy2q2wz9+86t64aD
         IHOgNhxcPwN8gOBwQFkQTUCj/xQ3XX3FMqILbPVk5NnmdwWtZqv6AkcT3rUl3YWu9d47
         NkTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B1IPaWShRHO+S25ine4LYsuzUXNhBul7A3bHVmcZDqE=;
        b=FbOjz4pkueE/59fuar1mK4ekrN7IgMvLckRHjw4jm5pKZo2qw0mlWkP3hlDJgjN+iC
         i58HIpMyrMQ7+YYIAuwqhwZXrJ+u+Zuu4cQQ2bOQr/ZTvBWaNORTirlE4jnDRVBpwZne
         RL+FRkXR7Z99m3TQWAs8AgqMCl+ENcn9tIThplvNSLc+e7Ou+37cTQmCd9fODUKacQBO
         K8rsgc4aofZPgtILkehCnFH1XqGf5/4PBeNUNm4t1+D/RJ0uM/VYck1BycPWImPufTGh
         bORdCv9D8GXanlGZj4wn6U7zhcrJWk8RXvkx+82XopqZMzGEz/C2tKVs6IF/MVx17VX8
         GyYw==
X-Gm-Message-State: AOAM532ljI2kZnJhqRXo/Gf1G+AC+5xFAKPkSj7znB6zIYdyvxiO7kpb
        gpt9+yy5EV39q6jC0aFDsqlK90QOJdalpZpOqN877Q==
X-Google-Smtp-Source: ABdhPJwc+o+M3KzvmYCuetm2zFZXHE5MraYO1ybETeCPb1awpwHv4HohqKP5JpPREoXBHHDM7lWNAj4l1bsIBGP++Fw=
X-Received: by 2002:a63:311:: with SMTP id 17mr16548751pgd.450.1629427151147;
 Thu, 19 Aug 2021 19:39:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com> <20210816060359.1442450-5-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210816060359.1442450-5-ruansy.fnst@fujitsu.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 19 Aug 2021 19:39:00 -0700
Message-ID: <CAPcyv4gFDyXqu5NyrWQ9Y_JqjLmCb8pWQgPZVBYE=dOir2KdzA@mail.gmail.com>
Subject: Re: [PATCH v7 4/8] fsdax: Add dax_iomap_cow_copy() for dax_iomap_zero
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        david <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>,
        Ritesh Harjani <riteshh@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 15, 2021 at 11:04 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> Punch hole on a reflinked file needs dax_iomap_cow_copy() too.
> Otherwise, data in not aligned area will be not correct.  So, add the
> srcmap to dax_iomap_zero() and replace memset() as dax_iomap_cow_copy().
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/dax.c               | 25 +++++++++++++++----------
>  fs/iomap/buffered-io.c |  4 ++--
>  include/linux/dax.h    |  3 ++-
>  3 files changed, 19 insertions(+), 13 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index e49ba68cc7e4..91ceb518f66a 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1198,7 +1198,8 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
>  }
>  #endif /* CONFIG_FS_DAX_PMD */
>
> -s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
> +s64 dax_iomap_zero(loff_t pos, u64 length, const struct iomap *iomap,
> +               const struct iomap *srcmap)
>  {
>         sector_t sector = iomap_sector(iomap, pos & PAGE_MASK);
>         pgoff_t pgoff;
> @@ -1220,19 +1221,23 @@ s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
>
>         if (page_aligned)
>                 rc = dax_zero_page_range(iomap->dax_dev, pgoff, 1);
> -       else
> +       else {
>                 rc = dax_direct_access(iomap->dax_dev, pgoff, 1, &kaddr, NULL);
> -       if (rc < 0) {
> -               dax_read_unlock(id);
> -               return rc;
> -       }
> -
> -       if (!page_aligned) {
> -               memset(kaddr + offset, 0, size);
> +               if (rc < 0)
> +                       goto out;
> +               if (iomap->addr != srcmap->addr) {
> +                       rc = dax_iomap_cow_copy(pos, size, PAGE_SIZE, srcmap,
> +                                               kaddr);

Apologies, I'm confused, why is it ok to skip zeroing here?
