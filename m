Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2BB14F8EDE
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Apr 2022 08:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbiDHG1Y (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Apr 2022 02:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbiDHG1W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Apr 2022 02:27:22 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D9B16CE63
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 23:25:17 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id ku13-20020a17090b218d00b001ca8fcd3adeso11063333pjb.2
        for <linux-xfs@vger.kernel.org>; Thu, 07 Apr 2022 23:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gpTt04knjFi7/r4rdhBFpeWlnWTTiUe1d93mQq2Do3I=;
        b=MAz6RPib3bcwbnw7VOzDKsX4M+0+QU+QgCQSRlXjmf8Y1j5E82C3MrTGAgpPQP7x2/
         7b9XV/2KcaXsvw+GrapP/fImELYl5GNzN9cbv9exuPksDfOeysAV7CzrjAFcCFLdpyD4
         cv20aVQbMuVGhrrBsMZl3Y8jzXtJorYiwaZ6s95JJpE0/CNVsbKtdGQ2lozCaCX2Z2jj
         aCCws8x6/Q4nlxvNHMQu8EzHC848KqfeK37XWl/JO83aKLXIaLW6At4fR5a2AYuvw90o
         YBWxQySI3dDSIpAkhSAUDAIqcG8Am5xjHEv3dQvB8v6T2tmLMTp34RjSYln0W0Mrb2aR
         fI4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gpTt04knjFi7/r4rdhBFpeWlnWTTiUe1d93mQq2Do3I=;
        b=aMN/L4qk138xJ8wywXFzXEEx180xsHfeaVzczvOq4kBy6HIOta7lDT9oA+eAjsVUAs
         BBa+UdpZMvBSV7eOFDvalp+/m5Jl6U9D2RuB0ICXMcQOe2AEzFhEPacJmotGBPGoDqN4
         0pO10t3H4v/eNM3/LoBt0wbmZGcLMNCs+teJ0WT8pMIYcvQELRWH0MJwEP8vIKCxl4In
         j5/01zpHLS0rsZ1WT2HOFdXa+Wrwhu3EfnI+Jna88MX6RmRxNKqpt6+PEyGVk8OE02HV
         QnK7vsCJrPLdGNp/3WggGmF+7445buMJ3qsidsqUSJ1J0rT3718MRT0ChWvmxXM21oQs
         iPWQ==
X-Gm-Message-State: AOAM531vJTfzfDqrMjT6TH5cMrMvrEwrOTyJeUSuix0z8EDxfceh7uXJ
        wMawS6AQS5kWUrYAh9FXh/A5lNdyb8xduFyDjgZ2tg==
X-Google-Smtp-Source: ABdhPJzID/VraWAFCvRtOjZrpYKIIRqJ1ed+REfBAOD4Tjags0hA+q9Oe2WNNyfILt9xFCTGNazEpbsu/uJg2gJ2j9Y=
X-Received: by 2002:a17:90a:c083:b0:1c6:a164:fd5d with SMTP id
 o3-20020a17090ac08300b001c6a164fd5dmr20043007pjs.8.1649399116938; Thu, 07 Apr
 2022 23:25:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220227120747.711169-1-ruansy.fnst@fujitsu.com>
 <20220227120747.711169-8-ruansy.fnst@fujitsu.com> <YkPyBQer+KRiregd@infradead.org>
In-Reply-To: <YkPyBQer+KRiregd@infradead.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 7 Apr 2022 23:25:06 -0700
Message-ID: <CAPcyv4g5V-0bUXQEJjqxLg=Q-t4jzgx5XNO--iRuHiLkUvgcBQ@mail.gmail.com>
Subject: Re: [PATCH v11 7/8] xfs: Implement ->notify_failure() for XFS
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
        Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 29, 2022 at 11:01 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> > @@ -1892,6 +1893,8 @@ xfs_free_buftarg(
> >       list_lru_destroy(&btp->bt_lru);
> >
> >       blkdev_issue_flush(btp->bt_bdev);
> > +     if (btp->bt_daxdev)
> > +             dax_unregister_holder(btp->bt_daxdev, btp->bt_mount);
> >       fs_put_dax(btp->bt_daxdev);
> >
> >       kmem_free(btp);
> > @@ -1939,6 +1942,7 @@ xfs_alloc_buftarg(
> >       struct block_device     *bdev)
> >  {
> >       xfs_buftarg_t           *btp;
> > +     int                     error;
> >
> >       btp = kmem_zalloc(sizeof(*btp), KM_NOFS);
> >
> > @@ -1946,6 +1950,14 @@ xfs_alloc_buftarg(
> >       btp->bt_dev =  bdev->bd_dev;
> >       btp->bt_bdev = bdev;
> >       btp->bt_daxdev = fs_dax_get_by_bdev(bdev, &btp->bt_dax_part_off);
> > +     if (btp->bt_daxdev) {
> > +             error = dax_register_holder(btp->bt_daxdev, mp,
> > +                             &xfs_dax_holder_operations);
> > +             if (error) {
> > +                     xfs_err(mp, "DAX device already in use?!");
> > +                     goto error_free;
> > +             }
> > +     }
>
> It seems to me that just passing the holder and holder ops to
> fs_dax_get_by_bdev and the holder to dax_unregister_holder would
> significantly simply the interface here.
>
> Dan, what do you think?

Yes, makes sense, just like the optional holder arguments to blkdev_get_by_*().

>
> > +#if IS_ENABLED(CONFIG_MEMORY_FAILURE) && IS_ENABLED(CONFIG_FS_DAX)
>
> No real need for the IS_ENABLED.  Also any reason to even build this
> file if the options are not set?  It seems like
> xfs_dax_holder_operations should just be defined to NULL and the
> whole file not supported if we can't support the functionality.
>
> Dan: not for this series, but is there any reason not to require
> MEMORY_FAILURE for DAX to start with?

Given that DAX ties some storage semantics to memory and storage
supports EIO I can see an argument to require memory_failure() for
DAX, and especially for DAX on CXL where hotplug is supported it will
be necessary. Linux currently has no facility to consult PCI drivers
about removal actions, so the only recourse for a force removed CXL
device is mass memory_failure().

>
> > +
> > +     ddev_start = mp->m_ddev_targp->bt_dax_part_off;
> > +     ddev_end = ddev_start +
> > +             (mp->m_ddev_targp->bt_bdev->bd_nr_sectors << SECTOR_SHIFT) - 1;
>
> This should use bdev_nr_bytes.
>
> But didn't we say we don't want to support notifications on partitioned
> devices and thus don't actually need all this?

Right.
