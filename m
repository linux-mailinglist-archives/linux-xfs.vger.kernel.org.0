Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578CE58AEA3
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Aug 2022 19:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240575AbiHERJJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Aug 2022 13:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237268AbiHERJJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Aug 2022 13:09:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F93472EE0
        for <linux-xfs@vger.kernel.org>; Fri,  5 Aug 2022 10:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659719347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r5W15z17AzoYxP/ni8JAfiKh3GiNFy5l7z/vSQgPe6A=;
        b=QOhY8tz00ADktMcY62N+8WQFS848EcR1fMsqT5lomrtZxf8KFG77xL9DvwdhTjzqM/reyg
        lYufpZvueVcShVP6mSWoroqO8ugVuHg5SgsS80DTRmLFvFJJApL/AsNH/5G3bVZYS7LSdJ
        w9b+bUqMb9QZomi9Wq6EWre8XEGSP70=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232--fhnpuhkOSyQm-7MoKyo3A-1; Fri, 05 Aug 2022 13:09:06 -0400
X-MC-Unique: -fhnpuhkOSyQm-7MoKyo3A-1
Received: by mail-qk1-f198.google.com with SMTP id n15-20020a05620a294f00b006b5768a0ed0so2405249qkp.7
        for <linux-xfs@vger.kernel.org>; Fri, 05 Aug 2022 10:09:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r5W15z17AzoYxP/ni8JAfiKh3GiNFy5l7z/vSQgPe6A=;
        b=lmW7a+DBjRsdBKXhSJuZVoGSZFy8aLPGUlvaIkvrHJkJqw5yhGijYLldY/S5thsFT4
         mlK78mc538cZu5zQW5b8SjCVqJs7+Z18/ehHh2uz6fwXoUpT0LqtDB4YBu6p57iEkhgJ
         M0CM/Qz9oRxYiPqKm6Tm9vB7I7TdNa069Sr7LRC0B/Wdi4Ac9H3I6409v9bZgPNyil3T
         cxOi9Xxp8kgp9XnDo823fVeVSWY0oFVhUVbpqDxSliwt3uuDDhvYNn3f987QGKgr6i9j
         pCOOjzTfemWsqhYdOjoC8TCyCMynG/dfuH/0A3NxOTLeH7ZToZl08wPVaRiWSf0qndjN
         NW9Q==
X-Gm-Message-State: ACgBeo3mST7tFQRZlEvQQG/hz4xV7d1WNwdyfNdStfXUMDZRfi36It2u
        2UkH0kCBHFHHRF/4zghhRBL21ENA70iFSE4CA/tfchDJxD2c0IITOtO8hf5JA9FhUulqtp5vO1V
        n3OUsOvA/oEItw/gwLa4m
X-Received: by 2002:a0c:9d46:0:b0:476:ff07:3fe7 with SMTP id n6-20020a0c9d46000000b00476ff073fe7mr6613721qvf.15.1659719345487;
        Fri, 05 Aug 2022 10:09:05 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7SGAsAp5S0tI0cjBQT5M9dteYX2aKog3Zhcsme6d1n+pmQikMyOMQ/NeozoNAYhuCGzwvx8w==
X-Received: by 2002:a0c:9d46:0:b0:476:ff07:3fe7 with SMTP id n6-20020a0c9d46000000b00476ff073fe7mr6613688qvf.15.1659719344988;
        Fri, 05 Aug 2022 10:09:04 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v19-20020a05620a441300b006b5f7d0d0b6sm3449126qkp.4.2022.08.05.10.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 10:09:04 -0700 (PDT)
Date:   Sat, 6 Aug 2022 01:08:58 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH v1.3 3/3] common/ext4: provide custom ext4 scratch fs
 options
