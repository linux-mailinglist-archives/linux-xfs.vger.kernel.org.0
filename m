Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAC28392D3
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 19:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbfFGRKm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 7 Jun 2019 13:10:42 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35060 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731062AbfFGRKm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 13:10:42 -0400
Received: by mail-pl1-f194.google.com with SMTP id p1so1067040plo.2;
        Fri, 07 Jun 2019 10:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KpRnpNPe63iWkU429E6B57kU+PdE2U1iu780REii7As=;
        b=cFReZgGkihG8NzN9eHyjDoPhE1uZuJwSq82MAT9TVxmtf49SOZ8bfECYz+YTFsPFrH
         g8rGADE0/fHjw3KMhTNOZS2hzt+Y9gSEB3pH2ykxmvT66JEEbEqi4fCRY54r7Xe/2uu5
         Cbnq1Okx/7JwCrgE+8Gc8lwgzZprLcTqm50Zt2b/rz9SP8vFDM89cvdz8zWoGB47ZAOL
         q5sfUNLgNYOueWZCtJ5T8DdRZO0tz/K7MXZN7/grQRNWTfkPXS0dRK/S3NPV0Zr+Y7KV
         9gAXlY5UE+JLb5Q5WJK6oFV9DIKUSRWyYDogJhAKZXG0r/azooJnaIWrV3j7VcrpVECJ
         pzcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KpRnpNPe63iWkU429E6B57kU+PdE2U1iu780REii7As=;
        b=RZtH3fnhflWoasvdREF4Zm9AN/20E/Hbjr+XDq8fG2WYq6zI16Q/wUXbxpPSnJeHH/
         ADKSaKZViO90/bjXY1r2DpGBDTQT7gCC0DxxV3kk27vQHXKP6Fjji1TOh03e8DHhj7Gm
         HyYsXnHd95/pkX3Ioe9NwPVSmftZX3kQ9Uj0AicTy05E1/++EcQiySGYWeZtEjZrPTR/
         m/2Y29bzH5VvhUdOXO55M5dFwotmuT3Nb35hvGOwvw6q7RAwIGDSYOc29dji/NLHRKNf
         vka2wyRzyTyjIsvZ+R3iWKmkjvglDlFUUW5w+tnFGYirbWf/qkIagnucpYeNrfvj++g7
         cNhQ==
X-Gm-Message-State: APjAAAUD2e0km4wWO6Ep1VoYgE+FgwU/eb/gf6xT4mq2X2yhJtRmAjGv
        9Zo/tk8DtzK3Gh2fK0xEZHk=
X-Google-Smtp-Source: APXvYqzX2UaZEYeAzVkzUaGU8F+VXo+biCeS0/OTJ4Mitk4eowzz/hWqLK0zO4XyB8qgBUhx0Fe87w==
X-Received: by 2002:a17:902:24b:: with SMTP id 69mr56588131plc.255.1559927441850;
        Fri, 07 Jun 2019 10:10:41 -0700 (PDT)
Received: from localhost ([47.254.35.144])
        by smtp.gmail.com with ESMTPSA id e127sm2808990pfe.98.2019.06.07.10.10.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 10:10:39 -0700 (PDT)
Date:   Sat, 8 Jun 2019 01:10:37 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 2/6] generic: copy_file_range immutable file test
Message-ID: <20190607171037.GW15846@desktop>
References: <20190602124114.26810-1-amir73il@gmail.com>
 <20190602124114.26810-3-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190602124114.26810-3-amir73il@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 02, 2019 at 03:41:10PM +0300, Amir Goldstein wrote:
> This test case was split out of Dave Chinner's copy_file_range bounds
> check test to reduce the requirements for running the bounds check.

I think this description should go below "---" and not be in the commit
log. I copied the test description from test here instead.

> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/generic/988     | 59 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/988.out |  5 ++++
>  tests/generic/group   |  1 +
>  3 files changed, 65 insertions(+)
>  create mode 100755 tests/generic/988
>  create mode 100644 tests/generic/988.out
> 
> diff --git a/tests/generic/988 b/tests/generic/988
> new file mode 100755
> index 00000000..0f4ee4ea
> --- /dev/null
> +++ b/tests/generic/988
> @@ -0,0 +1,59 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 988
> +#
> +# Check that we cannot copy_file_range() to/from an immutable file
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 7 15
> +
> +_cleanup()
> +{
> +	$CHATTR_PROG -i $testdir/immutable > /dev/null 2>&1
> +	cd /
> +	rm -rf $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_os Linux
> +_supported_fs generic
> +
> +rm -f $seqres.full
> +
> +_require_test
> +_require_chattr i
> +_require_xfs_io_command "copy_range"
> +_require_xfs_io_command "chattr"
> +
> +testdir="$TEST_DIR/test-$seq"

I renamed "testdir" to "workdir" to avoid confusing with TEST_DIR, and
moved the definition before _cleanup so we have a valid workdir
definition if any of the requires are not met.

Thanks,
Eryu

> +rm -rf $testdir
> +mkdir $testdir
> +
> +rm -f $seqres.full
> +
> +$XFS_IO_PROG -f -c "pwrite -S 0x61 0 128k" $testdir/file >> $seqres.full 2>&1
> +
> +# we have to open the file to be immutable rw and hold it open over the
> +# chattr command to set it immutable, otherwise we won't be able to open it for
> +# writing after it's been made immutable. (i.e. would exercise file mode checks,
> +# not immutable inode flag checks).
> +echo immutable file returns EPERM
> +$XFS_IO_PROG -f -c "pwrite -S 0x61 0 64k" -c fsync $testdir/immutable | _filter_xfs_io
> +$XFS_IO_PROG -f -c "chattr +i" -c "copy_range -l 32k $testdir/file" $testdir/immutable
> +$XFS_IO_PROG -f -r -c "chattr -i" $testdir/immutable
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/988.out b/tests/generic/988.out
> new file mode 100644
> index 00000000..e74a96bf
> --- /dev/null
> +++ b/tests/generic/988.out
> @@ -0,0 +1,5 @@
> +QA output created by 988
> +immutable file returns EPERM
> +wrote 65536/65536 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +copy_range: Operation not permitted
> diff --git a/tests/generic/group b/tests/generic/group
> index b498eb56..20b95c14 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -550,3 +550,4 @@
>  545 auto quick cap
>  546 auto quick clone enospc log
>  547 auto quick log
> +988 auto quick copy_range
> -- 
> 2.17.1
> 
