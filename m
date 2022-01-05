Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CC848590F
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jan 2022 20:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243472AbiAETUY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jan 2022 14:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243459AbiAETUY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 14:20:24 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD84AC061245
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 11:20:23 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id v13so249930pfi.3
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jan 2022 11:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dve+wxxw9ty3Px2ty9l66SiGhuevpIEjzTRbcfS2h4g=;
        b=8IJNIV4LzcZk4Gk1i5TwJ2/pjHaI5I/ZxjVO81zSvC7oeyj65UIb0m9RgbG8gz6Kp0
         59mKq0TZ/S9FE0NHhMPgo6Nc/C8C0i2PbWkg7IqNVvQJUIj/VMEch0dRlzvvSTuPhsbR
         dnICrGDtoYXsQq1BitIaSDpchHQK7QHrwe36S7aSMD0JSiKV6KmDUqRqHpc6hAr4jywd
         XwI146AjdrfxzR2kdmIyuvZFzDzCRmYFhNABMaWpQZpI0Gzx3na1ykEIAUjZ/aXuNKEg
         rv17ogtvQ6wW98kRgo5eNawBaWAq1psKDYwgPIMKF4m/zH5bqOV7s8wJvS0XTTuQvuu7
         JB8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dve+wxxw9ty3Px2ty9l66SiGhuevpIEjzTRbcfS2h4g=;
        b=njs1+Enmbj8hjHncImat2sYJADM4QH+Ww9yXOlCym+q5os3p/72mR1v70ESCXJeFDb
         dWjnNwNHatml67nf379L0ZW4LKdW/G6suF3+ruTF0U+MXXXs3kFnd5sAHiZUHnZ4vy68
         pj5Deg+6NuVZ4bMgeorDN1f88hQcMxE8POpUPkJed89FUYvlLNqZGkM3gZzYUFB9OFlZ
         AoU9nOT49RnHx3Toe+MEw3KIgxAzF2McnxiWqS9p4Yckd9vmew32QaI8EbOVRLiYcqJY
         f3j5ykITj2RQgKYxsYQOdEQXOjteOkTBC1+/HaqsdNN2aJJf7XxiRvc9VcFjRjsnp1PW
         dFXg==
X-Gm-Message-State: AOAM532nEKaVkvKCr3ithgjdR/JJZ+jle/EsY3q+HLzo2Xk7exU2ZZTR
        pdcRW05SXlG2ciqkLZjRyA8vehE1mOS6bQPMwWPWpA==
X-Google-Smtp-Source: ABdhPJz3U6I17PcLMJRT9nNHOY2Hml0MXvZXbyzvuHrppEa6CJQNVUp/+QSIaW561mi0Aw4p76wcTbR7GWuXBpuqFko=
X-Received: by 2002:a63:ab01:: with SMTP id p1mr1426162pgf.437.1641410423361;
 Wed, 05 Jan 2022 11:20:23 -0800 (PST)
MIME-Version: 1.0
References: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com>
 <20211226143439.3985960-3-ruansy.fnst@fujitsu.com> <20220105181230.GC398655@magnolia>
 <CAPcyv4iTaneUgdBPnqcvLr4Y_nAxQp31ZdUNkSRPsQ=9CpMWHg@mail.gmail.com> <20220105185626.GE398655@magnolia>
