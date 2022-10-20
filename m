Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42EB26069FC
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Oct 2022 23:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJTVDT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Oct 2022 17:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiJTVDS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Oct 2022 17:03:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE98220F94;
        Thu, 20 Oct 2022 14:03:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE915B828D6;
        Thu, 20 Oct 2022 21:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D06C433D6;
        Thu, 20 Oct 2022 21:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666299794;
        bh=TdC8MKWtLJ0SY+HqIEMHcCr65xiekpDeQyd0cEmmflo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WfX9GC8X8Kqb00wuX7/ego/xPuiiDwEMVKx9pVQdTudYKXQyASBSs3aZkRzme86f6
         aT31kZ1NYW3WjmxdnfG9W9cNvQu+VINsN2YoizPUO0Dedxdk3PyH8ZcrLMKdDy8c9X
         ZNtI3NQnMLr7NYrM3J000Gbvs+SH+nu7a8Me5lyKynizQ/5vG0RhAyYc9BXkC9lPn2
         58vf9/fIG0w3ltl4jqYtdfnNbVYk3ytx7E9CivdXLmhUW/PO+avVAs78k9XHHQY+UY
         3NcL70LehxJ4Ly61JvsHTUw+lUpHE/+9OKUcqcAubvHUhRZy34TsT2QM4+HqDmgOmi
         OSuFp/bGk3ANw==
Date:   Thu, 20 Oct 2022 14:03:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: refactor filesystem feature detection logic
Message-ID: <Y1G3ke/qWPZH9gMS@magnolia>
References: <166613312194.868141.5162859918517610030.stgit@magnolia>
 <166613312749.868141.7487830883814756598.stgit@magnolia>
 <20221020122622.ldtlvxhdn2ncnuln@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020122622.ldtlvxhdn2ncnuln@zlang-mailbox>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 20, 2022 at 08:26:22PM +0800, Zorro Lang wrote:
