Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1D54E345
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2019 11:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfFUJS5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 05:18:57 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42261 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfFUJS5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 05:18:57 -0400
Received: by mail-pl1-f195.google.com with SMTP id ay6so2683052plb.9;
        Fri, 21 Jun 2019 02:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pZyWrWRBol6j3cbiUNoqsTAbhmYmugie/evV/zspDEU=;
        b=tkOomdplAfZIOH8mF1DvleFRUe3FM5Bv1S4NefGOfOo8X/s78lTGKBKoC4uOUEFHIB
         Pn4PaqAtLy3Cvuuwxkd6xVMFDOvGAxRMBPMgzPXc2HmPvkBOl1y2/8RXKprmQIqN8y/2
         WigELiElalKcQiVeuKxDLo4Et0eBCnCEHtad2o2aX037GfvIH/TCVZQWSgem+ZscZVRC
         G/A8g2Wn8Vh5OzIqxHJkQnHXHj1w3hUhlItJKfnHzf3zEmTbOIW/s2vj7zMVD40ufpWq
         uT0IgwZMjjN+J9hz4NRIu1Jo4td3KYLiDK33a2QtucSSfbHA+L0DOmgHIPSyf4pFU5vr
         ubsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pZyWrWRBol6j3cbiUNoqsTAbhmYmugie/evV/zspDEU=;
        b=ZxnhJeVMotg5phTzMllLMW/jbZuh7Img34+tyhuz/362U9U33jDWoq0eww1aRg8QjN
         JR2exHU4C+jxJxiPFLjs9JUbkIfH3hf9YhDntv5wX0PSYBuAYYZ8bxD6lAjmi/Rz3Ih8
         D9fAbApTJ82MwaJxIX3SrAwuJsR1OxbUhIFOXc8uNsp37PS5lbDf5FALRlecM9eRprIw
         EAHgvPC4Hfxh80NDSzIzVNGw6xs1jXD3RYuoNeQmZBlJ4Jj80bIYlq5mUlpm3TgvZ+yV
         UCLtBbzLpv3PPQHlodYkY2La5e3JAxwQbClKz9vexjcwbBesUWgMQnX/o8o7StsFak1v
         Pmmw==
X-Gm-Message-State: APjAAAVQ30IonXjTd649vQlbSsIjzMHw1VrbAYM/wd9vlmq1gWKJGUXg
        3p29IiBIMm7bU1PVgPQYbpM=
X-Google-Smtp-Source: APXvYqxtkeIt3Gec75dKMMcjg8NWggyIdvkkEKtzVyMBXOOCPdQuCHnmpCtaUmYa2J93t+wwf025cQ==
X-Received: by 2002:a17:902:bd0a:: with SMTP id p10mr54842362pls.134.1561108736787;
        Fri, 21 Jun 2019 02:18:56 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id h26sm2690468pfq.64.2019.06.21.02.18.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 02:18:56 -0700 (PDT)
Date:   Fri, 21 Jun 2019 17:18:51 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs/016: calculate minimum log size and end locations
Message-ID: <20190621091851.GI15846@desktop>
References: <156089201978.345809.17444450351199726553.stgit@magnolia>
 <156089204146.345809.516891823391869532.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156089204146.345809.516891823391869532.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 18, 2019 at 02:07:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs/016 looks for corruption in the log when the log wraps.  However,
> it hardcodes the minimum log size and the "95%" point where it wants to
> start the "nudge and check for corruption" part of the test.  New
> features require larger logs, which causes the test to fail when it
> can't mkfs with the smaller log size and when that 95% point doesn't put
> us within 20x "_log_traffic 2"s of the end of the log.
> 
> Fix the first problem by using the new min log size helper and replace
> the 95% figure with an estimate of where we need to be to guarantee that
> the 20x loop wraps the log.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Call for reviews from other XFS folks :)

Thanks!

Eryu

