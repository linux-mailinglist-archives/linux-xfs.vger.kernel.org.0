Return-Path: <linux-xfs+bounces-7260-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A2288ABBE7
	for <lists+linux-xfs@lfdr.de>; Sat, 20 Apr 2024 16:03:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 817A01F21311
	for <lists+linux-xfs@lfdr.de>; Sat, 20 Apr 2024 14:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9823222301;
	Sat, 20 Apr 2024 14:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fT8ruQ4G"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7ACA1F954
	for <linux-xfs@vger.kernel.org>; Sat, 20 Apr 2024 14:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713621773; cv=none; b=CSoPdRCgggKVCfhQkBSBYuD8V6BfexINAccXDhsH1auMdv+q7Tv5gx4tT59HZJntpyncygoAVQsBGqdhMBtecDcqLOGBs9uerF73yoTCM9RcoCT0PuOorHNr5WZezcmpknBDVPKKlMGFZjdC+uDlPxyyvtYf4lB+LR/HiXdp9Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713621773; c=relaxed/simple;
	bh=0napQ7pi0k55WEnQiDhsd00EYcSZufBSSb/xqU60oe0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dnv/BRa4qz+Z8QGJYCjvJaThmbDfxIFhLF8SKFc9ayU4YxgjbvNMMnL0ZqcEIrWGCf3pur0A7emcQPLqwGDWwPTqOZNkrLRJV6oouYgfGFciN6WP/RDeLPQYVgIXujDk3U/OeEnH9uXXIXahFQ8ZKg5u4SIAJhH4KpYNBbT+3m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fT8ruQ4G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713621770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9lfgJeEkDXQcf1eXq96/sWgcK53JbCs/dnLvPig9JJw=;
	b=fT8ruQ4Gj9NVw4KNiMsOBY6N1q8QOsqi+gTF6EUn+xskYhchVraDZZXZehzFG/TDAnz+Rh
	CJ2JtSlaNfT0JUwMNTXIVvCnU9pBvDYyuCd6rJO2h3qMyruoU//cha/nHB6Ex1qdPHF3J2
	QoZMJGIWHfmrphY87Oa9hE9cWV8gk50=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-496-VLnBqo3BPGuYgUdkSPBccg-1; Sat, 20 Apr 2024 10:02:49 -0400
X-MC-Unique: VLnBqo3BPGuYgUdkSPBccg-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1e8afd9e4ceso23201635ad.2
        for <linux-xfs@vger.kernel.org>; Sat, 20 Apr 2024 07:02:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713621768; x=1714226568;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9lfgJeEkDXQcf1eXq96/sWgcK53JbCs/dnLvPig9JJw=;
        b=JwEIgOBkqmE4K0+TTVvgETr/vBWTQHgLqbkXeikWgABe4aQnT39Cg2N0dnka9k3L+u
         n2pMnyOAwx129k3VQm4yhwJTajIriN/6mitIVDCcSRCA0Q8BtD3nqLQ3UD51Agw2bjmH
         9+fUeDSgrxBnK+5idKJ6RhRBTZtrOXhLIDBEHnINFhoUcfbMf2rfXmxoJyQYdImOE1uT
         AWlzkUPQfemi7pn3X74Y6rarAXIE8/rMKfJPBysosA4LddmbSswm6Oa0JX4dd+Is2jdV
         B7CoBUtjNEAJZXcGFXyHx0cFCEozVp+fQfnox7V93LAEKg2TXNezcjqnCZBC1clo45Ca
         y5cg==
X-Forwarded-Encrypted: i=1; AJvYcCVRz2FDnG9nUSniFWtjXpBrtz6BdmkeMXO2o6vbsFSYMt4Gu93TRbi21xm7orPh7DRENYfk56aISpcs1gv1Hz4WrE4QhMIfzOPk
X-Gm-Message-State: AOJu0YxwOGsz/WzmkXO+XaWKPl70Un/1VAm4YudDxNU+33bvVgHymNr1
	uivKHtKP8T/+ye9DYhR9iXXBA0wMwSZ2+9JIumnLT7oZGRSoOvd9voAUkmxJq0NhsZpBkuVqBo8
	4Y/u2FwgtbgJ8sU/D6G7fkrPZ4HNnjNcX0LRythiRX6yakeFdA0mva0QIQw==
