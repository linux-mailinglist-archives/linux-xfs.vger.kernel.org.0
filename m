Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F68441DD2
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Nov 2021 17:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhKAQUV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Nov 2021 12:20:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23643 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231362AbhKAQUU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Nov 2021 12:20:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635783467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F2vxwqlB6wFzeCRM5lLa77O94J13VaOz9ZvoVd+rZG8=;
        b=B7k9y58G4JcIJeeiOMtSuF/pN9PKfe884hWhZsMpBKVicHOLGOaAhA3bkvQohmEfRR30U6
        ZdVJcyY/DGGosjEivx/lAq1oA8SbdNvebn4BSrV8ZNz5rn9Tc0zupJl4VmczztD5x2R0JF
        Ak+B7EQ3PIAaXpM6rGqwJSPquMZgtiQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-6GSFLHlXNtq2GNTza615eg-1; Mon, 01 Nov 2021 12:17:46 -0400
X-MC-Unique: 6GSFLHlXNtq2GNTza615eg-1
Received: by mail-qk1-f198.google.com with SMTP id h8-20020a05620a284800b0045ec745583cso10821302qkp.6
        for <linux-xfs@vger.kernel.org>; Mon, 01 Nov 2021 09:17:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F2vxwqlB6wFzeCRM5lLa77O94J13VaOz9ZvoVd+rZG8=;
        b=5yhkJf1PQHzLnkorgoW0RXAIVZrQGU11De1YljKTQbWIDShvh+vxLGwG5+FhHC2hvs
         iHK4NOslXYkPoWbUIl7LEV75tX/ortjnQfH02PVrxao7uQSF/Js6Wn5laadm0XZOT07g
         SjtyvfvRG6jVsgOdyUNLWx1qdM1ceBKs/u0JL0ASs1DYMQhDB+t7PIZy6VOqJf+1vDov
         XqH2uceCY8LTVo6MdL30wT2GyYsB7Nq3P2JsZjPcgEE4kJcJ4rUSRYjr1EYHIxWKcrGr
         YoltIgaNKZbd6VVH4u3MoKW2Zp7LtkitUxwq3r7Xl9jxHTJ6PiXk/nhSjSOEiSyhxxXB
         61Eg==
X-Gm-Message-State: AOAM532Kh58wa90O9vv4FhMlg3lvsMQoKAXj3g4y4M222ihGH2FWv5Cq
        B6KB8x7tD6Odc1N93SHQJN5yRkacbR05q6qxalMoAakaS00b3YLuU8YJAQjSikZQiWzCgcIUkzY
        WFdicDx7cD4UehQxa3ys=
X-Received: by 2002:a05:622a:1006:: with SMTP id d6mr31006240qte.259.1635783465568;
        Mon, 01 Nov 2021 09:17:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsvnNj6Smb4Ra96XKXfYd15LiYJibYUWXpiZB6UR51qpyc+daCyIZfeeXzYlbHsOmSJkMTRA==
X-Received: by 2002:a05:622a:1006:: with SMTP id d6mr31006216qte.259.1635783465346;
        Mon, 01 Nov 2021 09:17:45 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id f66sm5772868qkj.76.2021.11.01.09.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:17:44 -0700 (PDT)
Date:   Mon, 1 Nov 2021 12:17:43 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Ira Weiny <ira.weiny@intel.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 07/11] dax: remove dax_capable
Message-ID: <YYATJ+oDT15TD9Np@redhat.com>
References: <20211018044054.1779424-1-hch@lst.de>
 <20211018044054.1779424-8-hch@lst.de>
 <CAPcyv4gE8UXjQAe_6=BKFRCyLWNP_9CNxKFH---RpPnYfmBQLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gE8UXjQAe_6=BKFRCyLWNP_9CNxKFH---RpPnYfmBQLg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 27 2021 at  8:16P -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> I am going to change the subject of this patch to:
