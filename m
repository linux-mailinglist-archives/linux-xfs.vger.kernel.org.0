Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 872ED494C9
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 00:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727633AbfFQWJ1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Jun 2019 18:09:27 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:42544 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbfFQWJ0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jun 2019 18:09:26 -0400
Received: by mail-yw1-f67.google.com with SMTP id s5so5787240ywd.9
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2019 15:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=37RAusjL+qGthykpMCesacuiaMCcKpwrg3lD3kxifAk=;
        b=JUEKsPHUgmCjr0HgasL53mJtqBRgJ8OQvlN0nZf1lVrjCVxaXahCnJ43EDCsWk0QPP
         ZPuzuzr1RAwyAq/Wj3nAf7wo3HdRJotryxfd8gHLCCqU/ZpswrLBS+NtK92pn+lGxVJx
         ADp7bb4oi3q9Oe3FKL7vxJOiyDMgXbXUTkJZVB84+72rwY4ir3+jzJLP1MWQRtq+YoiU
         kYwmrSr6kP27Vs51lRoDdQ+wS3HkjghbIHADwLFp/vsZQStLLJvUlm9txZNheufDaAbs
         FJl51WFkU9x7VZbD6LTVJC/mZON/cTXyavEH8XwfY3qur8mirLq9lAcUYDi8e1ct4Pjz
         ZwAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=37RAusjL+qGthykpMCesacuiaMCcKpwrg3lD3kxifAk=;
        b=RaIsxzUUhYX5ZO3KNrwl7gj+/QWQzUn8PjeJg7tE3SR1T9AtrXxdTjGa361ahzSyOm
         X5Z9ffQpdGDNQstZHbnEf8qja7fH6mptJA2/f9cMSrYE2P4GlUqvPJtCfXAjHKu9o7f5
         504ASelXv1LMj9LSQfHkyCXdpXyAweVyMSVZWXi29tR2opZDxQs9VxlWpVEuKwNGZSmT
         vrPnscfLgowqj/F46Ltg/v6tFIyynYHMJ/WYqkvzeHoW0lPalpoaU8rx2DVhikQKmMev
         rkMsbcYMdPV5mRSTMTmfr2TLcC/HCR/GL3vpc6OeYJL0DqTmWMXagsnABYHcCaxwQ0Pu
         kyrw==
X-Gm-Message-State: APjAAAVzJxfpWiBhgzLuN5AC/uKuHuZDeUFymf0FsZt3qus+M7fccroQ
        qDB3OIIPd/KAkGb5icp68SPva826OhWF0jEd5UI=
X-Google-Smtp-Source: APXvYqycrdEhwG/+QIgcgKhyojIzuTuig0nydYXTfFO3Af8ypOsYU9KA9Bsn3JISaWW1qLE+xXDlwr9u0rB1P1dJofM=
X-Received: by 2002:a81:2343:: with SMTP id j64mr62386867ywj.224.1560809366147;
 Mon, 17 Jun 2019 15:09:26 -0700 (PDT)
MIME-Version: 1.0
References: <e6968aa2-a5ad-4964-2966-589486e4a251@sandeen.net>
 <20190606195724.2975689-1-sheenobu@fb.com> <f89a09b5-8a91-51e0-d869-039dbe9a7349@sandeen.net>
 <20190606215008.GA14308@dread.disaster.area> <4a03b347-1a71-857d-af9d-1d7eca00056a@sandeen.net>
 <20190606223607.GE14308@dread.disaster.area>
In-Reply-To: <20190606223607.GE14308@dread.disaster.area>
From:   Sheena Artrip <sheena.artrip@gmail.com>
Date:   Mon, 17 Jun 2019 15:09:15 -0700
Message-ID: <CABeZSNkGoKhfV2-=CfqSPUsf9CxLNFP5vRa161M_LowfnJ8TzA@mail.gmail.com>
Subject: Re: [PATCH v2] xfs_restore: detect rtinherit on destination
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Sheena Artrip <sheenobu@fb.com>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 6, 2019 at 3:37 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Thu, Jun 06, 2019 at 05:08:12PM -0500, Eric Sandeen wrote:
> > On 6/6/19 4:50 PM, Dave Chinner wrote:
> > > My take on this is that we need to decide which allocation policy to
> > > use - the kernel policy or the dump file policy - in the different
> > > situations. It's a simple, easy to document and understand solution.
> > >
> > > At minimum, if there's a mismatch between rtdev/non-rtdev between
> > > dump and restore, then restore should not try to restore or clear rt
> > > flags at all. i.e the rt flags in the dump image should be
> > > considered invalid in this situation and masked out in the restore
> > > process. This prevents errors from being reported during restore,
> > > and it does "the right thing" according to how the user has
> > > configured the destination directory. i.e.  if the destdir has the
> > > rtinherit bit set and there's a rtdev present, the kernel policy
> > > will cause all file data that is restored to be allocated on the
> > > rtdev. Otherwise the kernel will place it (correctly) on the data
> > > dev.
> > >
> > > In the case where both have rtdevs, but you want to restore to
> > > ignore the dump file rtdev policy, we really only need to add a CLI
> > > option to say "ignore rt flags" and that then allows the kernel
> > > policy to dictate how the restored files are placed in the same way
> > > that having a rtdev mismatch does.
> > >
> > > This is simple, consistent, fulfils the requirements and should have
> > > no hidden surprises for users....
> >
> > Sounds reasonable.  So the CLI flag would say "ignore RT info in the
> > dump, and write files according to the destination fs policy?"
> > I think that makes sense.

Any suggested flag name/prefix for this? Last i checked all the single
letters were taken up?

> *nod*
>
> > Now: do we need to do the same for all inheritable flags?  projid,
> > extsize, etc?  I think we probably do.
>
> I disagree. These things are all supported on all destination
> filesystems, unlike the rtdev. They are also things that can be
> changed after the fact, unlike rtdev allocation policy. i.e. rtdev
> has to be set /before/ restore, just about everything else can be
> set or reset after the fact....
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
