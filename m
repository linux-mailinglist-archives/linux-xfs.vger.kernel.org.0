Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA5B94E195
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2019 10:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfFUIFi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 04:05:38 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46678 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfFUIFi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 04:05:38 -0400
Received: by mail-pf1-f196.google.com with SMTP id 81so3162000pfy.13;
        Fri, 21 Jun 2019 01:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8cS3aljHQsKxdgIaLDDhnWUz8QbVIOXyKHWLL/HTfcU=;
        b=A76ahLON65ASI2gNcMFr7R4r2heFospsV6kvEp5b80Rl0+C6qk/9aVr2fKCxUE8U7d
         WppWbE0fzewji+pMF0h+YL5nBuzScPTnJu3n4mcitEAyEbFrBfSdTTeGvqo98GD1fab9
         MVgJNNNyxaZHkTvcxZFa9PCJ0E1lLPQ/GbX1/R76YeDDih2yJVWMrwbnR0gwSiOzGr1w
         DULnOUgjXuZzxBHcfkNwd0R7Cj5NWeFLDm5RVJZV+/c2Ntdbw+9iRQUxJ702/kZYLPS7
         ZFFUpy8ItzlvDbFt5nUSE6K30oYK65Y64cjp6z+vs31I6VhepMAjx//RKSzSD6ZlW6R5
         1a3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8cS3aljHQsKxdgIaLDDhnWUz8QbVIOXyKHWLL/HTfcU=;
        b=Em0tVqIPJc7hL862R9pzSQrOgqd/PljyaoqylskXhL33snFDwtC8vb+PO86SHbwF6U
         yzqqz++G9N6dfJlKBR3/TCW5DGkkwz5+CNvaGoOhe4oTcnRQN1tv0T7STMkwsl9ON+ua
         F/yGuHWcyS51stcAQnC5OzHfxStM1Ygqy0e1qlrF5qIVQlm8i7gty07Ug+qAdH7gF52c
         8toQVy2lU+rz/pKKB2VQJ81zaFBDfi+f16S0ETrEZYRKb3YXQsDifczVFywUZwFmIL5b
         wKBc7viEQ30MjqkFRmr11fUAsDApBmaE7T1bZl2H1Mc9nnGbWYljtYXblyfe34DEApQL
         +xkQ==
X-Gm-Message-State: APjAAAUCy9XvbBqDhhROiQ2kbYfkzdwS1yNjsR6NLCHu62F1zT5YRZK6
        Q9i0BxKbYOWSOPyQZyMxLOc=
X-Google-Smtp-Source: APXvYqwReZUGq5jL2XB8cg74tJLWInS7ay9/Ds/E3Sh4wXNbonP54Wj3HgH/137XcVdJLjjwZIY1Fw==
X-Received: by 2002:a63:fc61:: with SMTP id r33mr17080127pgk.294.1561104337389;
        Fri, 21 Jun 2019 01:05:37 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id t8sm1832813pfq.31.2019.06.21.01.05.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 01:05:36 -0700 (PDT)
Date:   Fri, 21 Jun 2019 16:05:31 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test xfs_info on block device and mountpoint
Message-ID: <20190621080531.GG15846@desktop>
References: <20190614044954.22022-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614044954.22022-1-zlang@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 14, 2019 at 12:49:54PM +0800, Zorro Lang wrote:
> There was a bug, xfs_info fails on a mounted block device:
> 
>   # xfs_info /dev/mapper/testdev
>   xfs_info: /dev/mapper/testdev contains a mounted filesystem
> 
>   fatal error -- couldn't initialize XFS library
> 
> xfsprogs has fixed it, this case is used to cover this bug.

Would you please document the commit that fixed this bug in test
description?

> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  tests/xfs/1000     | 65 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1000.out |  2 ++

I find it easier if you just pick the next free seq number :) If there's
no conflict I can just apply the patch, and if there's conflict I'll do
manual edit anyway.

>  tests/xfs/group    |  1 +
>  3 files changed, 68 insertions(+)
>  create mode 100755 tests/xfs/1000
>  create mode 100644 tests/xfs/1000.out
> 
> diff --git a/tests/xfs/1000 b/tests/xfs/1000
> new file mode 100755
> index 00000000..689fe9e7
> --- /dev/null
> +++ b/tests/xfs/1000
> @@ -0,0 +1,65 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 1000
> +#
> +# test xfs_info on block device and mountpoint
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch
> +
> +test_xfs_info()
> +{
> +	local target="$1"
> +	local file=$tmp.$seq.info
> +
> +	$XFS_INFO_PROG $target > $file 2>&1
> +	if [ $? -ne 0 ];then
> +		echo "$XFS_INFO_PROG $target fails:"
> +		cat $file
> +	else
> +		cat $file >> $seqres.full
> +	fi
> +}
> +
> +_scratch_mkfs > $seqres.full 2>&1
> +# test unmounted block device(contains XFS)
> +# Due to old xfsprogs doesn't support xfs_info a unmounted device, skip it
> +$XFS_DB_PROG -c "info" $SCRATCH_DEV | grep -q "command info not found"

Better to explain why xfs_db is used here instead of xfs_info.

> +if [ $? -ne 0 ]; then
> +	test_xfs_info $SCRATCH_DEV
> +fi

And I'd suggest move this test to the end (after umount the scratch dev)
so we're sure the device contains a valid xfs (which has just been
mounted & umounted).

Thanks,
Eryu

> +
> +_scratch_mount
> +# test mounted block device and mountpoint
> +test_xfs_info $SCRATCH_DEV
> +test_xfs_info $SCRATCH_MNT
> +
> +echo "Silence is golden"
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/1000.out b/tests/xfs/1000.out
> new file mode 100644
> index 00000000..681b3b48
> --- /dev/null
> +++ b/tests/xfs/1000.out
> @@ -0,0 +1,2 @@
> +QA output created by 1000
> +Silence is golden
> diff --git a/tests/xfs/group b/tests/xfs/group
> index ffe4ae12..047fe332 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -504,3 +504,4 @@
>  504 auto quick mkfs label
>  505 auto quick spaceman
>  506 auto quick health
> +1000 auto quick
> -- 
> 2.17.2
> 