> 
> dax: remove ->dax_supported()
> 
> On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> 
> I'll add a bit more background to help others review this.
> 
> The ->dax_supported() operation arranges for a stack of devices to
> each answer the question "is dax operational". That request routes to
> generic_fsdax_supported() at last level device and that attempted an
> actual dax_direct_access() call and did some sanity checks. However,
> those sanity checks can be validated in other ways and with those
> removed the only question to answer is "has each block device driver
> in the stack performed dax_add_host()". That can be validated without
> a dax_operation. So, just open code the block size and dax_dev == NULL
> checks in the callers, and delete ->dax_supported().
> 
> Mike, let me know if you have any concerns.

Thanks for your additional background, it helped.


> 
> > Just open code the block size and dax_dev == NULL checks in the callers.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/dax/super.c          | 36 ------------------------------------
> >  drivers/md/dm-table.c        | 22 +++++++++++-----------
> >  drivers/md/dm.c              | 21 ---------------------
> >  drivers/md/dm.h              |  4 ----
> >  drivers/nvdimm/pmem.c        |  1 -
> >  drivers/s390/block/dcssblk.c |  1 -
> >  fs/erofs/super.c             | 11 +++++++----
> >  fs/ext2/super.c              |  6 ++++--
> >  fs/ext4/super.c              |  9 ++++++---
> >  fs/xfs/xfs_super.c           | 21 ++++++++-------------
> >  include/linux/dax.h          | 14 --------------
> >  11 files changed, 36 insertions(+), 110 deletions(-)
> >
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index 482fe775324a4..803942586d1b6 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -108,42 +108,6 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
> >         return dax_dev;
> >  }
> >  EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
> > -
> > -bool generic_fsdax_supported(struct dax_device *dax_dev,
> > -               struct block_device *bdev, int blocksize, sector_t start,
> > -               sector_t sectors)
> > -{
> > -       if (blocksize != PAGE_SIZE) {
> > -               pr_info("%pg: error: unsupported blocksize for dax\n", bdev);
> > -               return false;
> > -       }
> > -
> > -       if (!dax_dev) {
> > -               pr_debug("%pg: error: dax unsupported by block device\n", bdev);
> > -               return false;
> > -       }
> > -
> > -       return true;
> > -}
> > -EXPORT_SYMBOL_GPL(generic_fsdax_supported);
> > -
> > -bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
> > -               int blocksize, sector_t start, sector_t len)
> > -{
> > -       bool ret = false;
> > -       int id;
> > -
> > -       if (!dax_dev)
> > -               return false;
> > -
> > -       id = dax_read_lock();
> > -       if (dax_alive(dax_dev) && dax_dev->ops->dax_supported)
> > -               ret = dax_dev->ops->dax_supported(dax_dev, bdev, blocksize,
> > -                                                 start, len);
> > -       dax_read_unlock(id);
> > -       return ret;
> > -}
> > -EXPORT_SYMBOL_GPL(dax_supported);
> >  #endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
> >
> >  enum dax_device_flags {
> > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > index 1fa4d5582dca5..4ae671c2168ea 100644
> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > @@ -807,12 +807,14 @@ void dm_table_set_type(struct dm_table *t, enum dm_queue_mode type)
> >  EXPORT_SYMBOL_GPL(dm_table_set_type);
> >
> >  /* validate the dax capability of the target device span */
> > -int device_not_dax_capable(struct dm_target *ti, struct dm_dev *dev,
> > +static int device_not_dax_capable(struct dm_target *ti, struct dm_dev *dev,
> >                         sector_t start, sector_t len, void *data)
> >  {
> > -       int blocksize = *(int *) data;
> > +       if (dev->dax_dev)
> > +               return false;
> >
> > -       return !dax_supported(dev->dax_dev, dev->bdev, blocksize, start, len);
> > +       pr_debug("%pg: error: dax unsupported by block device\n", dev->bdev);

Would prefer the use of DMDEBUG() here (which doesn't need trailing \n)

But otherwise:
Acked-by: Mike Snitzer <snitzer@redhat.com>

