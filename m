Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B41065E53C
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Jan 2023 06:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjAEFuT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Jan 2023 00:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjAEFuR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jan 2023 00:50:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8768240851
        for <linux-xfs@vger.kernel.org>; Wed,  4 Jan 2023 21:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672897770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mvahmqk0U+b3APw7gmdhzBs+Yi3sMhLUNAJRUvuI6YM=;
        b=iz59wDzG7yAhH0bvWUAoAaH7qPfXdOahuMxo1jntP5MlwmZIW+JfUGvjLmPyMIciEZzDOM
        26CYPPbyqxxKnRbWHv7jMNwHMyZkiJXckEyPTefTFoiQGKBzYckxw198RA6mdt2AnbpB/0
        pPswhC7GgIEWkQvBIYryaT5ETXgGqzE=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-227-RvAkD0DFM4WJfzYlDrqueQ-1; Thu, 05 Jan 2023 00:49:26 -0500
X-MC-Unique: RvAkD0DFM4WJfzYlDrqueQ-1
Received: by mail-pl1-f198.google.com with SMTP id u6-20020a170903124600b00188cd4769bcso25181811plh.0
        for <linux-xfs@vger.kernel.org>; Wed, 04 Jan 2023 21:49:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mvahmqk0U+b3APw7gmdhzBs+Yi3sMhLUNAJRUvuI6YM=;
        b=i1U2c/M47Vns5luEl5SW/SLLdDuF2GguT8F5sTWzGGEISu+kTiDdfiyWqJgsp1N+af
         XDYyyCVXMfCJIs/T+FbOwcR7DJPpCN3VA3ZOe1eHtawVqaP3viJpfO1UgdqR7+QImTKa
         nC93QhlR8fURkzdlR4Dnbc1ibU26orz6ux2RaIfawldEAcjmR7R3PW7AXIONR39mPGBR
         rnpvMWOR8iP6ndeYf4gzntg+vQ+/pjZiUPeDnJpX601yoYOhNEjQ2siYyWDieY8TCKoS
         OPk1QlfPldjaX2EsyW0cqyZPsc6L8v28JsKxeLHtqRCAP0mMKKs+M0pLc3pS4AeSz1xN
         zVaw==
X-Gm-Message-State: AFqh2kqQVaFHtVqnDyaqj0koT7z2lZrr7VRlyaPyusAASNyFZBysqBqX
        fUAHz+Var+u9YUWkKjKkMzBv0TiolsatrrqqCwtO07crSwx0/NWFewlNSjxNvMJk6E8qqEtRT0w
        7+xJCQgjPxlejGAqAuTNw
X-Received: by 2002:a17:90a:1345:b0:226:1495:3dca with SMTP id y5-20020a17090a134500b0022614953dcamr28348251pjf.45.1672897765314;
        Wed, 04 Jan 2023 21:49:25 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvYICwp3498gAuISM8MjFEtY8Htil5fa5cNqV+T0eom4GSjvwoQsQ1bRjZjE8j8D4TB5wXHBA==
X-Received: by 2002:a17:90a:1345:b0:226:1495:3dca with SMTP id y5-20020a17090a134500b0022614953dcamr28348235pjf.45.1672897764873;
        Wed, 04 Jan 2023 21:49:24 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y6-20020a17090a474600b002139459e121sm476873pjg.27.2023.01.04.21.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 21:49:24 -0800 (PST)
Date:   Thu, 5 Jan 2023 13:49:20 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] fuzzy: enhance scrub stress testing to use fsx
Message-ID: <20230105054920.bekb5vw5ah6o6m4f@zlang-mailbox>
References: <167243837772.695156.17793145241363597974.stgit@magnolia>
 <167243837785.695156.13821918047950372871.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167243837785.695156.13821918047950372871.stgit@magnolia>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 30, 2022 at 02:12:57PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a couple of new online fsck stress tests that race fsx against
