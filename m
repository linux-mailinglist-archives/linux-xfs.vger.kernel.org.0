Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E869C5948D
	for <lists+linux-xfs@lfdr.de>; Fri, 28 Jun 2019 09:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfF1HEN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 28 Jun 2019 03:04:13 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37314 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbfF1HEM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 03:04:12 -0400
Received: by mail-pf1-f194.google.com with SMTP id 19so2498940pfa.4;
        Fri, 28 Jun 2019 00:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GRbLrGqU2jfXn30lh3m3t93ZCre1+1dgqf3VEKwVyRs=;
        b=ReG+aFgId0cm6o6a+UP9q75A+UvgDhjiOT8wT3Wn1rqJYosX0GNKukIOhB/0iMaACz
         96fgKU5IjkHiC4ejgRt9ZcLJJ6KSTS3WbsNDBUnu88xL7S3MkasVkAk1JOHvtRG2Sq4c
         bHr11th6GEyFL2b3MZKVRWv8rcrFswczZW11exNjJ2b4hOeeYRoBADxzNVVEqY8pRYxI
         PVqno4SRZnBwDMUKoyemp2oHaf7QK39LQ8DwpHxS4aR1mDwO+7HYniXgiobkNtdvhNsl
         qFFUY946jCDjR6t3wdoKiSBLhYpf/HGjahbQuOQoXf7dnUjpkibMozrI/9vUtE2dNxgZ
         bi4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GRbLrGqU2jfXn30lh3m3t93ZCre1+1dgqf3VEKwVyRs=;
        b=qgIUWG6jOoDIGvu8lcEbJHCP9LnH/18gvMhsHPf5zSAiTxubUSLqZn/SJEvvTY2u+b
         UtaTEJsd/ngQyj0he5dHjAMO4yIJZQmaeye2+vaEhwX/wvGuIxShhxlj67cf3ufj7oLA
         2hQaTrLHyjjRql6M+5n1lIpGNlQf28PsEIBc/C2ASQ1V5O2J4sGWBB22031SfAnDWlUf
         VXrZDPoUeuJf5JqyV52SH5f6bnm5bQ79d8OY2yD8DuVMu0j7Ec9FRPPWQLGF6c9yhKYQ
         TFWNXQB9lUWUXNNH2Rdq5e1ZuQ6ARnGVU/d22+ieFs3lD2mwGPdF4yyo20JfJL1BOfKB
         f6BA==
X-Gm-Message-State: APjAAAV5MoqYx/YGLud9rxfQ5hSt2G3R+8Z1FnuB0WZ4H+h9sbXYCPHn
        C5pidfr5Xg6LSoTDddT4tKQPskPWlQY=
X-Google-Smtp-Source: APXvYqx/v559pAYHXG7nkxPWrFyB8gUWcS07sbg1cY7uqePxzqUJ3tURTgGW3cxN/6Pi4eXtTohUnw==
X-Received: by 2002:a17:90a:30e4:: with SMTP id h91mr10777051pjb.37.1561705451738;
        Fri, 28 Jun 2019 00:04:11 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id v13sm1191534pfe.105.2019.06.28.00.04.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 00:04:10 -0700 (PDT)
Date:   Fri, 28 Jun 2019 15:04:05 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: project quota ineritance flag test
Message-ID: <20190628070405.GC7943@desktop>
References: <20190619101047.3149-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619101047.3149-1-zlang@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 19, 2019 at 06:10:47PM +0800, Zorro Lang wrote:
> This case is used to cover xfsprogs bug "b136f48b xfs_quota: fix
> false error reporting of project inheritance flag is not set" at
> first. Then test more behavior when project ineritance flag is
> set or removed.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Test looks fine to me. Just some minor issues inline, and I've fixed
them up on commit.

> ---
>  tests/xfs/507     | 117 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/507.out |  23 +++++++++
>  tests/xfs/group   |   1 +
>  3 files changed, 141 insertions(+)
>  create mode 100755 tests/xfs/507
>  create mode 100644 tests/xfs/507.out
> 
> diff --git a/tests/xfs/507 b/tests/xfs/507
> new file mode 100755
> index 00000000..509da03e
> --- /dev/null
> +++ b/tests/xfs/507
> @@ -0,0 +1,117 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 507
> +#
> +# Test project quota inheritance flag, uncover xfsprogs:
> +#    b136f48b xfs_quota: fix false error reporting of project inheritance flag is not set