> ---
>  tests/xfs/016     |   50 ++++++++++++++++++++++++++++++++++++++------------
>  tests/xfs/016.out |    1 +
>  2 files changed, 39 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/tests/xfs/016 b/tests/xfs/016
> index 3407a4b1..aed37dca 100755
> --- a/tests/xfs/016
> +++ b/tests/xfs/016
> @@ -44,10 +44,21 @@ _block_filter()
>  
>  _init()
>  {
> +    echo "*** determine log size"
> +    local sz_mb=50
> +    local dsize="-d size=${sz_mb}m"
> +    local lsize="-l size=$(_scratch_find_xfs_min_logblocks $dsize)b"
> +    local force_opts="$dsize $lsize"
> +    _scratch_mkfs_xfs $force_opts >> $seqres.full 2>&1
> +
> +    # set log_size and log_size_bb globally
> +    log_size_bb=`_log_size`
> +    log_size=$((log_size_bb * 512))
> +    echo "log_size_bb = $log_size_bb log_size = $log_size" >> $seqres.full
> +
>      echo "*** reset partition"
> -    $here/src/devzero -b 2048 -n 50 -v 198 $SCRATCH_DEV
> +    $here/src/devzero -b 2048 -n $sz_mb -v 198 $SCRATCH_DEV # write 0xc6
>      echo "*** mkfs"
> -    force_opts="-dsize=50m -lsize=$log_size"
>      #
>      # Do not discard blocks as we check for patterns in free space.
>      # 
> @@ -65,6 +76,9 @@ _init()
>      . $tmp.mkfs
>      [ $logsunit -ne 0 ] && \
>          _notrun "Cannot run this test using log MKFS_OPTIONS specified"
> +
> +    # quotas generate extra log traffic so force it off
> +    _qmount_option noquota
>  }
>  
>  _log_traffic()
> @@ -157,6 +171,7 @@ _check_corrupt()
>  # get standard environment, filters and checks
>  . ./common/rc
>  . ./common/filter
> +. ./common/quota
>  
>  # real QA test starts here
>  _supported_fs xfs
> @@ -164,10 +179,6 @@ _supported_os Linux
>  
>  rm -f $seqres.full
>  
> -# mkfs sizes
> -log_size=3493888
> -log_size_bb=`expr $log_size / 512`
> -
>  _require_scratch
>  _init
>  
> @@ -188,18 +199,29 @@ echo "log sunit = $lsunit"			>>$seqres.full
>  [ $head -eq 2 -o $head -eq $((lsunit/512)) ] || \
>      _fail "!!! unexpected initial log position $head vs. $((lsunit/512))"
>  
> -# find how how many blocks per op for 100 ops
> +# find how how many blocks per op for 200 ops
>  # ignore the fact that it will also include an unmount record etc...
>  # this should be small overall
>  echo "    lots of traffic for sampling" >>$seqres.full
> -sample_size_ops=100
> +sample_size_ops=200
>  _log_traffic $sample_size_ops
>  head1=`_log_head`
>  num_blocks=`expr $head1 - $head`
>  blocks_per_op=`echo "scale=3; $num_blocks / $sample_size_ops" | bc`
> +echo "log position = $head1; old log position: $head" >> $seqres.full
>  echo "blocks_per_op = $blocks_per_op" >>$seqres.full
> -num_expected_ops=`echo "$log_size_bb / $blocks_per_op" | bc`
> +
> +# Since this is a log wrapping test, it's critical to push the log head to
> +# the point where it will wrap around within twenty rounds of log traffic.
> +near_end_min=$(echo "$log_size_bb - (10 * $blocks_per_op / 1)" | bc)
> +echo "near_end_min = $near_end_min" >>$seqres.full
> +
> +# Estimate the number of ops needed to get the log head close to but not past
> +# near_end_min.  We'd rather fall short and have to step our way closer to the
> +# end than run past the end.
> +num_expected_ops=$(( 8 * $(echo "$log_size_bb / $blocks_per_op" | bc) / 10))
>  echo "num_expected_ops = $num_expected_ops" >>$seqres.full
> +
>  num_expected_to_go=`echo "$num_expected_ops - $sample_size_ops" | bc`
>  echo "num_expected_to_go = $num_expected_to_go" >>$seqres.full
>  
> @@ -208,13 +230,17 @@ _log_traffic $num_expected_to_go
>  head=`_log_head`
>  echo "log position = $head"                     >>$seqres.full
>  
> -# e.g. 3891
> -near_end_min=`echo "0.95 * $log_size_bb" | bc | sed 's/\..*//'`
> -echo "near_end_min = $near_end_min" >>$seqres.full
> +# If we fell short of near_end_min, step our way towards it.
> +while [ $head -lt $near_end_min ]; do
> +	echo "    bump traffic from $head towards $near_end_min" >> $seqres.full
> +	_log_traffic 10 > /dev/null 2>&1
> +	head=$(_log_head)
> +done
>  
>  [ $head -gt $near_end_min -a $head -lt $log_size_bb ] || \
>      _fail "!!! unexpected near end log position $head"
>  
> +# Try to wrap the log, checking for corruption with each advance.
>  for c in `seq 0 20`
>  do
>      echo "   little traffic"            >>$seqres.full
> diff --git a/tests/xfs/016.out b/tests/xfs/016.out
> index f7844cdf..f4c8f88d 100644
> --- a/tests/xfs/016.out
> +++ b/tests/xfs/016.out
> @@ -1,4 +1,5 @@
>  QA output created by 016
> +*** determine log size
>  *** reset partition
>  Wrote 51200.00Kb (value 0xc6)
>  *** mkfs
> 
