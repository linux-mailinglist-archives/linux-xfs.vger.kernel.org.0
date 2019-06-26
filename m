Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9A456CE7
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 16:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfFZOzW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 10:55:22 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:45345 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727641AbfFZOzW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 10:55:22 -0400
Received: by mail-yb1-f195.google.com with SMTP id j8so1477073ybo.12;
        Wed, 26 Jun 2019 07:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HOvJy2yVgxChoqgTWHjy1r3hw+9MHPpXoDHVXZjIv0k=;
        b=A4Ts2uAkQRze0x+TVOMLRRVzaEGcxpS6CldQ5HxXUPkEMo3DRS1LETluMko7U1i/Zz
         p/2ezQQC0T/QCiDmuoAa5eC27POZTneNofN/+FnKnfZYoxvRhH0sks4t2ylDTmnkYaSc
         MQd/TaYfEKWnSJT9EDhWFdpBW+NAPXs/IdKuXyKDgy4gYgPY5WEEIsyjN1OpewUWo88d
         zNvbme6z8ZRvNJGd05JUbU7TzBmwD6ObBDN4Y1+860v3Grtl+bERu55+notnvwbPTmLR
         HE/4vnRjbel7uNwuNGIDbHSmWrXphtOAy4GjSt3v96vz+hCwYXScIw2Prpxy1OnZTAGx
         ZZAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HOvJy2yVgxChoqgTWHjy1r3hw+9MHPpXoDHVXZjIv0k=;
        b=bKS3h0MAJhWpe+lyNGmechKdq0bnAdLewmqMAG8M+adCCRiKEXN4K1P5lPyMICLSVq
         3xvFH+0I/o5dc27ESkZDVF0rH3FtUlOeoRv7EWe+3UlT2zT7PdMlA1UrM3/k2fP7yCtD
         JxoHbvv/rfgg4yzegjy158M0RdyFeT9+D2pEt0fZjnY60lvdNyiqtuYxcHiOjytUeKiG
         uLepA9gnyybcsDf0wTRkpLe/Jyeyql1yinvJoUjKSdn7P4itK1t49tzhy5w2Ma7ANxSK
         9uC0rIktd5rUoU5WLayvZioUODVHgGlCnydgi68g0Bt7HzZ/f4QA1MpwZigRHdXMNkqK
         GbZg==
X-Gm-Message-State: APjAAAXt2NIUQgZtCjTHjP5OvOdqKbmdyv5yllWEvvLZfsh+b0mcUmep
        MwFqLwJ3ef01WC86+mSVtOUgWn3Zlv2y6J623LE3Hg==
X-Google-Smtp-Source: APXvYqxpYn0LpcA73MH/szA8J++W9UtsNim1d2vfBHrVwuBf/KWH+B81kUiGzI1V4qeSSyQcNLZSS3ppzA8Hn3otdhw=
X-Received: by 2002:a25:db14:: with SMTP id g20mr2965902ybf.126.1561560921240;
 Wed, 26 Jun 2019 07:55:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190626061711.27690-1-amir73il@gmail.com> <fb00d61f-127e-b190-4059-81138279e0cc@sandeen.net>
In-Reply-To: <fb00d61f-127e-b190-4059-81138279e0cc@sandeen.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 26 Jun 2019 17:55:09 +0300
Message-ID: <CAOQ4uxjoXqSKWLxG5vp9O=Vvnrpd_RfocNX4LUp5UytvVMx9-Q@mail.gmail.com>
Subject: Re: [PATCH v2] xfs_io: allow passing an open file to copy_range
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 26, 2019 at 5:41 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 6/26/19 1:17 AM, Amir Goldstein wrote:
> > Commit 1a05efba ("io: open pipes in non-blocking mode")
> > addressed a specific copy_range issue with pipes by always opening
> > pipes in non-blocking mode.
> >
> > This change takes a different approach and allows passing any
> > open file as the source file to copy_range.  Besides providing
> > more flexibility to the copy_range command, this allows xfstests
> > to check if xfs_io supports passing an open file to copy_range.
> >
> > The intended usage is:
> > $ mkfifo fifo
> > $ xfs_io -f -n -r -c "open -f dst" -C "copy_range -f 0" fifo
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >
> > Eric,
> >
> > Re-posting this patch with Darrick's RVB, since it was missed last
> > two for-next updates.
>
> Thanks.  See, this is why I send that email ;)
>
> I was wondering about a small tweak to the man page to make it clear
> that "-f N" refers to "open file number N as shown by the files command"
> but I guess sendfile already uses the same terminology with no further
> explanation, so maybe it's ok.
>
> my only concern is this:
>
> +       if (optind != argc - src_file_arg) {
> +               fprintf(stderr, "optind=%d, argc=%d, src_file_arg=%d\n", optind, argc, src_file_arg);
>                 return command_usage(&copy_range_cmd);
> +       }
>
> spitting out source code bits when the user misuses the command isn't
> my favorite thing.  Should remove the fprintf, I think, as it's apparently
> for debugging the patch, not for general use?  I can do that on commit
> if you're ok with it.

Of course. I just forgot to remove it. My bad.

Thanks,
Amir.
