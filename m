Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C89B614F9E
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Nov 2022 17:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiKAQpC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Nov 2022 12:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiKAQpA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2022 12:45:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932321D0D0
        for <linux-xfs@vger.kernel.org>; Tue,  1 Nov 2022 09:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667321033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/P8rPpz6FvoZhE0ACX0EGWVDE2xn0XTE+Q+4ICCtd6c=;
        b=VtofvQh7OBhsh1SCtm8aROJqLUs8I8H5eSlH4f/I64bkV5qzCzdsED1Q1Uqh4JXqjF/Nsn
        6fZr5E3nbQV81VoMSrQVUNEn92H/eZXMLLTVQq7t/L01TzVvQ3TSEXANst1rP0zX9IhHez
        4q4IKZOBiGL1slL/UV4ykbN/IDWZKiY=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-473-2Fj8VxE3P-GS1fHS8Dvphg-1; Tue, 01 Nov 2022 12:43:52 -0400
X-MC-Unique: 2Fj8VxE3P-GS1fHS8Dvphg-1
Received: by mail-pf1-f199.google.com with SMTP id cw4-20020a056a00450400b00561ec04e77aso7647336pfb.12
        for <linux-xfs@vger.kernel.org>; Tue, 01 Nov 2022 09:43:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/P8rPpz6FvoZhE0ACX0EGWVDE2xn0XTE+Q+4ICCtd6c=;
        b=aScKQ0xnj0No05N9N0iC56/tqBsNil+BoVXyImRHVh68Bu8nVi8EUnm87Emp1lJPfs
         ey46yQAJ35sz1MwwMik+x/yNO+LrsqZEsKB8rMZW8CB/xNyVPtDfRF+PmoDdBUq0AAyu
         YS04ANsPfxcYvTaiv1kpE03I+ncIm/J5P6W5dazLIGUeOKM7r6BlRaG2Bm3qrmOuIK7V
         q1C2hRb6BUjr9g2Onwu/7fSeI3OSV7rUXzUf1YVudKQH4zYuHz+e79C4KZE8s8x7Tzi7
         pr2YE6n+C2t+9tdiZ6jGxsATIBK/JcWF2XHK3oJVzlGF81y5mSojv2c9IdiFGMrEelYW
         PHZA==
X-Gm-Message-State: ACrzQf3mloNQYoWD0f9zUSlMbbvOPMq42cAs4ST5vhaHOb5e4rmnXgea
        t9MDsWVUA1RHhyWeo/x6OBsSvAH4TIMSPvOsTjsjEdZbjAFsc2YIUXsaJlLdp/qzjzsVrV0b16U
        Lhaytf7qFL4q1fYshHOZD
X-Received: by 2002:a17:903:22c6:b0:187:1d13:c5f3 with SMTP id y6-20020a17090322c600b001871d13c5f3mr12721723plg.66.1667321031001;
        Tue, 01 Nov 2022 09:43:51 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6T2sYz8nXiIvCV0G/3vzrLm1Adwezl/+oa0lmFEmvrtRQMjgBxl7TwgjV/Q3dZjAtFA2OfMw==
X-Received: by 2002:a17:903:22c6:b0:187:1d13:c5f3 with SMTP id y6-20020a17090322c600b001871d13c5f3mr12721686plg.66.1667321030503;
        Tue, 01 Nov 2022 09:43:50 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u89-20020a17090a51e200b0020a28156e11sm6166433pjh.26.2022.11.01.09.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 09:43:49 -0700 (PDT)
Date:   Wed, 2 Nov 2022 00:43:45 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test xfs_scrub phase 6 media error reporting
Message-ID: <20221101164345.uirkzgnakgikw2zm@zlang-mailbox>
References: <166613311327.868072.4009665862280713748.stgit@magnolia>
 <166613311880.868072.17189668251232287066.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166613311880.868072.17189668251232287066.stgit@magnolia>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 18, 2022 at 03:45:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add new helpers to dmerror to provide for marking selected ranges
