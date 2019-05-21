Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADE472473B
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 07:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfEUFCJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 01:02:09 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:33725 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfEUFCJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 01:02:09 -0400
Received: by mail-yw1-f67.google.com with SMTP id v81so4550045ywe.0;
        Mon, 20 May 2019 22:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=teN77TVl6CxhIDIdsQw8FBy02eKmZEPb6P7yrY1EsHc=;
        b=o69nrCCUTdDP1hau8KrjGsWGGu6srcMXRbq+m3JY2vm7a0Uhv93RNoy2Aa9Wx0tj5a
         bL3S0iBf42adQPuPAsJxkjJQlkjE8SaptEGFxThhc4VeSCsIqjcHsDqPKqgLiXmzo6Fn
         r4hMoHU+1JnzmDtjfY9HlKsnI8Gg4HdX0E5XQ9IAbeonQu1ALvh9VZ9h6tw95vfppt22
         nirQqM9QzK0OKpnb5NhwCFw6r5t86IG5Y+o/sPbbowTXjevPsotHpjZ2A5yMqo8I01Rz
         X/n3A5fJ4AJlH49WRmYXOYBr+IuF0JUHIj0ikpyxQZ3o09MQ6c2wICBwbRPODmaVbcV4
         BY6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=teN77TVl6CxhIDIdsQw8FBy02eKmZEPb6P7yrY1EsHc=;
        b=sd7cnC3XqUPpq85otNEtpM3Q4mzIYz3EnBPOb14NWD2IUHi8SgWF1UN7k+0RqNS5/4
         al9YOx2nRmkeByeTbD+wZrqjJV+/SPjRqBiCXMEUIs2wHSRcGDB1rB9kkRj8JLDwzzlW
         maN2GoChEnWNrtvtoz/lmqXLMMnP/ySuZGix5UQTWzIMCuo5UVrb+c8z0DjdBpnsuVlw
         QK6mV4YL3j07S+lHZkee4VHGYR7NeG+Z85Ryhc4m1IwBT4kIHuZTjgVpMPyF+g8rDkYi
         kA1Yqs6vS9JjS/d5etVazEMMWbKDYvKT4m/4SJRdjiOiZCj3PVrbuBjbxH830pe+3qPm
         MMYw==
X-Gm-Message-State: APjAAAXRLOQwwczS9+lu0Bd8tS9tI7X5oe1fmPPqMVEchmV/xCR9scC5
        nXwOgr3DqjanvH5yvHtJnX7MaHeHW7MGBx62YlU=
X-Google-Smtp-Source: APXvYqyN/iAg9r0jZWKqGxVoUplvxTq5XSTXjfNTJS/rENdd0+4+Jps07+gxufgVgcwVbv9kw3TN4aiuhiRNBFJW1sw=
X-Received: by 2002:a81:9ac7:: with SMTP id r190mr24267198ywg.183.1558414928532;
 Mon, 20 May 2019 22:02:08 -0700 (PDT)
MIME-Version: 1.0
References: <155839145160.62682.10916303376882370723.stgit@magnolia> <155839145791.62682.9311727733965110633.stgit@magnolia>
In-Reply-To: <155839145791.62682.9311727733965110633.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 21 May 2019 08:01:57 +0300
Message-ID: <CAOQ4uxiaU2aJ6h1NGv=S8guuFgbPEQ+HwhQ_gPbsCFXmy+Ju+g@mail.gmail.com>
Subject: Re: [PATCH 1/3] generic/530: revert commit f8f57747222
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 1:31 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Commit f8f57747222 ("generic/530: fix shutdown failure of generic/530 in
> overlay") improperly clears an overlayfs test failure by shutting down
> the filesystem after all the tempfiles are closed, which totally defeats
> the purpose of both generic/530 and xfs/501.  Revert this commit so we
> can fix it properly.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  src/t_open_tmpfiles.c |   19 +++++++++++++++++++
>  tests/generic/530     |    4 +---
>  tests/xfs/501         |    4 +---
>  3 files changed, 21 insertions(+), 6 deletions(-)
>
>
> diff --git a/src/t_open_tmpfiles.c b/src/t_open_tmpfiles.c
> index 0393c6bd..da9390fd 100644
> --- a/src/t_open_tmpfiles.c
> +++ b/src/t_open_tmpfiles.c
> @@ -24,6 +24,7 @@ static int min_fd = -1;
>  static int max_fd = -1;
>  static unsigned int nr_opened = 0;
>  static float start_time;
> +static int shutdown_fs = 0;
>
>  void clock_time(float *time)
>  {
> @@ -68,6 +69,22 @@ void die(void)
>                                 end_time - start_time);
>                 fflush(stdout);
>
> +               if (shutdown_fs) {
> +                       /*
> +                        * Flush the log so that we have to process the
> +                        * unlinked inodes the next time we mount.
> +                        */
> +                       int flag = XFS_FSOP_GOING_FLAGS_LOGFLUSH;
> +                       int ret;
> +
> +                       ret = ioctl(min_fd, XFS_IOC_GOINGDOWN, &flag);
> +                       if (ret) {
> +                               perror("shutdown");
> +                               exit(2);
> +                       }
> +                       exit(0);
> +               }
> +
>                 clock_time(&start_time);
>                 for (fd = min_fd; fd <= max_fd; fd++)
>                         close(fd);
> @@ -143,6 +160,8 @@ int main(int argc, char *argv[])
>                 if (ret)
>                         perror(argv[1]);
>         }
> +       if (argc > 2 && !strcmp(argv[2], "shutdown"))
> +               shutdown_fs = 1;
>
>         clock_time(&start_time);
>         while (1)
> diff --git a/tests/generic/530 b/tests/generic/530
> index 56c6d32a..b0d188b1 100755
> --- a/tests/generic/530
> +++ b/tests/generic/530
> @@ -49,9 +49,7 @@ ulimit -n $max_files
>
>  # Open a lot of unlinked files
>  echo create >> $seqres.full
> -$here/src/t_open_tmpfiles $SCRATCH_MNT >> $seqres.full
> -_scratch_shutdown -f
> -
> +$here/src/t_open_tmpfiles $SCRATCH_MNT shutdown >> $seqres.full
>
>  # Unmount to prove that we can clean it all
>  echo umount >> $seqres.full
> diff --git a/tests/xfs/501 b/tests/xfs/501
> index 4be9997c..974f3414 100755
> --- a/tests/xfs/501
> +++ b/tests/xfs/501
> @@ -54,9 +54,7 @@ ulimit -n $max_files
>
>  # Open a lot of unlinked files
>  echo create >> $seqres.full
> -$here/src/t_open_tmpfiles $SCRATCH_MNT >> $seqres.full
> -_scratch_shutdown -f
> -
> +$here/src/t_open_tmpfiles $SCRATCH_MNT shutdown >> $seqres.full
>
>  # Unmount to prove that we can clean it all
>  echo umount >> $seqres.full
>
