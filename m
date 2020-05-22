Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349DD1DE13E
	for <lists+linux-xfs@lfdr.de>; Fri, 22 May 2020 09:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgEVHqh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 22 May 2020 03:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728230AbgEVHqh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 03:46:37 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5486DC061A0E
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 00:46:37 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id f4so10359620iov.11
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 00:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qyitknh8O6iPCJ7oErswixvslBReFKcTynQApgXWQGc=;
        b=O/nKX3YNvQBhf/KKAsQ97EBgegENP86V5hInKR+kmfFHC255s9z2BeiZtcS8c15zaR
         8Ho6IRyaZBUyT7ZXD5edOVf4ovsWYSQGMIGQB21RZHazzXG7CX+fiBR4xsPPcN25YXhe
         227i8zyEuugHikXMuiJ4HahzjEiGuSd+TRoUbI1p8z1W03iYjUeTgOEqKu55ofTgXjqm
         LPtQLXEo/gYhOqKXrBs0g7ljrf3GlqnIp6aaROmNFCfbUCrzW3POYDwXfotwqU4rfeTt
         xKez9ogyCysHkoXWMg6oW13McXM7ED8WmRpGGpd/rPQSJmELPadD5hZu7Vz2d1uTxS8q
         ko5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qyitknh8O6iPCJ7oErswixvslBReFKcTynQApgXWQGc=;
        b=Omgh31JCS/L7TqaUV0/R01a39+Mq8LJcAnYrq/roTgxB5Y5y6gMJxquvLf/6b9718U
         ESkJ/NIPPrIDHwOG/A3r7oekRlt4O8SN/iC3GVKuXtqZoA+TUE3myhFWxY4YX9JscG9o
         Y1YfB+Bx5ODBo7Bj7AP6sFowz5HkY3Rc55NuW3lw116mZiFTsxCNv45p24zdxVwUNCrc
         C0y7i3RgL68X7qDm3eEDjAH+LrT3701jU3bwRdwqYiMCmOp/O6K4JmK0o/s9actDH/Dl
         /zTxz1YdU6l4RXHcfSBdEYjkwY2psZIO8aaTSLTbH4S7VKOlV3vrL1EPgqmh8qZBV++P
         qyPQ==
X-Gm-Message-State: AOAM5319dtnLv2Ue89a5YZO0O/0h2BLiezIDYzqx+BRxx3jE7POk0oR9
        gWyjHm7g26k0N/ZAOZgxYblv2S8ig/urX0evAa1TcX0K
X-Google-Smtp-Source: ABdhPJwJ6QtVVWgnjpVf9rp8yRzlwn0Qx/XQGdFMTnMDVh6DDWoMP9fa/rwUm2R7K4Xdb8Mvh7NVh8Qw2p8JVHkva8I=
X-Received: by 2002:a02:b141:: with SMTP id s1mr7071273jah.123.1590133596696;
 Fri, 22 May 2020 00:46:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200522035029.3022405-1-david@fromorbit.com> <20200522035029.3022405-5-david@fromorbit.com>
In-Reply-To: <20200522035029.3022405-5-david@fromorbit.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 22 May 2020 10:46:25 +0300
Message-ID: <CAOQ4uxihgdgCAUNAd3G7-Zzad0mMEcZruxvzTXPFRGhb38FpvA@mail.gmail.com>
Subject: Re: [PATCH 04/24] xfs: mark dquot buffers in cache
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 6:51 AM Dave Chinner <david@fromorbit.com> wrote:
>
> dquot buffers always have write IO callbacks, so by marking them
> directly we can avoid needing to attach ->b_iodone functions to
> them. This avoids an indirect call, and makes future modifications
> much simpler.
>
> This is largely a rearrangement of the code at this point - no IO
> completion functionality changes at this point, just how the
> code is run is modified.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c       | 12 +++++++++++-
>  fs/xfs/xfs_buf.h       |  2 ++
>  fs/xfs/xfs_buf_item.c  | 10 ++++++++++
>  fs/xfs/xfs_buf_item.h  |  1 +
>  fs/xfs/xfs_dquot.c     |  1 +
>  fs/xfs/xfs_trans_buf.c |  1 +
>  6 files changed, 26 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 6105b97028d6a..77d40eb4a11db 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1204,17 +1204,27 @@ xfs_buf_ioend(
>                 bp->b_flags |= XBF_DONE;
>         }
>
> +       if (read)
> +               goto out_finish;
> +
>         /* inodes always have a callback on write */
> -       if (!read && (bp->b_flags & _XBF_INODES)) {
> +       if (bp->b_flags & _XBF_INODES) {
>                 xfs_buf_inode_iodone(bp);
>                 return;
>         }
>
> +       /* dquots always have a callback on write */
> +       if (bp->b_flags & _XBF_DQUOTS) {
> +               xfs_buf_dquot_iodone(bp);
> +               return;
> +       }
> +

As commented on another patch, this would look better as
a switch statement.

For not changing logic by rearranging code:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
