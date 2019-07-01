Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7185B4753D
	for <lists+linux-xfs@lfdr.de>; Sun, 16 Jun 2019 16:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbfFPOkD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 16 Jun 2019 10:40:03 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33095 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727230AbfFPOkD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Jun 2019 10:40:03 -0400
Received: by mail-pg1-f196.google.com with SMTP id k187so4313538pga.0;
        Sun, 16 Jun 2019 07:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HPORHiKbkOh6Q/xH1GRnOWZlsUgNSN8s2+gFM24tQ/k=;
        b=gaETkyYpPETJiSpt8P0iJYcqSnGyhNuJCB05O0zF+sF0oLGn1g58A7euWHcr9hT5/c
         I3Qx6ogzPLkwC5DJAbpOPiLQXtSnEfZCWJP5bYIkVgdnHlOAG6xZM/dYtqvWzI4jVpIX
         IOUJWdJZF4Baj/lX7kpYwEPLv4Xih7V7a6w3hRXfuuYv52OE2vL1xkv0lr7lGaJsq6Fn
         sRjgzXRz19sz1DMUlq2iBt8Iq2ze1kWNj4PflUBa3HC/FEzhzqCqafmuKj1F0POGOeM3
         Mf5Xy+Zajr+mF8P9Ru0M4NEMRA6nrY1joHpznXNF6QiXLDjJbpug4XL0eWMOZWR4oaSs
         d5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HPORHiKbkOh6Q/xH1GRnOWZlsUgNSN8s2+gFM24tQ/k=;
        b=A2XbAvDTPz3zD5VuhxubjJzlYAvnmXoajmpiVFmxXCfORzLUgJqZtnjlXLpmfRa7EN
         G96KFboGcpU7352yZqrPIOhdyn1XzpH7eoVjlKgj8UNPcbZY+JVm20brJygDUtsTS6LN
         kkb2+Amj1JXZxKvDHrowjsqCnhZP+Hho0A3Ocf07asQVmo9Ov9kwLtkW12lBRFf6/o8x
         vjtC0VO8jM9nxErsbTZHmdo46ZOEtDrF63/1k2dzlRgx7A1mKnMII4vvNUfuziK88Av+
         26SmaATKhhIwq6iOOhglIkq5A9Hs+y8LDoFB880oQfw9D74s44InStkrF7QI2uXgAdjM
         S/GQ==
X-Gm-Message-State: APjAAAX1uo4dgfnBOwtc+L62OJ02NVN51j2hbBeVgP1C0CJi7v4dGUNw
        hKdcZjAuBCblyZDPudpztug=
X-Google-Smtp-Source: APXvYqyWH9UImv0NYoP7eNKddqx3R8F0YUprq6YdBWew9yNxvmdtxOcVxY//boQPqE1WRpjZWZbRAQ==
X-Received: by 2002:a17:90a:d3c3:: with SMTP id d3mr21804712pjw.17.1560696002062;
        Sun, 16 Jun 2019 07:40:02 -0700 (PDT)
Received: from localhost ([47.254.35.144])
        by smtp.gmail.com with ESMTPSA id q7sm10053292pfb.32.2019.06.16.07.40.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 16 Jun 2019 07:40:01 -0700 (PDT)
Date:   Sun, 16 Jun 2019 22:39:56 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Cc:     darrick.wong@oracle.com, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs/191: update mkfs.xfs input results
Message-ID: <20190616143956.GC15846@desktop>
References: <1560414701-2590-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560414701-2590-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[cc xfs list for xfs specific test]

On Thu, Jun 13, 2019 at 04:31:41PM +0800, Yang Xu wrote:
> Currently, on 5.2.0-rc4+ kernel, when I run xfs/191-input-validation with upstream xfsprogs,
> I get the following errors because mkfs.xfs binary has changed a lot.

Lines are too long for commit log, please wrap at column 68.

> 
> --------------------------
> PLATFORM      -- Linux/x86_64  5.2.0-rc4+
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda11
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda11 /mnt/xfstests/scratch

But these quotes don't need to be wrapped.