Message-ID: <20220805170858.bxpnzplbgrrlouha@zlang-mailbox>
References: <165950050051.198922.13423077997881086438.stgit@magnolia>
 <165950051745.198922.6487109955066878945.stgit@magnolia>
 <YuvzzdisuzXKVlJK@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuvzzdisuzXKVlJK@magnolia>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 04, 2022 at 09:29:01AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a _scratch_options backend for ext* so that we can inject
> pathnames to external log devices into the scratch fs mount options.
> This enables common/dm* to install block device filters, e.g. dm-error
> for stress testing.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> v1.1: bad at counting
> v1.2: refactor _scratch_mkfs_ext4 to use _scratch_options too
> v1.3: quiet down realpath usage when SCRATCH_LOGDEV is unset

I think you'd like move these 3 change log lines after the "---" ?

As usual, I'm going to give this patchset enough testing before merging
it, due to it affect ext4 testing too much. And hope to get review from
ext4 list, or "no objection" means all good by default :)

Thanks,
Zorro

> ---
>  common/ext4 |   35 ++++++++++++++++++++++++++++++++---
>  common/rc   |    3 +++
>  2 files changed, 35 insertions(+), 3 deletions(-)
> 
> diff --git a/common/ext4 b/common/ext4
> index 287705af..f2df888c 100644
> --- a/common/ext4
> +++ b/common/ext4
> @@ -63,16 +63,24 @@ _setup_large_ext4_fs()
>  	return 0
>  }
>  
> +_scratch_mkfs_ext4_opts()
> +{
> +	mkfs_opts=$*
> +
> +	_scratch_options mkfs
> +
> +	echo "$MKFS_EXT4_PROG $SCRATCH_OPTIONS $mkfs_opts"
> +}
> +
>  _scratch_mkfs_ext4()
>  {
> -	local mkfs_cmd="$MKFS_EXT4_PROG -F"
> +	local mkfs_cmd="`_scratch_mkfs_ext4_opts`"
>  	local mkfs_filter="grep -v -e ^Warning: -e \"^mke2fs \" | grep -v \"^$\""
>  	local tmp=`mktemp -u`
>  	local mkfs_status
>  
>  	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> -	    $mkfs_cmd -O journal_dev $MKFS_OPTIONS $SCRATCH_LOGDEV && \
> -	    mkfs_cmd="$mkfs_cmd -J device=$SCRATCH_LOGDEV"
> +	    $MKFS_EXT4_PROG -F -O journal_dev $MKFS_OPTIONS $SCRATCH_LOGDEV
>  
>  	_scratch_do_mkfs "$mkfs_cmd" "$mkfs_filter" $* 2>$tmp.mkfserr 1>$tmp.mkfsstd
>  	mkfs_status=$?
> @@ -154,3 +162,24 @@ _require_scratch_richacl_ext4()
>  		|| _notrun "kernel doesn't support richacl feature on $FSTYP"
>  	_scratch_unmount
>  }
> +
> +_scratch_ext4_options()
> +{
> +	local type=$1
> +	local log_opt=""
> +
> +	case $type in
> +	mkfs)
> +		SCRATCH_OPTIONS="$SCRATCH_OPTIONS -F"
> +		log_opt="-J device=$SCRATCH_LOGDEV"
> +		;;
> +	mount)
> +		# As of kernel 5.19, the kernel mount option path parser only
> +		# accepts direct paths to block devices--the final path
> +		# component cannot be a symlink.
> +		log_opt="-o journal_path=$(realpath -q "$SCRATCH_LOGDEV")"
> +		;;
> +	esac
> +	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> +		SCRATCH_OPTIONS="$SCRATCH_OPTIONS ${log_opt}"
> +}
> diff --git a/common/rc b/common/rc
> index dc1d65c3..b82bb36b 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -178,6 +178,9 @@ _scratch_options()
>      "xfs")
>  	_scratch_xfs_options "$@"
>  	;;
> +    ext2|ext3|ext4|ext4dev)
> +	_scratch_ext4_options "$@"
> +	;;
>      esac
>  }
>  
> 