X-Received: by 2002:a17:903:22c5:b0:1dc:de65:623b with SMTP id y5-20020a17090322c500b001dcde65623bmr6365702plg.60.1713621767731;
        Sat, 20 Apr 2024 07:02:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+B4ecgGbiEbteqjqIcALgwRnV6lNA+X+RJ7IVvcGmdcjPMSR3Dzt2AzFx0d+Gyiael9DH1Q==
X-Received: by 2002:a17:903:22c5:b0:1dc:de65:623b with SMTP id y5-20020a17090322c500b001dcde65623bmr6365648plg.60.1713621767054;
        Sat, 20 Apr 2024 07:02:47 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e4-20020a17090301c400b001dd59b54f9fsm5095275plh.136.2024.04.20.07.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Apr 2024 07:02:46 -0700 (PDT)
Date: Sat, 20 Apr 2024 22:02:41 +0800
From: Zorro Lang <zlang@redhat.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: fstests@vger.kernel.org, kdevops@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, willy@infradead.org,
	david@redhat.com, linmiaohe@huawei.com, muchun.song@linux.dev,
	osalvador@suse.de
Subject: Re: [PATCH] fstests: add fsstress + compaction test
Message-ID: <20240420140241.wez2x3zoirzlmat6@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240418001356.95857-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240418001356.95857-1-mcgrof@kernel.org>

