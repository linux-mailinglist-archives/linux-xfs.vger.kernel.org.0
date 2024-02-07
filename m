Return-Path: <linux-xfs+bounces-3566-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60FFF84C709
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Feb 2024 10:15:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B830DB22A17
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Feb 2024 09:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BADDC20DCF;
	Wed,  7 Feb 2024 09:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ag4JBg8c"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEE020DCC
	for <linux-xfs@vger.kernel.org>; Wed,  7 Feb 2024 09:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707297316; cv=none; b=Tv6cWuejVJ7DE13ygWJXksGpawvxEe39DX4MyDQMPb41wcNaRUBBHCcJKD4PBWx0dPqiVvmRWiYe2w8McPzFkfG/5lyHuDrWdIFqlkw+YD/5ShcrAIAIFJvUfLE0YH3SQ7hkcOvxvkUTQvuDh+7SomTzrmnU91iVX5E56mwZRls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707297316; c=relaxed/simple;
	bh=iiGDFXBJC3XAZSAh2BozT2NZDaUZVo6heqsvbnK/ZX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GKB5vVTAARkj7OwUzFAYbqKoYPI6g32stpzmEd0yh80RqN+Ikm8yF1jxUInhO5ZvW9gnuPNIGrYUwUctUxH7M/nk9KxBEAUzuSyaXsPOmfD3f/hYuL7tB9F3+j0t8NyKSRq8cvSJM8/fhemTKOnST8eClAC3WFAlEtxuJHfucts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ag4JBg8c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707297312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZwUtlQlcJHDGZfcGJdrALl5b0U0UyNML3i4iNVvkKc0=;
	b=Ag4JBg8cE1WWKuuA2wO5L+QSwr/H42Jz4GE4+vifopmVgZV5kh+lizINBwiVIvsXCPGhmK
	HCM1J3m8cUjxYNl1dpZHPLtuStvr66FQiMRR54T5nGiE9JtWAOeIL4RHxABhMDxzDOiJdh
	GmKOrnyfASga+8cZg9W/ag3UO74e4DE=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-pT3WtCQMM4WnOSXkQD4nig-1; Wed, 07 Feb 2024 04:15:10 -0500
X-MC-Unique: pT3WtCQMM4WnOSXkQD4nig-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1d4a645af79so4928855ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 07 Feb 2024 01:15:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707297310; x=1707902110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZwUtlQlcJHDGZfcGJdrALl5b0U0UyNML3i4iNVvkKc0=;
        b=bZH7bUhFsx4jl5OQX9XCnsS/Of6JI2XIAo4hNm6LzTdRg9WLHblACOd+l9n2cEfKRI
         /V7+0MP3CsOnnzx/EvAkwdmyL+EKp7c+MSRMGGpFUgMt8FCyAsbt+J7dkUDm6In1tVpp
         YWIMg9BKI84Q4ucwLt2vJXFv2bks9oT9xAl1OSu6sHeaKc+2po0obRl+NFQvTLDZ8tKe
         Q3xBlh9cRAq0aQ87L9o4Bjx40OFmor/Eb7TptguSrGMGHxqph593ay0NKHw6YroN36UR
         vcpOmUVg01YKLBoyvJXrANRUqFnHii3wYYAIO/z7t2J9k9AsKAGHrSo0ZUsaee+8hUPG
         g0Ew==
X-Gm-Message-State: AOJu0Yz4g8vDgUIqB81V/tL4k2s8kLUdL29mtYN2NLGteS8C6DGi8m9K
	LuRb8G6tsoManD/qTjzuASjkKsr7tCqUuvjKQmERarNVXltlCmrTL4hSh3HgvOJ1CTgbdbcK9Aa
	pENGRhSkRkanO6ZQBYEMCgweOHfLcaemxAtE0YAKq4zSWyoZZi/mwV9vXkA==
X-Received: by 2002:a17:902:a3c6:b0:1d9:e182:2bf8 with SMTP id q6-20020a170902a3c600b001d9e1822bf8mr3441883plb.6.1707297309680;
        Wed, 07 Feb 2024 01:15:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGzasRkkacG+bsrQHikxdK8dw9uXx2ZdRf5k2dU6ACgot3jvIM9UYWGcmjyyaRc+IBWao5mSg==
X-Received: by 2002:a17:902:a3c6:b0:1d9:e182:2bf8 with SMTP id q6-20020a170902a3c600b001d9e1822bf8mr3441865plb.6.1707297309147;
        Wed, 07 Feb 2024 01:15:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW00V1VftjOiZzL4k1OwblsfTIUPC0EX951DacpggSdUzEP0XeRHe5FOMCTzTbPZ3uxTsr1fWhN/VVo9jpcSf0ErdjPImxQpQ==
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id l18-20020a170902d35200b001d9a42f6183sm948241plk.45.2024.02.07.01.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Feb 2024 01:15:08 -0800 (PST)
Date: Wed, 7 Feb 2024 17:15:05 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 05/10] common: refactor metadump v1 and v2 tests, version
 2
