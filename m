Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EDD68E062
	for <lists+linux-xfs@lfdr.de>; Tue,  7 Feb 2023 19:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjBGSqC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 7 Feb 2023 13:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjBGSqB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Feb 2023 13:46:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983A63FF20
        for <linux-xfs@vger.kernel.org>; Tue,  7 Feb 2023 10:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675795510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ouoFZNtuF4GQ/wDd0PlriQx0hzmbFs5kIitfSI/AdwM=;
        b=JexX3rWrUviDG2s3sudwxt4KOf7rbeiUTXQIvqaFlbDk6yq/jxv+DqSEQ2BAUk3HfagpnM
        7Iz+16kwPRQhpzaxUH6dluwQtrj7Tkk+7MbJrSHTE+2vwmXuUsLM62Toxo3NnyzM8P5cko
        JQCoq4ZGnkHUItctzcbmhrtrDe3ZRWc=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-629-oN6tPqwzNsa2nUYBpb-nhA-1; Tue, 07 Feb 2023 13:45:09 -0500
X-MC-Unique: oN6tPqwzNsa2nUYBpb-nhA-1
Received: by mail-pf1-f199.google.com with SMTP id ay13-20020a056a00300d00b005a7aae77508so1402876pfb.11
        for <linux-xfs@vger.kernel.org>; Tue, 07 Feb 2023 10:45:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ouoFZNtuF4GQ/wDd0PlriQx0hzmbFs5kIitfSI/AdwM=;
        b=wx5O3pqYssduAzRRXjufcozuo9owo3yPvp/fR7MH6zONOQnbWJJElz6/9LaWlwMoSl
         RlH9kxPV8ASz0H4dLdKkwA+tZh/xBGp/GhZviFJolWSkjWZmxsbQOLEZZe5Chxyvca34
         zgoJ2PAqI+gSx0bFyncFfhhOIinvwtGdReg6Wn983inmLwxv3fHoNiP+X7npo+mGiASD
         pDOmNHVMygzZGwoIwoSANaSTmId9p5+s8fiQXntWz74qYVU5LLYJBRQw4lTc7XZwxXK2
         Ne5VfspVSyR2vG1FqfJRD/oo7tuvKNznKEjXGB+BaIwdrJ8bG/qQuevq9FBPot1swYd2
         fBZQ==
X-Gm-Message-State: AO0yUKWGyToWupfPxTQUgE3SAT2aNyLEVzCBfhg+VX4eVxfUcmVKAiuv
        I3aK1cnFz0UbvCyr0zJgLoZsaa9jbOTSRf4SxdvyDr6Eij5frJr666YXILRQtYVNXSVhhgTme+q
        xBDmU7JZcDxKUALLA8eevuwsuQ3uOKgQ=
X-Received: by 2002:a17:90b:4c47:b0:225:e88c:33c2 with SMTP id np7-20020a17090b4c4700b00225e88c33c2mr5248566pjb.7.1675795507392;
        Tue, 07 Feb 2023 10:45:07 -0800 (PST)
X-Google-Smtp-Source: AK7set95QgWj2dVy352JPrl0ucb7lc2j+90i19CyFiIis+cgmwMWsWe2yzpfZQg+BWvsAJQttUtu9w==
X-Received: by 2002:a17:90b:4c47:b0:225:e88c:33c2 with SMTP id np7-20020a17090b4c4700b00225e88c33c2mr5248524pjb.7.1675795506763;
        Tue, 07 Feb 2023 10:45:06 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z11-20020a17090a170b00b0023087e8adf8sm6658109pjd.21.2023.02.07.10.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 10:45:06 -0800 (PST)
Date:   Wed, 8 Feb 2023 02:45:02 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v24.1 2/5] xfs: race fsstress with online scrubbers for
 AG and fs metadata