On Wed, Apr 17, 2024 at 05:13:56PM -0700, Luis Chamberlain wrote:
> Running compaction while we run fsstress can crash older kernels as per
> korg#218227 [0], the fix for that [0] has been posted [1] but that patch
> is not yet on v6.9-rc4 and the patch requires changes for v6.9.
> 
> Today I find that v6.9-rc4 is also hitting an unrecoverable hung task
> between compaction and fsstress while running generic/476 on the
> following kdevops test sections [2]:
> 
>   * xfs_nocrc
>   * xfs_nocrc_2k
>   * xfs_nocrc_4k
> 
> Analyzing the trace I see the guest uses loopback block devices for the
> fstests TEST_DEV, the loopback file uses sparsefiles on a btrfs
> partition. The contention based on traces [3] [4] seems to be that we
> have somehow have fsstress + compaction race on folio_wait_bit_common().
> 
> We have this happening:
> 
>   a) kthread compaction --> migrate_pages_batch()
>                 --> folio_wait_bit_common()
>   b) workqueue on btrfs writeback wb_workfn  --> extent_write_cache_pages()
>                 --> folio_wait_bit_common()
>   c) workqueue on loopback loop_rootcg_workfn() --> filemap_fdatawrite_wbc()
>                 --> folio_wait_bit_common()
>   d) kthread xfsaild --> blk_mq_submit_bio() --> wbt_wait()
> 
> I tried to reproduce but couldn't easily do so, so I wrote this test
> to help, and with this I have 100% failure rate so far out of 2 runs.
> 
> Given we also have korg#218227 and that patch likely needing
> backporting, folks will want a reproducer for this issue. This should
> hopefully help with that case and this new separate issue.
> 
> To reproduce with kdevops just:
> 
> make defconfig-xfs_nocrc_2k  -j $(nproc)
> make -j $(nproc)
> make fstests
> make linux
> make fstests-baseline TESTS=generic/733
> tail -f guestfs/*-xfs-nocrc-2k/console.log
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=218227
> [1] https://lore.kernel.org/all/7ee2bb8c-441a-418b-ba3a-d305f69d31c8@suse.cz/T/#u
> [2] https://github.com/linux-kdevops/kdevops/blob/main/playbooks/roles/fstests/templates/xfs/xfs.config
> [3] https://gist.github.com/mcgrof/4dfa3264f513ce6ca398414326cfab84
> [4] https://gist.github.com/mcgrof/f40a9f31a43793dac928ce287cfacfeb
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
> 
> Note: kdevops uses its own fork of fstests which has this merged
> already, so the above should just work. If it's your first time using
> kdevops be sure to just read the README for the first time users:
> 
> https://github.com/linux-kdevops/kdevops/blob/main/docs/kdevops-first-run.md
> 
>  common/rc             |  7 ++++++
>  tests/generic/744     | 56 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/744.out |  2 ++
>  3 files changed, 65 insertions(+)
>  create mode 100755 tests/generic/744
>  create mode 100644 tests/generic/744.out
> 
> diff --git a/common/rc b/common/rc
> index b7b77ac1b46d..d4432f5ce259 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -120,6 +120,13 @@ _require_hugepages()
>  		_notrun "Kernel does not report huge page size"
>  }
>  
> +# Requires CONFIG_COMPACTION
> +_require_compaction()

I'm not sure if we should name it as "_require_vm_compaction", does linux
have other "compaction" or only memory compaction?

> +{
> +	if [ ! -f /proc/sys/vm/compact_memory ]; then
> +	    _notrun "Need compaction enabled CONFIG_COMPACTION=y"
> +	fi
> +}
>  # Get hugepagesize in bytes
>  _get_hugepagesize()
>  {
> diff --git a/tests/generic/744 b/tests/generic/744
> new file mode 100755
> index 000000000000..2b3c0c7e92fb
> --- /dev/null
> +++ b/tests/generic/744
> @@ -0,0 +1,56 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Luis Chamberlain.  All Rights Reserved.
> +#
> +# FS QA Test 744
> +#
> +# fsstress + compaction test

fsstress + memory compaction ?

Looks like this case is copied from g/476, just add memory_compaction
test. That makes sense to me from the test side.

I'm a bit confused on your discussion about an old bug and a new bug(?)
you just found. Looks like you're reporting a bug, and provide a test
case to fstests@ by the way. Anyway, I think there's not objection on
this test itself, right? And is this test for someone known bug or not?

> +#
> +. ./common/preamble
> +_begin_fstest auto rw long_rw stress soak smoketest
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> +}
> +
> +# Import common functions.
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.

Useless comment~

> +_supported_fs generic
> +
> +_require_scratch
> +_require_compaction
> +_require_command "$KILLALL_PROG" "killall"
> +
> +echo "Silence is golden."
> +
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount >> $seqres.full 2>&1
> +
> +nr_cpus=$((LOAD_FACTOR * 4))
> +nr_ops=$((25000 * nr_cpus * TIME_FACTOR))
> +fsstress_args=(-w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus)
> +
> +# start a background getxattr loop for the existing xattr
> +runfile="$tmp.getfattr"
> +touch $runfile
> +while [ -e $runfile ]; do
> +	echo 1 > /proc/sys/vm/compact_memory
> +	sleep 15
> +done &
> +getfattr_pid=$!

I didn't see any other place use this "getfattr_pid". Better to deal with
it in _cleanup().

> +
> +test -n "$SOAK_DURATION" && fsstress_args+=(--duration="$SOAK_DURATION")
> +
> +$FSSTRESS_PROG $FSSTRESS_AVOID "${fsstress_args[@]}" >> $seqres.full
> +
> +rm -f $runfile
> +wait > /dev/null 2>&1

Better to do these things in _cleanup() function, make sure all background
processes can be done in _cleanup.

> +
> +status=0
> +exit
> diff --git a/tests/generic/744.out b/tests/generic/744.out
> new file mode 100644
> index 000000000000..205c684fa995
> --- /dev/null
> +++ b/tests/generic/744.out
> @@ -0,0 +1,2 @@
> +QA output created by 744
> +Silence is golden
> -- 
> 2.43.0
> 
> 


