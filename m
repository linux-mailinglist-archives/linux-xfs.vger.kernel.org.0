Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0467880B71
	for <lists+linux-xfs@lfdr.de>; Sun,  4 Aug 2019 17:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfHDP0z (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 4 Aug 2019 11:26:55 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41811 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfHDP0z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 11:26:55 -0400
Received: by mail-pg1-f196.google.com with SMTP id x15so28040899pgg.8;
        Sun, 04 Aug 2019 08:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QHq3e6BlBAnzk+FinFrlGH1LFdtG9qSWM96MxZsaxW8=;
        b=dj2EqWEFeT9eWjGAmatWMLmjsiisqy4PWjaRStZ9zazhb8zjbI9EUxX+ZeTHkDbhTt
         q5aibTordS/FcYd8q1xYSQF0b9L8veykh9jBzyUKMPcVmOQJDvgjKmqTxfizbjWaEEs7
         7L4o8mtjAb/wIgh7UNuI6eDOXd3/Y3KW+XXwDfyJF2wTEo+tX0E6nT7YOhcEPE43UE2I
         kwdIVXfic3aT2VoP4yPVVHH6JvLaf2dCwS+L40FuSG8epkpeWdSZuGd6RYQW5L4yJLtI
         hJ4q2SU8GPISh85mC9HhaDBp98HrkN41uWGc1wGrIblxfP4oAlvQkzP1nlb4ffHgeKZr
         cyXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QHq3e6BlBAnzk+FinFrlGH1LFdtG9qSWM96MxZsaxW8=;
        b=FOGB2V/ohPxCTs/792VPXQ+jOmpaPl9ft+P2DtoysVIwkowex/lnQv/hySSlo+vMPq
         kp0A0Xf4VRoyonXPE2ZX3g4pzq5YepRGBk/+8LC5q07suQQjVR0fAw3e2YDFnWolU0D7
         32NGMqgzIPhoTGbQ1IOVj+iJAO/Zkp1s4Dvo3m5ArC3gvJEbT7VVWlK+a+7CNhUphLO2
         h1VmqYDn721uOHy05coYBKHOy0r/R861Atb/EFLrSmsFTcS/gA1zfML9ufilvGRrAvRi
         XtcsjMUGt9cleRFRqpUdGGcmqUAJYTPuGXBPev/DAoE5hCldcK5yY4N/BoyvqjZHivUc
         jyBg==
X-Gm-Message-State: APjAAAUaEiB8qU56SRIMcHGlewgithF1d95LCZQTu/CixbqS3b50x2vn
        o2u/9kJY0syNJ/dFJILHAbs=
X-Google-Smtp-Source: APXvYqwbxQPs+zWrl0Y6C4FJMDodlEKaB0u6x2nSSjC87mbfphinWRWH1u2BQZxkcgHsz1BkF7mJIw==
X-Received: by 2002:a62:15c3:: with SMTP id 186mr71481708pfv.141.1564932414607;
        Sun, 04 Aug 2019 08:26:54 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id y8sm77994737pfn.52.2019.08.04.08.26.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 08:26:52 -0700 (PDT)
Date:   Sun, 4 Aug 2019 23:26:46 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc:     darrick.wong@oracle.com, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] common/rc: check 'chattr +/-x' on dax device.
Message-ID: <20190804152646.GA2665@desktop>
References: <20190731022949.2463-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731022949.2463-1-ruansy.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 31, 2019 at 10:29:49AM +0800, Shiyang Ruan wrote:
> 'chattr +/-x' only works on a dax device.  When checking if the 'x'
> attribute is supported by XFS_IO_PROG:
>     _require_xfs_io_command "chattr" "x"    (called by xfs/260)
> it's better to do the check on a dax device.

Hmm, I don't think it's necessary, test should _require_scratch_dax,
which should _notrun the test already, before checking chattr +/-x
support. Do you see any specific problem caused by this issue when
running xfs/260?

> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
> ---
>  common/rc | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index e0b087c1..91ab2900 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2094,11 +2094,23 @@ _require_xfs_io_command()
>  		if [ -z "$param" ]; then
>  			param=s
>  		fi
> +
> +		# Attribute "x" should be tested on a dax device
> +		if [ "$param" = "x" ]; then
> +			_require_scratch_dax
> +			_scratch_mount

$SCRATCH_DEV is wiped before every test, it's wrong to assume the device
is directly mountable. And checking chattr +/-x support doesn't require
scratch device, so it's better not to introduce this dependency
implicitly.

Thanks,
Eryu

> +			testfile=$SCRATCH_MNT/$$.xfs_io
> +		fi
> +
>  		# Test xfs_io chattr support AND
>  		# filesystem FS_IOC_FSSETXATTR support
>  		testio=`$XFS_IO_PROG -F -f -c "chattr +$param" $testfile 2>&1`
>  		$XFS_IO_PROG -F -f -r -c "chattr -$param" $testfile 2>&1
>  		param_checked="+$param"
> +
> +		if [ "$param" = "x" ]; then
> +			_scratch_unmount
> +		fi
>  		;;
>  	"chproj")
>  		testio=`$XFS_IO_PROG -F -f -c "chproj 0" $testfile 2>&1`
> -- 
> 2.17.0
> 
> 
> 
