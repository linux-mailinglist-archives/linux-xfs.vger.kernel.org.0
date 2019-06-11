Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058AF3D122
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 17:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390962AbfFKPlP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Jun 2019 11:41:15 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:32935 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388362AbfFKPlP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 11:41:15 -0400
Received: by mail-yb1-f193.google.com with SMTP id h17so515518ybm.0;
        Tue, 11 Jun 2019 08:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8wR3sLQd6++zVGyCuuy4DK8+Yz4wfFgkBSWkW03zh0I=;
        b=ZfLeK8zDWHw3UlI816wItfoXI5YAOFdTxs6JO/5y84qcLdGNiF+jy5XEnsFj8bac+f
         uk94oPozacdOMQL+najAf4NWOZNPozxI8iD4RrxWaVUmGScGPCZpBkdi8SDt51Pmnydg
         Ekh3wR3HQsnr/8sJaVbgWEK3VNkQsvJPttQ6aRMPP9DYYEjU6ZI/awqFrbDiLhrImnLg
         arkZfMFZI6M8soOOoassPl7V3Xgu4JrqBldWDqFHQh36N0woAfLCBgp1H793kEN4y/GN
         dBNbEqFDCNgbAsQgr3bZrT2M+L9mI8BC69uYwOySKmqU0a5O+y6DaCbH+0iddugZSxl5
         kAUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8wR3sLQd6++zVGyCuuy4DK8+Yz4wfFgkBSWkW03zh0I=;
        b=njqajPZInA9TVNGSCzGdFKyomfcDCdZxbN4axwy+Xh7hp7AyMmeujcynX6TQFQNJ2K
         Z52C5LmD6wGCRLr74jBCzHebxYFQbmAOW/YCTiZWj4JWAjV/38K6RxqX3+vX+pnzXw1Z
         s3IXIq3izclh8Se1F1a0Z7utqK16tg9/3ET0y/yQ4oKlyZUzijr82ZKW96TYvsGaJaSf
         9zrfrNbLwobu7LKE/pmAzTBAxC6L4C64puAGVPFbrBN00A/tNp/QcUEGTm/P44xeeFHY
         YVAc5fMi0uzNNkFrsgq9ZeJtCPwbE7BJvJlTeiCYBH2bK+HLz9yz991VnejZsZCsDwmx
         t8sA==
X-Gm-Message-State: APjAAAUyHagSp3q/8nuUpPGBdMY++wvtcDnc/V+BfStCTRIFTD59sN0D
        uyhAw1enp8wZlTLo7qPmGhQoUDVBfgiHdJ21Czc=
X-Google-Smtp-Source: APXvYqx/+5V95Epg/PCeCOkxg7uTNYEl5ue4G7NwNg+DGnIKa11PUfxuHu4H7tzx/yoZhSaD1Xq1WqEscoWV+gGmVMY=
X-Received: by 2002:a05:6902:4c3:: with SMTP id v3mr36656619ybs.144.1560267674592;
 Tue, 11 Jun 2019 08:41:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190611153916.13360-1-amir73il@gmail.com> <20190611153916.13360-2-amir73il@gmail.com>
In-Reply-To: <20190611153916.13360-2-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 11 Jun 2019 18:41:03 +0300
Message-ID: <CAOQ4uxgF5F_XOSq1dJLmhsFA+uKcu46Cn7f+dPT0cLUzfuigiw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] generic/554: test only copy to active swap file
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 11, 2019 at 6:39 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Depending on filesystem, copying from active swapfile may be allowed,
> just as read from swapfile may be allowed.
>
> Note the kernel fix commit in test description.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Forgot to add:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>
> Eryu,
>
> Per your and Ted's request, I've documented the kernel fix commit
> in the new copy_range tests. Those commits are now on Darrick's
> copy-file-range-fixes branch, which is on its way to linux-next
> and to kernel 5.3.
>
> Thanks,
> Amir.
>
>
> Changes from v1:
> - Document kernel fix commit
>
>  tests/generic/554     | 6 ++++--
>  tests/generic/554.out | 1 -
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/tests/generic/554 b/tests/generic/554
> index 10ae4035..fa19d580 100755
> --- a/tests/generic/554
> +++ b/tests/generic/554
> @@ -4,7 +4,10 @@
>  #
>  # FS QA Test No. 554
>  #
> -# Check that we cannot copy_file_range() to/from a swapfile
> +# Check that we cannot copy_file_range() to a swapfile
> +#
> +# This is a regression test for kernel commit:
> +#   a31713517dac ("vfs: introduce generic_file_rw_checks()")
>  #
>  seq=`basename $0`
>  seqres=$RESULT_DIR/$seq
> @@ -46,7 +49,6 @@ echo swap files return ETXTBUSY
>  _format_swapfile $SCRATCH_MNT/swapfile 16m
>  swapon $SCRATCH_MNT/swapfile
>  $XFS_IO_PROG -f -c "copy_range -l 32k $SCRATCH_MNT/file" $SCRATCH_MNT/swapfile
> -$XFS_IO_PROG -f -c "copy_range -l 32k $SCRATCH_MNT/swapfile" $SCRATCH_MNT/copy
>  swapoff $SCRATCH_MNT/swapfile
>
>  # success, all done
> diff --git a/tests/generic/554.out b/tests/generic/554.out
> index ffaa7b0a..19385a05 100644
> --- a/tests/generic/554.out
> +++ b/tests/generic/554.out
> @@ -1,4 +1,3 @@
>  QA output created by 554
>  swap files return ETXTBUSY
>  copy_range: Text file busy
> -copy_range: Text file busy
> --
> 2.17.1
>