Message-ID: <20240207091505.rpxirtdacyollzeo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <170727231361.3726171.14834727104549554832.stgit@frogsfrogsfrogs>
 <170727234241.3726171.5377809483090058891.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170727234241.3726171.5377809483090058891.stgit@frogsfrogsfrogs>

On Tue, Feb 06, 2024 at 06:19:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Refactor the copy-pasta'd code in xfs/129, xfs/234, xfs/253, xfs/291,
> xfs/432, xfs/503, and xfs/605 so that we don't have to maintain nearly
> duplicate copies of the same code.
> 
> While we're at it, fix the fsck so that it includes xfs_scrub.
> 
> [v2]
> 
> After the first version of this patch was committed to fstests for-next,
> Zorro reported that the cleanup function in common/xfs_metadump_tests
> zapped one of his test machines because of a well known shell variable
> expansion + globbing footgun.  This can trigger when running fstests on
> older configurations where a test adds _cleanup_verify_metadump to the
> local _cleanup function but exits before calling _setup_verify_metadump
> to set XFS_METADUMP_IMG to a non-empty value.
> 
> Redesign the cleanup function to check for non-empty values of
> XFS_METADUMP_{FILE,IMG} before proceeding with the rm.  Change the
> globbed parameter of "rm -f $XFS_METADUMP_IMG*" to a for loop so that if
> the glob does not match any files, the loop variable will be set to a
> path that does not resolve anywhere.
> 
> The for-next branch was reverted to v2024.01.14, hence this patch is
> being resubmitted with the fix inline instead of as a separate fix
> patch.
> 
> Longer term maybe we ought to set -u or something.  Or figure out how to
> make the root directory readonly.
> 
> Reported-by: Zorro Lang <zlang@redhat.com>
> Link: https://lore.kernel.org/fstests/20240205060016.7fgiyafbnrvf5chj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Thanks Darrick, this version looks good to me. I'll make a fstests
release again ASAP, after some testing jobs done.

Thanks,
Zorro