> On Tue, Oct 18, 2022 at 03:45:27PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > There are a lot of places where we open-code detecting features of a
> > specific filesystem.  Refactor this into a couple of helpers in
> > preparation for adding stress tests for online repair and fuzzing.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/populate |   14 ++++++-----
> >  common/rc       |    9 +++++++
> >  common/xfs      |   67 ++++++++++++++++++++++++++++++++++++++++++++++---------
> >  tests/xfs/097   |    2 +-
> >  tests/xfs/151   |    3 +-
> >  tests/xfs/271   |    2 +-
> >  tests/xfs/307   |    2 +-
> >  tests/xfs/308   |    2 +-
> >  tests/xfs/348   |    2 +-
> >  9 files changed, 77 insertions(+), 26 deletions(-)
> > 
> > 
> > diff --git a/common/populate b/common/populate
> > index 58b07e33be..9fa1a06798 100644
> > --- a/common/populate
> > +++ b/common/populate
> > @@ -131,7 +131,7 @@ _populate_xfs_qmount_option()
> >  	fi
> >  
> >  	# Turn on all the quotas
> > -	if $XFS_INFO_PROG "${TEST_DIR}" | grep -q 'crc=1'; then
> > +	if _xfs_has_feature "$TEST_DIR" crc; then
> >  		# v5 filesystems can have group & project quotas
> >  		quota="usrquota,grpquota,prjquota"
> >  	else
> > @@ -176,7 +176,7 @@ _scratch_xfs_populate() {
> >  
> >  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> >  	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > -	crc="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep crc= | sed -e 's/^.*crc=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > +	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
> >  	if [ $crc -eq 1 ]; then
> >  		leaf_hdr_size=64
> >  	else
> > @@ -315,7 +315,7 @@ _scratch_xfs_populate() {
> >  	done
> >  
> >  	# Reverse-mapping btree
> > -	is_rmapbt="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'rmapbt=1')"
> > +	is_rmapbt="$(_xfs_has_feature "$SCRATCH_MNT" rmapbt -v)"
> >  	if [ $is_rmapbt -gt 0 ]; then
> >  		echo "+ rmapbt btree"
> >  		nr="$((blksz * 2 / 24))"
> > @@ -332,7 +332,7 @@ _scratch_xfs_populate() {
> >  	fi
> >  
> >  	# Reference-count btree
> > -	is_reflink="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'reflink=1')"
> > +	is_reflink="$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)"
> >  	if [ $is_reflink -gt 0 ]; then
> >  		echo "+ reflink btree"
> >  		nr="$((blksz * 2 / 12))"
> > @@ -597,9 +597,9 @@ _scratch_xfs_populate_check() {
> >  	leaf_attr="$(__populate_find_inode "${SCRATCH_MNT}/ATTR.FMT_LEAF")"
> >  	node_attr="$(__populate_find_inode "${SCRATCH_MNT}/ATTR.FMT_NODE")"
> >  	btree_attr="$(__populate_find_inode "${SCRATCH_MNT}/ATTR.FMT_BTREE")"
> > -	is_finobt=$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'finobt=1')
> > -	is_rmapbt=$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'rmapbt=1')
> > -	is_reflink=$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'reflink=1')
> > +	is_finobt=$(_xfs_has_feature "$SCRATCH_MNT" finobt -v)
> > +	is_rmapbt=$(_xfs_has_feature "$SCRATCH_MNT" rmapbt -v)
> > +	is_reflink=$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)
> >  
> >  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> >  	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > diff --git a/common/rc b/common/rc
> > index f4785c17ca..7944ef550e 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -247,7 +247,14 @@ _supports_filetype()
> >  	local fstyp=`$DF_PROG $dir | tail -1 | $AWK_PROG '{print $2}'`
> >  	case "$fstyp" in
> >  	xfs)
> > -		$XFS_INFO_PROG $dir | grep -q "ftype=1"
> > +		# If _xfs_has_feature is not present, grep xfs_info directly.
> > +		# This can happen if we're testing overlayfs atop XFS and have
> > +		# not sourced ./common/xfs.
> 
> Hmm... I thought I've fixed this kind of problem in:
>   61775fb9 common: source base fs specific common file
> 
> didn't I?

Oh!  That /did/ fix it.  This hunk can go away.

--D