> totally bad -- both reads and writes will fail.  Create a new test for
> xfs_scrub to check that it reports media errors in data files correctly.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/dmerror    |  136 +++++++++++++++++++++++++++++++++++++++++++++--
>  common/xfs        |    9 +++
>  tests/xfs/747     |  155 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/747.out |   12 ++++
>  4 files changed, 309 insertions(+), 3 deletions(-)
>  create mode 100755 tests/xfs/747
>  create mode 100644 tests/xfs/747.out
> 
> 
> diff --git a/common/dmerror b/common/dmerror
> index 54122b12ea..58ab461e0e 100644
> --- a/common/dmerror
> +++ b/common/dmerror
> @@ -159,16 +159,16 @@ _dmerror_load_error_table()
>  	fi
>  
>  	# Load new table
> -	$DMSETUP_PROG load error-test --table "$DMERROR_TABLE"
> +	echo "$DMERROR_TABLE" | $DMSETUP_PROG load error-test
>  	load_res=$?
>  
>  	if [ -n "$NON_ERROR_RTDEV" ]; then
> -		$DMSETUP_PROG load error-rttest --table "$DMERROR_RTTABLE"
> +		echo "$DMERROR_RTTABLE" | $DMSETUP_PROG load error-rttest
>  		[ $? -ne 0 ] && _fail "failed to load error table into error-rttest"
>  	fi
>  
>  	if [ -n "$NON_ERROR_LOGDEV" ]; then
> -		$DMSETUP_PROG load error-logtest --table "$DMERROR_LOGTABLE"
> +		echo "$DMERROR_LOGTABLE" | $DMSETUP_PROG load error-logtest

Hi,

Is there any reason about why we need to replace "dmsetup --table $table" with
"echo $table | dmsetup"?

>  		[ $? -ne 0 ] && _fail "failed to load error table into error-logtest"
>  	fi
>  
> @@ -250,3 +250,133 @@ _dmerror_load_working_table()
>  	[ $load_res -ne 0 ] && _fail "dmsetup failed to load error table"
>  	[ $resume_res -ne 0 ] && _fail  "dmsetup resume failed"
>  }
> +
> +# Given a list of (start, length) tuples on stdin, combine adjacent tuples into
> +# larger ones and write the new list to stdout.
> +__dmerror_combine_extents()
> +{
> +	awk 'BEGIN{start = 0; len = 0;}{
> +if (start + len == $1) {
> +	len += $2;
> +} else {
> +	if (len > 0)
> +		printf("%d %d\n", start, len);
> +	start = $1;
> +	len = $2;
> +}
> +} END {
> +	if (len > 0)
> +		printf("%d %d\n", start, len);
> +}'
> +}
> +
> +# Given a block device, the name of a preferred dm target, the name of an
> +# implied dm target, and a list of (start, len) tuples on stdin, create a new
> +# dm table which maps each of the tuples to the preferred target and all other
> +# areas to the implied dm target.
> +__dmerror_recreate_map()
> +{
> +	local device="$1"
> +	local preferred_tgt="$2"
> +	local implied_tgt="$3"
> +	local size=$(blockdev --getsz "$device")
> +
> +	awk -v device="$device" -v size=$size -v implied_tgt="$implied_tgt" \
> +		-v preferred_tgt="$preferred_tgt" 'BEGIN{implied_start = 0;}{
> +	extent_start = $1;
> +	extent_len = $2;
> +
> +	if (extent_start > size) {
> +		extent_start = size;
> +		extent_len = 0;
> +	} else if (extent_start + extent_len > size) {
> +		extent_len = size - extent_start;
> +	}
> +
> +	if (implied_start < extent_start)
> +		printf("%d %d %s %s %d\n", implied_start,
> +				extent_start - implied_start, implied_tgt,
> +				device, implied_start);
> +	printf("%d %d %s %s %d\n", extent_start, extent_len, preferred_tgt,
> +			device, extent_start);
> +	implied_start = extent_start + extent_len;
> +}END{
> +	if (implied_start < size)
> +		printf("%d %d %s %s %d\n", implied_start, size - implied_start,
> +				implied_tgt, device, implied_start);
> +}'