Message-ID: <20230207184502.srusss5lhzzzu5bn@zlang-mailbox>
References: <167243874614.722028.11987534226186856347.stgit@magnolia>
 <167243874639.722028.9759938995780056273.stgit@magnolia>
 <Y+KEFGlYwMlhN9fJ@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+KEFGlYwMlhN9fJ@magnolia>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 07, 2023 at 09:02:12AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> For each XFS_SCRUB_TYPE_* that looks at AG or filesystem metadata,
> create a test that runs that scrubber in the foreground and fsstress in
> the background.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v24.1: rebase against newer upstream to get rid of merge conflicts
> ---

This version is good to me.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/quota      |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/782     |   37 +++++++++++++++++++++++++++++++
>  tests/xfs/782.out |    2 ++
>  tests/xfs/783     |   37 +++++++++++++++++++++++++++++++
>  tests/xfs/783.out |    2 ++
>  tests/xfs/784     |   37 +++++++++++++++++++++++++++++++
>  tests/xfs/784.out |    2 ++
>  tests/xfs/785     |   37 +++++++++++++++++++++++++++++++
>  tests/xfs/785.out |    2 ++
>  tests/xfs/786     |   38 +++++++++++++++++++++++++++++++
>  tests/xfs/786.out |    2 ++
>  tests/xfs/787     |   38 +++++++++++++++++++++++++++++++
>  tests/xfs/787.out |    2 ++
>  tests/xfs/788     |   38 +++++++++++++++++++++++++++++++
>  tests/xfs/788.out |    2 ++
>  tests/xfs/789     |   39 ++++++++++++++++++++++++++++++++
>  tests/xfs/789.out |    2 ++
>  tests/xfs/790     |   39 ++++++++++++++++++++++++++++++++
>  tests/xfs/790.out |    2 ++
>  tests/xfs/791     |   40 +++++++++++++++++++++++++++++++++
>  tests/xfs/791.out |    2 ++
>  tests/xfs/798     |   44 ++++++++++++++++++++++++++++++++++++
>  tests/xfs/798.out |    2 ++
>  tests/xfs/800     |   40 +++++++++++++++++++++++++++++++++
>  tests/xfs/800.out |    2 ++
>  tests/xfs/801     |   47 +++++++++++++++++++++++++++++++++++++++
>  tests/xfs/801.out |    2 ++
>  tests/xfs/802     |   40 +++++++++++++++++++++++++++++++++
>  tests/xfs/802.out |    2 ++
>  tests/xfs/803     |   40 +++++++++++++++++++++++++++++++++
>  tests/xfs/803.out |    2 ++
>  tests/xfs/804     |   40 +++++++++++++++++++++++++++++++++
>  tests/xfs/804.out |    2 ++
>  tests/xfs/805     |   38 +++++++++++++++++++++++++++++++
>  tests/xfs/805.out |    2 ++
>  35 files changed, 767 insertions(+)
>  create mode 100755 tests/xfs/782
>  create mode 100644 tests/xfs/782.out
>  create mode 100755 tests/xfs/783
>  create mode 100644 tests/xfs/783.out
>  create mode 100755 tests/xfs/784
>  create mode 100644 tests/xfs/784.out
>  create mode 100755 tests/xfs/785
>  create mode 100644 tests/xfs/785.out
>  create mode 100755 tests/xfs/786
>  create mode 100644 tests/xfs/786.out
>  create mode 100755 tests/xfs/787
>  create mode 100644 tests/xfs/787.out
>  create mode 100755 tests/xfs/788
>  create mode 100644 tests/xfs/788.out
>  create mode 100755 tests/xfs/789
>  create mode 100644 tests/xfs/789.out
>  create mode 100755 tests/xfs/790
>  create mode 100644 tests/xfs/790.out
>  create mode 100755 tests/xfs/791
>  create mode 100644 tests/xfs/791.out
>  create mode 100755 tests/xfs/798
>  create mode 100644 tests/xfs/798.out
>  create mode 100755 tests/xfs/800
>  create mode 100644 tests/xfs/800.out
>  create mode 100755 tests/xfs/801
>  create mode 100644 tests/xfs/801.out
>  create mode 100755 tests/xfs/802
>  create mode 100644 tests/xfs/802.out
>  create mode 100755 tests/xfs/803
>  create mode 100644 tests/xfs/803.out
>  create mode 100755 tests/xfs/804
>  create mode 100644 tests/xfs/804.out
>  create mode 100755 tests/xfs/805
>  create mode 100644 tests/xfs/805.out
> 
> diff --git a/common/quota b/common/quota
> index 24251d092a..96b8d04424 100644
> --- a/common/quota
> +++ b/common/quota
> @@ -53,6 +53,70 @@ _require_xfs_quota()
>      [ -n "$XFS_QUOTA_PROG" ] || _notrun "XFS quota user tools not installed"
>  }
>  
> +# Check that a mounted fs has a particular type of quota accounting turned on.
> +#
> +# The first argument must be the data device of a mounted fs.  It must not be
> +# the actual mountpath.
> +#
> +# The second argument is the quota type ('usrquota', 'grpquota', 'prjquota',
> +# 'any', or 'all').
> +_xfs_quota_acct_enabled()
> +{
> +	local dev="$1"
> +	local qtype="$2"
> +	local f_args=()
> +	local any=
> +
> +	case "$qtype" in
> +	"usrquota"|"uquota")	f_args=("-U");;
> +	"grpquota"|"gquota")	f_args=("-G");;
> +	"prjquota"|"pquota")	f_args=("-P");;
> +	"all")			f_args=("-U" "-G" "-P");;
> +	"any")			f_args=("-U" "-G" "-P"); any=1;;
> +	*)			echo "$qtype: Unknown quota type."; return 1;;
> +	esac
> +
> +	if [ "$any" = "1" ]; then
> +		for arg in "$f_args"; do
> +			$here/src/feature "$arg" "$dev" && return 0
> +		done
> +		return 1
> +	fi
> +
> +	$here/src/feature "${f_args[@]}" "$dev"
> +}
> +
> +# Require that a mounted fs has a particular type of quota turned on.  This
> +# takes the same arguments as _xfs_quota_acct_enabled.  If the third argument is
> +# '-u' (or is empty and dev is $SCRATCH_DEV) the fs will be unmounted on
> +# failure.
> +_require_xfs_quota_acct_enabled()
> +{
> +	local dev="$1"
> +	local qtype="$2"
> +	local umount="$3"
> +	local fsname="$dev"
> +
> +	_xfs_quota_acct_enabled "$dev" "$qtype" "$qmode" && return 0
> +
> +	if [ -z "$umount" ] && [ "$dev" = "$SCRATCH_DEV" ]; then
> +		umount="-u"
> +	fi
> +	test "$umount" = "-u" && umount "$dev" &>/dev/null
> +
> +	case "$dev" in
> +	"$TEST_DEV")	fsname="test";;
> +	"$SCRATCH_DEV")	fsname="scratch";;
> +	esac
> +
> +	case "$qtype" in
> +	"any")		qtype="any quotas";;
> +	"all")		qtype="all quotas";;
> +	esac
> +
> +	_notrun "$qtype: accounting not enabled on $fsname filesystem."
> +}
> +
>  #
>  # checks that xfs_quota can operate on foreign (non-xfs) filesystems
>  # Skips check on xfs filesystems, old xfs_quota is fine there.
> diff --git a/tests/xfs/782 b/tests/xfs/782
> new file mode 100755
> index 0000000000..4801eda4bd
> --- /dev/null
> +++ b/tests/xfs/782
> @@ -0,0 +1,37 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 782
> +#
> +# Race fsstress and superblock scrub for a while to see if we crash or livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_scratch_xfs_stress_scrub -s "scrub sb %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/782.out b/tests/xfs/782.out
> new file mode 100644
> index 0000000000..6e378f0e53
> --- /dev/null
> +++ b/tests/xfs/782.out
> @@ -0,0 +1,2 @@
> +QA output created by 782
> +Silence is golden
> diff --git a/tests/xfs/783 b/tests/xfs/783
> new file mode 100755
> index 0000000000..379a9369e5
> --- /dev/null
> +++ b/tests/xfs/783
> @@ -0,0 +1,37 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 783
> +#
> +# Race fsstress and AGF scrub for a while to see if we crash or livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_scratch_xfs_stress_scrub -s "scrub agf %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/783.out b/tests/xfs/783.out
> new file mode 100644
> index 0000000000..2522395956
> --- /dev/null
> +++ b/tests/xfs/783.out
> @@ -0,0 +1,2 @@
> +QA output created by 783
> +Silence is golden
> diff --git a/tests/xfs/784 b/tests/xfs/784
> new file mode 100755
> index 0000000000..2b89361c36
> --- /dev/null
> +++ b/tests/xfs/784
> @@ -0,0 +1,37 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 784
> +#
> +# Race fsstress and AGFL scrub for a while to see if we crash or livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_scratch_xfs_stress_scrub -s "scrub agfl %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/784.out b/tests/xfs/784.out
> new file mode 100644
> index 0000000000..48d9b24dd0
> --- /dev/null
> +++ b/tests/xfs/784.out
> @@ -0,0 +1,2 @@
> +QA output created by 784
> +Silence is golden
> diff --git a/tests/xfs/785 b/tests/xfs/785
> new file mode 100755
> index 0000000000..34a13b058d
> --- /dev/null
> +++ b/tests/xfs/785
> @@ -0,0 +1,37 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 785
> +#
> +# Race fsstress and AGI scrub for a while to see if we crash or livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_scratch_xfs_stress_scrub -s "scrub agi %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/785.out b/tests/xfs/785.out
> new file mode 100644
> index 0000000000..6ecb0c61b3
> --- /dev/null
> +++ b/tests/xfs/785.out
> @@ -0,0 +1,2 @@
> +QA output created by 785
> +Silence is golden
> diff --git a/tests/xfs/786 b/tests/xfs/786
> new file mode 100755
> index 0000000000..157200ea8c
> --- /dev/null
> +++ b/tests/xfs/786
> @@ -0,0 +1,38 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 786
> +#
> +# Race fsstress and freespace by block btree scrub for a while to see if we
> +# crash or livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_scratch_xfs_stress_scrub -s "scrub bnobt %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/786.out b/tests/xfs/786.out
> new file mode 100644
> index 0000000000..ccb9167df9
> --- /dev/null
> +++ b/tests/xfs/786.out
> @@ -0,0 +1,2 @@
> +QA output created by 786
> +Silence is golden
> diff --git a/tests/xfs/787 b/tests/xfs/787
> new file mode 100755
> index 0000000000..91eaf5a7af
> --- /dev/null
> +++ b/tests/xfs/787
> @@ -0,0 +1,38 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 787
> +#
> +# Race fsstress and free space by length btree scrub for a while to see if we
> +# crash or livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_scratch_xfs_stress_scrub -s "scrub cntbt %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/787.out b/tests/xfs/787.out
> new file mode 100644
> index 0000000000..fa7f038120
> --- /dev/null
> +++ b/tests/xfs/787.out
> @@ -0,0 +1,2 @@
> +QA output created by 787
> +Silence is golden
> diff --git a/tests/xfs/788 b/tests/xfs/788
> new file mode 100755
> index 0000000000..f1369e5309
> --- /dev/null
> +++ b/tests/xfs/788
> @@ -0,0 +1,38 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 788
> +#
> +# Race fsstress and inode btree scrub for a while to see if we crash or
> +# livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_scratch_xfs_stress_scrub -x 'dir' -s "scrub inobt %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/788.out b/tests/xfs/788.out
> new file mode 100644
> index 0000000000..5ddd661113
> --- /dev/null
> +++ b/tests/xfs/788.out
> @@ -0,0 +1,2 @@
> +QA output created by 788
> +Silence is golden
> diff --git a/tests/xfs/789 b/tests/xfs/789
> new file mode 100755
> index 0000000000..550ff2c690
> --- /dev/null
> +++ b/tests/xfs/789
> @@ -0,0 +1,39 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 789
> +#
> +# Race fsstress and free inode btree scrub for a while to see if we crash or
> +# livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_xfs_has_feature "$SCRATCH_MNT" finobt
> +_scratch_xfs_stress_scrub -x 'dir' -s "scrub finobt %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/789.out b/tests/xfs/789.out
> new file mode 100644
> index 0000000000..da88fc99cb
> --- /dev/null
> +++ b/tests/xfs/789.out
> @@ -0,0 +1,2 @@
> +QA output created by 789
> +Silence is golden
> diff --git a/tests/xfs/790 b/tests/xfs/790
> new file mode 100755
> index 0000000000..c4e5779ef7
> --- /dev/null
> +++ b/tests/xfs/790
> @@ -0,0 +1,39 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 790
> +#
> +# Race fsstress and reverse mapping btree scrub for a while to see if we crash
> +# or livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_xfs_has_feature "$SCRATCH_MNT" rmapbt
> +_scratch_xfs_stress_scrub -s "scrub rmapbt %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/790.out b/tests/xfs/790.out
> new file mode 100644
> index 0000000000..7102c590f0
> --- /dev/null
> +++ b/tests/xfs/790.out
> @@ -0,0 +1,2 @@
> +QA output created by 790
> +Silence is golden
> diff --git a/tests/xfs/791 b/tests/xfs/791
> new file mode 100755
> index 0000000000..6939d910c9
> --- /dev/null
> +++ b/tests/xfs/791
> @@ -0,0 +1,40 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 791
> +#
> +# Race fsstress and reference count btree scrub for a while to see if we crash
> +# or livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +. ./common/reflink
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_xfs_has_feature "$SCRATCH_MNT" reflink
> +_scratch_xfs_stress_scrub -s "scrub refcountbt %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/791.out b/tests/xfs/791.out
> new file mode 100644
> index 0000000000..758905371d
> --- /dev/null
> +++ b/tests/xfs/791.out
> @@ -0,0 +1,2 @@
> +QA output created by 791
> +Silence is golden
> diff --git a/tests/xfs/798 b/tests/xfs/798
> new file mode 100755
> index 0000000000..c5bdfad50a
> --- /dev/null
> +++ b/tests/xfs/798
> @@ -0,0 +1,44 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 798
> +#
> +# Race fsstress and fscounter scrub on the realtime device for a while to see
> +# if we crash or livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_realtime
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_xfs_has_feature "$SCRATCH_MNT" realtime
> +
> +# Force all files to be allocated on the realtime device
> +_xfs_force_bdev realtime $SCRATCH_MNT
> +
> +_scratch_xfs_stress_scrub -s 'scrub fscounters'
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/798.out b/tests/xfs/798.out
> new file mode 100644
> index 0000000000..216d6e93f4
> --- /dev/null
> +++ b/tests/xfs/798.out
> @@ -0,0 +1,2 @@
> +QA output created by 798
> +Silence is golden
> diff --git a/tests/xfs/800 b/tests/xfs/800
> new file mode 100755
> index 0000000000..cbcfb5f5a6
> --- /dev/null
> +++ b/tests/xfs/800
> @@ -0,0 +1,40 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 800
> +#
> +# Race fsstress and realtime bitmap scrub for a while to see if we crash or
> +# livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_realtime
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_xfs_has_feature "$SCRATCH_MNT" realtime
> +_scratch_xfs_stress_scrub -s "scrub rtbitmap"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/800.out b/tests/xfs/800.out
> new file mode 100644
> index 0000000000..bdfaa2cecd
> --- /dev/null
> +++ b/tests/xfs/800.out
> @@ -0,0 +1,2 @@
> +QA output created by 800
> +Silence is golden
> diff --git a/tests/xfs/801 b/tests/xfs/801
> new file mode 100755
> index 0000000000..a51fab523b
> --- /dev/null
> +++ b/tests/xfs/801
> @@ -0,0 +1,47 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 801
> +#
> +# Race fsstress and realtime summary scrub for a while to see if we crash or
> +# livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_realtime
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_xfs_has_feature "$SCRATCH_MNT" realtime
> +
> +# XXX the realtime summary scrubber isn't currently implemented upstream.
> +# Don't bother trying to test it on those kernels
> +$XFS_IO_PROG -c 'scrub rtsummary' -c 'scrub rtsummary' "$SCRATCH_MNT" 2>&1 | \
> +	grep -q 'Scan was not complete' && \
> +	_notrun "rtsummary scrub is incomplete"
> +
> +_scratch_xfs_stress_scrub -s "scrub rtsummary"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/801.out b/tests/xfs/801.out
> new file mode 100644
> index 0000000000..39481b38e2
> --- /dev/null
> +++ b/tests/xfs/801.out
> @@ -0,0 +1,2 @@
> +QA output created by 801
> +Silence is golden
> diff --git a/tests/xfs/802 b/tests/xfs/802
> new file mode 100755
> index 0000000000..1f3b83882e
> --- /dev/null
> +++ b/tests/xfs/802
> @@ -0,0 +1,40 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 802
> +#
> +# Race fsstress and user quota scrub for a while to see if we crash or
> +# livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +. ./common/quota
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_xfs_quota_acct_enabled "$SCRATCH_DEV" usrquota
> +_scratch_xfs_stress_scrub -s "scrub usrquota"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/802.out b/tests/xfs/802.out
> new file mode 100644
> index 0000000000..a69c05391f
> --- /dev/null
> +++ b/tests/xfs/802.out
> @@ -0,0 +1,2 @@
> +QA output created by 802
> +Silence is golden
> diff --git a/tests/xfs/803 b/tests/xfs/803
> new file mode 100755
> index 0000000000..b2bb85672d
> --- /dev/null
> +++ b/tests/xfs/803
> @@ -0,0 +1,40 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 803
> +#
> +# Race fsstress and group quota scrub for a while to see if we crash or
> +# livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +. ./common/quota
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_xfs_quota_acct_enabled "$SCRATCH_DEV" grpquota
> +_scratch_xfs_stress_scrub -s "scrub grpquota"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/803.out b/tests/xfs/803.out
> new file mode 100644
> index 0000000000..38ba741d0f
> --- /dev/null
> +++ b/tests/xfs/803.out
> @@ -0,0 +1,2 @@
> +QA output created by 803
> +Silence is golden
> diff --git a/tests/xfs/804 b/tests/xfs/804
> new file mode 100755
> index 0000000000..129724eb11
> --- /dev/null
> +++ b/tests/xfs/804
> @@ -0,0 +1,40 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 804
> +#
> +# Race fsstress and project quota scrub for a while to see if we crash or
> +# livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +. ./common/quota
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_xfs_quota_acct_enabled "$SCRATCH_DEV" prjquota
> +_scratch_xfs_stress_scrub -s "scrub prjquota"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/804.out b/tests/xfs/804.out
> new file mode 100644
> index 0000000000..5e0cb437e7
> --- /dev/null
> +++ b/tests/xfs/804.out
> @@ -0,0 +1,2 @@
> +QA output created by 804
> +Silence is golden
> diff --git a/tests/xfs/805 b/tests/xfs/805
> new file mode 100755
> index 0000000000..aca9b9cdf4
> --- /dev/null
> +++ b/tests/xfs/805
> @@ -0,0 +1,38 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 805
> +#
> +# Race fsstress and summary counters scrub for a while to see if we crash or
> +# livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_scratch_xfs_stress_scrub -s "scrub fscounters"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/805.out b/tests/xfs/805.out
> new file mode 100644
> index 0000000000..ac324c5874
> --- /dev/null
> +++ b/tests/xfs/805.out
> @@ -0,0 +1,2 @@
> +QA output created by 805
> +Silence is golden
> 