> Others looks good to me,
> 
> Thanks,
> Zorro
> 
> 
> > +		if command -v "_xfs_has_feature" &>/dev/null; then
> > +			_xfs_has_feature $dir ftype
> > +		else
> > +			$XFS_INFO_PROG $dir | grep -q "ftype=1"
> > +		fi
> >  		;;
> >  	ext2|ext3|ext4)
> >  		local dev=`$DF_PROG $dir | tail -1 | $AWK_PROG '{print $1}'`
> > diff --git a/common/xfs b/common/xfs
> > index 2cd8254937..c7496bce3f 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -422,6 +422,56 @@ _require_xfs_crc()
> >  	_scratch_unmount
> >  }
> >  
> > +# If the xfs_info output for the given XFS filesystem mount mentions the given
> > +# feature.  If so, return 0 for success.  If not, return 1 for failure.  If the
> > +# third option is -v, echo 1 for success and 0 for not.
> > +#
> > +# Starting with xfsprogs 4.17, this also works for unmounted filesystems.
> > +_xfs_has_feature()
> > +{
> > +	local fs="$1"
> > +	local feat="$2"
> > +	local verbose="$3"
> > +
> > +	local answer="$($XFS_INFO_PROG "$fs" 2>&1 | grep -w -c "$feat=1")"
> > +	if [ "$answer" -ne 0 ]; then
> > +		test "$verbose" = "-v" && echo 1
> > +		return 0
> > +	fi
> > +
> > +	test "$verbose" = "-v" && echo 0
> > +	return 1
> > +}
> > +
> > +# Require that the xfs_info output for the given XFS filesystem mount mentions
> > +# the given feature flag.  If the third argument is -u (or is empty and the
> > +# second argument is $SCRATCH_MNT), unmount the fs on failure.  If a fourth
> > +# argument is supplied, it will be used as the _notrun message.
> > +_require_xfs_has_feature()
> > +{
> > +	local fs="$1"
> > +	local feat="$2"
> > +	local umount="$3"
> > +	local message="$4"
> > +
> > +	if [ -z "$umount" ] && [ "$fs" = "$SCRATCH_MNT" ]; then
> > +		umount="-u"
> > +	fi
> > +
> > +	_xfs_has_feature "$1" "$2" && return 0
> > +
> > +	test "$umount" = "-u" && umount "$fs" &>/dev/null
> > +
> > +	test -n "$message" && _notrun "$message"
> > +
> > +	case "$fs" in
> > +	"$TEST_DIR"|"$TEST_DEV")	fsname="test";;
> > +	"$SCRATCH_MNT"|"$SCRATCH_DEV")	fsname="scratch";;
> > +	*)				fsname="$fs";;
> > +	esac
> > +	_notrun "$2 not supported by $fsname filesystem type: $FSTYP"
> > +}
> > +
> >  # this test requires the xfs kernel support crc feature on scratch device
> >  #
> >  _require_scratch_xfs_crc()
> > @@ -429,7 +479,8 @@ _require_scratch_xfs_crc()
> >  	_scratch_mkfs_xfs >/dev/null 2>&1
> >  	_try_scratch_mount >/dev/null 2>&1 \
> >  	   || _notrun "Kernel doesn't support crc feature"
> > -	$XFS_INFO_PROG $SCRATCH_MNT | grep -q 'crc=1' || _notrun "crc feature not supported by this filesystem"
> > +	_require_xfs_has_feature $SCRATCH_MNT crc -u \
> > +		"crc feature not supported by this filesystem"
> >  	_scratch_unmount
> >  }
> >  
> > @@ -748,10 +799,7 @@ _check_xfs_test_fs()
> >  _require_xfs_test_rmapbt()
> >  {
> >  	_require_test
> > -
> > -	if [ "$($XFS_INFO_PROG "$TEST_DIR" | grep -c "rmapbt=1")" -ne 1 ]; then
> > -		_notrun "rmapbt not supported by test filesystem type: $FSTYP"
> > -	fi
> > +	_require_xfs_has_feature "$TEST_DIR" rmapbt
> >  }
> >  
> >  _require_xfs_scratch_rmapbt()
> > @@ -760,10 +808,7 @@ _require_xfs_scratch_rmapbt()
> >  
> >  	_scratch_mkfs > /dev/null
> >  	_scratch_mount
> > -	if [ "$($XFS_INFO_PROG "$SCRATCH_MNT" | grep -c "rmapbt=1")" -ne 1 ]; then
> > -		_scratch_unmount
> > -		_notrun "rmapbt not supported by scratch filesystem type: $FSTYP"
> > -	fi
> > +	_require_xfs_has_feature "$SCRATCH_MNT" rmapbt
> >  	_scratch_unmount
> >  }
> >  
> > @@ -1366,8 +1411,8 @@ _require_scratch_xfs_bigtime()
> >  		_notrun "mkfs.xfs doesn't support bigtime feature"
> >  	_try_scratch_mount || \
> >  		_notrun "kernel doesn't support xfs bigtime feature"
> > -	$XFS_INFO_PROG "$SCRATCH_MNT" | grep -q -w "bigtime=1" || \
> > -		_notrun "bigtime feature not advertised on mount?"
> > +	_require_xfs_has_feature $SCRATCH_MNT bigtime -u \
> > +		"crc feature not supported by this filesystem"
> >  	_scratch_unmount
> >  }
> >  
> > diff --git a/tests/xfs/097 b/tests/xfs/097
> > index 4cad7216cd..1df34eeddc 100755
> > --- a/tests/xfs/097
> > +++ b/tests/xfs/097
> > @@ -42,7 +42,7 @@ _scratch_mkfs_xfs -m crc=1,finobt=1 > /dev/null
> >  
> >  echo "+ mount fs image"
> >  _scratch_mount
> > -$XFS_INFO_PROG "${SCRATCH_MNT}" | grep -q "finobt=1" || _notrun "finobt not enabled"
> > +_require_xfs_has_feature "$SCRATCH_MNT" finobt
> >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> >  
> >  echo "+ make some files"
> > diff --git a/tests/xfs/151 b/tests/xfs/151
> > index 66425f6710..b2fe16aefb 100755
> > --- a/tests/xfs/151
> > +++ b/tests/xfs/151
> > @@ -24,8 +24,7 @@ echo "Format filesystem and populate"
> >  _scratch_mkfs > $seqres.full
> >  _scratch_mount >> $seqres.full
> >  
> > -$XFS_INFO_PROG $SCRATCH_MNT | grep -q ftype=1 || \
> > -	_notrun "filesystem does not support ftype"
> > +_require_xfs_has_feature "$SCRATCH_MNT" ftype
> >  
> >  filter_ls() {
> >  	awk '
> > diff --git a/tests/xfs/271 b/tests/xfs/271
> > index 14d64cd0e5..d67ac4d6c1 100755
> > --- a/tests/xfs/271
> > +++ b/tests/xfs/271
> > @@ -37,7 +37,7 @@ agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
> >  # same owner (per-AG metadata) for rmap btree blocks and blocks on the AGFL and
> >  # the reverse mapping index merges records, the number of per-AG extents
> >  # reported will vary depending on whether the refcount btree is enabled.
> > -$XFS_INFO_PROG $SCRATCH_MNT | grep -q reflink=1
> > +_require_xfs_has_feature "$SCRATCH_MNT" reflink
> >  has_reflink=$(( 1 - $? ))
> >  perag_metadata_exts=2
> >  test $has_reflink -gt 0 && perag_metadata_exts=$((perag_metadata_exts + 1))
> > diff --git a/tests/xfs/307 b/tests/xfs/307
> > index ba7204dd00..f3c970fadf 100755
> > --- a/tests/xfs/307
> > +++ b/tests/xfs/307
> > @@ -22,7 +22,7 @@ _require_scratch_reflink
> >  echo "Format"
> >  _scratch_mkfs > $seqres.full 2>&1
> >  _scratch_mount >> $seqres.full
> > -is_rmap=$($XFS_INFO_PROG $SCRATCH_MNT | grep -c "rmapbt=1")
> > +is_rmap=$(_xfs_has_feature $SCRATCH_MNT rmapbt -v)
> >  _scratch_unmount
> >  
> >  _get_agf_data() {
> > diff --git a/tests/xfs/308 b/tests/xfs/308
> > index d0f47f5038..6da6622e14 100755
> > --- a/tests/xfs/308
> > +++ b/tests/xfs/308
> > @@ -22,7 +22,7 @@ _require_scratch_reflink
> >  echo "Format"
> >  _scratch_mkfs > $seqres.full 2>&1
> >  _scratch_mount >> $seqres.full
> > -is_rmap=$($XFS_INFO_PROG $SCRATCH_MNT | grep -c "rmapbt=1")
> > +is_rmap=$(_xfs_has_feature $SCRATCH_MNT rmapbt -v)
> >  _scratch_xfs_unmount_dirty
> >  
> >  _get_agf_data() {
> > diff --git a/tests/xfs/348 b/tests/xfs/348
> > index faf2dca50b..d1645d9462 100755
> > --- a/tests/xfs/348
> > +++ b/tests/xfs/348
> > @@ -39,7 +39,7 @@ mknod $testdir/CHRDEV c 1 1
> >  mknod $testdir/BLKDEV b 1 1
> >  mknod $testdir/FIFO p
> >  
> > -$XFS_INFO_PROG $SCRATCH_MNT | grep -q "ftype=1" && FTYPE_FEATURE=1
> > +_xfs_has_feature $SCRATCH_MNT ftype && FTYPE_FEATURE=1
> >  
> >  # Record test dir inode for xfs_repair filter
> >  inode_filter=$tmp.sed
> > 
