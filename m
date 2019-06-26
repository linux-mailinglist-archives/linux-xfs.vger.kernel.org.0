Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9584D57436
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Jun 2019 00:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfFZWTH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 18:19:07 -0400
Received: from mail-yb1-f172.google.com ([209.85.219.172]:35094 "EHLO
        mail-yb1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfFZWTG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 18:19:06 -0400
Received: by mail-yb1-f172.google.com with SMTP id i203so283618ybg.2
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 15:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=editshare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=52LYnRXI1AtLAKrANeGNSSy4qme8XhGESEE/aDeKW+8=;
        b=Qxa+pxOTh7de0+HlKEazPIaD4yc9Rl4giNLuBQw5C+It02zWTWxaIgSn5tlrjvkdiu
         uXqt/Zc95euqIl1eG0YP1ZJv3CSwcxuLdATIJ/IP3u4eFahtfYWyu30KAtHgq5fsPFwI
         6K1wWeR55tiWw9ScpRAKp4hSLAFXp7wv7D4fA/RO24mscVh/SIrUAkai2wCqfPJIuGvP
         lgk/fKMGOs4CI9e8LH4dQ9cntM8SoDghAVndOkghCax/Q98IfOhynqCSEmAK0fP/7i+U
         68N2XC55vZY/z/O1T/MvE7MlXKhLWPnd1E2+slInFmLN9Z4O8/MjcfI5/jc/ZG57H57f
         HA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=52LYnRXI1AtLAKrANeGNSSy4qme8XhGESEE/aDeKW+8=;
        b=AMrqum4c9UJWmS453CbBlE5h8F+2pbHvCnhxtsjmQpvq5mi/F9MIcBbjyO/0v2Azr9
         14Ml9EYECgRAPWzxepPho1R1Z6bJJ4D+qbR6Xe5cvTEHzQxxujNwCkwPLR7jU1KoZnTI
         dtR57Vqg8h99KceAhhT9EvUxr0DCgw4nUus2wgHzS3P3f0knpLPbZCGl1Z42YUzZWE5b
         hGu7OmrSp2LBDjVHKhJlrhyjSnceSZkOcubYIH8PlLsk0xU0Ltd256igJD4t4NzNF04A
         YsPGJHUl9YTk90WE6iSDmGDlhx/tovutH0PgAI1KUePF287+HhuS8zUI83WBbIEP+CZC
         XuwA==
X-Gm-Message-State: APjAAAU/x+ccOd+6oS9hiGJfT/QBJVDXRrdhluMj5WlinVJfVhzeDBfQ
        dXL+AODQ8Rr84EEP1Z9JOa5psHSWOnQ/V+ojTcWiEyXZqLb3AQ==
X-Google-Smtp-Source: APXvYqzwhts8Ks6f5O78RFr8c7jgFFB7aogRrZ9eVTQekGkFCcD/52V0reWqXgPZU5uuwUGbWlBgVhgRHOfPYa8Y/gE=
X-Received: by 2002:a25:8311:: with SMTP id s17mr494902ybk.13.1561587545629;
 Wed, 26 Jun 2019 15:19:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAFVd4NsBRm_pbySuSc4U=a=G4wiowZ3gFBooLEQZGZJe9V748g@mail.gmail.com>
 <CAJCQCtRD2g1c5uyDurLbt7tedPM8g6f1-74ECAW9cA1Do1yNBQ@mail.gmail.com>
 <CAFVd4NszdvQ0P4KPo9pRqtRRJxebhtMBqGVAZTmGAPBWe25nFg@mail.gmail.com> <660f9958-b10a-3bf4-6910-87a811b2a7c3@sandeen.net>
In-Reply-To: <660f9958-b10a-3bf4-6910-87a811b2a7c3@sandeen.net>
From:   Rich Otero <rotero@editshare.com>
Date:   Wed, 26 Jun 2019 18:18:54 -0400
Message-ID: <CAFVd4Nuv9H4AAR9DPDhhdZtKV=QXFiC8AHZz9jb46EibuO568A@mail.gmail.com>
Subject: Re: XFS Repair Error
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Chris Murphy <lists@colorremedies.com>,
        xfs list <linux-xfs@vger.kernel.org>,
        Steve Alves <steve.alves@editshare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> the filesystem seems to be a disaster, probably due to bad disks - xfs_repair can't repair bad hardware, of course.
>
> current xfs_repair completes for me without error, after spitting out over 450,000 lines of detected corruption issues.
>
> so my suggestions going forward would be:
>
> 1) fix storage
> 2) get newer admin tools for next time
>
> I appreciate the report, but not much to do w/ such an old version (and it seems already fixed in any case).

Since I knew that there were issues with the hardware, that's pretty
much what I expected to hear. It's good to know that the current
version could repair this sort of problem. Thanks for the reply.

Regards,
Rich Otero
EditShare
rotero@editshare.com
617-782-0479

On Wed, Jun 26, 2019 at 6:10 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 6/26/19 4:30 PM, Rich Otero wrote:
> >> This applies
> >> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> >
> > kernel version: 3.12.17
>
> ~6 years old :(
>
> > xfsprogs version: 3.1.7
>
> 8 years old :(  So, bug reports are not really useful here ;)
>
> the filesystem seems to be a disaster, probably due to bad disks - xfs_repair can't repair bad hardware, of course.
>
> current xfs_repair completes for me without error, after spitting out over 450,000 lines of detected corruption issues.
>
> so my suggestions going forward would be:
>
> 1) fix storage
> 2) get newer admin tools for next time
>
> I appreciate the report, but not much to do w/ such an old version (and it seems already fixed in any case).
>
> -Eric
