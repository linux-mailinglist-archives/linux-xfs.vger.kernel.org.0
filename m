Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9184D695BB7
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Feb 2023 09:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjBNIBh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Feb 2023 03:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbjBNIBV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 03:01:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34092278F
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2023 00:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676361614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BgMue5w2JVSiPn5I5OoXQEIIrJbaZshclf45BstvmDM=;
        b=HwbB0ps94XD0Xi9J9PoFXy9ogNjHIlS2WKeCoUqZZ7ANfGuTVdBCFrZG/TVptqGjZJRwOQ
        HIAOvyYO5z+Gb1iLXmsIjQogOB85rYXtwZeFArzmgS+jBFerOsvzCLXxBf8bmH7sUy87OH
        NfAH6fmBXma4Oti1YvyI3El8BRGgx74=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-167-1zjLQ6JqNHWLf9IERs92oA-1; Tue, 14 Feb 2023 03:00:13 -0500
X-MC-Unique: 1zjLQ6JqNHWLf9IERs92oA-1
Received: by mail-pf1-f200.google.com with SMTP id u18-20020a62ed12000000b00593cc641da4so7496554pfh.0
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2023 00:00:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BgMue5w2JVSiPn5I5OoXQEIIrJbaZshclf45BstvmDM=;
        b=zNhJZ4eF82MLnRvDxLQbyJNeXzTrcStczPOcY9xydDD3f5uNbarGEksJ9nm1bvCR7v
         JrDVavAtYxv4banx0xueevEjAntGNuDWqRRxR28LxDwpyoLG+UEvy5F7gIL54Ed/jinK
         rx3TJC1HM/lxZ4ZzbFY/DLdnA58DMKDxTE99C76Yl4077Nsapec55zJR9B1COFMx0+DL
         psuZ45TIzrJzxcNdEUiWwcvmGI0gzkEZrLZHG9Yf2nVcrrA5vBO8rav0OvDOEGqujDAt
         XaWGW2S9DnkcQPiSQ7VjstKb2+SgF2icedafB+TjZ5M5Q84NrOezj6/RuHFFR9fkGGSF
         ruYQ==
X-Gm-Message-State: AO0yUKV+crgewP0EEH8VT0kv1AhAR1VwXTfTYg4CjVksuMxcXPIkc5dy
        7LtBx34mBizzi/wrEZQAMbFHtAWQZTrA23PPZzhImwtGVCJArZ20EDP/3xAuJ7xPIe6hgv0qzsd
        7r7u6GoW2tl965vdEoeHXPYyzA27nw3k=
X-Received: by 2002:a17:90b:4d91:b0:233:f354:e7f6 with SMTP id oj17-20020a17090b4d9100b00233f354e7f6mr1338143pjb.46.1676361612239;
        Tue, 14 Feb 2023 00:00:12 -0800 (PST)
X-Google-Smtp-Source: AK7set/OiLgAlO0CU4FnmTlAHb/aGKd7gOqEeQReYo8YxH7F4/Is3a0ZIJvZir+rw28SM9AuSCa+OA==
X-Received: by 2002:a17:90b:4d91:b0:233:f354:e7f6 with SMTP id oj17-20020a17090b4d9100b00233f354e7f6mr1338119pjb.46.1676361611837;
        Tue, 14 Feb 2023 00:00:11 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d3-20020a17090a3b0300b002340b73ded1sm2437899pjc.26.2023.02.14.00.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 00:00:11 -0800 (PST)
Date:   Tue, 14 Feb 2023 16:00:07 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] fuzzy: use FORCE_REBUILD over injecting force_repair
Message-ID: <20230214080007.i7m5hzlcmthd6ka3@zlang-mailbox>
References: <167243874952.722591.1496636246267309523.stgit@magnolia>
 <167243874964.722591.9199494099572054329.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167243874964.722591.9199494099572054329.stgit@magnolia>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 30, 2022 at 02:19:09PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> For stress testing online repair, try to use the FORCE_REBUILD ioctl
