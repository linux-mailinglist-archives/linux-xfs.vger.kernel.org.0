Return-Path: <linux-xfs+bounces-10842-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 95F2D93D768
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Jul 2024 19:15:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC03B1C23133
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Jul 2024 17:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A359E17CA0E;
	Fri, 26 Jul 2024 17:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aeuvONMa"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949BF17CA07
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jul 2024 17:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722014092; cv=none; b=s8SdJ5GXcqGExcGIBI1UXmKX7Mc5WCkWq54fzkls7ZJ5+TC868b9IWDpe0wUu2A8dRUYu3Rvm4urUMMvVXpeLyD+3lEYlGOB/4/eOW9GWvW24ZtH0Z5fU4qPSD+V0KpwnjUg9+UZvZfzoDS4ceNXy462OoozSVjxhr0RdOco/Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722014092; c=relaxed/simple;
	bh=0Au71qHG8t0BNWpauHmURbqpJzYtGSXnoA//JDCtInc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=naxAuD3EU+FvenfoyFwR/AtTrlSGqrm7vHWeiKM+MMD/Wwaq/671SaI18qKpM/MqzXh/NioXyt/dOViIK6oyNExyukkAlY4t2PPMUiGj/JvmuMba3GJJ++CeKQBSFomz3nZQuOFSzR1KIMRz01t/37jM9vAEOM8dFsB/qGhPPTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aeuvONMa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722014086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PV4T/cuBGiBKWbpeAgg0Wm+lcmIWYApb9+LDwmz0+qc=;
	b=aeuvONMaXvVaN9g477Yx2NAv86V8jzYYTrWuZjW9ibJazoOulnMh68kJRnaALm72y5xCoK
	T5tX1ccnn27C8JFzLflrH3i6R7wVBTzDspG9IQ36ERXtezpf4+j0tLv1GM0adpZjjPfA2T
	qmCXfyHzxBDtS/inCq6MbuJhxE8hWzQ=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-SlwdW0vRM6SWvqP_7C573A-1; Fri, 26 Jul 2024 13:14:41 -0400
X-MC-Unique: SlwdW0vRM6SWvqP_7C573A-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1fd774c3b8eso8790545ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jul 2024 10:14:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722014080; x=1722618880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PV4T/cuBGiBKWbpeAgg0Wm+lcmIWYApb9+LDwmz0+qc=;
        b=EBluDKLAi3lvSbbURyw8TT5dAgIa/77+rDqJfD6R0mVXF6judjPWTBkDxU2mUHW8x4
         r8RKU+esSFy/mcVLL41zXF7v0/A0sswFZjK3npzWxcPe1UB61ghxZqRyB7HQtzQreizB
         /mvMmxtDcPxCOcd6rBxN6AUuY1Od4F9O6VMCu3jGiU+btnpucmFiYgL3yrzZ6fEgslXV
         5+POMRKB3uwNM3WtJ4Ji2jtO+espsrjU1Q7KkqnLqQ0/8huuTaX00B9r/ZAmFoQU6ESz
         q3CXv3/o3nhf4QUq/9u2DKxCnwsU9h4aCfvYZeZMOyYvEu94Um4l3kmR/uxSbvJ/4daJ
         QJvw==
X-Forwarded-Encrypted: i=1; AJvYcCWooObn81KhDLuiwUC7XQ/+eZ2Pi0K6/dZpu5D17T7Ye26Q0F9Dcg+geNOpYtNBRFmis9xJU1zDg38gXYzgzGP7kAuwIVDpIV+G
X-Gm-Message-State: AOJu0YxKzRnT+tyHZKlew1liexVlRiNOldqhzVqW1tJ8Jb1c4vvpBHhn
	i5RXC2TElD+OkLbPGOkFNYLiIUodRlj3eAvzcIyrYQDx2Q/zkJHkL9cN3YixGS3XeLFd9ioop9L
	Bs4ILQH9DPsx9hx/IUrcaKFweTNuVB7rqGyMl5WrbgzTDZ86noI6LVqCuOBDSWN/YIeXM
X-Received: by 2002:a17:902:db05:b0:1f9:e2c0:d962 with SMTP id d9443c01a7336-1ff04b5f70fmr3402865ad.31.1722014079408;
        Fri, 26 Jul 2024 10:14:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFni2IIsIJ25f29QEIWWNy77Gmm2SxFXJ10N7Oomj3j8OK309dvuLcM+WmkMkSmSyvSWU4x4A==
X-Received: by 2002:a17:902:db05:b0:1f9:e2c0:d962 with SMTP id d9443c01a7336-1ff04b5f70fmr3402175ad.31.1722014078677;
        Fri, 26 Jul 2024 10:14:38 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7eef4f0sm35383515ad.178.2024.07.26.10.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 10:14:38 -0700 (PDT)
Date: Sat, 27 Jul 2024 01:14:34 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] common: _notrun if _scratch_mkfs_xfs failed
Message-ID: <20240726171434.kwgmlksglw4yolyb@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240723000042.240981-1-hch@lst.de>
 <20240723000042.240981-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240723000042.240981-3-hch@lst.de>

On Mon, Jul 22, 2024 at 05:00:33PM -0700, Christoph Hellwig wrote:
> If we fail to create a file system with specific passed in options, that
> that these options conflict with other options $MKFS_OPTIONS. Don't
> fail the test case for that, but instead _norun it and display the options
> that caused it to fail.
> 
> Add a lower-level _try_scratch_mkfs_xfs helper for those places that want
> to check the return value.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/attr        |  4 ++--
>  common/filestreams |  2 +-
>  common/log         |  4 ++--
>  common/rc          |  9 +++++----
>  common/xfs         | 28 +++++++++++++++++-----------

[snip]
  
> diff --git a/common/rc b/common/rc
> index f0ad843d7..760f7dc3b 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -784,7 +784,7 @@ _scratch_mkfs()
>  		return $?
>  		;;
>  	xfs)
> -		_scratch_mkfs_xfs $*
> +		_try_scratch_mkfs_xfs $*

I thought you might want to affect all test cases (on xfs), until I see this :)

So most of cases (on xfs) will be not changed, only those cases call
_scratch_mkfs_xfs directly will be _notrun (if it fails to mkfs before).


