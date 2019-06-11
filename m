Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9035A3D121
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 17:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405302AbfFKPk6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Jun 2019 11:40:58 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35768 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405025AbfFKPk6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 11:40:58 -0400
Received: by mail-yw1-f68.google.com with SMTP id k128so5483752ywf.2;
        Tue, 11 Jun 2019 08:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=irogcAdEfUBjb25dQd80pQnsWPBRpcbQ6uh1CEwa7tk=;
        b=W+/tOB4YzuG35o9nuYXoqr7DMseSTYqh4A9uXa8iZwDcQ6Q+F3i4Opmzl/0b4k1X/O
         ZhCq/LkAsu6rFTgJF1h678ydHdxD2383WZIPsPQXlAoUhAK0mZAxzpC4WzJtI5c6M6+9
         lsk+465wFmmhwNZycBYV3iWdSYErskxxgP+LpvGVcLEPuD+gqd/FkbOMhMMT1K3rqS96
         80M3+ORUZVBoSEMxrBRARbQ8dYYmXNAFQD5itiMxonFlnzYeg8T5yKqZhPOxiri3WPQJ
         mvZjVLcIZA1SyG70iytlTCwRvgbltH66TMs+gODhgFbvZJZE4iL4weVlch/Z2biCIfWf
         YuPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=irogcAdEfUBjb25dQd80pQnsWPBRpcbQ6uh1CEwa7tk=;
        b=qJ+AY4wL+SGycd0+qxhHYBuu7Z/7TgYtyLmVmAHE1RrohPPIeO3Ukh0vovT1ZYr2VV
         9deac8RniertsOz6aLUhxIny8UYoSWwj+Y5XnGG6l5dkltzIIawOt1G7R7v22CEAb35Q
         +mkgsMVTjmiFTcOW7oNaisOR1BpUTvHXk+zTsYvJsRG6DxkxFKF8IInp2vxW5MuDx1rq
         vDQPZm0jRQd3fqz97/mClZ3StRZweyVvxUTmsY5XvWPdgbYOCpEZ2KXnxsnp6KD2r/j4
         MLM4Y6YcOIM8rzJm1QIKTneFAmn+I0GLy0f9Kvahb0E/tVAEWibg0BTmbtLU/GxNTzGX
         gGAQ==
X-Gm-Message-State: APjAAAWKcvhUOQFjVOFt3QU7Yy2wQZwbnAaSUyzr1nqwYC2w3wwIkG3d
        dJykPugNDiXz2kIfAGzXCTPNsrLl12cS3zrmb0Y=
X-Google-Smtp-Source: APXvYqwlNav5UfCX2UAW09InqWGVXzSSiJA9gRUC10hBwxBRIh73aPPLuXgOI2Jr/3rrGmk25T3flBSbdWIDHMhQCQ4=
X-Received: by 2002:a81:374c:: with SMTP id e73mr31131383ywa.379.1560267657838;
 Tue, 11 Jun 2019 08:40:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190611153916.13360-1-amir73il@gmail.com>
In-Reply-To: <20190611153916.13360-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 11 Jun 2019 18:40:46 +0300
Message-ID: <CAOQ4uxjgAOgN6r6ZSsw_xZg7c-dsMLYUExU7BMi0NFpcT_wV1w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] generic/553: fix test description
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
> The test only checks copy to immutable file.
> Note the kernel fix commit.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Forgot to add:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>
> Changes from v1:
> - Document kernel fix commit
>
>  tests/generic/553 | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/tests/generic/553 b/tests/generic/553
> index 98ef77cc..58e0d5ef 100755
> --- a/tests/generic/553
> +++ b/tests/generic/553
> @@ -4,7 +4,10 @@
>  #
>  # FS QA Test No. 553
>  #
> -# Check that we cannot copy_file_range() to/from an immutable file
> +# Check that we cannot copy_file_range() to an immutable file
> +#
> +# This is a regression test for kernel commit:
> +#   a31713517dac ("vfs: introduce generic_file_rw_checks()")
>  #
>  seq=`basename $0`
>  seqres=$RESULT_DIR/$seq
> --
> 2.17.1
>