> online fsck.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/fuzzy      |   39 ++++++++++++++++++++++++++++++++++++---
>  tests/xfs/847     |   38 ++++++++++++++++++++++++++++++++++++++
>  tests/xfs/847.out |    2 ++
>  tests/xfs/848     |   38 ++++++++++++++++++++++++++++++++++++++
>  tests/xfs/848.out |    2 ++
>  5 files changed, 116 insertions(+), 3 deletions(-)
>  create mode 100755 tests/xfs/847
>  create mode 100644 tests/xfs/847.out
>  create mode 100755 tests/xfs/848
>  create mode 100644 tests/xfs/848.out
> 
> 
> diff --git a/common/fuzzy b/common/fuzzy
> index 1df51a6dd8..3512e95e02 100644
> --- a/common/fuzzy
> +++ b/common/fuzzy
> @@ -408,6 +408,30 @@ __stress_scrub_clean_scratch() {
>  	return 0
>  }
>  
> +# Run fsx while we're testing online fsck.
> +__stress_scrub_fsx_loop() {
> +	local end="$1"
> +	local runningfile="$2"
> +	local focus=(-q -X)	# quiet, validate file contents
> +
> +	# As of November 2022, 2 million fsx ops should be enough to keep
> +	# any filesystem busy for a couple of hours.
> +	focus+=(-N 2000000)
> +	focus+=(-o $((128000 * LOAD_FACTOR)) )
> +	focus+=(-l $((600000 * LOAD_FACTOR)) )
> +
> +	local args="$FSX_AVOID ${focus[@]} ${SCRATCH_MNT}/fsx.$seq"
> +	echo "Running $here/ltp/fsx $args" >> $seqres.full
> +
> +	while __stress_scrub_running "$end" "$runningfile"; do
> +		# Need to recheck running conditions if we cleared anything
> +		__stress_scrub_clean_scratch && continue
> +		$here/ltp/fsx $args >> $seqres.full
> +		echo "fsx exits with $? at $(date)" >> $seqres.full
> +	done
> +	rm -f "$runningfile"
> +}
> +
>  # Run fsstress while we're testing online fsck.
>  __stress_scrub_fsstress_loop() {
>  	local end="$1"
> @@ -454,7 +478,7 @@ _scratch_xfs_stress_scrub_cleanup() {
>  	# Send SIGINT so that bash won't print a 'Terminated' message that
>  	# distorts the golden output.
>  	echo "Killing stressor processes at $(date)" >> $seqres.full
> -	$KILLALL_PROG -INT xfs_io fsstress >> $seqres.full 2>&1
> +	$KILLALL_PROG -INT xfs_io fsstress fsx >> $seqres.full 2>&1
>  
>  	# Tests are not allowed to exit with the scratch fs frozen.  If we
>  	# started a fs freeze/thaw background loop, wait for that loop to exit
> @@ -522,30 +546,39 @@ __stress_scrub_check_commands() {
>  # -w	Delay the start of the scrub/repair loop by this number of seconds.
>  #	Defaults to no delay unless XFS_SCRUB_STRESS_DELAY is set.  This value
>  #	will be clamped to ten seconds before the end time.
> +# -X	Run this program to exercise the filesystem.  Currently supported
> +#       options are 'fsx' and 'fsstress'.  The default is 'fsstress'.
>  _scratch_xfs_stress_scrub() {
>  	local one_scrub_args=()
>  	local scrub_tgt="$SCRATCH_MNT"
>  	local runningfile="$tmp.fsstress"
>  	local freeze="${XFS_SCRUB_STRESS_FREEZE}"
>  	local scrub_delay="${XFS_SCRUB_STRESS_DELAY:--1}"
> +	local exerciser="fsstress"
>  
>  	__SCRUB_STRESS_FREEZE_PID=""
>  	rm -f "$runningfile"
>  	touch "$runningfile"
>  
>  	OPTIND=1
> -	while getopts "fs:t:w:" c; do
> +	while getopts "fs:t:w:X:" c; do
>  		case "$c" in
>  			f) freeze=yes;;
>  			s) one_scrub_args+=("$OPTARG");;
>  			t) scrub_tgt="$OPTARG";;
>  			w) scrub_delay="$OPTARG";;
> +			X) exerciser="$OPTARG";;
>  			*) return 1; ;;
>  		esac
>  	done
>  
>  	__stress_scrub_check_commands "$scrub_tgt" "${one_scrub_args[@]}"
>  
> +	if ! command -v "__stress_scrub_${exerciser}_loop" &>/dev/null; then
> +		echo "${exerciser}: Unknown fs exercise program."
> +		return 1
> +	fi
> +
>  	local start="$(date +%s)"
>  	local end="$((start + (30 * TIME_FACTOR) ))"
>  	local scrub_startat="$((start + scrub_delay))"
> @@ -555,7 +588,7 @@ _scratch_xfs_stress_scrub() {
>  	echo "Loop started at $(date --date="@${start}")," \
>  		   "ending at $(date --date="@${end}")" >> $seqres.full
>  
> -	__stress_scrub_fsstress_loop "$end" "$runningfile" &
> +	"__stress_scrub_${exerciser}_loop" "$end" "$runningfile" &
>  
>  	if [ -n "$freeze" ]; then
>  		__stress_scrub_freeze_loop "$end" "$runningfile" &
> diff --git a/tests/xfs/847 b/tests/xfs/847
> new file mode 100755
> index 0000000000..856e9a6c26
> --- /dev/null
> +++ b/tests/xfs/847
> @@ -0,0 +1,38 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 847
> +#
> +# Race fsx and xfs_scrub in read-only mode for a while to see if we crash
> +# or livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub

Hi Darrick,

Such huge patchsets :) I'll try to review them one by one (patchset).

Now I'm trying to review "[NYE DELUGE 1/4]", but I can't find the
"dangerous_fsstress_scrub" group in the whole patchsets. Is there any
prepositive patch(set)? Or you'd like to use "dangerous_fsstress_repair"?

P.S: More cases use "dangerous_fsstress_scrub" in your new patchsets.

Thanks,
Zorro

> +
> +_cleanup() {
> +	cd /
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
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
> +_scratch_xfs_stress_scrub -S '-n' -X 'fsx'
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/847.out b/tests/xfs/847.out
> new file mode 100644
> index 0000000000..b7041db159
> --- /dev/null
> +++ b/tests/xfs/847.out
> @@ -0,0 +1,2 @@
> +QA output created by 847
> +Silence is golden
> diff --git a/tests/xfs/848 b/tests/xfs/848
> new file mode 100755
> index 0000000000..ab32020624
> --- /dev/null
> +++ b/tests/xfs/848
> @@ -0,0 +1,38 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 848
> +#
> +# Race fsx and xfs_scrub in force-repair mode for a while to see if we
> +# crash or livelock.
> +#
> +. ./common/preamble
> +_begin_fstest online_repair dangerous_fsstress_repair
> +
> +_cleanup() {
> +	cd /
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
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
> +_require_xfs_stress_online_repair
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_scratch_xfs_stress_online_repair -S '-k' -X 'fsx'
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/848.out b/tests/xfs/848.out
> new file mode 100644
> index 0000000000..23f674045c
> --- /dev/null
> +++ b/tests/xfs/848.out
> @@ -0,0 +1,2 @@
> +QA output created by 848
> +Silence is golden
> 