In-Reply-To: <20220105185626.GE398655@magnolia>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 5 Jan 2022 11:20:12 -0800
Message-ID: <CAPcyv4h3M9f1-C5e9kHTfPaRYR_zN4gzQWgR+ZyhNmG_SL-u+A@mail.gmail.com>
Subject: Re: [PATCH v9 02/10] dax: Introduce holder for dax_device
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        david <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 5, 2022 at 10:56 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Wed, Jan 05, 2022 at 10:23:08AM -0800, Dan Williams wrote:
> > On Wed, Jan 5, 2022 at 10:12 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > On Sun, Dec 26, 2021 at 10:34:31PM +0800, Shiyang Ruan wrote:
> > > > To easily track filesystem from a pmem device, we introduce a holder for
> > > > dax_device structure, and also its operation.  This holder is used to
> > > > remember who is using this dax_device:
> > > >  - When it is the backend of a filesystem, the holder will be the
> > > >    instance of this filesystem.
> > > >  - When this pmem device is one of the targets in a mapped device, the
> > > >    holder will be this mapped device.  In this case, the mapped device
> > > >    has its own dax_device and it will follow the first rule.  So that we
> > > >    can finally track to the filesystem we needed.
> > > >
> > > > The holder and holder_ops will be set when filesystem is being mounted,
> > > > or an target device is being activated.
> > > >
> > > > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > > > ---
> > > >  drivers/dax/super.c | 62 +++++++++++++++++++++++++++++++++++++++++++++
> > > >  include/linux/dax.h | 29 +++++++++++++++++++++
> > > >  2 files changed, 91 insertions(+)
> > > >
> > > > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > > > index c46f56e33d40..94c51f2ee133 100644
> > > > --- a/drivers/dax/super.c
> > > > +++ b/drivers/dax/super.c
> > > > @@ -20,15 +20,20 @@
> > > >   * @inode: core vfs
> > > >   * @cdev: optional character interface for "device dax"
> > > >   * @private: dax driver private data
> > > > + * @holder_data: holder of a dax_device: could be filesystem or mapped device
> > > >   * @flags: state and boolean properties
> > > > + * @ops: operations for dax_device
> > > > + * @holder_ops: operations for the inner holder
> > > >   */
> > > >  struct dax_device {
> > > >       struct inode inode;
> > > >       struct cdev cdev;
> > > >       void *private;
> > > >       struct percpu_rw_semaphore rwsem;
> > > > +     void *holder_data;
> > > >       unsigned long flags;
> > > >       const struct dax_operations *ops;
> > > > +     const struct dax_holder_operations *holder_ops;
> > > >  };
> > > >
> > > >  static dev_t dax_devt;
> > > > @@ -192,6 +197,29 @@ int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(dax_zero_page_range);
> > > >
> > > > +int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off,
> > > > +                           u64 len, int mf_flags)
> > > > +{
> > > > +     int rc;
> > > > +
> > > > +     dax_read_lock(dax_dev);
> > > > +     if (!dax_alive(dax_dev)) {
> > > > +             rc = -ENXIO;
> > > > +             goto out;
> > > > +     }
> > > > +
> > > > +     if (!dax_dev->holder_ops) {
> > > > +             rc = -EOPNOTSUPP;
> > > > +             goto out;
> > > > +     }
> > > > +
> > > > +     rc = dax_dev->holder_ops->notify_failure(dax_dev, off, len, mf_flags);
> > > > +out:
> > > > +     dax_read_unlock(dax_dev);
> > > > +     return rc;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(dax_holder_notify_failure);
> > > > +
> > > >  #ifdef CONFIG_ARCH_HAS_PMEM_API
> > > >  void arch_wb_cache_pmem(void *addr, size_t size);
> > > >  void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
> > > > @@ -254,6 +282,10 @@ void kill_dax(struct dax_device *dax_dev)
> > > >               return;
> > > >       dax_write_lock(dax_dev);
> > > >       clear_bit(DAXDEV_ALIVE, &dax_dev->flags);
> > > > +
> > > > +     /* clear holder data */
> > > > +     dax_dev->holder_ops = NULL;
> > > > +     dax_dev->holder_data = NULL;
> > > >       dax_write_unlock(dax_dev);
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(kill_dax);
> > > > @@ -401,6 +433,36 @@ void put_dax(struct dax_device *dax_dev)
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(put_dax);
> > > >
> > > > +void dax_register_holder(struct dax_device *dax_dev, void *holder,
> > > > +             const struct dax_holder_operations *ops)
> > > > +{
> > > > +     if (!dax_alive(dax_dev))
> > > > +             return;
> > > > +
> > > > +     dax_dev->holder_data = holder;
> > > > +     dax_dev->holder_ops = ops;
> > >
> > > Shouldn't this return an error code if the dax device is dead or if
> > > someone already registered a holder?  I'm pretty sure XFS should not
> > > bind to a dax device if someone else already registered for it...
> >
> > Agree, yes.
> >
> > >
> > > ...unless you want to use a notifier chain for failure events so that
> > > there can be multiple consumers of dax failure events?
> >
> > No, I would hope not. It should be 1:1 holders to dax-devices. Similar
> > ownership semantics like bd_prepare_to_claim().
>
> Does each partition on a pmem device still have its own dax_device?

No, it never did...

Just as before, each dax-device is still associated with a gendisk /
whole-block_device. The recent change is that instead of needing that
partition-block_device plumbed to convert a relative block number to
its absolute whole-block_device offset the filesystem now handles that
at iomap_begin() time. See:

                if (mapping_flags & IOMAP_DAX)
                        iomap->addr += target->bt_dax_part_off;

...in xfs_bmbt_to_iomap() (in -next). I.e. bdev_dax_pgoff() is gone
with the lead-in reworks.
