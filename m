Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92D12483D0
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Aug 2020 13:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgHRLbK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Aug 2020 07:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726570AbgHRLay (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 07:30:54 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58E8C061342
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 04:20:33 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id f12so9662679ils.6
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 04:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7OLfmk7pXbOiOzOdP7Rduut7BhZBQzcP6nPIr5wC4wo=;
        b=KCUjs9nN1LHWe+NjUZiiUskkY+k4KGtqXMdfCjg4+iIL22IUJrMWiU5oWnmNgQxDX0
         ShP+ST52PYP8mUvUBA7fTsV2t8ui3HkK7CQ+9yDHhVUVgD/PlqZtSJ8gufRcv6CWxTXO
         QGIgs1pUsc4sixDOLeuCJIGDPLWm3e0Vf16Fo5OwNxmn4PPYFMEuPp7Lf5wQEngnnqkC
         ByY8RXJxbFl5frO517B7C/IPIJhDOSsoIKkKc3m/mx3T7Etdv70vTV1w7zTio/rOXQM/
         ES9F5FcQRrFZOwy0GfB2CAsCIpzGxkm7ok5BonHkNbtL3gzMyhdWMSutJLmMK/b1zfxd
         p4Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7OLfmk7pXbOiOzOdP7Rduut7BhZBQzcP6nPIr5wC4wo=;
        b=czeDekG6q4vycEHplgqKnGpQ9MPNjK4pztJmGiCzBrIly7IyVyVP6u1RABQdK4RLQq
         eg51Hmn7SJ/ImUJS5Jcy2qek0iGiwLwSWFTt/l+aBwE2kYaZMDJ4HyOEedgjg7G5KU0S
         XA+zRA3TWLYBEfIbmrhdqpAr4kO1Md5JFwBpwvf4a1AIi95se8b28asnrbyEWZ7W0oHE
         /npiF0NkOkJp55TnMaXQq2TPGGljBaLisTaZNg2Tu56VWJ+iB5MsPfdKSFZiI7t6E8up
         AeSNWJftPby4qGof69sShsQCQzP2sR8AOg0YIdZ3bhXwATg6o0cofN8DIVMXhl4ByLBA
         xigA==
X-Gm-Message-State: AOAM532B6zmRj63sZhOaxJUiMF1VI78df9ezvihIyc3f1eMGQfCCE5l4
        L65ZEShHulBuBEOS1w6LwAf4smdLsDZfZsL9DR0=
X-Google-Smtp-Source: ABdhPJzmpxNq7bHGhooNJTQ0VEoJiRQ0qf9OqIfHfp6jJJvHlFXoG20bWD9GLZoPdpdYQflhIvtoiSTgpEVHCz+HzC4=
X-Received: by 2002:a92:1fd9:: with SMTP id f86mr17974128ilf.250.1597749633268;
 Tue, 18 Aug 2020 04:20:33 -0700 (PDT)
MIME-Version: 1.0
References: <159770500809.3956827.8869892960975362931.stgit@magnolia> <159770504627.3956827.1457402206153045570.stgit@magnolia>
In-Reply-To: <159770504627.3956827.1457402206153045570.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 14:20:22 +0300
Message-ID: <CAOQ4uxhcf1-MKsyenuHnJ5WhpZk7eM53DSmyKYr-EGoSCieTSg@mail.gmail.com>
Subject: Re: [PATCH 06/11] xfs: refactor inode timestamp coding
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 1:57 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Refactor inode timestamp encoding and decoding into helper functions so
> that we can add extra behaviors in subsequent patches.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

With nit below...

...

> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index d95a00376fad..c2f9a0adeed2 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -295,6 +295,15 @@ xfs_inode_item_format_attr_fork(
>         }
>  }
>
> +static inline void
> +xfs_from_log_timestamp(
> +       struct xfs_timestamp            *ts,
> +       const struct xfs_ictimestamp    *its)
> +{
> +       ts->t_sec = cpu_to_be32(its->t_sec);
> +       ts->t_nsec = cpu_to_be32(its->t_nsec);
> +}
> +
>  void
>  xfs_log_dinode_to_disk(

Following convention of xfs_inode_{to,from}_disk_timestamp()
I think it would be less confusing to name these helpers
xfs_log_to_disk_timestamp()

and...

>
> +static inline void
> +xfs_to_log_timestamp(
> +       struct xfs_ictimestamp          *its,
> +       const struct timespec64         *ts)
> +{
> +       its->t_sec = ts->tv_sec;
> +       its->t_nsec = ts->tv_nsec;
> +}
> +
>  static void
>  xfs_inode_to_log_dinode(

xfs_inode_to_log_timestamp()

Because xfs_{to,from}_log_timestamp() may sound like a matching pair,
to your average code reviewer, but they are not.

Thanks,
Amir.
