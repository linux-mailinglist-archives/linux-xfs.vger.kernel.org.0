Return-Path: <linux-xfs+bounces-2445-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87FF78220C8
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jan 2024 19:10:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 879831C228A9
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jan 2024 18:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A6D2156DA;
	Tue,  2 Jan 2024 18:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VsmMofMd"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF3F156CB;
	Tue,  2 Jan 2024 18:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DC0C433C7;
	Tue,  2 Jan 2024 18:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704219030;
	bh=Jm0xIsMKfbJBY50vtODW6Wnl3LtBjvCuagNsi5YuUa0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VsmMofMdAhHHRpXElHEgx911tNSj6tO6Q2IeJ1fc4G2IVVk0V5TklyBshMNdsSjCj
	 zL1yCXybIembvIqh3fBVfiWE2r+VhQtosAxMXxUjW37u1EQAnWtbf2V87gMyTY68AG
	 iQ9KiA+lks85vhZe0SQcqPjuYFh/EU6HRXBRSlFxd6n2tmDHIwi/POcenDfBcbxs06
	 5RrvHnMW15y+GNKdMqXd01avX89lkpVtUZ+iELnc58E/JZUUJpnHjukCr4atzPOU5E
	 NL4KZuVeS2AOWolcGl9RzE556ZR2YyH5i0Or7ARtieyAoRqmTE5g/b5lgPJrS8wGIC
	 3aM/yN2wz5f0Q==
Date: Tue, 2 Jan 2024 10:10:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH 1/5] common/xfs: Do not append -a and -o options to
 metadump
Message-ID: <20240102181029.GD108281@frogsfrogsfrogs>
References: <20240102084357.1199843-1-chandanbabu@kernel.org>
 <20240102084357.1199843-2-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240102084357.1199843-2-chandanbabu@kernel.org>

On Tue, Jan 02, 2024 at 02:13:48PM +0530, Chandan Babu R wrote:
> xfs/253 requires the metadump to be obfuscated. However _xfs_metadump() would
> append the '-o' option causing the metadump to be unobfuscated.
> 
> This commit fixes the bug by modifying _xfs_metadump() to no longer append any
> metadump options. The direct/indirect callers of this function now pass the
> required options explicitly.
> 
> Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
> ---
>  common/populate | 2 +-
>  common/xfs      | 7 +++----
>  tests/xfs/291   | 2 +-
>  tests/xfs/336   | 2 +-
>  tests/xfs/432   | 2 +-
>  tests/xfs/503   | 2 +-

Hmm.  Shouldn't "-a -o" be lowered into xfs/168?  It generates a
metadump if a post-shrinkfs repair fails and someone needs to debug the
resulting breakage.

I think that in general, tests should be using -a (copy entire fs
blocks) and -o (do not obfuscate) to reduce the amount of processing
that fstests has to do; and to make it easy for developers to examine
the fs metadata.

(Also given the number of bugs that we keep finding in the "zero unused
parts of blocks" code, I almost always use -a to reduce the number of
pieces that can fail.)

Obviously that does not apply to tests that are exercising metadump
itself.

--D

