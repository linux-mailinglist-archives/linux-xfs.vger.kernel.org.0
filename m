Return-Path: <linux-xfs+bounces-14634-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BEF829AF7C2
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Oct 2024 04:57:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2B941C21D01
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Oct 2024 02:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AA8C18A95D;
	Fri, 25 Oct 2024 02:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EIh3KcDu"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BC918BB84
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 02:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729825024; cv=none; b=ZjVQAKZBkvt0tFhDPCyljzw6y8guFrd322kE0hOvsn0FkXER3N5N20FZo1LeDCPV/pVcbHXqriQaUqqHaOHW5JR0A2J0jCjh7YtV9zEbWwztJZG79k6z9NHTwX6KHGitF76ocYbTZFqK9pAxe6Pzrk6bLaNQVUB8wYHsBr0ePbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729825024; c=relaxed/simple;
	bh=QkACfeFBx+I3qySlFSUTlZ/njQy6u+B98pXhxXYVm/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IluSFNq05z5OTMwUpGK8Z4ATBtsaT3qTC82+lrnQTIANM5DaVJ96r+3OZdCCDFV4p4NWvclO7Ayme3YEM5kES2d4hOR5RV8adLW8UoP+NDSSOl6W09f4N3GQUQE4Y8Mrt30upOIdPNP9/CXICDg5M7G9XiljZu/6qBq10xCFPsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EIh3KcDu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729825020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8UHff/EyTmoZg0kmavC/tExlcMWqKizkzXldFqApwD0=;
	b=EIh3KcDufY+caj7LDNPYtijdGcWc+a4drXetjpc25WyxJ2dYi0edABBj1jAsLZTTDDgYyW
	tlqaTHDd9ITeiOis58s4zURekrEHryNedZQ0sr+zHCU0u065vwHL2I7ZrOyFMzDFssR6Jf
	HCcfvAb2OVGV4T9r1iVQNGr/hdmH/Sk=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-68q48A9fPASunIMZ9RS2JA-1; Thu, 24 Oct 2024 22:56:58 -0400
X-MC-Unique: 68q48A9fPASunIMZ9RS2JA-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2e2d396c77fso1774328a91.2
        for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2024 19:56:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729825018; x=1730429818;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8UHff/EyTmoZg0kmavC/tExlcMWqKizkzXldFqApwD0=;
        b=kaWKEbCqByZuvxhtxjuxptpPRamr6PwVgamQA4PuK6C7l8I3YNEHGTtvpLpjtWHNp2
         I+XXEa/9GC6h1KLzb8gNopRwZ9Y3mco+gOCNthP8GSTS2vUN2c/LjZFtZIvLzeqO13TQ
         Trd/ILUNpHfIKSgitflfV2bKIXTlGYGozFFTo44aM7J0sujO/zmfBpoAViegQhm5Huer
         uSbVV5tloyZ0zSMS1/pknnPG/KQtxnWhelPpSVqCgATxe0ZxVlrhPCCF3aQH4dJrKYDf
         bztmEMGesyarymRsT+UKwdoZQr/xRHGmjRTkQb+iiKwbuvF/68VCk9TCV0t2izi/jjpR
         XX/w==
X-Forwarded-Encrypted: i=1; AJvYcCUfDaiGYnIiA6jCmNp2Zyq1oQXRF+MJkEMZI2piMpj+FBJsuPQi33lQndb3NF5xhpTIy68bJICHzkc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk/dLdlieJXoqcAerQvN7Q6oxctFt/wNOtYgQln/tkcewRgN+x
	As0OAvezcLWbsa2twmZCCa27slDuVOa8v/BBpk7SXQJefMUYR7NoX5NCKwvxEVlLXSJXhoCMKgu
	T6T6X/WT7mBz2M6YvypHYUAY9fjM53Ea3B8/IiMOqOhNSLb7iN7BAsFwLjg==
X-Received: by 2002:a17:90b:390c:b0:2e2:b204:90c8 with SMTP id 98e67ed59e1d1-2e76b704a80mr9052707a91.34.1729825017817;
        Thu, 24 Oct 2024 19:56:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPY7d8j4Tzb3Ou4jwwXiPijsWHHk7FnEJVWhatTWexAqRlAmd59sltTz+ydRVnn6fKczQ7GA==
X-Received: by 2002:a17:90b:390c:b0:2e2:b204:90c8 with SMTP id 98e67ed59e1d1-2e76b704a80mr9052696a91.34.1729825017464;
        Thu, 24 Oct 2024 19:56:57 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e77e59d826sm2256453a91.52.2024.10.24.19.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 19:56:57 -0700 (PDT)
