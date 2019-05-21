Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6AB724740
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 07:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbfEUFEf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 01:04:35 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:32847 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfEUFEf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 01:04:35 -0400
Received: by mail-yw1-f67.google.com with SMTP id v81so4551734ywe.0;
        Mon, 20 May 2019 22:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bkTlFlylplY2sLbf5X1CbWIIUMamJ5FYlyQvn2i/0Js=;
        b=Vabx1HSGjFSpa9GLaCXw0/YboHAQpAHIebAD24/DG4SyInJPHBLtGYRNF3UWEMC6Fl
         gHP0KWgyXWnhl2smLVFc2bUYh1sImpqg7CxPp3EbpcFugHD6nLgM4wWG5iBh9JeeJFyq
         oHnFtpwbQWafCCXifdY2ocnDdkOozW4EvkiDKONzZ15U9SaMSAUHMAPD+FStRb/qVeMN
         J0lRwrepARr+MYNZzMTXDBxhFtG1PzsSblMeoMWkNJuV5G51rEw3EVuYQggMJ8GTqTOD
         kL/6vsaWwiT3ZuB6IldrkrWtGUMs5tNl6IW48zG0AakwDstXP6cT6Vh9kD4WEwBDQQLN
         tZCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bkTlFlylplY2sLbf5X1CbWIIUMamJ5FYlyQvn2i/0Js=;
        b=KcK18ONgbl2FfgTvFBAGANzJlR5oaDVsGNeF1q4vdPhZBhlxPxfWwTecte60llz8Z8
         AGMuP1lQxPtXwzx2XdUbmV33WU+36dgNj2OyC/M0w/b1gQo+oDgCdyl2th1Y9kA4Io+7
         Kc0EdTeNoa5csf48gLKGbQggsz528aTWkjHnPLsOg8BP6aeNjYQgDDFoWlt34h8Dp47H
         94/xLuvf9oqFWnAdAGBAn2yFYwRYZLIad6oVIeJmGEZyED6rVymZv0ObrtLmS4o9XXPV
         bg5YzwsjufRG98/AaKv7b6f/YVsLgyhZcN8Pr0OgQGBugLDDSRk+/KS6T6RpNq8QJSZ8
         CkiA==
X-Gm-Message-State: APjAAAVrmNw9cjrPXdcAssK4/dh+eOasDqMSlQKgUT9IzV/fvy15XN4q
        CM8trYJFbZr7lBHh2zZopcSLrDuQzxEjHaopfdI=
X-Google-Smtp-Source: APXvYqyO/BI5kaSNq7HFwOmpEvaMnribHbQ357Hvhdcsc4Kgok1Qxrr7EJjvXg1wZw7mXqXXHUqpoLjmogeE4K6MpME=
X-Received: by 2002:a0d:d5c1:: with SMTP id x184mr13890097ywd.88.1558415074726;
 Mon, 20 May 2019 22:04:34 -0700 (PDT)