Above indentation (of awk code mix with bash function) is a little confused ...

> +}
> +
> +# Update the dm error table so that the range (start, len) maps to the
> +# preferred dm target, overriding anything that maps to the implied dm target.
> +# This assumes that the only desired targets for this dm device are the
> +# preferred and and implied targets.  The fifth argument is the scratch device
> +# that we want to change the table for.
> +__dmerror_change()
> +{
> +	local start="$1"
> +	local len="$2"
> +	local preferred_tgt="$3"
> +	local implied_tgt="$4"
> +	local whichdev="$5"

local old_table ?
local new_table ?

> +
> +	case "$whichdev" in
> +	"SCRATCH_DEV"|"")	whichdev="$SCRATCH_DEV";;
> +	"SCRATCH_LOGDEV"|"LOG")	whichdev="$NON_ERROR_LOGDEV";;
> +	"SCRATCH_RTDEV"|"RT")	whichdev="$NON_ERROR_RTDEV";;
> +	esac
> +
> +	case "$whichdev" in
> +	"$SCRATCH_DEV")		old_table="$DMERROR_TABLE";;
> +	"$NON_ERROR_LOGDEV")	old_table="$DMERROR_LOGTABLE";;
> +	"$NON_ERROR_RTDEV")	old_table="$DMERROR_RTTABLE";;
> +	*)
> +		echo "$whichdev: Unknown dmerror device."
> +		return
> +		;;
> +	esac
> +
> +	new_table="$( (echo "$old_table"; echo "$start $len $preferred_tgt") | \
> +		awk -v type="$preferred_tgt" '{if ($3 == type) print $0;}' | \
> +		sort -g | \
> +		__dmerror_combine_extents | \
> +		__dmerror_recreate_map "$whichdev" "$preferred_tgt" \
> +				"$implied_tgt" )"
> +
> +	case "$whichdev" in
> +	"$SCRATCH_DEV")		DMERROR_TABLE="$new_table";;
> +	"$NON_ERROR_LOGDEV")	DMERROR_LOGTABLE="$new_table";;
> +	"$NON_ERROR_RTDEV")	DMERROR_RTTABLE="$new_table";;
> +	esac
> +}
> +
> +# Reset the dm error table to everything ok.  The dm device itself must be
> +# remapped by calling _dmerror_load_error_table.
> +_dmerror_reset_table()
> +{
> +	DMERROR_TABLE="$DMLINEAR_TABLE"
> +	DMERROR_LOGTABLE="$DMLINEAR_LOGTABLE"
> +	DMERROR_RTTABLE="$DMLINEAR_RTTABLE"
> +}
> +
> +# Update the dm error table so that IOs to the given range will return EIO.
> +# The dm device itself must be remapped by calling _dmerror_load_error_table.
> +_dmerror_mark_range_bad()
> +{
> +	local start="$1"
> +	local len="$2"
> +	local dev="$3"
> +
> +	__dmerror_change "$start" "$len" error linear "$dev"
> +}
> +
> +# Update the dm error table so that IOs to the given range will succeed.
> +# The dm device itself must be remapped by calling _dmerror_load_error_table.
> +_dmerror_mark_range_good()
> +{
> +	local start="$1"
> +	local len="$2"
> +	local dev="$3"
> +
> +	__dmerror_change "$start" "$len" linear error "$dev"
> +}
> diff --git a/common/xfs b/common/xfs
> index e1c15d3d04..2cd8254937 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -194,6 +194,15 @@ _xfs_get_file_block_size()
>  	$XFS_INFO_PROG "$path" | grep realtime | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
>  }
>  
> +# Decide if this path is a file on the realtime device
> +_xfs_is_realtime_file()
> +{
> +	if [ "$USE_EXTERNAL" != "yes" ] || [ -z "$SCRATCH_RTDEV" ]; then
> +		return 1
> +	fi
> +	$XFS_IO_PROG -c 'stat -v' "$1" | grep -q -w realtime
> +}
> +
>  # Set or clear the realtime status of every supplied path.  The first argument
>  # is either 'data' or 'realtime'.  All other arguments should be paths to
>  # existing directories or empty regular files.
> diff --git a/tests/xfs/747 b/tests/xfs/747