> 
> pass -n size=2b /dev/sda11
> pass -d agsize=8192b /dev/sda11
> pass -d agsize=65536s /dev/sda11
> pass -d su=0,sw=64 /dev/sda11
> pass -d su=4096s,sw=64 /dev/sda11
> pass -d su=4096b,sw=64 /dev/sda11
> pass -l su=10b /dev/sda11
> fail -n log=15 /dev/sda11
> fail -r size=65536,rtdev=$fsimg /dev/sda11
> fail -r rtdev=$fsimg /dev/sda11
> fail -i log=10 /dev/sda11
> --------------------------
> 
> "pass -d su=0,sw=64 /dev/sda11", expect fail, this behavior has been fixed by commit 16adcb88:
> (mkfs: more sunit/swidth sanity checking).
> 
> "fail -n log=15 /dev/sda11" "fail -i log=10 /dev/sda11", expect pass, this option has been removed
> since commit 2cf637c(mkfs: remove logarithm based CLI option).
> 
> "fail -r size=65536,rtdev=$fsimg /dev/sda11" "fail -r rtdev=$fsimg /dev/sda11" works well if we disable
> reflink, fail if we enable reflink. It fails because reflink was not supported in realtime devices
> since commit bfa66ec.
> 
> I change the expected result for compatibility with current xfsprogs and add rtdev test with reflink .
> 
> Signed-off-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>

I noticed Darrick provided a Reviewed-by tag, but as Darrick also noted,
it'd be good to know what do other xfs maintainers think about this
test.

