Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7A33D1B9
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 18:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391345AbfFKQHU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Jun 2019 12:07:20 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:40619 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391474AbfFKQHU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 12:07:20 -0400
Received: by mail-yb1-f193.google.com with SMTP id g62so5324931ybg.7;
        Tue, 11 Jun 2019 09:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bo+Qju++WXjBQKsupEybJmvatt3DYfRs+7REX9cYwjo=;
        b=i3l0D9ty1IenZdpwO9TEjCBaIO99FPXyrarFptnZwU64rj+Z9GPF+i4C9rJIEwaTH5
         uXxVQMog2SK0Uwm/v2Ghdo/gV5BY9zeIRhF6f1QY5WDPDlFTBbXF61eH5BhLIFmIIeZv
         mGYbJ0HJRuuVcEUj6Mpw5dcI3Xy/vB/ot5xhCCDMRJCDJHHhMGFFiVDkR4DZqNKfRWyi
         vMLARLmXFpT76rHJoocVI0D+s4GfadI2qJum0UBQgYD+OqpujtaEF7N6JkwaOKSrkuyh
         Xw5d2Iecff3tawlFtASIxaNB30fhfV7nEYxjMnY8ObNR/lPzuLiOljbG/n/ZaFjVX8FT
         yL+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bo+Qju++WXjBQKsupEybJmvatt3DYfRs+7REX9cYwjo=;
        b=pMqTt5gzT2kB8n/feZf41iM7/GBQcImQS9Mst5stv3N5drVFkmrRfjVUSTOuQxb7gd
         CLPr5MnhU6GyTGZkfzvizNk7kuaqiu9GxB2pnMojYGlzSbiHCVLDBDcyWbg1b8R2XByt
         gpVYc62LW3K7vlbvkF5V9VUDeEmUzA2UofPGfJqq9OPvQFFjuJsogEUPIsCILHCz3mKL
         8x8XPY86Acr0yKvWL7jmP6TtMvZ/nu0QFyXZfN+lmwFrZwfYu08EpWRe5j4R3CIv8kHt
         3rTai+Wo6KDQW/uW370vlayhCECHAYVhyBhtS4LSHYNDH+M/ZgoK97+cRlykMjcs58ex
         inpw==
X-Gm-Message-State: APjAAAW2W1yIcmGx15sSZmfLLypDN5kUswZlxp20Oxur6Oy2sj8fs+8r
        rrqsCL7b+QwjmgCge2XNWxLZViAoA9jOKr7i48A=
X-Google-Smtp-Source: APXvYqyHvr9mD+CA6PZ4z09FSwBScxMjMsQOtOeDwUDTNgKnVHOVl5Tf2KuWAidtpivZ2rfNvjMBekz+KKfS9OhxqCc=
X-Received: by 2002:a25:8109:: with SMTP id o9mr33842596ybk.132.1560269239421;
 Tue, 11 Jun 2019 09:07:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190611153916.13360-1-amir73il@gmail.com> <20190611153916.13360-2-amir73il@gmail.com>
 <20190611155925.GA5081@mit.edu>
In-Reply-To: <20190611155925.GA5081@mit.edu>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 11 Jun 2019 19:07:08 +0300
Message-ID: <CAOQ4uxiZxJk1qwuKCJQvYggx_km4yzvjaAWn8ow5pLjmPnceHA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] generic/554: test only copy to active swap file
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 11, 2019 at 6:59 PM Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Tue, Jun 11, 2019 at 06:39:16PM +0300, Amir Goldstein wrote:
> > Depending on filesystem, copying from active swapfile may be allowed,
> > just as read from swapfile may be allowed.
> >
> > Note the kernel fix commit in test description.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >
> > Per your and Ted's request, I've documented the kernel fix commit
> > in the new copy_range tests. Those commits are now on Darrick's
> > copy-file-range-fixes branch, which is on its way to linux-next
> > and to kernel 5.3.
>
> Thanks!  Are we sure at this point that the commit won't need to be
> modified / rebased in Darrick's tree?
>

Yes. The intention is that fs maintainers can now rebase their
v5.3 development branch on this non-rewindable branch.

Note that you do still need to merge the fixes from Darrick's branch
for ext4 to pass this test despite relaxing the "copy from swapfile" test case.

Thanks,
Amir.