MIME-Version: 1.0
References: <155839145160.62682.10916303376882370723.stgit@magnolia> <155839147057.62682.15559355049172171217.stgit@magnolia>
In-Reply-To: <155839147057.62682.15559355049172171217.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 21 May 2019 08:04:23 +0300
Message-ID: <CAOQ4uxhsiM-tCB+RV9P7z6kK_kEwxKpoeAFfc8Y5YwC8F6C40g@mail.gmail.com>
Subject: Re: [PATCH 3/3] generic, xfs: use _scratch_shutdown instead of
 calling src/godown
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
> Overlayfs introduces some complexity with regards to what path we have
> to use to shut down the scratch filesystem: it's SCRATCH_MNT for regular
> filesystems, but it's OVL_BASE_SCRATCH_MNT (i.e. the lower mount of the
> overlay) if overlayfs is enabled.  The helper works through all that, so
> we might as well use it.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks for cleaning that up

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  tests/generic/050 |    2 +-
>  tests/xfs/051     |    2 +-
>  tests/xfs/079     |    2 +-
>  tests/xfs/121     |    4 ++--
>  tests/xfs/181     |    4 ++--
>  5 files changed, 7 insertions(+), 7 deletions(-)
>
>
> diff --git a/tests/generic/050 b/tests/generic/050
> index 9a327165..91632d2d 100755
> --- a/tests/generic/050
> +++ b/tests/generic/050
> @@ -92,7 +92,7 @@ echo "touch files"
>  touch $SCRATCH_MNT/{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}
>
>  echo "going down:"
> -src/godown -f $SCRATCH_MNT
> +_scratch_shutdown -f
>
>  echo "unmounting shutdown filesystem:"
>  _scratch_unmount 2>&1 | _filter_scratch
> diff --git a/tests/xfs/051 b/tests/xfs/051
> index bcc824f8..105fa9ff 100755
> --- a/tests/xfs/051
> +++ b/tests/xfs/051
> @@ -47,7 +47,7 @@ _scratch_mount
>  # recovery.
>  $FSSTRESS_PROG -n 9999 -p 2 -w -d $SCRATCH_MNT > /dev/null 2>&1 &
>  sleep 5
> -src/godown -f $SCRATCH_MNT
> +_scratch_shutdown -f
>  $KILLALL_PROG -q $FSSTRESS_PROG
>  wait
>  _scratch_unmount
> diff --git a/tests/xfs/079 b/tests/xfs/079
> index bf965a7f..67250495 100755
> --- a/tests/xfs/079
> +++ b/tests/xfs/079
> @@ -56,7 +56,7 @@ _scratch_mount "-o logbsize=32k"
>  # Run a workload to dirty the log, wait a bit and shutdown the fs.
>  $FSSTRESS_PROG -d $SCRATCH_MNT -p 4 -n 99999999 >> $seqres.full 2>&1 &
>  sleep 10
> -./src/godown -f $SCRATCH_MNT
> +_scratch_shutdown -f
>  wait
>
>  # Remount with a different log buffer size. Going from 32k to 64k increases the
> diff --git a/tests/xfs/121 b/tests/xfs/121
> index d82a367f..2e3914b7 100755
> --- a/tests/xfs/121
> +++ b/tests/xfs/121
> @@ -52,7 +52,7 @@ src/multi_open_unlink -f $SCRATCH_MNT/test_file -n $num_files -s $delay &
>  sleep 3
>
>  echo "godown"
> -src/godown -v -f $SCRATCH_MNT >> $seqres.full
> +_scratch_shutdown -v -f >> $seqres.full
>
>  # time for multi_open_unlink to exit out after its delay
>  # so we have no references and can unmount
> @@ -69,7 +69,7 @@ _try_scratch_mount $mnt >>$seqres.full 2>&1 \
>      || _fail "mount failed: $mnt $MOUNT_OPTIONS"
>
>  echo "godown"
> -src/godown -v -f $SCRATCH_MNT >> $seqres.full
> +_scratch_shutdown -v -f >> $seqres.full
>
>  echo "unmount"
>  _scratch_unmount
> diff --git a/tests/xfs/181 b/tests/xfs/181
> index 882a974b..dba69a70 100755
> --- a/tests/xfs/181
> +++ b/tests/xfs/181
> @@ -65,7 +65,7 @@ pid=$!
>  sleep 10
>
>  echo "godown"
> -src/godown -v -f $SCRATCH_MNT >> $seqres.full
> +_scratch_shutdown -v -f >> $seqres.full
>
>  # kill the multi_open_unlink
>  kill $pid 2>/dev/null
> @@ -83,7 +83,7 @@ _scratch_mount $mnt >>$seqres.full 2>&1 \
>      || _fail "mount failed: $mnt $MOUNT_OPTIONS"
>
>  echo "godown"
> -src/godown -v -f $SCRATCH_MNT >> $seqres.full
> +_scratch_shutdown -v -f >> $seqres.full
>
>  echo "unmount"
>  _scratch_unmount
>