>  6 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/common/populate b/common/populate
> index 3d233073..cfbfd88a 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -55,7 +55,7 @@ __populate_fail() {
>  	case "$FSTYP" in
>  	xfs)
>  		_scratch_unmount
> -		_scratch_xfs_metadump "$metadump"
> +		_scratch_xfs_metadump "$metadump" -a -o
>  		;;
>  	ext4)
>  		_scratch_unmount
> diff --git a/common/xfs b/common/xfs
> index f53b33fc..38094828 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -667,7 +667,6 @@ _xfs_metadump() {
>  	local compressopt="$4"
>  	shift; shift; shift; shift
>  	local options="$@"
> -	test -z "$options" && options="-a -o"
>  
>  	if [ "$logdev" != "none" ]; then
>  		options="$options -l $logdev"
> @@ -855,7 +854,7 @@ _check_xfs_filesystem()
>  	if [ "$ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
>  		local flatdev="$(basename "$device")"
>  		_xfs_metadump "$seqres.$flatdev.check.md" "$device" "$logdev" \
> -			compress >> $seqres.full
> +			compress -a -o >> $seqres.full
>  	fi
>  
>  	# Optionally test the index rebuilding behavior.
> @@ -888,7 +887,7 @@ _check_xfs_filesystem()
>  		if [ "$rebuild_ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
>  			local flatdev="$(basename "$device")"
>  			_xfs_metadump "$seqres.$flatdev.rebuild.md" "$device" \
> -				"$logdev" compress >> $seqres.full
> +				"$logdev" compress -a -o >> $seqres.full
>  		fi
>  	fi
>  
> @@ -972,7 +971,7 @@ _check_xfs_filesystem()
>  		if [ "$orebuild_ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
>  			local flatdev="$(basename "$device")"
>  			_xfs_metadump "$seqres.$flatdev.orebuild.md" "$device" \
> -				"$logdev" compress >> $seqres.full
> +				"$logdev" compress -a -o >> $seqres.full
>  		fi
>  	fi
>  
> diff --git a/tests/xfs/291 b/tests/xfs/291
> index 600dcb2e..54448497 100755
> --- a/tests/xfs/291
> +++ b/tests/xfs/291
> @@ -92,7 +92,7 @@ _scratch_xfs_check >> $seqres.full 2>&1 || _fail "xfs_check failed"
>  
>  # Yes they can!  Now...
>  # Can xfs_metadump cope with this monster?
> -_scratch_xfs_metadump $tmp.metadump || _fail "xfs_metadump failed"
> +_scratch_xfs_metadump $tmp.metadump -a -o || _fail "xfs_metadump failed"
>  SCRATCH_DEV=$tmp.img _scratch_xfs_mdrestore $tmp.metadump || _fail "xfs_mdrestore failed"
>  SCRATCH_DEV=$tmp.img _scratch_xfs_repair -f &>> $seqres.full || \
>  	_fail "xfs_repair of metadump failed"
> diff --git a/tests/xfs/336 b/tests/xfs/336
> index d7a074d9..43b3790c 100755
> --- a/tests/xfs/336
> +++ b/tests/xfs/336
> @@ -62,7 +62,7 @@ _scratch_cycle_mount
>  
>  echo "Create metadump file"
>  _scratch_unmount
> -_scratch_xfs_metadump $metadump_file
> +_scratch_xfs_metadump $metadump_file -a
>  
>  # Now restore the obfuscated one back and take a look around
>  echo "Restore metadump"
> diff --git a/tests/xfs/432 b/tests/xfs/432
> index 66315b03..dae68fb2 100755
> --- a/tests/xfs/432
> +++ b/tests/xfs/432
> @@ -86,7 +86,7 @@ echo "qualifying extent: $extlen blocks" >> $seqres.full
>  test -n "$extlen" || _notrun "could not create dir extent > 1000 blocks"
>  
>  echo "Try to metadump"
> -_scratch_xfs_metadump $metadump_file -w
> +_scratch_xfs_metadump $metadump_file -a -o -w
>  SCRATCH_DEV=$metadump_img _scratch_xfs_mdrestore $metadump_file
>  
>  echo "Check restored metadump image"
> diff --git a/tests/xfs/503 b/tests/xfs/503
> index f5710ece..8805632d 100755
> --- a/tests/xfs/503
> +++ b/tests/xfs/503
> @@ -46,7 +46,7 @@ metadump_file_ag=${metadump_file}.ag
>  copy_file=$testdir/copy.img
>  
>  echo metadump
> -_scratch_xfs_metadump $metadump_file >> $seqres.full
> +_scratch_xfs_metadump $metadump_file -a -o >> $seqres.full
>  
>  echo metadump a
>  _scratch_xfs_metadump $metadump_file_a -a >> $seqres.full
> -- 
> 2.43.0
> 
> 

