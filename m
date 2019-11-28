Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8A7910C3D5
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Nov 2019 07:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbfK1GRt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 28 Nov 2019 01:17:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31037 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726436AbfK1GRt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Nov 2019 01:17:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574921867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SZyNPfVsQkaxDgBh37VBqORWkT3R8jk6qn7L5EizNZ0=;
        b=WaimODYaLHbRFGKAXAsj2C1H1PdMC5yosnDObvKnwQAyuZ7xj0cZxmovq4E/n9pk98ZLvU
        NUGtCpzXtSTOFU4LFUfswNPZsL3xBozQQu0hybk8W5H+0xSdaHc+pfajYmAxqOaEHvk/qr
        QcCwmUuqvvNpvWfIkdbUl0aOTowH81Y=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-ny_qPnUEO4qTMt0Bk_hMsg-1; Thu, 28 Nov 2019 01:17:45 -0500
Received: by mail-vk1-f199.google.com with SMTP id k23so9588171vkn.5
        for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2019 22:17:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=l7PeDk4xK/DRueCP3Y02sj0vWbM3ENu5OwXFsj9EG40=;
        b=K5stMKE6SP2zVMhAK8Mz7R+7lPZaj3xblauOYkf/Fw4xwejC2qxBx5NNWcPfU0m3Y6
         SlciRsIlBU8kNGpZMmKW3jrKMRkZiXypyRJ8cwT0N0+TrY8QOUkPBN8n7nPm6/DRz8BQ
         hDLhFieNO7Y8lY68O9+VJlmrTifqRAt1UCuDXLKG82kaxG0CJyk63HxYzMqwOmE6AVGg
         z6kPe4XB83BT9PXhQR8o3kKp5Q1ZAMM+Y8JyM/gofdqPlAfbwV/PV+2dfIXwIKrwm1md
         Na8MZbnOSlre2vMd+iN4X4Oka8osL1cd75qWycF/2DJJ9wgCq98QyjUuzEl9H29547Im
         219g==
X-Gm-Message-State: APjAAAUzQNo60Q1w/uTw2VcfosDGoKrA4Kez3020h1gdJgAj6ZSGsrDn
        Ihp3TzCAsLyKfDBkvxxnwCDoohK0YGlOmuZpTiNsBQB37sblRYpNl75qPVsmv+Jl0MpfT4CDXom
        pGojRCXZtUMaOVfvwiLOCWSOYaHfKbO+1FYUJ
X-Received: by 2002:ab0:7403:: with SMTP id r3mr5192682uap.42.1574921864872;
        Wed, 27 Nov 2019 22:17:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqyl7sbhE7A0vqQiy2gBxoTQTyxrDayo3BxwaCgrRS4wafuYyHx58HkYvLifyEmrmbmgnB7gXBNz9CI3rmIrRAo=
X-Received: by 2002:ab0:7403:: with SMTP id r3mr5192667uap.42.1574921864533;
 Wed, 27 Nov 2019 22:17:44 -0800 (PST)
MIME-Version: 1.0
References: <20191127212152.69780-1-preichl@redhat.com>
In-Reply-To: <20191127212152.69780-1-preichl@redhat.com>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Thu, 28 Nov 2019 07:17:33 +0100
Message-ID: <CAJc7PzVRF034H1YN1WN1=yR2FkSxPtZpXCpv=GfsyRnOgEbfMw@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mkfs: Break block discard into chunks of 2 GB
To:     linux-xfs@vger.kernel.org
X-MC-Unique: ny_qPnUEO4qTMt0Bk_hMsg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Oh,  I forgot to add '\n' to one of the printf statements. I'll send
fixed patch immediately.

On Wed, Nov 27, 2019 at 10:23 PM Pavel Reichl <preichl@redhat.com> wrote:
>
> Some users are not happy about the BLKDISCARD taking too long and at the =
same
> time not being informed about that - so they think that the command actua=
lly
> hung.
>
> This commit changes code so that progress reporting is possible and also =
typing
> the ^C will cancel the ongoing BLKDISCARD.
>
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 50 ++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 37 insertions(+), 13 deletions(-)
>
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 18338a61..7fa4af0e 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1240,17 +1240,40 @@ done:
>  }
>
>  static void
> -discard_blocks(dev_t dev, uint64_t nsectors)
> +discard_blocks(dev_t dev, uint64_t nsectors, int quiet)
>  {
> -       int fd;
> +       int             fd;
> +       uint64_t        offset =3D 0;
> +       /* Discard the device 2G at a time */
> +       const uint64_t  step =3D 2ULL << 30;
> +       const uint64_t  count =3D BBTOB(nsectors);
>
> -       /*
> -        * We intentionally ignore errors from the discard ioctl.  It is
> -        * not necessary for the mkfs functionality but just an optimizat=
ion.
> -        */
>         fd =3D libxfs_device_to_fd(dev);
> -       if (fd > 0)
> -               platform_discard_blocks(fd, 0, nsectors << 9);
> +       if (fd <=3D 0)
> +               return;
> +       if (!quiet) {
> +               printf("Discarding blocks...");
> +               printf("...");
> +       }
> +
> +       /* The block discarding happens in smaller batches so it can be
> +        * interrupted prematurely
> +        */
> +       while (offset < count) {
> +               uint64_t        tmp_step =3D min(step, count - offset);
> +
> +               /*
> +                * We intentionally ignore errors from the discard ioctl.=
 It is
> +                * not necessary for the mkfs functionality but just an
> +                * optimization. However we should stop on error.
> +                */
> +               if (platform_discard_blocks(fd, offset, tmp_step))
> +                       return;
> +
> +               offset +=3D tmp_step;
> +       }
> +       if (!quiet)
> +               printf("Done.\n");
>  }
>
>  static __attribute__((noreturn)) void
> @@ -2507,18 +2530,19 @@ open_devices(
>
>  static void
>  discard_devices(
> -       struct libxfs_xinit     *xi)
> +       struct libxfs_xinit     *xi,
> +       int                     quiet)
>  {
>         /*
>          * This function has to be called after libxfs has been initializ=
ed.
>          */
>
>         if (!xi->disfile)
> -               discard_blocks(xi->ddev, xi->dsize);
> +               discard_blocks(xi->ddev, xi->dsize, quiet);
>         if (xi->rtdev && !xi->risfile)
> -               discard_blocks(xi->rtdev, xi->rtsize);
> +               discard_blocks(xi->rtdev, xi->rtsize, quiet);
>         if (xi->logdev && xi->logdev !=3D xi->ddev && !xi->lisfile)
> -               discard_blocks(xi->logdev, xi->logBBsize);
> +               discard_blocks(xi->logdev, xi->logBBsize, quiet);
>  }
>
>  static void
> @@ -3749,7 +3773,7 @@ main(
>          * All values have been validated, discard the old device layout.
>          */
>         if (discard && !dry_run)
> -               discard_devices(&xi);
> +               discard_devices(&xi, quiet);
>
>         /*
>          * we need the libxfs buffer cache from here on in.
> --
> 2.23.0
>

