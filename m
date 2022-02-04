Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADE44A93A9
	for <lists+linux-xfs@lfdr.de>; Fri,  4 Feb 2022 06:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242596AbiBDFei (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 4 Feb 2022 00:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243464AbiBDFeh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Feb 2022 00:34:37 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6401C061714
        for <linux-xfs@vger.kernel.org>; Thu,  3 Feb 2022 21:34:37 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 192so4189492pfz.3
        for <linux-xfs@vger.kernel.org>; Thu, 03 Feb 2022 21:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3aYp4Y6S+6Gb2kVa9/dfBS0YmJLNZ9g5MDY83trp3jE=;
        b=3uxIlPlxMjCMor3fUa5A1CVTOKqzwIs88e75GZ6lwMFIeSEuDYJQ+HhdiOSMvMZUC2
         el8NY8R7Q9+3swpx5TANATK4m3B46DtiHaJIy7ZzPYpTGGqeEnZr7PLssTl1cvpAcOZU
         nokKYUdj3Z7tk3YSujQ+QUROL/NmwF0Mm9NS6YpsBHvyMbu3IFFqUIrt+ZXYbm9WfUY3
         OqcFP+UX5+Fblg9IA+7D9UjfvmsRx7z63seKJWSPaFSowJKfc/i5nVZUIHAHSlP5QkVV
         AUKpbmFIPpD4NPvGvvu+ybsVNz7R3PudpeIms5A7qbXIfHObHTenOpzq85d5Tf96p99l
         LS9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3aYp4Y6S+6Gb2kVa9/dfBS0YmJLNZ9g5MDY83trp3jE=;
        b=Nv9AhFBIu0eFS3cBHj4iUgH1Sml8sNJzaL+l08Pac9D9xqX/fA5kPxFlv1zbozJnBp
         QMFAhsR25i916pWSvIGqbKTcvN/DngYof/ab2DDMhTH7iHk0cFQHibL5tlZMZvkBbDuN
         HuRP5WP9FRrW+LfKgH85bExtD7531giJjWzLNjcKOJkeTJUbDRR2zanOazy1MwYrcvtq
         ja2iURWcjM97sQSndZGRf11CGVoLGyCyF8cOji/OyW2Ap//r1th0LZzqw7hv3/8Bx3bJ
         IhrAQA/bwDwBvtjlyRvJ/OY5n+Z2EOTbGGwagi8zkJYOeMb0VrjEgKZFSyTOQZuapJWk
         v1hA==
X-Gm-Message-State: AOAM531shiAVFJ8DOAG2dICLdW4nJALubXowSphrZKTnoR4ttSEGLvoi
        +mZVYcQiycblIs6DIiL8ksr5JS5wcpjepvcP05D/8w==
X-Google-Smtp-Source: ABdhPJxkwin78+MQJeCI7c5YXNEsK0mcEauKNshyhXHK8pXn7gbTrlWDvF68YcAOEJJFUIqSHpEVknWFvdBz/Brte1A=
X-Received: by 2002:a05:6a00:1312:: with SMTP id j18mr1391861pfu.61.1643952877343;
 Thu, 03 Feb 2022 21:34:37 -0800 (PST)
MIME-Version: 1.0
References: <20220128213150.1333552-1-jane.chu@oracle.com> <20220128213150.1333552-4-jane.chu@oracle.com>
In-Reply-To: <20220128213150.1333552-4-jane.chu@oracle.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 3 Feb 2022 21:34:25 -0800
Message-ID: <CAPcyv4jw+meUy-DrLgqn_4kPCF2WAZrMJ8Nan4xCncr7-4Y0hw@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] dm: make dm aware of target's DAXDEV_RECOVERY capability
To:     Jane Chu <jane.chu@oracle.com>
Cc:     david <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Weiny, Ira" <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 28, 2022 at 1:32 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> If one of the MD raid participating target dax device supports
> DAXDEV_RECOVERY, then it'll be declared on the whole that the
> MD device is capable of DAXDEV_RECOVERY.
> And only when the recovery process reaches to the target driver,
> it becomes deterministic whether a certain dax address range
> maybe recovered, or not.
>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  drivers/md/dm-table.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index e43096cfe9e2..8af8a81b6172 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -844,6 +844,36 @@ static bool dm_table_supports_dax(struct dm_table *t,
>         return true;
>  }
>
> +/* Check whether device is capable of dax poison recovery */
> +static int device_poison_recovery_capable(struct dm_target *ti,
> +       struct dm_dev *dev, sector_t start, sector_t len, void *data)
> +{
> +       if (!dev->dax_dev)
> +               return false;
> +       return dax_recovery_capable(dev->dax_dev);

Hmm it's not clear to me that dax_recovery_capable is necessary. If a
dax_dev does not support recovery it can simply fail the
dax_direct_access() call with the DAX_RECOVERY flag set.

So all DM needs to worry about is passing the new @flags parameter
through the stack.