> ---
>  tests/xfs/191-input-validation | 36 ++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/tests/xfs/191-input-validation b/tests/xfs/191-input-validation
> index b6658015..9fe72051 100755
> --- a/tests/xfs/191-input-validation
> +++ b/tests/xfs/191-input-validation
> @@ -112,10 +112,11 @@ do_mkfs_fail -b size=2b $SCRATCH_DEV
>  do_mkfs_fail -b size=nfi $SCRATCH_DEV
>  do_mkfs_fail -b size=4096nfi $SCRATCH_DEV
>  do_mkfs_fail -n size=2s $SCRATCH_DEV
> -do_mkfs_fail -n size=2b $SCRATCH_DEV
>  do_mkfs_fail -n size=nfi $SCRATCH_DEV
>  do_mkfs_fail -n size=4096nfi $SCRATCH_DEV
>  
> +do_mkfs_pass -n size=2b $SCRATCH_DEV
> +
>  # bad label length
>  do_mkfs_fail -L thisiswaytoolong $SCRATCH_DEV
>  
> @@ -129,6 +130,8 @@ do_mkfs_pass -d agsize=32M $SCRATCH_DEV
>  do_mkfs_pass -d agsize=1g $SCRATCH_DEV
>  do_mkfs_pass -d agsize=$((32 * 1024 * 1024)) $SCRATCH_DEV
>  do_mkfs_pass -b size=4096 -d agsize=8192b $SCRATCH_DEV
> +do_mkfs_pass -d agsize=8192b $SCRATCH_DEV
> +do_mkfs_pass -d agsize=65536s $SCRATCH_DEV
>  do_mkfs_pass -d sectsize=512,agsize=65536s $SCRATCH_DEV
>  do_mkfs_pass -s size=512 -d agsize=65536s $SCRATCH_DEV
>  do_mkfs_pass -d noalign $SCRATCH_DEV
> @@ -136,7 +139,10 @@ do_mkfs_pass -d sunit=0,swidth=0 $SCRATCH_DEV
>  do_mkfs_pass -d sunit=8,swidth=8 $SCRATCH_DEV
>  do_mkfs_pass -d sunit=8,swidth=64 $SCRATCH_DEV
>  do_mkfs_pass -d su=0,sw=0 $SCRATCH_DEV
> +do_mkfs_pass -d su=0,sw=64 $SCRATCH_DEV
>  do_mkfs_pass -d su=4096,sw=1 $SCRATCH_DEV
> +do_mkfs_pass -d su=4096s,sw=64 $SCRATCH_DEV
> +do_mkfs_pass -d su=4096b,sw=64 $SCRATCH_DEV
>  do_mkfs_pass -d su=4k,sw=1 $SCRATCH_DEV
>  do_mkfs_pass -d su=4K,sw=8 $SCRATCH_DEV
>  do_mkfs_pass -b size=4096 -d su=1b,sw=8 $SCRATCH_DEV
> @@ -147,8 +153,6 @@ do_mkfs_pass -s size=512 -d su=8s,sw=8 $SCRATCH_DEV
>  do_mkfs_fail -d size=${fssize}b $SCRATCH_DEV
>  do_mkfs_fail -d size=${fssize}s $SCRATCH_DEV
>  do_mkfs_fail -d size=${fssize}yerk $SCRATCH_DEV
> -do_mkfs_fail -d agsize=8192b $SCRATCH_DEV
> -do_mkfs_fail -d agsize=65536s $SCRATCH_DEV
>  do_mkfs_fail -d agsize=32Mbsdfsdo $SCRATCH_DEV
>  do_mkfs_fail -d agsize=1GB $SCRATCH_DEV
>  do_mkfs_fail -d agcount=1k $SCRATCH_DEV
> @@ -159,13 +163,10 @@ do_mkfs_fail -d sunit=64,swidth=0 $SCRATCH_DEV
>  do_mkfs_fail -d sunit=64,swidth=64,noalign $SCRATCH_DEV
>  do_mkfs_fail -d sunit=64k,swidth=64 $SCRATCH_DEV
>  do_mkfs_fail -d sunit=64,swidth=64m $SCRATCH_DEV
> -do_mkfs_fail -d su=0,sw=64 $SCRATCH_DEV
>  do_mkfs_fail -d su=4096,sw=0 $SCRATCH_DEV
>  do_mkfs_fail -d su=4097,sw=1 $SCRATCH_DEV
>  do_mkfs_fail -d su=4096,sw=64,noalign $SCRATCH_DEV
>  do_mkfs_fail -d su=4096,sw=64s $SCRATCH_DEV
> -do_mkfs_fail -d su=4096s,sw=64 $SCRATCH_DEV
> -do_mkfs_fail -d su=4096b,sw=64 $SCRATCH_DEV
>  do_mkfs_fail -d su=4096garabge,sw=64 $SCRATCH_DEV
>  do_mkfs_fail -d su=4096,sw=64,sunit=64,swidth=64 $SCRATCH_DEV
>  do_mkfs_fail -d sectsize=10,agsize=65536s $SCRATCH_DEV
> @@ -206,6 +207,7 @@ do_mkfs_pass -l sunit=64 $SCRATCH_DEV
>  do_mkfs_pass -l sunit=64 -d sunit=8,swidth=8 $SCRATCH_DEV
>  do_mkfs_pass -l sunit=8 $SCRATCH_DEV
>  do_mkfs_pass -l su=$((4096*10)) $SCRATCH_DEV
> +do_mkfs_pass -l su=10b $SCRATCH_DEV
>  do_mkfs_pass -b size=4096 -l su=10b $SCRATCH_DEV
>  do_mkfs_pass -l sectsize=512,su=$((4096*10)) $SCRATCH_DEV
>  do_mkfs_pass -l internal $SCRATCH_DEV
> @@ -228,7 +230,6 @@ do_mkfs_fail -l agnum=32 $SCRATCH_DEV
>  do_mkfs_fail -l sunit=0  $SCRATCH_DEV
>  do_mkfs_fail -l sunit=63 $SCRATCH_DEV
>  do_mkfs_fail -l su=1 $SCRATCH_DEV
> -do_mkfs_fail -l su=10b $SCRATCH_DEV
>  do_mkfs_fail -l su=10s $SCRATCH_DEV
>  do_mkfs_fail -l su=$((4096*10+1)) $SCRATCH_DEV
>  do_mkfs_fail -l sectsize=10,agsize=65536s $SCRATCH_DEV
> @@ -246,7 +247,6 @@ do_mkfs_fail -l version=0  $SCRATCH_DEV
>  
>  # naming section, should pass
>  do_mkfs_pass -n size=65536 $SCRATCH_DEV
> -do_mkfs_pass -n log=15 $SCRATCH_DEV
>  do_mkfs_pass -n version=2 $SCRATCH_DEV
>  do_mkfs_pass -n version=ci $SCRATCH_DEV
>  do_mkfs_pass -n ftype=0 -m crc=0 $SCRATCH_DEV
> @@ -257,6 +257,7 @@ do_mkfs_fail -n version=1 $SCRATCH_DEV
>  do_mkfs_fail -n version=cid $SCRATCH_DEV
>  do_mkfs_fail -n ftype=4 $SCRATCH_DEV
>  do_mkfs_fail -n ftype=0 $SCRATCH_DEV
> +do_mkfs_fail -n log=15 $SCRATCH_DEV
>  
>  reset_fsimg
>  
> @@ -273,14 +274,24 @@ do_mkfs_fail -m crc=0,finobt=1 $SCRATCH_DEV
>  do_mkfs_fail -m crc=1 -n ftype=0 $SCRATCH_DEV
>  
>  
> +# realtime section, results depend on reflink
> +$MKFS_XFS_PROG -f -m reflink=0 $SCRATCH_DEV >/dev/null 2>&1