>  common/metadump |  137 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  common/rc       |   10 ----
>  common/xfs      |   14 ++++++
>  tests/xfs/129   |   90 ++----------------------------------
>  tests/xfs/234   |   91 ++-----------------------------------
>  tests/xfs/253   |   89 ++----------------------------------
>  tests/xfs/291   |   31 ++++--------
>  tests/xfs/432   |   30 ++----------
>  tests/xfs/503   |   60 +++---------------------
>  tests/xfs/605   |   84 ++--------------------------------
>  10 files changed, 195 insertions(+), 441 deletions(-)
>  create mode 100644 common/metadump
> 
> 
> diff --git a/common/metadump b/common/metadump
> new file mode 100644
> index 0000000000..4b576f045e
> --- /dev/null
> +++ b/common/metadump
> @@ -0,0 +1,137 @@
> +##/bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2024 Oracle.  All Rights Reserved.
> +#
> +# Filesystem metadata dump testing functions.
> +#
> +
> +# Set up environment variables for a metadump test.  Requires the test and
> +# scratch devices.  Sets XFS_METADUMP_{FILE,IMG} and MAX_XFS_METADUMP_VERSION.
> +_xfs_setup_verify_metadump()
> +{
> +	XFS_METADUMP_FILE="$TEST_DIR/${seq}_metadump"
> +	XFS_METADUMP_IMG="$TEST_DIR/${seq}_image"
> +	MAX_XFS_METADUMP_VERSION="$(_xfs_metadump_max_version)"
> +
> +	rm -f "$XFS_METADUMP_FILE" "$XFS_METADUMP_IMG"*
> +}
> +
> +_xfs_cleanup_verify_metadump()
> +{
> +	local img
> +
> +	_scratch_unmount &>> $seqres.full
> +
> +	test -n "$XFS_METADUMP_FILE" && rm -f "$XFS_METADUMP_FILE"
> +
> +	if [ -n "$XFS_METADUMP_IMG" ]; then
> +		losetup -n -a -O BACK-FILE,NAME | grep "^$XFS_METADUMP_IMG" | while read backing ldev; do
> +			losetup -d "$ldev"
> +		done
> +
> +		# Don't call rm directly with a globbed argument here to avoid
> +		# issues issues with variable expansions.
> +		for img in "$XFS_METADUMP_IMG"*; do
> +			test -e "$img" && rm -f "$img"
> +		done
> +	fi
> +}
> +
> +# Create a metadump in v1 format, restore it to fs image files, then mount the
> +# images and fsck them.
> +_xfs_verify_metadump_v1()
> +{
> +	local metadump_args="$1"
> +	local extra_test="$2"
> +
> +	local metadump_file="$XFS_METADUMP_FILE"
> +	local version=""
> +	local data_img="$XFS_METADUMP_IMG.data"
> +	local data_loop
> +
> +	# Force v1 if we detect v2 support
> +	if [[ $MAX_XFS_METADUMP_FORMAT > 1 ]]; then
> +		version="-v 1"
> +	fi
> +
> +	# Capture metadump, which creates metadump_file
> +	_scratch_xfs_metadump $metadump_file $metadump_args $version
> +
> +	# Restore metadump, which creates data_img
> +	SCRATCH_DEV=$data_img _scratch_xfs_mdrestore $metadump_file
> +
> +	# Create loopdev for data device so we can mount the fs
> +	data_loop=$(_create_loop_device $data_img)
> +
> +	# Mount fs, run an extra test, fsck, and unmount
> +	SCRATCH_DEV=$data_loop _scratch_mount
> +	if [ -n "$extra_test" ]; then
> +		SCRATCH_DEV=$data_loop $extra_test
> +	fi
> +	SCRATCH_DEV=$data_loop _check_xfs_scratch_fs
> +	SCRATCH_DEV=$data_loop _scratch_unmount
> +
> +	# Tear down what we created
> +	_destroy_loop_device $data_loop
> +	rm -f $data_img
> +}
> +
> +# Create a metadump in v2 format, restore it to fs image files, then mount the
> +# images and fsck them.
> +_xfs_verify_metadump_v2()
> +{
> +	local metadump_args="$1"
> +	local extra_test="$2"
> +
> +	local metadump_file="$XFS_METADUMP_FILE"
> +	local version="-v 2"
> +	local data_img="$XFS_METADUMP_IMG.data"
> +	local data_loop
> +	local log_img=""
> +	local log_loop
> +
> +	# Capture metadump, which creates metadump_file
> +	_scratch_xfs_metadump $metadump_file $metadump_args $version
> +
> +	#
> +	# Metadump v2 files can contain contents dumped from an external log
> +	# device. Use a temporary file to hold the log device contents restored
> +	# from such a metadump file.
> +	test -n "$SCRATCH_LOGDEV" && log_img="$XFS_METADUMP_IMG.log"
> +
> +	# Restore metadump, which creates data_img and log_img
> +	SCRATCH_DEV=$data_img SCRATCH_LOGDEV=$log_img \
> +		_scratch_xfs_mdrestore $metadump_file
> +
> +	# Create loopdev for data device so we can mount the fs
> +	data_loop=$(_create_loop_device $data_img)
> +
> +	# Create loopdev for log device if we recovered anything
> +	test -s "$log_img" && log_loop=$(_create_loop_device $log_img)
> +
> +	# Mount fs, run an extra test, fsck, and unmount
> +	SCRATCH_DEV=$data_loop SCRATCH_LOGDEV=$log_loop _scratch_mount
> +	if [ -n "$extra_test" ]; then
> +		SCRATCH_DEV=$data_loop SCRATCH_LOGDEV=$log_loop $extra_test
> +	fi
> +	SCRATCH_DEV=$data_loop SCRATCH_LOGDEV=$log_loop _check_xfs_scratch_fs
> +	SCRATCH_DEV=$data_loop _scratch_unmount
> +
> +	# Tear down what we created
> +	if [ -b "$log_loop" ]; then
> +		_destroy_loop_device $log_loop
> +		rm -f $log_img
> +	fi
> +	_destroy_loop_device $data_loop
> +	rm -f $data_img
> +}
> +
> +# Verify both metadump formats if possible
> +_xfs_verify_metadumps()
> +{
> +	_xfs_verify_metadump_v1 "$@"
> +
> +	if [[ $MAX_XFS_METADUMP_FORMAT == 2 ]]; then
> +		_xfs_verify_metadump_v2 "$@"
> +	fi
> +}
> diff --git a/common/rc b/common/rc
> index 524ffa02aa..0b69f7f54f 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3320,15 +3320,7 @@ _check_scratch_fs()
>  
>      case $FSTYP in
>      xfs)
> -	local scratch_log="none"
> -	local scratch_rt="none"
> -	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> -	    scratch_log="$SCRATCH_LOGDEV"
> -
> -	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
> -	    scratch_rt="$SCRATCH_RTDEV"
> -
> -	_check_xfs_filesystem $device $scratch_log $scratch_rt
> +	_check_xfs_scratch_fs $device
>  	;;
>      udf)
>  	_check_udf_filesystem $device $udf_fsize
> diff --git a/common/xfs b/common/xfs
> index 248ccefda3..6a48960a7f 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1035,6 +1035,20 @@ _check_xfs_test_fs()
>  	return $?
>  }
>  
> +_check_xfs_scratch_fs()
> +{
> +	local device="${1:-$SCRATCH_DEV}"
> +	local scratch_log="none"
> +	local scratch_rt="none"
> +	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> +	    scratch_log="$SCRATCH_LOGDEV"
> +
> +	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
> +	    scratch_rt="$SCRATCH_RTDEV"
> +
> +	_check_xfs_filesystem $device $scratch_log $scratch_rt
> +}
> +
>  # modeled after _scratch_xfs_repair
>  _test_xfs_repair()
>  {
> diff --git a/tests/xfs/129 b/tests/xfs/129
> index cdac2349df..ec1a2ff3da 100755
> --- a/tests/xfs/129
> +++ b/tests/xfs/129
> @@ -16,98 +16,23 @@ _cleanup()
>  {
>      cd /
>      _scratch_unmount > /dev/null 2>&1
> -    [[ -n $logdev && $logdev != "none" && $logdev != $SCRATCH_LOGDEV ]] && \
> -	    _destroy_loop_device $logdev
> -    [[ -n $datadev ]] && _destroy_loop_device $datadev
> -    rm -rf $tmp.* $testdir $metadump_file $TEST_DIR/data-image \
> -       $TEST_DIR/log-image
> +    _xfs_cleanup_verify_metadump
> +    rm -rf $tmp.* $testdir
>  }
>  
>  # Import common functions.
>  . ./common/filter
>  . ./common/reflink
> +. ./common/metadump
>  
>  # real QA test starts here
>  _supported_fs xfs
>  _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
>  _require_loop
>  _require_scratch_reflink
> -
> -metadump_file=$TEST_DIR/${seq}_metadump
> -
> -verify_metadump_v1()
> -{
> -	local max_version=$1
> -	local version=""
> -
> -	if [[ $max_version == 2 ]]; then
> -		version="-v 1"
> -	fi
> -
> -	_scratch_xfs_metadump $metadump_file $version
> -
> -	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV="" \
> -		   _scratch_xfs_mdrestore $metadump_file
> -
> -	datadev=$(_create_loop_device $TEST_DIR/data-image)
> -
> -	SCRATCH_DEV=$datadev _scratch_mount
> -	SCRATCH_DEV=$datadev _scratch_unmount
> -
> -	logdev=$SCRATCH_LOGDEV
> -	[[ -z $logdev ]] && logdev=none
> -	_check_xfs_filesystem $datadev $logdev none
> -
> -	_destroy_loop_device $datadev
> -	datadev=""
> -	rm -f $TEST_DIR/data-image
> -}
> -
> -verify_metadump_v2()
> -{
> -	version="-v 2"
> -
> -	_scratch_xfs_metadump $metadump_file $version
> -
> -	# Metadump v2 files can contain contents dumped from an external log
> -	# device. Use a temporary file to hold the log device contents restored
> -	# from such a metadump file.
> -	slogdev=""
> -	if [[ -n $SCRATCH_LOGDEV ]]; then
> -		slogdev=$TEST_DIR/log-image
> -	fi
> -
> -	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV=$slogdev \
> -		   _scratch_xfs_mdrestore $metadump_file
> -
> -	datadev=$(_create_loop_device $TEST_DIR/data-image)
> -
> -	logdev=${SCRATCH_LOGDEV}
> -	if [[ -s $TEST_DIR/log-image ]]; then
> -		logdev=$(_create_loop_device $TEST_DIR/log-image)
> -	fi
> -
> -	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_mount
> -	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_unmount
> -
> -	[[ -z $logdev ]] && logdev=none
> -	_check_xfs_filesystem $datadev $logdev none
> -
> -	if [[ -s $TEST_DIR/log-image ]]; then
> -		_destroy_loop_device $logdev
> -		logdev=""
> -		rm -f $TEST_DIR/log-image
> -	fi
> -
> -	_destroy_loop_device $datadev
> -	datadev=""
> -	rm -f $TEST_DIR/data-image
> -}
> +_xfs_setup_verify_metadump
>  
>  _scratch_mkfs >/dev/null 2>&1
> -
> -max_md_version=$(_xfs_metadump_max_version)
> -
>  _scratch_mount
>  
>  testdir=$SCRATCH_MNT/test-$seq
> @@ -127,12 +52,7 @@ done
>  _scratch_unmount
>  
>  echo "Create metadump file, restore it and check restored fs"
> -
> -verify_metadump_v1 $max_md_version
> -
> -if [[ $max_md_version == 2 ]]; then
> -	verify_metadump_v2
> -fi
> +_xfs_verify_metadumps
>  
>  # success, all done
>  status=0
> diff --git a/tests/xfs/234 b/tests/xfs/234
> index f4f8af6d3a..6fdea42d21 100755
> --- a/tests/xfs/234
> +++ b/tests/xfs/234
> @@ -15,16 +15,13 @@ _begin_fstest auto quick rmap punch metadump
>  _cleanup()
>  {
>      cd /
> -    _scratch_unmount > /dev/null 2>&1
> -    [[ -n $logdev && $logdev != "none" && $logdev != $SCRATCH_LOGDEV ]] && \
> -	    _destroy_loop_device $logdev
> -    [[ -n $datadev ]] && _destroy_loop_device $datadev
> -    rm -rf $tmp.* $testdir $metadump_file $TEST_DIR/image \
> -       $TEST_DIR/log-image
> +    _xfs_cleanup_verify_metadump
> +    rm -rf $tmp.* $testdir
>  }
>  
>  # Import common functions.
>  . ./common/filter
> +. ./common/metadump
>  
>  # real QA test starts here
>  _supported_fs xfs
> @@ -32,82 +29,9 @@ _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
>  _require_loop
>  _require_xfs_scratch_rmapbt
>  _require_xfs_io_command "fpunch"
> -
> -metadump_file=$TEST_DIR/${seq}_metadump
> -
> -verify_metadump_v1()
> -{
> -	local max_version=$1
> -	local version=""
> -
> -	if [[ $max_version == 2 ]]; then
> -		version="-v 1"
> -	fi
> -
> -	_scratch_xfs_metadump $metadump_file $version
> -
> -	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV="" \
> -		   _scratch_xfs_mdrestore $metadump_file
> -
> -	datadev=$(_create_loop_device $TEST_DIR/data-image)
> -
> -	SCRATCH_DEV=$datadev _scratch_mount
> -	SCRATCH_DEV=$datadev _scratch_unmount
> -
> -	logdev=$SCRATCH_LOGDEV
> -	[[ -z $logdev ]] && logdev=none
> -	_check_xfs_filesystem $datadev $logdev none
> -
> -	_destroy_loop_device $datadev
> -	datadev=""
> -	rm -f $TEST_DIR/data-image
> -}
> -
> -verify_metadump_v2()
> -{
> -	version="-v 2"
> -
> -	_scratch_xfs_metadump $metadump_file $version
> -
> -	# Metadump v2 files can contain contents dumped from an external log
> -	# device. Use a temporary file to hold the log device contents restored
> -	# from such a metadump file.
> -	slogdev=""
> -	if [[ -n $SCRATCH_LOGDEV ]]; then
> -		slogdev=$TEST_DIR/log-image
> -	fi
> -
> -	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV=$slogdev \
> -		   _scratch_xfs_mdrestore $metadump_file
> -
> -	datadev=$(_create_loop_device $TEST_DIR/data-image)
> -
> -	logdev=${SCRATCH_LOGDEV}
> -	if [[ -s $TEST_DIR/log-image ]]; then
> -		logdev=$(_create_loop_device $TEST_DIR/log-image)
> -	fi
> -
> -	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_mount
> -	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_unmount
> -
> -	[[ -z $logdev ]] && logdev=none
> -	_check_xfs_filesystem $datadev $logdev none
> -
> -	if [[ -s $TEST_DIR/log-image ]]; then
> -		_destroy_loop_device $logdev
> -		logdev=""
> -		rm -f $TEST_DIR/log-image
> -	fi
> -
> -	_destroy_loop_device $datadev
> -	datadev=""
> -	rm -f $TEST_DIR/data-image
> -}
> +_xfs_setup_verify_metadump
>  
>  _scratch_mkfs >/dev/null 2>&1
> -
> -max_md_version=$(_xfs_metadump_max_version)
> -
>  _scratch_mount
>  
>  testdir=$SCRATCH_MNT/test-$seq
> @@ -127,12 +51,7 @@ done
>  _scratch_unmount
>  
>  echo "Create metadump file, restore it and check restored fs"
> -
> -verify_metadump_v1 $max_md_version
> -
> -if [[ $max_md_version == 2 ]]; then
> -	verify_metadump_v2
> -fi
> +_xfs_verify_metadumps
>  
>  # success, all done
>  status=0
> diff --git a/tests/xfs/253 b/tests/xfs/253
> index 3b567999d8..18c58eb8d5 100755
> --- a/tests/xfs/253
> +++ b/tests/xfs/253
> @@ -26,23 +26,21 @@ _cleanup()
>      cd /
>      rm -f $tmp.*
>      rm -rf "${OUTPUT_DIR}"
> -    rm -f "${METADUMP_FILE}"
> -    [[ -n $logdev && $logdev != $SCRATCH_LOGDEV ]] && \
> -	    _destroy_loop_device $logdev
> -    [[ -n $datadev ]] && _destroy_loop_device $datadev
> +    _xfs_cleanup_verify_metadump
>  }
>  
>  # Import common functions.
>  . ./common/filter
> +. ./common/metadump
>  
>  _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
>  _require_test
>  _require_scratch
> +_xfs_setup_verify_metadump
>  
>  # real QA test starts here
>  
>  OUTPUT_DIR="${SCRATCH_MNT}/test_${seq}"
> -METADUMP_FILE="${TEST_DIR}/${seq}_metadump"
>  ORPHANAGE="lost+found"
>  
>  _supported_fs xfs
> @@ -52,24 +50,7 @@ function create_file() {
>  	touch $(printf "$@")
>  }
>  
> -verify_metadump_v1()
> -{
> -	local max_version=$1
> -	local version=""
> -
> -	if [[ $max_version == 2 ]]; then
> -		version="-v 1"
> -	fi
> -
> -	_scratch_xfs_metadump $METADUMP_FILE $version
> -
> -	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV="" \
> -		   _scratch_xfs_mdrestore $METADUMP_FILE
> -
> -	datadev=$(_create_loop_device $TEST_DIR/data-image)
> -
> -	SCRATCH_DEV=$datadev _scratch_mount
> -
> +extra_test() {
>  	cd "${SCRATCH_MNT}"
>  
>  	# Get a listing of all the files after obfuscation
> @@ -78,60 +59,6 @@ verify_metadump_v1()
>  	ls -R | od -c >> $seqres.full
>  
>  	cd /
> -
> -	SCRATCH_DEV=$datadev _scratch_unmount
> -
> -	_destroy_loop_device $datadev
> -	datadev=""
> -	rm -f $TEST_DIR/data-image
> -}
> -
> -verify_metadump_v2()
> -{
> -	version="-v 2"
> -
> -	_scratch_xfs_metadump $METADUMP_FILE $version
> -
> -	# Metadump v2 files can contain contents dumped from an external log
> -	# device. Use a temporary file to hold the log device contents restored
> -	# from such a metadump file.
> -	slogdev=""
> -	if [[ -n $SCRATCH_LOGDEV ]]; then
> -		slogdev=$TEST_DIR/log-image
> -	fi
> -
> -	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV=$slogdev \
> -		   _scratch_xfs_mdrestore $METADUMP_FILE
> -
> -	datadev=$(_create_loop_device $TEST_DIR/data-image)
> -
> -	logdev=${SCRATCH_LOGDEV}
> -	if [[ -s $TEST_DIR/log-image ]]; then
> -		logdev=$(_create_loop_device $TEST_DIR/log-image)
> -	fi
> -
> -	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_mount
> -
> -	cd "${SCRATCH_MNT}"
> -
> -	# Get a listing of all the files after obfuscation
> -	echo "Metadump v2" >> $seqres.full
> -	ls -R >> $seqres.full
> -	ls -R | od -c >> $seqres.full
> -
> -	cd /
> -
> -	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_unmount
> -
> -	if [[ -s $TEST_DIR/log-image ]]; then
> -		_destroy_loop_device $logdev
> -		logdev=""
> -		rm -f $TEST_DIR/log-image
> -	fi
> -
> -	_destroy_loop_device $datadev
> -	datadev=""
> -	rm -f $TEST_DIR/data-image
>  }
>  
>  echo "Disciplyne of silence is goed."
> @@ -233,13 +160,7 @@ cd $here
>  
>  _scratch_unmount
>  
> -max_md_version=$(_xfs_metadump_max_version)
> -
> -verify_metadump_v1 $max_md_version
> -
> -if [[ $max_md_version == 2 ]]; then
> -	verify_metadump_v2
> -fi
> +_xfs_verify_metadumps '' extra_test
>  
>  # Finally, re-make the filesystem since to ensure we don't
>  # leave a directory with duplicate entries lying around.
> diff --git a/tests/xfs/291 b/tests/xfs/291
> index 1433140821..2bd94d7b9b 100755
> --- a/tests/xfs/291
> +++ b/tests/xfs/291
> @@ -9,11 +9,21 @@
>  . ./common/preamble
>  _begin_fstest auto repair metadump
>  
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +	_xfs_cleanup_verify_metadump
> +}
> +
>  # Import common functions.
>  . ./common/filter
> +. ./common/metadump
>  
>  _supported_fs xfs
>  _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
> +_xfs_setup_verify_metadump
>  
>  # real QA test starts here
>  _require_scratch
> @@ -92,26 +102,7 @@ _scratch_xfs_check >> $seqres.full 2>&1 || _fail "xfs_check failed"
>  
>  # Yes they can!  Now...
>  # Can xfs_metadump cope with this monster?
> -max_md_version=$(_xfs_metadump_max_version)
> -
> -for md_version in $(seq 1 $max_md_version); do
> -	version=""
> -	if [[ $max_md_version == 2 ]]; then
> -		version="-v $md_version"
> -	fi
> -
> -	_scratch_xfs_metadump $tmp.metadump -a -o $version || \
> -		_fail "xfs_metadump failed"
> -
> -	slogdev=$SCRATCH_LOGDEV
> -	if [[ -z $version || $version == "-v 1" ]]; then
> -		slogdev=""
> -	fi
> -	SCRATCH_DEV=$tmp.img SCRATCH_LOGDEV=$slogdev _scratch_xfs_mdrestore \
> -		   $tmp.metadump || _fail "xfs_mdrestore failed"
> -	SCRATCH_DEV=$tmp.img _scratch_xfs_repair -f &>> $seqres.full || \
> -		_fail "xfs_repair of metadump failed"
> -done
> +_xfs_verify_metadumps '-a -o'
>  
>  # Yes it can; success, all done
>  status=0
> diff --git a/tests/xfs/432 b/tests/xfs/432
> index 7e402aa88f..4eae92e75b 100755
> --- a/tests/xfs/432
> +++ b/tests/xfs/432
> @@ -20,16 +20,19 @@ _begin_fstest auto quick dir metadata metadump
>  _cleanup()
>  {
>  	cd /
> -	rm -f "$tmp".* $metadump_file $metadump_img
> +	rm -f "$tmp".*
> +	_xfs_cleanup_verify_metadump
>  }
>  
>  # Import common functions.
>  . ./common/filter
> +. ./common/metadump
>  
>  # real QA test starts here
>  _supported_fs xfs
>  _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
>  _require_scratch
> +_xfs_setup_verify_metadump
>  
>  rm -f "$seqres.full"
>  
> @@ -54,9 +57,6 @@ echo "Format and mount"
>  _scratch_mkfs -b size=1k -n size=64k > "$seqres.full" 2>&1
>  _scratch_mount >> "$seqres.full" 2>&1
>  
> -metadump_file="$TEST_DIR/meta-$seq"
> -metadump_img="$TEST_DIR/img-$seq"
> -rm -f $metadump_file $metadump_img
>  testdir="$SCRATCH_MNT/test-$seq"
>  max_fname_len=255
>  blksz=$(_get_block_size $SCRATCH_MNT)
> @@ -87,27 +87,7 @@ echo "qualifying extent: $extlen blocks" >> $seqres.full
>  test -n "$extlen" || _notrun "could not create dir extent > 1000 blocks"
>  
>  echo "Try to metadump, restore and check restored metadump image"
> -max_md_version=$(_xfs_metadump_max_version)
> -
> -for md_version in $(seq 1 $max_md_version); do
> -	version=""
> -	if [[ $max_md_version == 2 ]]; then
> -		version="-v $md_version"
> -	fi
> -
> -	_scratch_xfs_metadump $metadump_file -a -o -w $version
> -
> -	slogdev=$SCRATCH_LOGDEV
> -	if [[ -z $version || $version == "-v 1" ]]; then
> -		slogdev=""
> -	fi
> -
> -	SCRATCH_DEV=$metadump_img SCRATCH_LOGDEV=$slogdev \
> -		   _scratch_xfs_mdrestore $metadump_file
> -
> -	SCRATCH_DEV=$metadump_img _scratch_xfs_repair -n &>> $seqres.full || \
> -		echo "xfs_repair on restored fs returned $?"
> -done
> +_xfs_verify_metadumps '-a -o -w'
>  
>  # success, all done
>  status=0
> diff --git a/tests/xfs/503 b/tests/xfs/503
> index 8643c3d483..854cc74bbe 100755
> --- a/tests/xfs/503
> +++ b/tests/xfs/503
> @@ -17,11 +17,13 @@ _cleanup()
>  {
>  	cd /
>  	rm -rf $tmp.* $testdir
> +	_xfs_cleanup_verify_metadump
>  }
>  
>  # Import common functions.
>  . ./common/filter
>  . ./common/populate
> +. ./common/metadump
>  
>  testdir=$TEST_DIR/test-$seq
>  
> @@ -35,6 +37,7 @@ _require_scratch_nocheck
>  _require_populate_commands
>  _xfs_skip_online_rebuild
>  _xfs_skip_offline_rebuild
> +_xfs_setup_verify_metadump
>  
>  echo "Format and populate"
>  _scratch_populate_cached nofill > $seqres.full 2>&1
> @@ -43,66 +46,17 @@ mkdir -p $testdir
>  metadump_file=$testdir/scratch.md
>  copy_file=$testdir/copy.img
>  
> -check_restored_metadump_image()
> -{
> -	local image=$1
> -
> -	loop_dev=$(_create_loop_device $image)
> -	SCRATCH_DEV=$loop_dev _scratch_mount
> -	SCRATCH_DEV=$loop_dev _check_scratch_fs
> -	SCRATCH_DEV=$loop_dev _scratch_unmount
> -	_destroy_loop_device $loop_dev
> -}
> -
> -max_md_version=$(_xfs_metadump_max_version)
> -
>  echo "metadump and mdrestore"
> -for md_version in $(seq 1 $max_md_version); do
> -	version=""
> -	if [[ $max_md_version == 2 ]]; then
> -		version="-v $md_version"
> -	fi
> -
> -	_scratch_xfs_metadump $metadump_file -a -o $version >> $seqres.full
> -	SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
> -	check_restored_metadump_image $TEST_DIR/image
> -done
> +_xfs_verify_metadumps '-a -o'
>  
>  echo "metadump a and mdrestore"
> -for md_version in $(seq 1 $max_md_version); do
> -	version=""
> -	if [[ $max_md_version == 2 ]]; then
> -		version="-v $md_version"
> -	fi
> -
> -	_scratch_xfs_metadump $metadump_file -a $version >> $seqres.full
> -	SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
> -	check_restored_metadump_image $TEST_DIR/image
> -done
> +_xfs_verify_metadumps '-a'
>  
>  echo "metadump g and mdrestore"
> -for md_version in $(seq 1 $max_md_version); do
> -	version=""
> -	if [[ $max_md_version == 2 ]]; then
> -		version="-v $md_version"
> -	fi
> -
> -	_scratch_xfs_metadump $metadump_file -g $version >> $seqres.full
> -	SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
> -	check_restored_metadump_image $TEST_DIR/image
> -done
> +_xfs_verify_metadumps '-g' >> $seqres.full
>  
>  echo "metadump ag and mdrestore"
> -for md_version in $(seq 1 $max_md_version); do
> -	version=""
> -	if [[ $max_md_version == 2 ]]; then
> -		version="-v $md_version"
> -	fi
> -
> -	_scratch_xfs_metadump $metadump_file -a -g $version >> $seqres.full
> -	SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
> -	check_restored_metadump_image $TEST_DIR/image
> -done
> +_xfs_verify_metadumps '-a -g' >> $seqres.full
>  
>  echo copy
>  $XFS_COPY_PROG $SCRATCH_DEV $copy_file >> $seqres.full
> diff --git a/tests/xfs/605 b/tests/xfs/605
> index f2cd7aba98..13cf065495 100755
> --- a/tests/xfs/605
> +++ b/tests/xfs/605
> @@ -15,17 +15,13 @@ _cleanup()
>  {
>  	cd /
>  	rm -r -f $tmp.*
> -	_scratch_unmount > /dev/null 2>&1
> -	[[ -n $logdev && $logdev != "none" && $logdev != $SCRATCH_LOGDEV ]] && \
> -		_destroy_loop_device $logdev
> -	[[ -n $datadev ]] && _destroy_loop_device $datadev
> -	rm -r -f $metadump_file $TEST_DIR/data-image \
> -	   $TEST_DIR/log-image
> +	_xfs_cleanup_verify_metadump
>  }
>  
>  # Import common functions.
>  . ./common/dmflakey
>  . ./common/inject
> +. ./common/metadump
>  
>  # real QA test starts here
>  _supported_fs xfs
> @@ -37,85 +33,22 @@ _require_xfs_io_error_injection log_item_pin
>  _require_dm_target flakey
>  _require_xfs_io_command "pwrite"
>  _require_test_program "punch-alternating"
> +_xfs_setup_verify_metadump
>  
> -metadump_file=${TEST_DIR}/${seq}.md
>  testfile=${SCRATCH_MNT}/testfile
>  
>  echo "Format filesystem on scratch device"
>  _scratch_mkfs >> $seqres.full 2>&1
>  
> -max_md_version=$(_xfs_metadump_max_version)
> -
>  external_log=0
>  if [[ $USE_EXTERNAL = yes && -n "$SCRATCH_LOGDEV" ]]; then
>  	external_log=1
>  fi
>  
> -if [[ $max_md_version == 1 && $external_log == 1 ]]; then
> +if [[ $MAX_XFS_METADUMP_FORMAT == 1 && $external_log == 1 ]]; then
>  	_notrun "metadump v1 does not support external log device"
>  fi
>  
> -verify_metadump_v1()
> -{
> -	local version=""
> -	if [[ $max_md_version == 2 ]]; then
> -		version="-v 1"
> -	fi
> -
> -	_scratch_xfs_metadump $metadump_file -a -o $version
> -
> -	SCRATCH_DEV=$TEST_DIR/data-image _scratch_xfs_mdrestore $metadump_file
> -
> -	datadev=$(_create_loop_device $TEST_DIR/data-image)
> -
> -	SCRATCH_DEV=$datadev _scratch_mount
> -	SCRATCH_DEV=$datadev _check_scratch_fs
> -	SCRATCH_DEV=$datadev _scratch_unmount
> -
> -	_destroy_loop_device $datadev
> -	datadev=""
> -	rm -f $TEST_DIR/data-image
> -}
> -
> -verify_metadump_v2()
> -{
> -	local version="-v 2"
> -
> -	_scratch_xfs_metadump $metadump_file -a -o $version
> -
> -	# Metadump v2 files can contain contents dumped from an external log
> -	# device. Use a temporary file to hold the log device contents restored
> -	# from such a metadump file.
> -	slogdev=""
> -	if [[ -n $SCRATCH_LOGDEV ]]; then
> -		slogdev=$TEST_DIR/log-image
> -	fi
> -
> -	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV=$slogdev \
> -		   _scratch_xfs_mdrestore $metadump_file
> -
> -	datadev=$(_create_loop_device $TEST_DIR/data-image)
> -
> -	logdev=""
> -	if [[ -s $slogdev ]]; then
> -		logdev=$(_create_loop_device $slogdev)
> -	fi
> -
> -	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_mount
> -	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _check_scratch_fs
> -	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_unmount
> -
> -	if [[ -s $logdev ]]; then
> -		_destroy_loop_device $logdev
> -		logdev=""
> -		rm -f $slogdev
> -	fi
> -
> -	_destroy_loop_device $datadev
> -	datadev=""
> -	rm -f $TEST_DIR/data-image
> -}
> -
>  echo "Initialize and mount filesystem on flakey device"
>  _init_flakey
>  _load_flakey_table $FLAKEY_ALLOW_WRITES
> @@ -160,14 +93,7 @@ echo -n "Filesystem has a "
>  _print_logstate
>  
>  echo "Create metadump file, restore it and check restored fs"
> -
> -if [[ $external_log == 0 ]]; then
> -	verify_metadump_v1 $max_md_version
> -fi
> -
> -if [[ $max_md_version == 2 ]]; then
> -	verify_metadump_v2
> -fi
> +_xfs_verify_metadumps '-a -o'
>  
>  # Mount the fs to replay the contents from the dirty log.
>  _scratch_mount
> 
> 