I tried this case, and got below error, looks like the od error output need a filter?

# ./check -s simpledev -s logdev xfs/747
SECTION       -- simpledev
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 6.1.0-rc3 #5 SMP PREEMPT_DYNAMIC Tue Nov  1 01:08:52 CST 2022
MKFS_OPTIONS  -- -f /dev/sda3
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda3 /mnt/scratch

xfs/747       - output mismatch (see /root/git/xfstests/results//simpledev/xfs/747.out.bad)
    --- tests/xfs/747.out       2022-11-01 14:48:56.990683131 +0800
    +++ /root/git/xfstests/results//simpledev/xfs/747.out.bad   2022-11-01 19:38:34.825632961 +0800
    @@ -5,7 +5,7 @@
     Scrub for injected media error (multi threaded)
     Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
     SCRATCH_MNT: unfixable errors found: 1
    -od: SCRATCH_MNT/a: read error: Input/output error
    +od: SCRATCH_MNT/a: Input/output error

> new file mode 100755
> index 0000000000..8952c24ee6
> --- /dev/null
> +++ b/tests/xfs/747
> @@ -0,0 +1,155 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 747
> +#
> +# Check xfs_scrub's media scan can actually return diagnostic information for
> +# media errors in file data extents.
> +
> +. ./common/preamble
> +_begin_fstest auto quick scrub

  eio ?

Thanks,
Zorro

> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	_dmerror_cleanup
> +}
> +
> +# Import common functions.
> +. ./common/fuzzy
> +. ./common/filter
> +. ./common/dmerror
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_dm_target error
> +_require_scratch
> +_require_scratch_xfs_crc
> +_require_scrub
> +
> +filter_scrub_errors() {
> +	_filter_scratch | sed \
> +		-e "s/offset $((fs_blksz * 2)) /offset 2FSB /g" \
> +		-e "s/length $fs_blksz.*/length 1FSB./g"
> +}
> +
> +_scratch_mkfs >> $seqres.full
> +_dmerror_init
> +_dmerror_mount >> $seqres.full 2>&1
> +
> +_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || _notrun "Scrub not supported"
> +
> +# Write a file with 4 file blocks worth of data
> +victim=$SCRATCH_MNT/a
> +file_blksz=$(_get_file_block_size $SCRATCH_MNT)
> +$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c "fsync" $victim >> $seqres.full
> +unset errordev
> +_xfs_is_realtime_file $victim && errordev="RT"
> +bmap_str="$($XFS_IO_PROG -c "bmap -elpv" $victim | grep "^[[:space:]]*0:")"
> +echo "$errordev:$bmap_str" >> $seqres.full
> +
> +phys="$(echo "$bmap_str" | $AWK_PROG '{print $3}')"
> +if [ "$errordev" = "RT" ]; then
> +	len="$(echo "$bmap_str" | $AWK_PROG '{print $4}')"
> +else
> +	len="$(echo "$bmap_str" | $AWK_PROG '{print $6}')"
> +fi
> +fs_blksz=$(_get_block_size $SCRATCH_MNT)
> +echo "file_blksz:$file_blksz:fs_blksz:$fs_blksz" >> $seqres.full
> +kernel_sectors_per_fs_block=$((fs_blksz / 512))
> +
> +# Did we get at least 4 fs blocks worth of extent?
> +min_len_sectors=$(( 4 * kernel_sectors_per_fs_block ))
> +test "$len" -lt $min_len_sectors && \
> +	_fail "could not format a long enough extent on an empty fs??"
> +
> +phys_start=$(echo "$phys" | sed -e 's/\.\..*//g')
> +
> +echo "$errordev:$phys:$len:$fs_blksz:$phys_start" >> $seqres.full
> +echo "victim file:" >> $seqres.full
> +od -tx1 -Ad -c $victim >> $seqres.full
> +
> +# Set the dmerror table so that all IO will pass through.
> +_dmerror_reset_table
> +
> +cat >> $seqres.full << ENDL
> +dmerror before:
> +$DMERROR_TABLE
> +$DMERROR_RTTABLE
> +<end table>
> +ENDL
> +
> +# All sector numbers that we feed to the kernel must be in units of 512b, but
> +# they also must be aligned to the device's logical block size.
> +logical_block_size=$(_min_dio_alignment $SCRATCH_DEV)
> +kernel_sectors_per_device_lba=$((logical_block_size / 512))
> +
> +# Mark as bad one of the device LBAs in the middle of the extent.  Target the
> +# second LBA of the third block of the four-block file extent that we allocated
> +# earlier, but without overflowing into the fourth file block.
> +bad_sector=$(( phys_start + (2 * kernel_sectors_per_fs_block) ))
> +bad_len=$kernel_sectors_per_device_lba
> +if (( kernel_sectors_per_device_lba < kernel_sectors_per_fs_block )); then
> +	bad_sector=$((bad_sector + kernel_sectors_per_device_lba))
> +fi
> +if (( (bad_sector % kernel_sectors_per_device_lba) != 0)); then
> +	echo "bad_sector $bad_sector not congruent with device logical block size $logical_block_size"
> +fi
> +_dmerror_mark_range_bad $bad_sector $bad_len $errordev
> +
> +cat >> $seqres.full << ENDL
> +dmerror after marking bad:
> +$DMERROR_TABLE
> +$DMERROR_RTTABLE
> +<end table>
> +ENDL
> +
> +_dmerror_load_error_table
> +
> +# See if the media scan picks it up.
> +echo "Scrub for injected media error (single threaded)"
> +
> +# Once in single-threaded mode
> +_scratch_scrub -b -x >> $seqres.full 2> $tmp.error
> +cat $tmp.error | filter_scrub_errors
> +
> +# Once in parallel mode
> +echo "Scrub for injected media error (multi threaded)"
> +_scratch_scrub -x >> $seqres.full 2> $tmp.error
> +cat $tmp.error | filter_scrub_errors
> +
> +# Remount to flush the page cache and reread to see the IO error
> +_dmerror_unmount
> +_dmerror_mount
> +echo "victim file:" >> $seqres.full
> +od -tx1 -Ad -c $victim >> $seqres.full 2> $tmp.error
> +cat $tmp.error | _filter_scratch
> +
> +# Scrub again to re-confirm the media error across a remount
> +echo "Scrub for injected media error (after remount)"
> +_scratch_scrub -x >> $seqres.full 2> $tmp.error
> +cat $tmp.error | filter_scrub_errors
> +
> +# Now mark the bad range good so that a retest shows no media failure.
> +_dmerror_mark_range_good $bad_sector $bad_len $errordev
> +_dmerror_load_error_table
> +
> +cat >> $seqres.full << ENDL
> +dmerror after marking good:
> +$DMERROR_TABLE
> +$DMERROR_RTTABLE
> +<end table>
> +ENDL
> +
> +echo "Scrub after removing injected media error"
> +
> +# Scrub one last time to make sure the error's gone.
> +_scratch_scrub -x >> $seqres.full 2> $tmp.error
> +cat $tmp.error | filter_scrub_errors
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/747.out b/tests/xfs/747.out
> new file mode 100644
> index 0000000000..f85f1753a6
> --- /dev/null
> +++ b/tests/xfs/747.out
> @@ -0,0 +1,12 @@
> +QA output created by 747
> +Scrub for injected media error (single threaded)
> +Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
> +SCRATCH_MNT: unfixable errors found: 1
> +Scrub for injected media error (multi threaded)
> +Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
> +SCRATCH_MNT: unfixable errors found: 1
> +od: SCRATCH_MNT/a: read error: Input/output error
> +Scrub for injected media error (after remount)
> +Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
> +SCRATCH_MNT: unfixable errors found: 1
> +Scrub after removing injected media error
> 

