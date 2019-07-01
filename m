Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAC5858D2B
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Jun 2019 23:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfF0VfY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Jun 2019 17:35:24 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42950 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfF0VfY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 17:35:24 -0400
Received: by mail-pg1-f193.google.com with SMTP id k13so1585642pgq.9
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jun 2019 14:35:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OPOmeN69iVAmBvntGDpqqdFPIFiXN1uvB4TPi+DIgx8=;
        b=f1WqqGHEeJa7M63/Kx1u4piUWpYa3DpbBQdLxyt7+XEbKXgyCT7rPlfPztYv0btjKS
         4w6Sbn940zQSazIgmX2iUXw2lDdDMlhK3fvI/1EggeDH9zJ8XLXiUkNELPXKP7sR0SjD
         eo7+Tt0u8yeK/3mh7neVGshrHMXs2KFL1cRz/6JsdnnPdMilr3YONZTT+E5k5pnqfjmp
         HrYsw+TUxXyGAwGOFzTjKNp8Ha5XG4vjOPt9kqgK5gGVntGZaC+WmV42HWr5B7VoPQ89
         2LxxV19Uzb2ZlU+q7ps3cloFO9Evipq0iR8OFudSuTj62VYz21tD3W0ycSK4jT5TWgWS
         UenQ==
X-Gm-Message-State: APjAAAU7KlfrokRIGP2OL4tQkF85rZjjSZZkMHFSp2nZ6W+OLOGt9jaM
        f4Dp0L21CIF1iEOEHxgN+A0=
X-Google-Smtp-Source: APXvYqx0j9EVKn1tDRo3L9Jc2lAwOJ27UslTNGsKJWDKDfER1Zc5KxJhzlKzdRU1pqSZnJYjzGq+1A==
X-Received: by 2002:a65:480b:: with SMTP id h11mr5997037pgs.222.1561671322993;
        Thu, 27 Jun 2019 14:35:22 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id i36sm83743pgl.70.2019.06.27.14.35.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 14:35:21 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id C10B0403ED; Thu, 27 Jun 2019 21:35:20 +0000 (UTC)
Date:   Thu, 27 Jun 2019 21:35:20 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Alvin Zheng <Alvin@linux.alibaba.com>,
        gregkh <gregkh@linuxfoundation.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        "joseph.qi" <joseph.qi@linux.alibaba.com>,
        caspar <caspar@linux.alibaba.com>
Subject: Re: [backport request][stable] xfs: xfstests generic/538 failed on
 xfs
Message-ID: <20190627213520.GG19023@42.do-not-panic.com>
References: <a665a93a-0bf8-aedb-2ba3-d4b2fb672970@linux.alibaba.com>
 <20190627155455.GA30113@42.do-not-panic.com>
 <CAOQ4uxgqgDAdKZDYwmf0M35M3D6Ctn25-VVj3wu5XSj_4c-WdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgqgDAdKZDYwmf0M35M3D6Ctn25-VVj3wu5XSj_4c-WdA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 27, 2019 at 07:18:40PM +0300, Amir Goldstein wrote:
> On Thu, Jun 27, 2019 at 6:55 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > On Thu, Jun 27, 2019 at 08:10:56PM +0800, Alvin Zheng wrote:
> > > Hi,
> > >
> > >     I  was using kernel v4.19.y and found that it cannot pass the
> > > generic/538 due to data corruption. I notice that upstream has fix this
> > > issue with commit 2032a8a27b5cc0f578d37fa16fa2494b80a0d00a. Will v4.19.y
> > > backport this patch?
> >
> > Hey Alvin,
> >
> > Thanks for Bringing this to attention.  I'll look into this a bit more.
> > Time for a new set of stable fixes for v4.19.y. Of course, I welcome
> > Briant's feedback, but if he's busy I'll still look into it.
> >
> 
> FWIW, I tested -g quick on xfs with reflink=1,rmapbt=1 and did not
> observe any regressions from v4.19.55.

As you may recall I test all agreed upon configurations. Just one is not
enough.

> Luis, sorry I forgot to CC you on a request I just sent to consider 4 xfs
> patches for stable to fix generic/529 and generic/530:
> 
> 3b50086f0c0d xfs: don't overflow xattr listent buffer
> e1f6ca113815 xfs: rename m_inotbt_nores to m_finobt_nores
> 15a268d9f263 xfs: reserve blocks for ifree transaction during log recovery
> c4a6bf7f6cc7 xfs: don't ever put nlink > 0 inodes on the unlinked list
> 
> If you can run those patches through your setup that would be great.

Sure, it may take 1-2 weeks, just a heads up. If you're OK with waiting
then great. Otherwise I personally cannot vouch for them. What types of
tests did you run and what configurations?

  Luis