Test project..., uncover xfsprogs bug fixed by commit b136f48b19a5
("xfs_quota: fix false error reporting of project inheritance flag is
not set").

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
> +. ./common/filter
> +. ./common/quota
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch
> +_require_xfs_quota
> +
> +cat >$tmp.projects <<EOF
> +10:$SCRATCH_MNT/dir
> +EOF
> +
> +cat >$tmp.projid <<EOF
> +root:0
> +test:10
> +EOF
> +
> +QUOTA_CMD="$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid"
> +
> +filter_xfs_pquota()
> +{
> +        perl -ne "
> +s,$tmp.projects,[PROJECTS_FILE],;
> +s,$SCRATCH_MNT,[SCR_MNT],;
> +s,$SCRATCH_DEV,[SCR_DEV],;
> +        print;"
> +}
> +
> +do_quota_nospc()
> +{
> +	local file=$1
> +	local exp=$2
> +
> +	echo "Write $file, expect $exp:" | _filter_scratch
> +
> +	# replace the "pwrite64" which old xfs_io prints
> +	$XFS_IO_PROG -t -f -c "pwrite 0 5m" $file 2>&1 >/dev/null | \
> +		sed -e 's/pwrite64/pwrite/g'

_filter_xfs_io_error does this job.

> +	rm -f $file
> +}
> +
> +_scratch_mkfs_xfs >>$seqres.full 2>&1
> +_qmount_option "prjquota"
> +_qmount
> +_require_prjquota $SCRATCH_DEV
> +
> +mkdir $SCRATCH_MNT/dir
> +$QUOTA_CMD -x -c 'project -s test' $SCRATCH_MNT >>$seqres.full 2>&1
> +$QUOTA_CMD -x -c 'limit -p bsoft=1m bhard=2m test' $SCRATCH_MNT
> +
> +# test the Project inheritance bit is a directory only flag, and it's set on
> +# directory by default

I added comments here to state that we don't expect "project inheritance
flag is not set" from xfs_quota.

Thanks,
Eryu

> +echo "== The parent directory has Project inheritance bit by default =="
> +touch $SCRATCH_MNT/dir/foo
> +mkdir $SCRATCH_MNT/dir/dir_inherit
> +touch $SCRATCH_MNT/dir/dir_inherit/foo
> +$QUOTA_CMD -x -c 'project -c test' $SCRATCH_MNT | filter_xfs_pquota
> +echo ""
> +
> +# test the quota and the project inheritance quota work well
> +do_quota_nospc $SCRATCH_MNT/dir/foo ENOSPC
> +do_quota_nospc $SCRATCH_MNT/dir/dir_inherit/foo ENOSPC
> +echo ""
> +
> +# test the project quota won't be inherited, if removing the Project
> +# inheritance bit
> +echo "== After removing parent directory has Project inheritance bit =="
> +$XFS_IO_PROG -x -c "chattr -P" $SCRATCH_MNT/dir
> +touch $SCRATCH_MNT/dir/foo
> +mkdir $SCRATCH_MNT/dir/dir_uninherit
> +touch $SCRATCH_MNT/dir/dir_uninherit/foo
> +$QUOTA_CMD -x -c 'project -c test' $SCRATCH_MNT | filter_xfs_pquota
> +echo ""
> +
> +# after remove the Project inheritance bit of the original parent directory,
> +# then verify:
> +# 1) there's not any limit on the original parent directory and files under it
> +# 2) the quota limit of sub-directory which has inherited still works
> +# 3) there's not limit on the new sub-dirctory (not inherit from parent)
> +do_quota_nospc $SCRATCH_MNT/dir/foo Success
> +do_quota_nospc $SCRATCH_MNT/dir/dir_inherit/foo ENOSPC
> +do_quota_nospc $SCRATCH_MNT/dir/dir_uninherit/foo Success
> +
> +_scratch_unmount
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/507.out b/tests/xfs/507.out
> new file mode 100644
> index 00000000..c8c09d3f
> --- /dev/null
> +++ b/tests/xfs/507.out
> @@ -0,0 +1,23 @@
> +QA output created by 507
> +== The parent directory has Project inheritance bit by default ==
> +Checking project test (path [SCR_MNT]/dir)...
> +Processed 1 ([PROJECTS_FILE] and cmdline) paths for project test with recursion depth infinite (-1).
> +
> +Write SCRATCH_MNT/dir/foo, expect ENOSPC:
> +pwrite: No space left on device
> +Write SCRATCH_MNT/dir/dir_inherit/foo, expect ENOSPC:
> +pwrite: No space left on device
> +
> +== After removing parent directory has Project inheritance bit ==
> +Checking project test (path [SCR_MNT]/dir)...
> +[SCR_MNT]/dir - project inheritance flag is not set
> +[SCR_MNT]/dir/foo - project identifier is not set (inode=0, tree=10)
> +[SCR_MNT]/dir/dir_uninherit - project identifier is not set (inode=0, tree=10)
> +[SCR_MNT]/dir/dir_uninherit - project inheritance flag is not set
> +[SCR_MNT]/dir/dir_uninherit/foo - project identifier is not set (inode=0, tree=10)
> +Processed 1 ([PROJECTS_FILE] and cmdline) paths for project test with recursion depth infinite (-1).
> +
> +Write SCRATCH_MNT/dir/foo, expect Success:
> +Write SCRATCH_MNT/dir/dir_inherit/foo, expect ENOSPC:
> +pwrite: No space left on device
> +Write SCRATCH_MNT/dir/dir_uninherit/foo, expect Success:
> diff --git a/tests/xfs/group b/tests/xfs/group
> index ffe4ae12..46200752 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -504,3 +504,4 @@
>  504 auto quick mkfs label
>  505 auto quick spaceman
>  506 auto quick health
> +507 auto quick quota
> -- 
> 2.17.2
> 
