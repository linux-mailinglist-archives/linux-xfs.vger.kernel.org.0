Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02BAA319E5
	for <lists+linux-xfs@lfdr.de>; Sat,  1 Jun 2019 08:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfFAG3I (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 1 Jun 2019 02:29:08 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:35829 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbfFAG3I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Jun 2019 02:29:08 -0400
Received: by mail-ot1-f66.google.com with SMTP id n14so11424050otk.2
        for <linux-xfs@vger.kernel.org>; Fri, 31 May 2019 23:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pvQK6WJG0mGv3pVSu5OSYb8LqyE3fhcFrJhciECSYJY=;
        b=zAq3dmDcYmDOFRGWPRho3n9VwHtS/ms4RxAtlrWfGP6kzMscluGhAO/pUa4TA+4EUS
         O0/4V2wR9qZcVx3qMS3QoB+HAQeLd2d2CDwsDN1N3DBbRKcGdR7bB+bQJPhBtO5qBBD8
         qYtkmlkUSEKMjZ50q7KpWOF2nJop+rQTGA+KOkHdzHd+G7A7NpsAwm9za6+lD17Xpadt
         bBwCs0HFc6tNdDL6uOqSRQ+UbMp0iEmi4VLXhjbg/8iQ6ZYHFac4FNgAxARif9GzMuH6
         t9gOCBA01URioVkiQ14oCPcK7W+RxbSIJNNYh1f11vuThMbN9aOLBPGBjStFZqhbk42U
         MHXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pvQK6WJG0mGv3pVSu5OSYb8LqyE3fhcFrJhciECSYJY=;
        b=TcSHyMM9P6DETEXvHaDmssNnZgfRsUKu8/xft0iYxo1m9SqkhI+GdDYriraYPjmRgH
         zVKDQl3kpq+mXo2sGRtLMl0cNnlsuJBj61wf+G1MkSPUsqYWt+MRjAult7M/vgSp7l8d
         KgijTOo9L/QJTGHp1hMiOaVblHxiGHgP2PHsCzRzg1qHU2BjZxoJInh62hIr+83rJY3u
         MzXzUHCh6XUTUJullR2YWurq0rlvaRMLoYRCs9JskQ/dowP2XMyBfx+VVr6jdK838B2l
         91p/ZnCb3p/tTWEIyK4t8Syvu4K4ImsaDLq04PigIsRGoStKSeNBnJ7FK9WT8ZspHYe1
         zZ9w==
X-Gm-Message-State: APjAAAV3jb7z7nDazbvud05ixf1nI/xwakQap0hxDdm6SRj1c89ZkavP
        h9RKnl49Rw0mv9wnD+CiJmU07FaDZCowg2Pyue7zWA==
X-Google-Smtp-Source: APXvYqxuwOV4rRKEmSZCq5qcwBRWuusFc8LtQ4tAccMQn0kPo+oROMhcV0mbfJCQAHkg4BYqbZdyRhVUU/uCtJ3RX78=
X-Received: by 2002:a9d:7a8b:: with SMTP id l11mr4259219otn.247.1559370547538;
 Fri, 31 May 2019 23:29:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190521133713.31653-1-pagupta@redhat.com> <20190521133713.31653-5-pagupta@redhat.com>
In-Reply-To: <20190521133713.31653-5-pagupta@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 31 May 2019 23:28:56 -0700
Message-ID: <CAPcyv4iW-UeHBs+qSii2Pk7Q2Nki6imGBTEORuxEAWgEMMp=nA@mail.gmail.com>
Subject: Re: [PATCH v10 4/7] dm: enable synchronous dax
To:     Pankaj Gupta <pagupta@redhat.com>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        KVM list <kvm@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Qemu Developers <qemu-devel@nongnu.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Ross Zwisler <zwisler@kernel.org>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Christoph Hellwig <hch@infradead.org>,
        Len Brown <lenb@kernel.org>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        jmoyer <jmoyer@redhat.com>,
        Nitesh Narayan Lal <nilal@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        david <david@fromorbit.com>, cohuck@redhat.com,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        yuval shaia <yuval.shaia@oracle.com>,
        Adam Borowski <kilobyte@angband.pl>, jstaron@google.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Mike Snitzer <snitzer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 6:43 AM Pankaj Gupta <pagupta@redhat.com> wrote:
>
>  This patch sets dax device 'DAXDEV_SYNC' flag if all the target
>  devices of device mapper support synchrononous DAX. If device
>  mapper consists of both synchronous and asynchronous dax devices,
>  we don't set 'DAXDEV_SYNC' flag.
>
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> ---
>  drivers/md/dm-table.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index cde3b49b2a91..1cce626ff576 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -886,10 +886,17 @@ static int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
>         return bdev_dax_supported(dev->bdev, PAGE_SIZE);
>  }
>
> +static int device_synchronous(struct dm_target *ti, struct dm_dev *dev,
> +                              sector_t start, sector_t len, void *data)
> +{
> +       return dax_synchronous(dev->dax_dev);
> +}
> +
>  static bool dm_table_supports_dax(struct dm_table *t)
>  {
>         struct dm_target *ti;
>         unsigned i;
> +       bool dax_sync = true;
>
>         /* Ensure that all targets support DAX. */
>         for (i = 0; i < dm_table_get_num_targets(t); i++) {
> @@ -901,7 +908,14 @@ static bool dm_table_supports_dax(struct dm_table *t)
>                 if (!ti->type->iterate_devices ||
>                     !ti->type->iterate_devices(ti, device_supports_dax, NULL))
>                         return false;
> +
> +               /* Check devices support synchronous DAX */
> +               if (dax_sync &&
> +                   !ti->type->iterate_devices(ti, device_synchronous, NULL))
> +                       dax_sync = false;

Looks like this needs to be rebased on the current state of v5.2-rc,
and then we can nudge Mike for an ack.
