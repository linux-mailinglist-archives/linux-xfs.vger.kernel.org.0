Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 201734E271
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2019 10:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfFUI54 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 04:57:56 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36350 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbfFUI5z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 04:57:55 -0400
Received: by mail-pg1-f196.google.com with SMTP id f21so3058862pgi.3;
        Fri, 21 Jun 2019 01:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nRPQXdqLedtNgscXnRjPfeJWe5ZlldcTjKoE0Uu/TIg=;
        b=O1TISh7T1gVhVJ1eyDgMWiv287JayGkibe1YG25rTFSlBwRLtIDudtzYp9trWdqF1A
         jaY9ryzoR8TuHBF0nGsVwvGFoJ73EXeV8sm86Xa8xk6T6K8ZVBfdss/HSpqkCEamZ6Sc
         2qEVMmuGL8xqDsDg5W/1Ym3MHKmST7sGA9VYtYAJQLD6bWlExCaCqCXo6wHmHmS+Os3x
         UmUcWVqzPs/QaAQZiQsrGKEmSIeS6kMJC9ps8da76x6+cF1EEbOCXJ998I1rd6WqCXn2
         yAwFI5FDVuWcNJ45CbRowH1aDa09M4ibG5DdyGOkfbHhKRQZCuGzwMhJAhTWt7/YcWb5
         QGaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nRPQXdqLedtNgscXnRjPfeJWe5ZlldcTjKoE0Uu/TIg=;
        b=mYfo1l3y2eGTaLOoKTC0bhW7Q+7k0QzKbQdMrKnZwnaVMCdQebZr3CKwOgRXsl8Po5
         Ju8KTgiLwC2oedaJN5P+foVErbzGSUWgYFzvRZP0PnU7vWodohQ8b2kxNvvFMthMuzQy
         +GgsWjeRRwwHZyvJ/rSV7eoEy+fKny0+bcZcAVzVZafZMWzyKiOemV8Wn7+RMaICeQpN
         UdmXQTWAMal+qOamUc/MONjwCoVOr9+HufkRp5rV3T3bpYy2JuiIaJx60sqZs1cXdweo
         EAMok3PwptJo+ZlhmwCd8cnytA3pmGmyjDsekUjp5EvHIe4y99iT1eQPMMi/HTAZ7HpU
         ++EA==
X-Gm-Message-State: APjAAAVjI01qqgG/ILmRHW88iiR3z7+YiAW8wIBJyxpVc0VzHFqFj+FB
        4Uahy2oZIZ1xtUBG1S96s1Joz9xutAc=
X-Google-Smtp-Source: APXvYqwRirxBy6d7CZGh4zWmWfKbRLhEpQUokD5odKVeymNMDzqCQwgOhg5zhytK7Hca5pRecywTpg==
X-Received: by 2002:a63:ec13:: with SMTP id j19mr16781502pgh.174.1561107474788;
        Fri, 21 Jun 2019 01:57:54 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id 11sm2585754pfw.33.2019.06.21.01.57.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 01:57:54 -0700 (PDT)
Date:   Fri, 21 Jun 2019 16:57:48 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: rework min log size helper
Message-ID: <20190621085748.GH15846@desktop>
References: <156089201978.345809.17444450351199726553.stgit@magnolia>
 <156089203509.345809.3448903728041546348.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156089203509.345809.3448903728041546348.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 18, 2019 at 02:07:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The recent _scratch_find_xfs_min_logblocks helper has a major thinko in
> it -- it relies on feeding a too-small size to _scratch_do_mkfs so that
> mkfs will tell us the minimum log size.  Unfortunately, _scratch_do_mkfs
> will see that first failure and retry the mkfs without MKFS_OPTIONS,
> which means that we return the minimum log size for the default mkfs
> settings without MKFS_OPTIONS.
> 
> This is a problem if someone's running fstests with a set of
> MKFS_OPTIONS that affects the minimum log size.  To fix this, open-code
> the _scratch_do_mkfs retry behavior so that we only do the "retry
> without MKFS_OPTIONS" behavior if the mkfs failed for a reason other
> than the minimum log size check.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/rc  |   13 ++++++++++---
>  common/xfs |   23 +++++++++++++++++++++--
>  2 files changed, 31 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/common/rc b/common/rc
> index 25203bb4..a38b7f02 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -438,6 +438,14 @@ _scratch_mkfs_options()
>      echo $SCRATCH_OPTIONS $MKFS_OPTIONS $* $SCRATCH_DEV
>  }
>  
> +# Format the scratch device directly.  First argument is the mkfs command.
> +# Second argument are all the parameters.  stdout goes to $tmp.mkfsstd and
> +# stderr goes to $tmp.mkfserr.
> +__scratch_do_mkfs()
> +{
> +	eval "$1 $2 $SCRATCH_DEV" 2>$tmp.mkfserr 1>$tmp.mkfsstd

I'd prefer leaving stdout and stderr to caller to handle, because ..


> +}
> +
>  # Do the actual mkfs work on SCRATCH_DEV. Firstly mkfs with both MKFS_OPTIONS
>  # and user specified mkfs options, if that fails (due to conflicts between mkfs
>  # options), do a second mkfs with only user provided mkfs options.
> @@ -456,8 +464,7 @@ _scratch_do_mkfs()
>  
>  	# save mkfs output in case conflict means we need to run again.
>  	# only the output for the mkfs that applies should be shown
> -	eval "$mkfs_cmd $MKFS_OPTIONS $extra_mkfs_options $SCRATCH_DEV" \
> -		2>$tmp.mkfserr 1>$tmp.mkfsstd