Date: Fri, 25 Oct 2024 10:56:51 +0800
From: Zorro Lang <zlang@redhat.com>
To: Nirjhar Roy <nirjhar@linux.ibm.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org
Subject: Re: [PATCH 1/2] common/xfs,xfs/207: Adding a common helper function
 to check xflag bits on a given file
Message-ID: <20241025025651.okneano7d324nl4e@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1729624806.git.nirjhar@linux.ibm.com>
 <6ba7f682af7e0bc99a8baeccc0d7aa4e5062a433.1729624806.git.nirjhar@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ba7f682af7e0bc99a8baeccc0d7aa4e5062a433.1729624806.git.nirjhar@linux.ibm.com>

On Wed, Oct 23, 2024 at 12:56:19AM +0530, Nirjhar Roy wrote:
> This patch defines a common helper function to test whether any of
> fsxattr xflags field is set or not. We will use this helper in the next
> patch for checking extsize (e) flag.
> 
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Signed-off-by: Nirjhar Roy <nirjhar@linux.ibm.com>
> ---
>  common/xfs    |  9 +++++++++
>  tests/xfs/207 | 14 +++-----------
>  2 files changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/common/xfs b/common/xfs
> index 62e3100e..7340ccbf 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -13,6 +13,15 @@ __generate_xfs_report_vars() {
>  	REPORT_ENV_LIST_OPT+=("TEST_XFS_REPAIR_REBUILD" "TEST_XFS_SCRUB_REBUILD")
>  }
>  
> +# Check whether a fsxattr xflags character field is set on a given file.

Better to explain the arguments, e.g.

# Check whether a fsxattr xflags character ($2) field is set on a given file ($1).

> +# e.g. fsxattr.xflags = 0x0 [--------------C-]
> +# Returns 0 if passed flag character is set, otherwise returns 1
> +_test_xfs_xflags_field()
> +{
> +    $XFS_IO_PROG -c "stat" "$1" | grep "fsxattr.xflags" | grep -q "\[.*$2.*\]" \
> +        && return 0 || return 1

That's too complex. Those "return" aren't needed as Darrick metioned. About
that two "grep", how about combine them, e.g.

_test_xfs_xflags_field()
{
	grep -q "fsxattr.xflags.*\[.*$2.*\]" <($XFS_IO_PROG -c "stat" "$1")
}



> +}
> +
>  _setup_large_xfs_fs()
>  {
>  	fs_size=$1
> diff --git a/tests/xfs/207 b/tests/xfs/207
> index bbe21307..adb925df 100755
> --- a/tests/xfs/207
> +++ b/tests/xfs/207
> @@ -15,21 +15,13 @@ _begin_fstest auto quick clone fiemap
>  # Import common functions.
>  . ./common/filter
>  . ./common/reflink
> +. ./common/xfs

Is this really necessary? Will this test fail without this line?
The common/$FSTYP file is imported automatically, if it's not, that a bug.

Thanks,
Zorro

>  
>  _require_scratch_reflink
>  _require_cp_reflink
>  _require_xfs_io_command "fiemap"
>  _require_xfs_io_command "cowextsize"
>  
> -# Takes the fsxattr.xflags line,
> -# i.e. fsxattr.xflags = 0x0 [--------------C-]
> -# and tests whether a flag character is set
> -test_xflag()
> -{
> -    local flg=$1
> -    grep -q "\[.*${flg}.*\]" && echo "$flg flag set" || echo "$flg flag unset"
> -}
> -
>  echo "Format and mount"
>  _scratch_mkfs > $seqres.full 2>&1
>  _scratch_mount >> $seqres.full 2>&1
> @@ -65,14 +57,14 @@ echo "Set cowextsize and check flag"
>  $XFS_IO_PROG -c "cowextsize 1048576" $testdir/file3 | _filter_scratch
>  _scratch_cycle_mount
>  
> -$XFS_IO_PROG -c "stat" $testdir/file3 | grep 'fsxattr.xflags' | test_xflag "C"
> +_test_xfs_xflags_field "$testdir/file3" "C" && echo "C flag set" || echo "C flag unset"
>  $XFS_IO_PROG -c "cowextsize" $testdir/file3 | _filter_scratch
>  
>  echo "Unset cowextsize and check flag"
>  $XFS_IO_PROG -c "cowextsize 0" $testdir/file3 | _filter_scratch
>  _scratch_cycle_mount
>  
> -$XFS_IO_PROG -c "stat" $testdir/file3 | grep 'fsxattr.xflags' | test_xflag "C"
> +_test_xfs_xflags_field "$testdir/file3" "C" && echo "C flag set" || echo "C flag unset"
>  $XFS_IO_PROG -c "cowextsize" $testdir/file3 | _filter_scratch
>  
>  status=0
> -- 
> 2.43.5
> 
> 