_scratch_mkfs_xfs_supported -m reflink=0 >/dev/null 2>&1

This helper doesn't actually create new fs but tests the given param
with a dry run.

And I think we need _require_scratch_nocheck instead of
_require_scratch, as we test mkfs function and do wipefs $SCRATCH_DEV
before every test now.

Thanks,
Eryu

> +if [ $? -eq 0 ]; then
> +	do_mkfs_pass -m reflink=0 -r rtdev=$fsimg $SCRATCH_DEV
> +	do_mkfs_pass -m reflink=0 -r size=65536,rtdev=$fsimg $SCRATCH_DEV
> +	do_mkfs_fail -m reflink=1 -r rtdev=$fsimg $SCRATCH_DEV
> +	do_mkfs_fail -m reflink=1 -r size=65536,rtdev=$fsimg $SCRATCH_DEV
> +else
> +	do_mkfs_pass -r rtdev=$fsimg $SCRATCH_DEV
> +	do_mkfs_pass -r size=65536,rtdev=$fsimg $SCRATCH_DEV
> +fi
> +
> +
>  # realtime section, should pass
> -do_mkfs_pass -r rtdev=$fsimg $SCRATCH_DEV
>  do_mkfs_pass -r extsize=4k $SCRATCH_DEV
>  do_mkfs_pass -r extsize=1G $SCRATCH_DEV
> -do_mkfs_pass -r size=65536,rtdev=$fsimg $SCRATCH_DEV
>  do_mkfs_pass -r noalign $SCRATCH_DEV
>  
> -
>  # realtime section, should fail
>  do_mkfs_fail -r rtdev=$SCRATCH_DEV
>  do_mkfs_fail -r extsize=256 $SCRATCH_DEV
> @@ -293,7 +304,6 @@ do_mkfs_fail -r size=65536 $SCRATCH_DEV
>  do_mkfs_pass -i size=256 -m crc=0 $SCRATCH_DEV
>  do_mkfs_pass -i size=512 $SCRATCH_DEV
>  do_mkfs_pass -i size=2048 $SCRATCH_DEV
> -do_mkfs_pass -i log=10 $SCRATCH_DEV
>  do_mkfs_pass -i perblock=2 $SCRATCH_DEV
>  do_mkfs_pass -i maxpct=10 $SCRATCH_DEV
>  do_mkfs_pass -i maxpct=100 $SCRATCH_DEV
> @@ -317,6 +327,8 @@ do_mkfs_fail -i align=2 $SCRATCH_DEV
>  do_mkfs_fail -i sparse -m crc=0 $SCRATCH_DEV
>  do_mkfs_fail -i align=0 -m crc=1 $SCRATCH_DEV
>  do_mkfs_fail -i attr=1 -m crc=1 $SCRATCH_DEV
> +do_mkfs_fail -i log=10 $SCRATCH_DEV
> +
>  
>  status=0
>  exit
> -- 
> 2.18.1
> 
> 
> 
