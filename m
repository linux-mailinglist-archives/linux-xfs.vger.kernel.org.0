Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6836271C
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Jul 2019 19:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387717AbfGHR3d (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Jul 2019 13:29:33 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36570 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387506AbfGHR3d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jul 2019 13:29:33 -0400
Received: by mail-ot1-f67.google.com with SMTP id r6so17028103oti.3
        for <linux-xfs@vger.kernel.org>; Mon, 08 Jul 2019 10:29:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nA6Jna13w+RzGgaq8zqHZyOTzP+Rl2ic3AndNFYmYd4=;
        b=R413GWV7s8XCdO7ncjkvTbmVzbulyvoMxOh7rxNtvKuDKfvf8ZOh0egGjh5sd5U4nt
         X/EIB9oyKpdcJPp9g/lD9p3pc+o0GVx16DLbj8fDq1vwA+fLtutbkOvn9PiJCDCL/1dC
         GvlsAwC1X/V+3n5jfIz+hva17hplcsd7ZkE0K1rJOd9DpiZ1GDoX0uswNMkSm8P9wR0p
         jDJCW8DE3Rd5aWbzUa5qSeaMbTTRv5fSFj8XUxJEFgA8IG2Y7m8lui3DNFG4InZV56a4
         m/PXsSaTGv5E5lJJIObqDhD66OiVQeby9vds123TzF8+Bsa4icwuy+DaH00k/8LXa66c
         i38w==
X-Gm-Message-State: APjAAAVQ0PUAsydILkm7nitXBnblPLLFJJRGlatF4xpw03PTyjQgkmhl
        u78mPhpbJuTHitnyP7hMUYlyZx1l1/63+RET3rC3sA==
X-Google-Smtp-Source: APXvYqx0RPvy74yzmrSczU2RfOeT51FXoyiAVwrmEDfjnlD9nHbQUGYVCsDvdT1tpWknkWW1QJvBsFLFOqZUsxSEAWw=
X-Received: by 2002:a9d:5cc1:: with SMTP id r1mr15913810oti.341.1562606972599;
 Mon, 08 Jul 2019 10:29:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190701215439.19162-1-hch@lst.de> <CAHc6FU5MHCdXENW_Y++hO_qhtCh4XtAHYOaTLzk+1KU=JNpPww@mail.gmail.com>
 <20190708160351.GA9871@lst.de>
In-Reply-To: <20190708160351.GA9871@lst.de>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Mon, 8 Jul 2019 19:29:21 +0200
Message-ID: <CAHc6FU5942i0XrCjUAhR9NCmfLuu7_CoPXNDsdF0X+gCpF1cDQ@mail.gmail.com>
Subject: Re: RFC: use the iomap writepage path in gfs2
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 8 Jul 2019 at 18:04, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, Jul 04, 2019 at 12:35:41AM +0200, Andreas Gruenbacher wrote:
> > Patch "gfs2: implement gfs2_block_zero_range using iomap_zero_range"
> > isn't quite ready: the gfs2 iomap operations don't handle IOMAP_ZERO
> > correctly so far, and that needs to be fixed first.
>
> What is the issue with IOMAP_ZERO on gfs2?  Zeroing never does block
> allocations except when on COW extents, which gfs2 doesn't support,
> so there shouldn't really be any need for additional handling.

We still want to set iomap->page_ops for journalled data files on gfs2.

Also, if we go through the existing gfs2_iomap_begin_write /
__gfs2_iomap_begin logic for iomap_zero_range, it will work for
stuffed files as well, and so we can replace stuffed_zero_range with
iomap_zero_range.

> > Some of the tests assume that the filesystem supports unwritten
> > extents, trusted xattrs, the usrquota / grpquota / prjquota mount
> > options. There shouldn't be a huge number of failing tests beyond
> > that, but I know things aren't perfect.
>
> In general xfstests is supposed to have tests for that and not run
> the tests if not supported.  In most cases this is automatic, but
> in case a feature can't be autodetect we have a few manual overrides.

Yes, that needs a bit of work. Let's see.

Thanks,
Andreas
