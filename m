Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6465FC8A0
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Oct 2022 17:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJLPrb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Oct 2022 11:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJLPrb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Oct 2022 11:47:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B03A8C46F
        for <linux-xfs@vger.kernel.org>; Wed, 12 Oct 2022 08:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665589649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9FZiZGxd4rlI8MLVkVbMv62qRD/MTnJaaQ1Nwc9bfWc=;
        b=F/+YDD34LZSmmNsn9DndBpY+eSy4fCdaqHb1KQMBREpkTk4FkvSrp5/1tTVXGE7Jy+3yJx
        FvyvkFTWeRpionpDXznY/DZ2+5WxMGoAiBJyaMW9ZFWNWdYeIwnPQrMUV/i1xB2mDCCFqf
        Bcsf5zk1eZNvSYYs5Eqa4Z+zBtHQew0=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-197-LVse00beMMy6psqcR--AOQ-1; Wed, 12 Oct 2022 11:47:28 -0400
X-MC-Unique: LVse00beMMy6psqcR--AOQ-1
Received: by mail-pg1-f197.google.com with SMTP id l185-20020a6388c2000000b004610d11faddso5261869pgd.1
        for <linux-xfs@vger.kernel.org>; Wed, 12 Oct 2022 08:47:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9FZiZGxd4rlI8MLVkVbMv62qRD/MTnJaaQ1Nwc9bfWc=;
        b=mtWC/7T6PyVED9x6Me39Oa0UF48lTC5mcqhJcfOt+1R39mKWAo0UGqFGGhNkfYR2wJ
         GjWz/c+iSY+JLCgdlyBjTl1Bt0+LVdAWe6z3xNwAZ8vZ1gIdRGIRntH7/6keMkPzdA9z
         LaZWgfUTMbF9O72zyLJ1MO1V6alt7SBLodCBV5mL08qb3Z2DuUCHXkcbqSf0M/CuRJzu
         k2HzP/8knojjsnuSoUWrOsRlJO9ttb+wpRH6vN+8HzEyAmLvjNpUJmTsNf5mrNNOPw0W
         4c/UZHa2yTIQApHcFnYzYCVqS0zSsbziwVcxwe0YtdGLNDtOGBIPdjSYAShtkv+3153z
         TpBg==
X-Gm-Message-State: ACrzQf0i0McfgstDmh9mHiCEdvQcO2YpxGBcTMyqjFHVDuh0io9vU90C
        PjG0r3JR8rFPm59X2lmiQN8RaS4Lf1jHYcfaJg+zRUGdD6RCexHBBmJJUqH8dnOcpcbTJ5dI8ir
        Rwys8a7tYqsMiOZ/oOA7v
X-Received: by 2002:a17:902:ce87:b0:181:e55d:2d4 with SMTP id f7-20020a170902ce8700b00181e55d02d4mr19287187plg.13.1665589646844;
        Wed, 12 Oct 2022 08:47:26 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6qR8LG9D4KXmDnJxHUkTMfSR4nwXWiIwkNgh1Yn2bsizReudN/ELa04VZsDdvz3JAgUk7FKQ==
X-Received: by 2002:a17:902:ce87:b0:181:e55d:2d4 with SMTP id f7-20020a170902ce8700b00181e55d02d4mr19287151plg.13.1665589646404;
        Wed, 12 Oct 2022 08:47:26 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w9-20020a656949000000b00469e09532e0sm1549823pgq.18.2022.10.12.08.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 08:47:26 -0700 (PDT)
Date:   Wed, 12 Oct 2022 23:47:21 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] check: detect and preserve all coredumps made by a
 test
Message-ID: <20221012154721.gmuzp7inbtqbk73i@zlang-mailbox>
References: <166553910766.422356.8069826206437666467.stgit@magnolia>
 <166553911331.422356.4424521847397525024.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166553911331.422356.4424521847397525024.stgit@magnolia>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 11, 2022 at 06:45:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If someone sets kernel.core_uses_pid (or kernel.core_pattern), any
> coredumps generated by fstests might have names that are longer than
> just "core".  Since the pid isn't all that useful by itself, let's
> record the coredumps by hash when we save them, so that we don't waste
> space storing identical crash dumps.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  check     |   26 ++++++++++++++++++++++----
>  common/rc |   16 ++++++++++++++++
>  2 files changed, 38 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/check b/check
> index af23572ccc..654d986b27 100755
> --- a/check
> +++ b/check
> @@ -913,11 +913,19 @@ function run_section()
>  			sts=$?
>  		fi
>  
> -		if [ -f core ]; then
> -			_dump_err_cont "[dumped core]"
> -			mv core $RESULT_BASE/$seqnum.core
> +		# If someone sets kernel.core_pattern or kernel.core_uses_pid,
> +		# coredumps generated by fstests might have a longer name than
> +		# just "core".  Use globbing to find the most common patterns,
> +		# assuming there are no other coredump capture packages set up.
> +		local cores=0
> +		for i in core core.*; do
> +			test -f "$i" || continue
> +			if ((cores++ == 0)); then
> +				_dump_err_cont "[dumped core]"
> +			fi
> +			_save_coredump "$i"
>  			tc_status="fail"
> -		fi
> +		done
>  
>  		if [ -f $seqres.notrun ]; then
>  			$timestamp && _timestamp
> @@ -950,6 +958,16 @@ function run_section()
>  			# of the check script itself.
>  			(_adjust_oom_score 250; _check_filesystems) || tc_status="fail"
>  			_check_dmesg || tc_status="fail"
> +
> +			# Save any coredumps from the post-test fs checks
> +			for i in core core.*; do
> +				test -f "$i" || continue
> +				if ((cores++ == 0)); then
> +					_dump_err_cont "[dumped core]"
> +				fi
> +				_save_coredump "$i"
> +				tc_status="fail"
> +			done
>  		fi
>  
>  		# Reload the module after each test to check for leaks or
> diff --git a/common/rc b/common/rc
> index d877ac77a0..152b8bb414 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4949,6 +4949,22 @@ _create_file_sized()
>  	return $ret
>  }
>  
> +_save_coredump()
> +{
> +	local path="$1"
> +
> +	local core_hash="$(_md5_checksum "$path")"
> +	local out_file="$RESULT_BASE/$seqnum.core.$core_hash"

I doubt this can work with fstests section, if we use section, the out_file
should be "$RESULT_BASE/$section/....", so I think if we can write this line
as:

  local out_file="$seqres.core.$core_hash"

Or use $REPORT_DIR?

Thanks,
Zorro

> +
> +	if [ -s "$out_file" ]; then
> +		rm -f "$path"
> +		return
> +	fi
> +	rm -f "$out_file"
> +
> +	mv "$path" "$out_file"
> +}
> +
>  init_rc
>  
>  ################################################################################
> 