> flag over the error injection knobs whenever possible because the knobs
> are very noisy and are not always available.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/fuzzy |   34 +++++++++++++++++++++++++++++++---
>  1 file changed, 31 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/common/fuzzy b/common/fuzzy
> index f7f660bc31..14f7fdf03c 100644
> --- a/common/fuzzy
> +++ b/common/fuzzy
> @@ -398,6 +398,9 @@ __stress_one_scrub_loop() {
>  
>  	local xfs_io_args=()
>  	for arg in "$@"; do
> +		if [ -n "$SCRUBSTRESS_USE_FORCE_REBUILD" ]; then
> +			arg="$(echo "$arg" | sed -e 's/^repair/repair -R/g')"
> +		fi
>  		if echo "$arg" | grep -q -w '%agno%'; then
>  			# Substitute the AG number
>  			for ((agno = 0; agno < agcount; agno++)); do
> @@ -695,13 +698,21 @@ _require_xfs_stress_scrub() {
>  		_notrun 'xfs scrub stress test requires common/filter'
>  }
>  
> +# Make sure that we can force repairs either by error injection or passing
> +# FORCE_REBUILD via ioctl.
> +__require_xfs_stress_force_rebuild() {
> +	local output="$($XFS_IO_PROG -x -c 'repair -R probe' $SCRATCH_MNT 2>&1)"
> +	test -z "$output" && return
> +	_require_xfs_io_error_injection "force_repair"
> +}
> +
>  # Make sure we have everything we need to run stress and online repair
>  _require_xfs_stress_online_repair() {
>  	_require_xfs_stress_scrub
>  	_require_xfs_io_command "repair"
>  	command -v _require_xfs_io_error_injection &>/dev/null || \
>  		_notrun 'xfs repair stress test requires common/inject'
> -	_require_xfs_io_error_injection "force_repair"
> +	__require_xfs_stress_force_rebuild
>  	_require_freeze
>  }
>  
> @@ -783,7 +794,11 @@ __stress_scrub_check_commands() {
>  	esac
>  
>  	for arg in "$@"; do
> -		local cooked_arg="$(echo "$arg" | sed -e "s/%agno%/0/g")"
> +		local cooked_arg="$arg"
> +		if [ -n "$SCRUBSTRESS_USE_FORCE_REBUILD" ]; then
> +			cooked_arg="$(echo "$cooked_arg" | sed -e 's/^repair/repair -R/g')"
> +		fi
> +		cooked_arg="$(echo "$cooked_arg" | sed -e "s/%agno%/0/g")"
>  		testio=`$XFS_IO_PROG -x -c "$cooked_arg" "$cooked_tgt" 2>&1`
>  		echo $testio | grep -q "Unknown type" && \
>  			_notrun "xfs_io scrub subcommand support is missing"
> @@ -943,10 +958,23 @@ _scratch_xfs_stress_scrub() {
>  	echo "Loop finished at $(date)" >> $seqres.full
>  }
>  
> +# Decide if we're going to force repairs either by error injection or passing
> +# FORCE_REBUILD via ioctl.
> +__scratch_xfs_stress_setup_force_rebuild() {
> +	local output="$($XFS_IO_PROG -x -c 'repair -R probe' $SCRATCH_MNT 2>&1)"
> +
> +	if [ -z "$output" ]; then
> +		export SCRUBSTRESS_USE_FORCE_REBUILD=1

Do you need to use this parameter ^^ in another child process? Is the "export"
necessary?

Thanks,
Zorro

> +		return
> +	fi
> +
> +	$XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
> +}
> +
>  # Start online repair, freeze, and fsstress in background looping processes,
>  # and wait for 30*TIME_FACTOR seconds to see if the filesystem goes down.
>  # Same requirements and arguments as _scratch_xfs_stress_scrub.
>  _scratch_xfs_stress_online_repair() {
> -	$XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
> +	__scratch_xfs_stress_setup_force_rebuild
>  	XFS_SCRUB_FORCE_REPAIR=1 _scratch_xfs_stress_scrub "$@"
>  }
> 