it's easier to know the $tmp.mkfserr and $tmp.mkfsstd files should be
cleaned up, otherwise it's not that clear where these files come from.

> +	__scratch_do_mkfs "$mkfs_cmd" "$MKFS_OPTIONS $extra_mkfs_options"
>  	mkfs_status=$?
>  
>  	# a mkfs failure may be caused by conflicts between $MKFS_OPTIONS and
> @@ -471,7 +478,7 @@ _scratch_do_mkfs()
>  		) >> $seqres.full
>  
>  		# running mkfs again. overwrite previous mkfs output files
> -		eval "$mkfs_cmd $extra_mkfs_options $SCRATCH_DEV" \
> +		__scratch_do_mkfs "$mkfs_cmd" "$extra_mkfs_options" \
>  			2>$tmp.mkfserr 1>$tmp.mkfsstd

With the implemention in the patch, the "2>$tmp.mkfserr 1>$tmp.mkfsstd"
part should be removed too, but with the suggested implemention we can
keep it :)

>  		mkfs_status=$?
>  	fi
> diff --git a/common/xfs b/common/xfs
> index f8dafc6c..8733e2ae 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -87,16 +87,33 @@ _scratch_find_xfs_min_logblocks()
>  	# minimum log size.
>  	local XFS_MIN_LOG_BYTES=2097152
>  
> -	_scratch_do_mkfs "$mkfs_cmd" "cat" $* -N -l size=$XFS_MIN_LOG_BYTES \
> -		2>$tmp.mkfserr 1>$tmp.mkfsstd
> +	# Try formatting the filesystem with all the options given and the
> +	# minimum log size.  We hope either that this succeeds or that mkfs
> +	# tells us the required minimum log size for the feature set.
> +	#
> +	# We cannot use _scratch_do_mkfs because it will retry /any/ failed
> +	# mkfs with MKFS_OPTIONS removed even if the only "failure" was that
> +	# the log was too small.
> +	local extra_mkfs_options="$* -N -l size=$XFS_MIN_LOG_BYTES"
> +	__scratch_do_mkfs "$mkfs_cmd" "$MKFS_OPTIONS $extra_mkfs_options"
>  	local mkfs_status=$?
>  
> +	# If the format fails for a reason other than the log being too small,
> +	# try again without MKFS_OPTIONS because that's what _scratch_do_mkfs
> +	# will do if we pass in the log size option.
> +	if [ $mkfs_status -ne 0 ] &&
> +	   ! grep -q 'log size.*too small, minimum' $tmp.mkfserr; then
> +		__scratch_do_mkfs "$mkfs_cmd" "$extra_mkfs_options"
> +		local mkfs_status=$?

We've already declared mkfs_status as local, no need to do it again
here.

Thanks,
Eryu

> +	fi
> +
>  	# mkfs suceeded, so we must pick out the log block size to do the
>  	# unit conversion
>  	if [ $mkfs_status -eq 0 ]; then
>  		local blksz="$(grep '^log.*bsize' $tmp.mkfsstd | \
>  			sed -e 's/log.*bsize=\([0-9]*\).*$/\1/g')"
>  		echo $((XFS_MIN_LOG_BYTES / blksz))
> +		rm -f $tmp.mkfsstd $tmp.mkfserr
>  		return
>  	fi
>  
> @@ -104,6 +121,7 @@ _scratch_find_xfs_min_logblocks()
>  	if grep -q 'minimum size is' $tmp.mkfserr; then
>  		grep 'minimum size is' $tmp.mkfserr | \
>  			sed -e 's/^.*minimum size is \([0-9]*\) blocks/\1/g'
> +		rm -f $tmp.mkfsstd $tmp.mkfserr
>  		return
>  	fi
>  
> @@ -111,6 +129,7 @@ _scratch_find_xfs_min_logblocks()
>  	echo "Cannot determine minimum log size" >&2
>  	cat $tmp.mkfsstd >> $seqres.full
>  	cat $tmp.mkfserr >> $seqres.full
> +	rm -f $tmp.mkfsstd $tmp.mkfserr
>  }
>  
>  _scratch_mkfs_xfs()
> 
