Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB3D66A6F2
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Jul 2019 13:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387552AbfGPLGH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 16 Jul 2019 07:06:07 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53804 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733037AbfGPLGH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jul 2019 07:06:07 -0400
Received: by mail-wm1-f68.google.com with SMTP id x15so18219026wmj.3
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2019 04:06:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=x5b6E2x880qXUhUUZTb6ghOGf7FBWGyq4IjIPQG7uIk=;
        b=tQQYSDYd+oJ9si8LXEQPkIrKRTkPwMszU9WW3RZn07hr9SiT7ZB9tQD1IQaKbcaZEm
         573lrXN3O5WwAxyCcb92X4FsKsyrn/pmSu7ReHjFmpl0gmIxqClrBsqhcxA64zhtNCSV
         NX9yGR6cZFYhxTj4wJCzg+wJt5aXabOPAoa9x3l0GJGMhuBMbd6pZCQ7CrLHaF8y77JP
         wBO5nNK4HqNk2XgsiP2rqYEei6ILQrFpSgPzhMYBG+iV7xpKcw8QKe+7nrxoJbUxE6lP
         czMOMcrAJeQ90y4/QVOYaaE0xxNkiwb7jY0JYtAeTuQk+jzhRPp/cFZK9hlgNhSlkGU4
         bU4A==
X-Gm-Message-State: APjAAAXKd1lwIzsJM8d80Sw16PFWek3RrU6/hQzFzDZ9S622uwcH8yK6
        2Baxd855AEmhvnINcMY566xP9g==
X-Google-Smtp-Source: APXvYqwq8lr5rsaGI76i29tbL1U3ADVVbryjrfZQacWfkjsTJ+jVJ+5KnXuZduhEEx5TK0qVJ2OEMg==
X-Received: by 2002:a1c:a7ca:: with SMTP id q193mr32168022wme.150.1563275165155;
        Tue, 16 Jul 2019 04:06:05 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id 2sm24123048wrn.29.2019.07.16.04.06.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 04:06:04 -0700 (PDT)
Date:   Tue, 16 Jul 2019 13:06:02 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: test statfs on project quota directory
Message-ID: <20190716110602.pw5g33ynux5p5xpy@pegasus.maiolino.io>
Mail-Followup-To: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
References: <20190716093550.23059-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716093550.23059-1-zlang@redhat.com>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Zoro.

On Tue, Jul 16, 2019 at 05:35:50PM +0800, Zorro Lang wrote:
> There's a bug on xfs cause statfs get negative f_ffree value from
> a project quota directory. It's fixed by "de7243057 fs/xfs: fix
> f_ffree value for statfs when project quota is set". So add statfs
> testing on project quota block and inode count limit.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> This V2 patch changes this case from a generic case to a xfs only case, due to
> ext4 has different behavior.
> 
.
.
.
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch
> +_require_xfs_quota
> +
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_enable_pquota
> +_qmount_option "prjquota"
> +_qmount
> +_require_prjquota $SCRATCH_DEV
> +
> +# Create a directory to be project object, and create a file to take 64k space
> +mkdir $SCRATCH_MNT/t
> +$XFS_IO_PROG -f -c "pwrite 0 65536" -c sync $SCRATCH_MNT/t/file >>$seqres.full
> +
> +# Setup temporary replacements for /etc/projects and /etc/projid
> +cat >$tmp.projects <<EOF
> +42:$SCRATCH_MNT/t
> +EOF
> +
> +cat >$tmp.projid <<EOF
> +answer:42
> +EOF

> +
> +quota_cmd="$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid"
> +$quota_cmd -x -c 'project -s answer' $SCRATCH_MNT >/dev/null 2>&1
> +$quota_cmd -x -c 'limit -p isoft=53 bsoft=100m answer' $SCRATCH_MNT

I wonder if is there any specific reason why you're using project quota config
files for this test? Maybe it would simplify the test if you replace the config
files and the quota command by something like:

$quota_cmd -x -c 'answer -s -p $SCRATCH_MNT/t 42' $SCRATCH_MNT >/dev/null 2>&1
$quota_cmd -x -c 'limit -p isoft=53 bsoft=100m 42' $SCRATCH_MNT

Which would remove from the test all the configuration files setup


> +
> +# The itotal and size should be 53 and 102400(k), as above project quota limit.
> +# The isued and used should be 2 and 64(k), as this case takes. But ext4 always
> +# shows more 4k 'used' space than XFS, it prints 68k at here. So filter the
> +# 6[48] at the end.

If this is a XFS only test, we don't need this comment right?

> +df -k --output=file,itotal,iused,size,used $SCRATCH_MNT/t | \
> +	_filter_scratch | _filter_spaces
> +

Cheers

-- 
Carlos
