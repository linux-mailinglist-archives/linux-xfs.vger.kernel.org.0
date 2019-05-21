Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA681245D9
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 04:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfEUCKU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 22:10:20 -0400
Received: from mail-ot1-f45.google.com ([209.85.210.45]:41814 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfEUCKU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 22:10:20 -0400
Received: by mail-ot1-f45.google.com with SMTP id l25so6533281otp.8
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 19:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vaultcloud-com-au.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N9KxDyH5sZlnanonQgCIESV9nUjPnd6roFLl0SeXN88=;
        b=JHPEJzmLMUxKGOQfYkJ2Wyey4xSxCk2nCsB3HHxFHcYpUIxoaPOnzP0HsGmyUKdd8b
         yoX7P+EjsTzpvRvZNt3dxwvUc0SvtUvhCNQdcF3udwDQfHCbdPCq9fJctdboV8qJl91j
         GTUxNhMKNKhdb2DeHSwnf72OZK1cPFTxKgenAJ5YgX848xa+6tKYGzKkK4OH1FkBf4bo
         t1GnZ63qHTiwYAViglcKx2NaUCW32WE5S3ebfzgdHz3AakguUWnpc8tOYfhTWam3oSva
         nsz9GrPJZnqHXJXQ4eHAPYUmgDkcu/D+kNhBgT28dg3WzVVacVFxIsb+v6A9r88VrJQi
         0Drw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N9KxDyH5sZlnanonQgCIESV9nUjPnd6roFLl0SeXN88=;
        b=EucG6layCmQiEthqPB4sUpDyk13sd+QECB6YQzhsc0IUv7RayLBjKaHZvV5VSVGPoe
         rg+FUPJ4qI1l3A1yjcwFOUBTtBh9v3oNTlsGDccqwuz249mWdqDTo9DDq8qyJ5tiDud7
         Nzo0t7oWlBPaNwADyh4/MwAWa6S54Xr2kzdyjgmY6l98tQyIvXmwy0lOSIMQ74PH/ndA
         wZfl53O+U/E/eY43IiR/xKTBix5+bs3PQBW36nt6cbhLXpWpNiQRgrQSR8iv5MPGsxR2
         knF4M2ALeBiOLOGZk+bfT313ExUm9B/6WPjGN9npdyCiURNWR13VIWWesMICMRQU01sf
         DvvQ==
X-Gm-Message-State: APjAAAVmp8wUUAyK/jhok6scR4jglRoWzhQEeNnK3BTPz+vSEOGTnC/P
        OAQVlIV1aaXNqxYexUrgrlUgQkIQBEYKWtRfSHZ4w4Dmev0=
X-Google-Smtp-Source: APXvYqyk5w+OqsVI3QQQIpUYrDuzfHalaMePmzGKx0P3AaggAOCRNkbg49gDRDHa8BIgOz7IcC/nVjPMBi1S26TT+cU=
X-Received: by 2002:a9d:1b6d:: with SMTP id l100mr25982506otl.15.1558404620040;
 Mon, 20 May 2019 19:10:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAHgs-5XkA5xFgxgSaX9m70gduuO1beq6fiY7UEGv1ad6bd19Hw@mail.gmail.com>
 <20190513140943.GC61135@bfoster> <683a9b7b-ad5c-5e91-893e-daaa68a853c9@sandeen.net>
 <CAHgs-5Vybp+diCoecfEWbHLRScNnsHKW7-4rwhXH3H+hfcfoLg@mail.gmail.com> <20190521014336.GG29573@dread.disaster.area>
In-Reply-To: <20190521014336.GG29573@dread.disaster.area>
From:   Tim Smith <tim.smith@vaultcloud.com.au>
Date:   Tue, 21 May 2019 12:10:09 +1000
Message-ID: <CAHgs-5V1v976so3BF7OhbSk0KypqSVwE5b4c0jWgRBCRvuaSPA@mail.gmail.com>
Subject: Re: xfs filesystem reports negative usage - reoccurring problem
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 11:43 AM Dave Chinner <david@fromorbit.com> wrote:
> 8756a5af1819 ("libxfs: add more bounds checking to sb sanity checks")
> 2e9e6481e2a7 ("xfs: detect and fix bad summary counts at mount")
>
> were both merged in 4.19. Well, that would explain why you aren't
> seeing warnings or having it fixed automatically on detection.
>
> IOWs, whatever the cause of your single bit error is, I don't know,
> but it would seem that recent kernels will detect the condition and
> automatically fix themselves at mount time.

This kit is in a legacy environment to be (eventually) decommissioned,
so I'll patch the kernel to work around the issue until we can put the
hardware to bed.

Absolute legend! Thank you for all your help!