I'm still thinking about if this behavior is needed. Last time we
just let _scratch_mkfs_sized calls _fail if it fails to mkfs. And
we hope to get a fail report generally, if a mkfs fails. But
now we hope to _notrun? With this patchset, some mkfs failures will
cause _fail, but some will cause _notrun. There'll be two kind of
behaviors.

Thanks,
Zorro

>  		return $?
>  		;;
>  	udf)
> @@ -1090,9 +1090,10 @@ _try_scratch_mkfs_sized()
>  		# don't override MKFS_OPTIONS that set a block size.
>  		echo $MKFS_OPTIONS |grep -E -q "b\s*size="
>  		if [ $? -eq 0 ]; then
> -			_scratch_mkfs_xfs -d size=$fssize $rt_ops
> +			_try_scratch_mkfs_xfs -d size=$fssize $rt_ops
>  		else
> -			_scratch_mkfs_xfs -d size=$fssize $rt_ops -b size=$blocksize
> +			_try_scratch_mkfs_xfs -d size=$fssize $rt_ops \
> +				-b size=$blocksize
>  		fi
>  		;;
>  	ext2|ext3|ext4)
> @@ -1234,7 +1235,7 @@ _scratch_mkfs_blocksized()
>  		_scratch_mkfs --sectorsize=$blocksize
>  		;;
>  	xfs)
> -		_scratch_mkfs_xfs $MKFS_OPTIONS -b size=$blocksize
> +		_try_scratch_mkfs_xfs $MKFS_OPTIONS -b size=$blocksize
>  		;;
>  	ext2|ext3|ext4)
>  		_scratch_mkfs_ext4 $MKFS_OPTIONS -b $blocksize
> diff --git a/common/xfs b/common/xfs
> index 59a34754b..ac2706cdb 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -146,7 +146,7 @@ _scratch_find_xfs_min_logblocks()
>  	rm -f $tmp.mkfsstd $tmp.mkfserr
>  }
>  
> -_scratch_mkfs_xfs()
> +_try_scratch_mkfs_xfs()
>  {
>  	local mkfs_cmd="`_scratch_mkfs_xfs_opts`"
>  	local mkfs_filter="sed -e '/less than device physical sector/d' \
> @@ -180,6 +180,11 @@ _scratch_mkfs_xfs()
>  	return $mkfs_status
>  }
>  
> +_scratch_mkfs_xfs()
> +{
> +	_try_scratch_mkfs_xfs $* || _notrun "_scratch_mkfs_xfs failed with ($*)"
> +}
> +
>  # Get the number of realtime extents of a mounted filesystem.
>  _xfs_get_rtextents()
>  {
> @@ -525,7 +530,7 @@ _require_xfs_has_feature()
>  #
>  _require_scratch_xfs_crc()
>  {
> -	_scratch_mkfs_xfs >/dev/null 2>&1
> +	_try_scratch_mkfs_xfs >/dev/null 2>&1
>  	_try_scratch_mount >/dev/null 2>&1 \
>  	   || _notrun "Kernel doesn't support crc feature"
>  	_require_xfs_has_feature $SCRATCH_MNT crc -u \
> @@ -545,7 +550,7 @@ _require_xfs_mkfs_finobt()
>  #
>  _require_xfs_finobt()
>  {
> -	_scratch_mkfs_xfs -m crc=1,finobt=1 >/dev/null 2>&1
> +	_try_scratch_mkfs_xfs -m crc=1,finobt=1 >/dev/null 2>&1
>  	_try_scratch_mount >/dev/null 2>&1 \
>  	   || _notrun "Kernel doesn't support finobt feature"
>  	_scratch_unmount
> @@ -573,7 +578,7 @@ _require_xfs_sparse_inodes()
>  {
>  	_scratch_mkfs_xfs_supported -m crc=1 -i sparse > /dev/null 2>&1 \
>  		|| _notrun "mkfs.xfs does not support sparse inodes"
> -	_scratch_mkfs_xfs -m crc=1 -i sparse > /dev/null 2>&1
> +	_try_scratch_mkfs_xfs -m crc=1 -i sparse > /dev/null 2>&1
>  	_try_scratch_mount >/dev/null 2>&1 \
>  		|| _notrun "kernel does not support sparse inodes"
>  	_scratch_unmount
> @@ -585,7 +590,7 @@ _require_xfs_nrext64()
>  {
>  	_scratch_mkfs_xfs_supported -m crc=1 -i nrext64 > /dev/null 2>&1 \
>  		|| _notrun "mkfs.xfs does not support nrext64"
> -	_scratch_mkfs_xfs -m crc=1 -i nrext64 > /dev/null 2>&1
> +	_try_scratch_mkfs_xfs -m crc=1 -i nrext64 > /dev/null 2>&1
>  	_try_scratch_mount >/dev/null 2>&1 \
>  		|| _notrun "kernel does not support nrext64"
>  	_scratch_unmount
> @@ -600,7 +605,7 @@ _require_xfs_db_command()
>  	fi
>  	command=$1
>  
> -	_scratch_mkfs_xfs >/dev/null 2>&1
> +	_try_scratch_mkfs_xfs >/dev/null 2>&1
>  	_scratch_xfs_db -x -c "help" | grep $command > /dev/null || \
>  		_notrun "xfs_db $command support is missing"
>  }
> @@ -1276,7 +1281,7 @@ _require_scratch_xfs_shrink()
>  	_require_scratch
>  	_require_command "$XFS_GROWFS_PROG" xfs_growfs
>  
> -	_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
> +	_try_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
>  	. $tmp.mkfs
>  	_scratch_mount
>  	# here just to check if kernel supports, no need do more extra work
> @@ -1581,7 +1586,7 @@ _try_wipe_scratch_xfs()
>  	# Try to wipe each SB by default mkfs.xfs geometry
>  	local tmp=`mktemp -u`
>  	unset agcount agsize dbsize
> -	_scratch_mkfs_xfs -N 2>/dev/null | perl -ne '
> +	_try_scratch_mkfs_xfs -N 2>/dev/null | perl -ne '
>  		if (/^meta-data=.*\s+agcount=(\d+), agsize=(\d+) blks/) {
>  			print STDOUT "agcount=$1\nagsize=$2\n";
>  		}
> @@ -1814,7 +1819,8 @@ _scratch_xfs_create_fake_root()
>  
>  	# A large stripe unit will put the root inode out quite far
>  	# due to alignment, leaving free blocks ahead of it.
> -	_scratch_mkfs_xfs -d sunit=1024,swidth=1024 > $seqres.full 2>&1 || _fail "mkfs failed"
> +	_try_scratch_mkfs_xfs -d sunit=1024,swidth=1024 > $seqres.full 2>&1 || \
> +		_fail "mkfs failed"
>  
>  	# Mounting /without/ a stripe should allow inodes to be allocated
>  	# in lower free blocks, without the stripe alignment.
> @@ -1983,7 +1989,7 @@ _xfs_discard_max_offset_kb()
>  # check if mkfs and the kernel support nocrc (v4) file systems
>  _require_xfs_nocrc()
>  {
> -	_scratch_mkfs_xfs -m crc=0 > /dev/null 2>&1 || \
> +	_try_scratch_mkfs_xfs -m crc=0 > /dev/null 2>&1 || \
>  		_notrun "v4 file systems not supported"
>  	_try_scratch_mount > /dev/null 2>&1 || \
>  		_notrun "v4 file systems not supported"
> @@ -2012,7 +2018,7 @@ _require_xfs_parent()
>  {
>  	_scratch_mkfs_xfs_supported -n parent > /dev/null 2>&1 \
>  		|| _notrun "mkfs.xfs does not support parent pointers"
> -	_scratch_mkfs_xfs -n parent > /dev/null 2>&1
> +	_try_scratch_mkfs_xfs -n parent > /dev/null 2>&1
>  	_try_scratch_mount >/dev/null 2>&1 \
>  		|| _notrun "kernel does not support parent pointers"
>  	_scratch_unmount
> diff --git a/tests/generic/083 b/tests/generic/083
> index 10db5f080..ff4785eee 100755
> --- a/tests/generic/083
> +++ b/tests/generic/083
> @@ -45,8 +45,7 @@ workout()
>  	echo ""                                     >>$seqres.full
>  	if [ $FSTYP = xfs ]
>  	then
> -		_scratch_mkfs_xfs -dsize=$fsz,agcount=$ags  >>$seqres.full 2>&1 \
> -			|| _fail "size=$fsz,agcount=$ags mkfs failed"
> +		_scratch_mkfs_xfs -dsize=$fsz,agcount=$ags  >>$seqres.full 2>&1
>  	else
>  		_scratch_mkfs_sized $fsz >>$seqres.full 2>&1
>  	fi
> diff --git a/tests/xfs/002 b/tests/xfs/002
> index c9450ff40..388822c13 100755
> --- a/tests/xfs/002
> +++ b/tests/xfs/002
> @@ -24,7 +24,7 @@ _require_scratch_nocheck
>  _require_no_large_scratch_dev
>  _require_xfs_nocrc
>  
> -_scratch_mkfs_xfs -m crc=0 -d size=128m >> $seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mkfs_xfs -m crc=0 -d size=128m >> $seqres.full 2>&1
>  
>  # Scribble past a couple V4 secondary superblocks to populate sb_crc
>  # (We can't write to the structure member because it doesn't exist
> diff --git a/tests/xfs/004 b/tests/xfs/004
> index 6ff15df23..473b82c94 100755
> --- a/tests/xfs/004
> +++ b/tests/xfs/004
> @@ -21,7 +21,7 @@ _cleanup()
>  _populate_scratch()
>  {
>  	echo "=== mkfs output ===" >>$seqres.full
> -	_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
> +	_try_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
>  	. $tmp.mkfs
>  	_scratch_mount
>  	# This test looks at specific behaviors of the xfs_db freesp command,
> diff --git a/tests/xfs/005 b/tests/xfs/005
> index 0c8061b0f..c1333924c 100755
> --- a/tests/xfs/005
> +++ b/tests/xfs/005
> @@ -20,7 +20,7 @@ _begin_fstest auto quick
>  
>  _require_scratch_nocheck
>  
> -_scratch_mkfs_xfs -m crc=1 >> $seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mkfs_xfs -m crc=1 >> $seqres.full 2>&1
>  
>  # Zap the crc.  xfs_db updates the CRC post-write, so poke it directly
>  $XFS_IO_PROG -c "pwrite 224 4" -c fsync $SCRATCH_DEV | _filter_xfs_io
> diff --git a/tests/xfs/009 b/tests/xfs/009
> index 986459036..dde505f07 100755
> --- a/tests/xfs/009
> +++ b/tests/xfs/009
> @@ -19,7 +19,7 @@ _cleanup()
>  _init()
>  {
>      echo "*** mkfs"
> -    if ! _scratch_mkfs_xfs >$tmp.out 2>&1
> +    if ! _try_scratch_mkfs_xfs >$tmp.out 2>&1
>      then
>  	cat $tmp.out
>          echo "failed to mkfs $SCRATCH_DEV"
> diff --git a/tests/xfs/017 b/tests/xfs/017
> index efe0ac119..5b26523c7 100755
> --- a/tests/xfs/017
> +++ b/tests/xfs/017
> @@ -33,8 +33,7 @@ echo "*** init FS"
>  _scratch_unmount >/dev/null 2>&1
>  echo "*** MKFS ***"                         >>$seqres.full
>  echo ""                                     >>$seqres.full
> -_scratch_mkfs_xfs                           >>$seqres.full 2>&1 \
> -    || _fail "mkfs failed"
> +_scratch_mkfs_xfs                           >>$seqres.full 2>&1
>  _scratch_mount
>  
>  echo "*** test"
> diff --git a/tests/xfs/019 b/tests/xfs/019
> index 914f0a287..fdd965aa9 100755
> --- a/tests/xfs/019
> +++ b/tests/xfs/019
> @@ -99,8 +99,7 @@ _verify_fs()
>  	_scratch_unmount >/dev/null 2>&1
>  
>  	_full "mkfs"
> -	_scratch_mkfs_xfs $VERSION -p $protofile >>$seqfull 2>&1 \
> -		|| _fail "mkfs failed"
> +	_scratch_mkfs_xfs $VERSION -p $protofile >>$seqfull 2>&1
>  
>  	echo "*** check FS"
>  	_check_scratch_fs
> diff --git a/tests/xfs/021 b/tests/xfs/021
> index 84360a8fc..1a93e0827 100755
> --- a/tests/xfs/021
> +++ b/tests/xfs/021
> @@ -59,8 +59,7 @@ _require_attrs
>  _scratch_unmount >/dev/null 2>&1
>  
>  echo "*** mkfs"
> -_scratch_mkfs_xfs >/dev/null \
> -	|| _fail "mkfs failed"
> +_scratch_mkfs_xfs >/dev/null
>  
>  echo "*** mount FS"
>  _scratch_mount
> diff --git a/tests/xfs/022 b/tests/xfs/022
> index 106539146..ccde9bab0 100755
> --- a/tests/xfs/022
> +++ b/tests/xfs/022
> @@ -28,7 +28,7 @@ _cleanup()
>  
>  _require_tape $TAPE_DEV
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  # note: fsstress uses an endian dependent random number generator, running this
> diff --git a/tests/xfs/023 b/tests/xfs/023
> index 06be85020..e41da3a8a 100755
> --- a/tests/xfs/023
> +++ b/tests/xfs/023
> @@ -27,7 +27,7 @@ _cleanup()
>  
>  _require_tape $TAPE_DEV
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  _create_dumpdir_fill
>  _erase_hard
> diff --git a/tests/xfs/024 b/tests/xfs/024
> index 3636e3eb8..b661c4a18 100755
> --- a/tests/xfs/024
> +++ b/tests/xfs/024
> @@ -25,7 +25,7 @@ _cleanup()
>  
>  _require_tape $TAPE_DEV
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  _create_dumpdir_fill
>  # ensure file/dir timestamps precede dump timestamp
> diff --git a/tests/xfs/025 b/tests/xfs/025
> index 071e04e4f..3c47507c5 100755
> --- a/tests/xfs/025
> +++ b/tests/xfs/025
> @@ -25,7 +25,7 @@ _cleanup()
>  
>  _require_tape $TAPE_DEV
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  _create_dumpdir_fill
>  _erase_hard
> diff --git a/tests/xfs/026 b/tests/xfs/026
> index 060bcfe02..fae5a4e6e 100755
> --- a/tests/xfs/026
> +++ b/tests/xfs/026
> @@ -23,7 +23,7 @@ _cleanup()
>  . ./common/dump
>  
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  _create_dumpdir_fill
> diff --git a/tests/xfs/027 b/tests/xfs/027
> index a1fbec9dd..9cc01c81d 100755
> --- a/tests/xfs/027
> +++ b/tests/xfs/027
> @@ -23,7 +23,7 @@ _cleanup()
>  . ./common/dump
>  
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  _create_dumpdir_fill
> diff --git a/tests/xfs/028 b/tests/xfs/028
> index bed88b113..2264863c3 100755
> --- a/tests/xfs/028
> +++ b/tests/xfs/028
> @@ -23,7 +23,7 @@ _cleanup()
>  . ./common/dump
>  
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  #
> diff --git a/tests/xfs/030 b/tests/xfs/030
> index 7f8222d77..22fbdb2fd 100755
> --- a/tests/xfs/030
> +++ b/tests/xfs/030
> @@ -57,7 +57,7 @@ DSIZE="-dsize=100m,agcount=6"
>  # superblock (hanging around from earlier tests)...
>  #
>  
> -_scratch_mkfs_xfs $DSIZE >/dev/null 2>&1
> +_try_scratch_mkfs_xfs $DSIZE >/dev/null 2>&1
>  if [ $? -ne 0 ]		# probably don't have a big enough scratch
>  then
>  	_notrun "SCRATCH_DEV too small, results would be non-deterministic"
> diff --git a/tests/xfs/034 b/tests/xfs/034
> index 2acf0ad44..e5ee2790c 100755
> --- a/tests/xfs/034
> +++ b/tests/xfs/034
> @@ -29,8 +29,7 @@ echo "*** init FS"
>  _scratch_unmount >/dev/null 2>&1
>  echo "*** MKFS ***"                         >>$seqres.full
>  echo ""                                     >>$seqres.full
> -_scratch_mkfs_xfs                           >>$seqres.full 2>&1 \
> -    || _fail "mkfs failed"
> +_scratch_mkfs_xfs                           >>$seqres.full
>  _scratch_mount
>  
>  echo "*** test"
> diff --git a/tests/xfs/035 b/tests/xfs/035
> index 81e21dc5c..88e45fada 100755
> --- a/tests/xfs/035
> +++ b/tests/xfs/035
> @@ -24,7 +24,7 @@ _cleanup()
>  
>  _require_tape $TAPE_DEV
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  _create_dumpdir_fill
>  _erase_hard
> diff --git a/tests/xfs/036 b/tests/xfs/036
> index 6a03b3269..a9074ac2d 100755
> --- a/tests/xfs/036
> +++ b/tests/xfs/036
> @@ -24,7 +24,7 @@ _cleanup()
>  
>  _require_tape $RMT_IRIXTAPE_DEV
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  _create_dumpdir_fill
>  _erase_soft
> diff --git a/tests/xfs/037 b/tests/xfs/037
> index 0298f0bbd..1b7b083d6 100755
> --- a/tests/xfs/037
> +++ b/tests/xfs/037
> @@ -23,7 +23,7 @@ _cleanup()
>  
>  _require_tape $RMT_TAPE_DEV
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  _create_dumpdir_fill
>  _erase_soft
> diff --git a/tests/xfs/038 b/tests/xfs/038
> index fb26d9991..44c0f2181 100755
> --- a/tests/xfs/038
> +++ b/tests/xfs/038
> @@ -23,7 +23,7 @@ _cleanup()
>  
>  _require_tape $RMT_TAPE_DEV
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  _create_dumpdir_fill
>  _erase_hard
> diff --git a/tests/xfs/039 b/tests/xfs/039
> index 53273d11d..e5ed42447 100755
> --- a/tests/xfs/039
> +++ b/tests/xfs/039
> @@ -24,7 +24,7 @@ _cleanup()
>  
>  _require_tape $RMT_IRIXTAPE_DEV
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  _create_dumpdir_fill
>  _erase_soft
> diff --git a/tests/xfs/041 b/tests/xfs/041
> index 31807530f..780078d44 100755
> --- a/tests/xfs/041
> +++ b/tests/xfs/041
> @@ -38,7 +38,7 @@ _fill()
>  _do_die_on_error=message_only
>  agsize=32
>  echo -n "Make $agsize megabyte filesystem on SCRATCH_DEV and mount... "
> -_scratch_mkfs_xfs -dsize=${agsize}m,agcount=1 2>&1 >/dev/null || _fail "mkfs failed"
> +_scratch_mkfs_xfs -dsize=${agsize}m,agcount=1 2>&1 >/dev/null
>  bsize=`_scratch_mkfs_xfs -dsize=${agsize}m,agcount=1 2>&1 | _filter_mkfs 2>&1 \
>  		| perl -ne 'if (/dbsize=(\d+)/) {print $1;}'`
>  onemeginblocks=`expr 1048576 / $bsize`
> diff --git a/tests/xfs/042 b/tests/xfs/042
> index f598c45a4..0e054e080 100755
> --- a/tests/xfs/042
> +++ b/tests/xfs/042
> @@ -50,7 +50,7 @@ _require_scratch
>  _do_die_on_error=message_only
>  
>  echo -n "Make a 96 megabyte filesystem on SCRATCH_DEV and mount... "
> -_scratch_mkfs_xfs -dsize=96m,agcount=3 2>&1 >/dev/null || _fail "mkfs failed"
> +_scratch_mkfs_xfs -dsize=96m,agcount=3 2>&1 >/dev/null
>  _scratch_mount
>  
>  echo "done"
> diff --git a/tests/xfs/043 b/tests/xfs/043
> index b5583e2c5..27168bbe8 100755
> --- a/tests/xfs/043
> +++ b/tests/xfs/043
> @@ -26,7 +26,7 @@ _cleanup()
>  
>  _require_tape $TAPE_DEV
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  _create_dumpdir_fill
>  _erase_hard
> diff --git a/tests/xfs/044 b/tests/xfs/044
> index 9861c72a1..3ecb34793 100755
> --- a/tests/xfs/044
> +++ b/tests/xfs/044
> @@ -73,7 +73,7 @@ echo "*** mkfs"
>  # this test only works for version 1 logs currently
>  lversion=1
>  lsize=16777216
> -_scratch_mkfs_xfs -lsize=$lsize,version=$lversion >$tmp.mkfs0 2>&1
> +_try_scratch_mkfs_xfs -lsize=$lsize,version=$lversion >$tmp.mkfs0 2>&1
>  [ $? -ne 0 ] && \
>      _notrun "Cannot mkfs for this test using MKFS_OPTIONS specified"
>  _filter_mkfs <$tmp.mkfs0 2>$tmp.mkfs1
> diff --git a/tests/xfs/045 b/tests/xfs/045
> index 06faa9e31..724bffc5a 100755
> --- a/tests/xfs/045
> +++ b/tests/xfs/045
> @@ -25,7 +25,7 @@ echo "*** get uuid"
>  uuid=`_get_existing_uuid`
>  
>  echo "*** mkfs"
> -if ! _scratch_mkfs_xfs >$tmp.out 2>&1
> +if ! _try_scratch_mkfs_xfs >$tmp.out 2>&1
>  then
>      cat $tmp.out
>      echo "!!! failed to mkfs on $SCRATCH_DEV"
> diff --git a/tests/xfs/046 b/tests/xfs/046
> index f2f9f7b38..314193d96 100755
> --- a/tests/xfs/046
> +++ b/tests/xfs/046
> @@ -21,7 +21,7 @@ _cleanup()
>  . ./common/dump
>  
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  _create_dumpdir_symlinks
> diff --git a/tests/xfs/047 b/tests/xfs/047
> index 05e62cb5a..0c65659f4 100755
> --- a/tests/xfs/047
> +++ b/tests/xfs/047
> @@ -21,7 +21,7 @@ _cleanup()
>  . ./common/dump
>  
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  #
> diff --git a/tests/xfs/055 b/tests/xfs/055
> index 8fe7d273d..80db71a4d 100755
> --- a/tests/xfs/055
> +++ b/tests/xfs/055
> @@ -24,7 +24,7 @@ _cleanup()
>  
>  _require_tape $RMT_TAPE_USER@$RMT_IRIXTAPE_DEV
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  _create_dumpdir_fill
> diff --git a/tests/xfs/056 b/tests/xfs/056
> index 18ff592b9..5d61ff6a6 100755
> --- a/tests/xfs/056
> +++ b/tests/xfs/056
> @@ -24,7 +24,7 @@ _cleanup()
>  . ./common/dump
>  
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  _create_dumpdir_fill_perm
> diff --git a/tests/xfs/059 b/tests/xfs/059
> index 7086dae8f..5f3c4c420 100755
> --- a/tests/xfs/059
> +++ b/tests/xfs/059
> @@ -25,7 +25,7 @@ _cleanup()
>  
>  _require_multi_stream
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  _create_dumpdir_fill_multi
> diff --git a/tests/xfs/060 b/tests/xfs/060
> index 0bafe69e9..cc94468e6 100755
> --- a/tests/xfs/060
> +++ b/tests/xfs/060
> @@ -25,7 +25,7 @@ _cleanup()
>  
>  _require_multi_stream
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  _create_dumpdir_fill_multi
> diff --git a/tests/xfs/061 b/tests/xfs/061
> index 69aaf5d9f..7f4c91bef 100755
> --- a/tests/xfs/061
> +++ b/tests/xfs/061
> @@ -23,7 +23,7 @@ _cleanup()
>  . ./common/dump
>  
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  # src/dumpfile based on dumping from
> diff --git a/tests/xfs/063 b/tests/xfs/063
> index 28dadf53f..33c10efec 100755
> --- a/tests/xfs/063
> +++ b/tests/xfs/063
> @@ -25,7 +25,7 @@ _cleanup()
>  
>  _require_attrs trusted user
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  # create files with EAs
> diff --git a/tests/xfs/064 b/tests/xfs/064
> index cbaee9594..1dbf4d9f9 100755
> --- a/tests/xfs/064
> +++ b/tests/xfs/064
> @@ -35,7 +35,7 @@ _ls_size_filter()
>  }
>  
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  _create_dumpdir_hardlinks 9
> diff --git a/tests/xfs/066 b/tests/xfs/066
> index 48183ae06..eeedcb5b1 100755
> --- a/tests/xfs/066
> +++ b/tests/xfs/066
> @@ -36,7 +36,7 @@ else
>  	_notrun "Installed libc doesn't correctly handle setrlimit/ftruncate64"
>  fi
>  
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  _create_dumpdir_largefile
>  echo "ls dumpdir/largefile"
> diff --git a/tests/xfs/068 b/tests/xfs/068
> index c6459ea77..5a89aace6 100755
> --- a/tests/xfs/068
> +++ b/tests/xfs/068
> @@ -27,7 +27,7 @@ _cleanup()
>  . ./common/dump
>  
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  _create_dumpdir_stress_num 4096
> diff --git a/tests/xfs/070 b/tests/xfs/070
> index 608afe688..d2bd7e2c4 100755
> --- a/tests/xfs/070
> +++ b/tests/xfs/070
> @@ -75,7 +75,6 @@ _require_scratch_nocheck
>  _require_command "$KILLALL_PROG" killall
>  
>  _scratch_mkfs | _filter_mkfs > /dev/null 2> $tmp.mkfs
> -test "${PIPESTATUS[0]}" -eq 0 || _fail "mkfs failed"
>  
>  . $tmp.mkfs # import agcount
>  
> diff --git a/tests/xfs/072 b/tests/xfs/072
> index a90938de5..7ba5ac3e9 100755
> --- a/tests/xfs/072
> +++ b/tests/xfs/072
> @@ -26,7 +26,7 @@ _require_xfs_io_command "falloc"
>  
>  _scratch_unmount >/dev/null 2>&1
>  
> -_scratch_mkfs_xfs >/dev/null	|| _fail "mkfs failed"
> +_scratch_mkfs_xfs >/dev/null
>  _scratch_mount
>  
>  # check there's enough freespace on $SCRATCH_MNT ... (1GiB + 1MiB)
> diff --git a/tests/xfs/077 b/tests/xfs/077
> index 301344d7a..4a4ac4702 100755
> --- a/tests/xfs/077
> +++ b/tests/xfs/077
> @@ -48,7 +48,7 @@ _fs_has_META_UUID()
>  	$XFS_DB_PROG -r -c version $FS | grep -q META_UUID
>  }
>  
> -_scratch_mkfs_xfs -m crc=1 >> $seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mkfs_xfs -m crc=1 >> $seqres.full 2>&1
>  
>  ORIG_UUID=`_scratch_xfs_db -c "uuid" | awk '{print $NF}'`
>  
> diff --git a/tests/xfs/090 b/tests/xfs/090
> index 0a3f13f45..dfc10d88b 100755
> --- a/tests/xfs/090
> +++ b/tests/xfs/090
> @@ -23,7 +23,7 @@ _filter_io()
>  _create_scratch()
>  {
>  	echo "*** mkfs"
> -	if ! _scratch_mkfs_xfs >$tmp.out 2>&1
> +	if ! _try_scratch_mkfs_xfs >$tmp.out 2>&1
>  	then
>  		cat $tmp.out
>  		echo "failed to mkfs $SCRATCH_DEV"
> diff --git a/tests/xfs/094 b/tests/xfs/094
> index f9cea67f9..be6a32430 100755
> --- a/tests/xfs/094
> +++ b/tests/xfs/094
> @@ -38,7 +38,7 @@ _filter_rtinherit_flag()
>  _create_scratch()
>  {
>  	echo "*** mkfs"
> -	if ! _scratch_mkfs_xfs >$tmp.out 2>&1
> +	if ! _try_scratch_mkfs_xfs >$tmp.out 2>&1
>  	then
>  		cat $tmp.out
>  		echo "failed to mkfs $SCRATCH_DEV"
> diff --git a/tests/xfs/103 b/tests/xfs/103
> index 72cb0e3ea..b42b6eeac 100755
> --- a/tests/xfs/103
> +++ b/tests/xfs/103
> @@ -15,7 +15,7 @@ _begin_fstest metadata dir ioctl auto quick
>  _create_scratch()
>  {
>  	echo "*** mkfs"
> -	if ! _scratch_mkfs_xfs >$tmp.out 2>&1
> +	if ! _try_scratch_mkfs_xfs >$tmp.out 2>&1
>  	then
>  		cat $tmp.out
>  		echo "failed to mkfs $SCRATCH_DEV"
> diff --git a/tests/xfs/121 b/tests/xfs/121
> index 0210a627c..8a376e90b 100755
> --- a/tests/xfs/121
> +++ b/tests/xfs/121
> @@ -23,8 +23,7 @@ rm -f $tmp.log
>  _require_scratch
>  
>  echo "mkfs"
> -_scratch_mkfs_xfs >>$seqres.full 2>&1 \
> -    || _fail "mkfs scratch failed"
> +_scratch_mkfs_xfs >>$seqres.full 2>&1
>  
>  echo "mount"
>  _scratch_mount
> diff --git a/tests/xfs/153 b/tests/xfs/153
> index 10ce15117..2ce22b8c4 100755
> --- a/tests/xfs/153
> +++ b/tests/xfs/153
> @@ -73,7 +73,7 @@ _filter_and_check_blks()
>  
>  run_tests()
>  {
> -	_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
> +	_try_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
>  	cat $tmp.mkfs >>$seqres.full
>  
>  	# keep the blocksize and data size for dd later
> diff --git a/tests/xfs/168 b/tests/xfs/168
> index e8e61dbfa..f187a336f 100755
> --- a/tests/xfs/168
> +++ b/tests/xfs/168
> @@ -18,7 +18,7 @@ _begin_fstest auto growfs shrinkfs ioctl prealloc stress
>  
>  create_scratch()
>  {
> -	_scratch_mkfs_xfs $@ | tee -a $seqres.full | \
> +	_try_scratch_mkfs_xfs $@ | tee -a $seqres.full | \
>  		_filter_mkfs 2>$tmp.mkfs >/dev/null
>  	. $tmp.mkfs
>  
> @@ -46,7 +46,7 @@ stress_scratch()
>  _require_scratch_xfs_shrink
>  _require_xfs_io_command "falloc"
>  
> -_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs >/dev/null
> +_try_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs >/dev/null
>  . $tmp.mkfs	# extract blocksize and data size for scratch device
>  
>  endsize=`expr 125 \* 1048576`	# stop after shrinking this big
> diff --git a/tests/xfs/178 b/tests/xfs/178
> index e7d1cb0e0..0cc0e3f5b 100755
> --- a/tests/xfs/178
> +++ b/tests/xfs/178
> @@ -52,7 +52,6 @@ _dd_repair_check()
>  _require_scratch
>  _scratch_xfs_force_no_metadir
>  _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
> -test "${PIPESTATUS[0]}" -eq 0 || _fail "mkfs failed!"
>  
>  # By executing the followint tmp file, will get on the mkfs options stored in
>  # variables
> @@ -61,7 +60,7 @@ test "${PIPESTATUS[0]}" -eq 0 || _fail "mkfs failed!"
>  # if the default agcount is too small, bump it up and re-mkfs before testing
>  if [ $agcount -lt 8 ]; then
>  	agcount=8
> -	_scratch_mkfs_xfs -dagcount=$agcount >/dev/null 2>&1 \
> +	_try_scratch_mkfs_xfs -dagcount=$agcount >/dev/null 2>&1 \
>  	        || _notrun "Test requires at least 8 AGs."
>  fi
>  
> @@ -69,8 +68,7 @@ _dd_repair_check $SCRATCH_DEV $sectsz
>  
>  # smaller AGCOUNT
>  let "agcount=$agcount-2"
> -_scratch_mkfs_xfs -dagcount=$agcount >/dev/null 2>&1 \
> -        || _fail "mkfs failed!"
> +_scratch_mkfs_xfs -dagcount=$agcount >/dev/null 2>&1
>  
>  _dd_repair_check $SCRATCH_DEV $sectsz
>  
> diff --git a/tests/xfs/181 b/tests/xfs/181
> index a20f412f9..f7c986703 100755
> --- a/tests/xfs/181
> +++ b/tests/xfs/181
> @@ -32,8 +32,7 @@ rm -f $tmp.log
>  _require_scratch
>  
>  echo "mkfs"
> -_scratch_mkfs_xfs >>$seqres.full 2>&1 \
> -    || _fail "mkfs scratch failed"
> +_scratch_mkfs_xfs >>$seqres.full 2>&1
>  
>  echo "mount"
>  _scratch_mount
> diff --git a/tests/xfs/183 b/tests/xfs/183
> index 7b0abdc14..cb12fff90 100755
> --- a/tests/xfs/183
> +++ b/tests/xfs/183
> @@ -18,8 +18,7 @@ _begin_fstest rw other auto quick
>  
>  # Setup Filesystem
>  _require_scratch
> -_scratch_mkfs_xfs >/dev/null 2>&1 \
> -        || _fail "mkfs failed"
> +_scratch_mkfs_xfs >/dev/null 2>&1
>  
>  _scratch_mount
>  
> diff --git a/tests/xfs/202 b/tests/xfs/202
> index 6708a6ed7..4f27e738e 100755
> --- a/tests/xfs/202
> +++ b/tests/xfs/202
> @@ -24,8 +24,7 @@ _require_scratch_nocheck
>  # a single AG filesystem.
>  #
>  echo "== Creating single-AG filesystem =="
> -_scratch_mkfs_xfs -d agcount=1 -d size=$((1024*1024*1024)) >/dev/null 2>&1 \
> - || _fail "!!! failed to make filesystem with single AG"
> +_scratch_mkfs_xfs -d agcount=1 -d size=$((1024*1024*1024)) >/dev/null 2>&1
>  
>  echo "== Trying to repair it (should fail) =="
>  _scratch_xfs_repair
> diff --git a/tests/xfs/244 b/tests/xfs/244
> index 8a6337bd1..8d8bb9043 100755
> --- a/tests/xfs/244
> +++ b/tests/xfs/244
> @@ -29,7 +29,7 @@ _require_projid16bit
>  export MOUNT_OPTIONS="-opquota"
>  
>  # make fs with no projid32bit
> -_scratch_mkfs_xfs -i projid32bit=0 >> $seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs -i projid32bit=0 >> $seqres.full
>  _qmount
>  # make sure project quota is supported
>  _require_prjquota ${SCRATCH_DEV}
> @@ -73,7 +73,7 @@ fi
>  
>  #  Do testing on filesystem with projid32bit feature enabled
>  _scratch_unmount 2>/dev/null
> -_scratch_mkfs_xfs -i projid32bit=1 >> $seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs -i projid32bit=1 >> $seqres.full
>  _qmount
>  mkdir $dir
>  
> diff --git a/tests/xfs/266 b/tests/xfs/266
> index 8c5cc4683..3d0fd61b7 100755
> --- a/tests/xfs/266
> +++ b/tests/xfs/266
> @@ -55,7 +55,7 @@ if [ $? -ne 0 ]; then
>      _notrun "requires xfsdump -D"
>  fi
>  
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  _create_dumpdir_fill
>  # ensure file/dir timestamps precede dump timestamp
> diff --git a/tests/xfs/267 b/tests/xfs/267
> index ca1b0fa20..94fff638e 100755
> --- a/tests/xfs/267
> +++ b/tests/xfs/267
> @@ -46,7 +46,7 @@ End-of-File
>  _require_tape $TAPE_DEV
>  _require_attrs trusted
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  _create_files
> diff --git a/tests/xfs/268 b/tests/xfs/268
> index 0ddb40a50..e9896316b 100755
> --- a/tests/xfs/268
> +++ b/tests/xfs/268
> @@ -49,7 +49,7 @@ End-of-File
>  _require_tape $TAPE_DEV
>  _require_attrs trusted user
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  _create_files
> diff --git a/tests/xfs/281 b/tests/xfs/281
> index 43f6333b3..c31d34814 100755
> --- a/tests/xfs/281
> +++ b/tests/xfs/281
> @@ -22,7 +22,7 @@ _cleanup()
>  
>  _require_legacy_v2_format
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  _create_dumpdir_fill
> diff --git a/tests/xfs/282 b/tests/xfs/282
> index 4a9c53db5..bf75a01af 100755
> --- a/tests/xfs/282
> +++ b/tests/xfs/282
> @@ -24,7 +24,7 @@ _cleanup()
>  
>  _require_legacy_v2_format
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  _create_dumpdir_fill
> diff --git a/tests/xfs/283 b/tests/xfs/283
> index 8124807f4..94cb5721e 100755
> --- a/tests/xfs/283
> +++ b/tests/xfs/283
> @@ -24,7 +24,7 @@ _cleanup()
>  
>  _require_legacy_v2_format
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  _create_dumpdir_fill
> diff --git a/tests/xfs/287 b/tests/xfs/287
> index 3d6800a95..4537b040f 100755
> --- a/tests/xfs/287
> +++ b/tests/xfs/287
> @@ -35,8 +35,7 @@ _require_projid32bit
>  _require_projid16bit
>  
>  # create xfs fs without projid32bit ability, will be gained by xfs_admin
> -_scratch_mkfs_xfs -i projid32bit=0 -d size=200m >> $seqres.full \
> -		|| _fail "mkfs failed"
> +_scratch_mkfs_xfs -i projid32bit=0 -d size=200m >> $seqres.full
>  _qmount_option "pquota"
>  _qmount
>  # require project quotas
> diff --git a/tests/xfs/296 b/tests/xfs/296
> index befbf9dfb..306751bad 100755
> --- a/tests/xfs/296
> +++ b/tests/xfs/296
> @@ -26,7 +26,7 @@ _cleanup()
>  _require_scratch
>  _require_command "$SETCAP_PROG" setcap
>  _require_command "$GETCAP_PROG" getcap
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  mkdir -p $dump_dir
> diff --git a/tests/xfs/300 b/tests/xfs/300
> index c0b713f0d..3f0dbb9ac 100755
> --- a/tests/xfs/300
> +++ b/tests/xfs/300
> @@ -20,8 +20,7 @@ _require_xfs_nocrc
>  getenforce | grep -q "Enforcing\|Permissive" || _notrun "SELinux not enabled"
>  [ "$XFS_FSR_PROG" = "" ] && _notrun "xfs_fsr not found"
>  
> -_scratch_mkfs_xfs -m crc=0 -i size=256 >> $seqres.full 2>&1 \
> -			|| _fail "mkfs failed"
> +_scratch_mkfs_xfs -m crc=0 -i size=256 >> $seqres.full 2>&1
>  
>  # Manually mount to avoid fs-wide context set by default in xfstests
>  mount $SCRATCH_DEV $SCRATCH_MNT
> diff --git a/tests/xfs/301 b/tests/xfs/301
> index 986baf29b..cbf273cfa 100755
> --- a/tests/xfs/301
> +++ b/tests/xfs/301
> @@ -25,7 +25,7 @@ _cleanup()
>  
>  # Modify as appropriate.
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  # Extended attributes
> diff --git a/tests/xfs/302 b/tests/xfs/302
> index 525a72ff8..8a9213fad 100755
> --- a/tests/xfs/302
> +++ b/tests/xfs/302
> @@ -24,7 +24,7 @@ _cleanup()
>  
>  # Modify as appropriate.
>  _require_scratch
> -_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mkfs_xfs >>$seqres.full
>  _scratch_mount
>  
>  echo "Silence is golden."
> diff --git a/tests/xfs/306 b/tests/xfs/306
> index e21a56220..8981cbd72 100755
> --- a/tests/xfs/306
> +++ b/tests/xfs/306
> @@ -30,8 +30,7 @@ unset SCRATCH_RTDEV
>  
>  # Create a small fs with a large directory block size. We want to fill up the fs
>  # quickly and then create multi-fsb dirblocks over fragmented free space.
> -_scratch_mkfs_xfs -d size=100m -n size=64k >> $seqres.full 2>&1 || \
> -	_notrun 'could not format tiny scratch fs'
> +_scratch_mkfs_xfs -d size=100m -n size=64k >> $seqres.full 2>&1
>  _scratch_mount
>  
>  # Fill a source directory with many largish-named files. 1k uuid-named entries
> diff --git a/tests/xfs/445 b/tests/xfs/445
> index c31b134b8..0ea85ad01 100755
> --- a/tests/xfs/445
> +++ b/tests/xfs/445
> @@ -45,8 +45,7 @@ _check_filestreams_support || _notrun "filestreams not available"
>  unset SCRATCH_RTDEV
>  
>  # use small AGs for frequent stream switching
> -_scratch_mkfs_xfs -d agsize=20m,size=2g >> $seqres.full 2>&1 ||
> -	_fail "mkfs failed"
> +_scratch_mkfs_xfs -d agsize=20m,size=2g >> $seqres.full 2>&1
>  _scratch_mount "-o filestreams"
>  
>  # start background inode reclaim
> diff --git a/tests/xfs/448 b/tests/xfs/448
> index 88efe2d18..fbd1af383 100755
> --- a/tests/xfs/448
> +++ b/tests/xfs/448
> @@ -33,7 +33,6 @@ rm -f "$seqres.full"
>  
>  # Format and mount
>  _scratch_mkfs | _filter_mkfs > $seqres.full 2> $tmp.mkfs
> -test "${PIPESTATUS[0]}" -eq 0 || _fail "mkfs failed"
>  _scratch_mount
>  
>  # Get directory block size
> diff --git a/tests/xfs/520 b/tests/xfs/520
> index 3895db3a2..3734d8746 100755
> --- a/tests/xfs/520
> +++ b/tests/xfs/520
> @@ -34,7 +34,7 @@ _require_scratch_nocheck
>  unset USE_EXTERNAL
>  
>  force_crafted_metadata() {
> -	_scratch_mkfs_xfs -f $fsdsopt "$4" >> $seqres.full 2>&1 || _fail "mkfs failed"
> +	_scratch_mkfs_xfs -f $fsdsopt "$4" >> $seqres.full 2>&1
>  	_scratch_xfs_set_metadata_field "$1" "$2" "$3" >> $seqres.full 2>&1
>  	local kmsg="xfs/$seq: testing $1=$2 at $(date +"%F %T")"
>  	local mounted=0
> diff --git a/tests/xfs/596 b/tests/xfs/596
> index 21cce047c..12c38c2e9 100755
> --- a/tests/xfs/596
> +++ b/tests/xfs/596
> @@ -39,7 +39,6 @@ _do_die_on_error=message_only
>  rtsize=32
>  echo -n "Make $rtsize megabyte rt filesystem on SCRATCH_DEV and mount... "
>  _scratch_mkfs_xfs -rsize=${rtsize}m | _filter_mkfs 2> "$tmp.mkfs" >> $seqres.full
> -test "${PIPESTATUS[0]}" -eq 0 || _fail "mkfs failed"
>  
>  . $tmp.mkfs
>  onemeginblocks=`expr 1048576 / $dbsize`
> -- 
> 2.43.0
> 
> 


