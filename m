Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D14335D0E
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 14:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfFEMmb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 08:42:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727607AbfFEMmb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Jun 2019 08:42:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B98BB206BB;
        Wed,  5 Jun 2019 12:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559738550;
        bh=f1m2C7OLs79bHhHwUsSMSLK4XXJRRb3fDdNegN1DuRY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PZk5MiqkVKNp1G/87D3BSDD91zWbqTrOsMPSloZ97W9d2txecV6f2mKL67ev2Fh3G
         qYworJ8GPzAorMW+RJFpYfLAy7noTf9Te5gvxlQwI48yT4ATNqKY3Fqk2l+Fc9VpfL
         c6D3O7hOzBk7UPKJshnMFKcFuZd0qbAVbz0g1WZo=
Date:   Wed, 5 Jun 2019 14:42:27 +0200
From:   gregkh <gregkh@linuxfoundation.org>
To:     Alvin Zheng <Alvin@linux.alibaba.com>
Cc:     "darrick.wong" <darrick.wong@oracle.com>, axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        caspar <caspar@linux.alibaba.com>,
        "joseph.qi" <joseph.qi@linux.alibaba.com>
Subject: Re: [bug report][stable] xfstests:generic/538 failed on xfs
Message-ID: <20190605124227.GC17558@kroah.com>
References: <f9a7b0c4-178a-4a7c-8ac6-aec79b06b810.Alvin@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9a7b0c4-178a-4a7c-8ac6-aec79b06b810.Alvin@linux.alibaba.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 05, 2019 at 08:21:44PM +0800, Alvin Zheng wrote:
> Hi,
>   I was using kernel v4.19.48 and found that it cannot pass the generic/538 on xfs. The error output is as follows:

Has 4.19 ever been able to pass that test?  If not, I wouldn't worry
about it :)

> 
>   FSTYP         -- xfs (non-debug)
>   PLATFORM      -- Linux/x86_64 alinux2-6 4.19.48
>   MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdc
>   MOUNT_OPTIONS -- /dev/vdc /mnt/testarea/scra
>   generic/538 0s ... - output mismatch (see /root/usr/local/src/xfstests/results//generic/538.out.bad)
>       --- tests/generic/538.out   2019-05-27 13:57:06.505666465 +0800
>       +++ /root/usr/local/src/xfstests/results//generic/538.out.bad       2019-06-05 16:43:14.702002326 +0800
>       @@ -1,2 +1,10 @@
>        QA output created by 538
>       +Data verification fails
>       +Find corruption
>       +00000000  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>       +*
>       +00000200  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
>       +00002000
>       ...
>       (Run 'diff -u /root/usr/local/src/xfstests/tests/generic/538.out /root/usr/local/src/xfstests/results//generic/538.out.bad'  to see the entire diff)
>   Ran: generic/538
>   Failures: generic/538
>   Failed 1 of 1 tests
>   
> I also found that the latest kernel (v5.2.0-rc2) of upstream can pass the generic/538 test. Therefore, I bisected and found the first good commit is 3110fc79606. This commit adds the hardware queue into the sort function. Besides, the sort function returns a negative value when the offset and queue (software and hardware) of two I/O requests are same. I think the second part of the change make senses. The kernel should not change the relative position of two I/O requests when their offset and queue are same. So I made the following changes and merged it into the kernel 4.19.48. After the modification, we can pass the generic/538 test on xfs. The same case can be passed on ext4, since ext4 has corresponding fix 0db24122bd7f ("ext4: fix data corruption caused by overlapping unaligned and aligned IO"). Though I think xfs should be responsible for this issue, the block layer code below is also problematic. Any ideas?
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 4e563ee..a7309cd 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1610,7 +1610,7 @@ static int plug_ctx_cmp(void *priv, struct list_head *a, struct list_head *b)
> 
>         return !(rqa->mq_ctx < rqb->mq_ctx ||
>                  (rqa->mq_ctx == rqb->mq_ctx &&
> -                 blk_rq_pos(rqa) < blk_rq_pos(rqb)));
> +                 blk_rq_pos(rqa) <= blk_rq_pos(rqb)));
>  }
> 
>  void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)

I would not like to take a patch that is not upstream, but rather take
the original commit.

Can 3110fc79606f ("blk-mq: improve plug list sorting") on its own
resolve this issue for 4.19.y?

thanks,

greg k-h
