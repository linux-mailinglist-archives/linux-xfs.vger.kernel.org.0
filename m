Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4062AFAF
	for <lists+linux-xfs@lfdr.de>; Mon, 27 May 2019 10:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfE0IEX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 27 May 2019 04:04:23 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33446 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfE0IEX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 May 2019 04:04:23 -0400
Received: by mail-io1-f67.google.com with SMTP id u13so3870764iop.0
        for <linux-xfs@vger.kernel.org>; Mon, 27 May 2019 01:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oq1VRTyGOQqRfozLQ/A8lwTjPf2jKBZ94QPfTNcJawk=;
        b=XGm4JwRtnZxnJl0TL9l4hNd4nk1PvH/dkXRdmfV2DWAyME+NBLf5z049EgDVX51CIw
         YJMD6zHYp7fbhlhI3hopKWmn9LrR11Ppp7t2ErYyleIx4N1LLFVBYQpTYX/+azbjxdzj
         9NeyuL80svvkyqw8blqn1hKYRjVc4cMlKIzhM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oq1VRTyGOQqRfozLQ/A8lwTjPf2jKBZ94QPfTNcJawk=;
        b=dVSxgVSt2EBQycPbzWADlCNS76t4R7JZu3Ngq5YSjSEiwsjmNfadUmlbQ/93owrNYF
         rhJ6Ux3A1hO1mx+jGKsEi4kuFMPCraI9JkOrjcY5wthPPdSMnIFeA0gQ+j5g9MRO8QYl
         AzvOkKgbaTW8/fgO5w8bkfhwIU0QqDIe2dZdvd0iUU8OW65iwNTSwCYuE2ZeH3nxO9/6
         WWevC5Sh0Hail7G3ZXwHovR62nBiTFKBDtcxCNDqx8wpx+K/MoAD8PNWGvcZ++rbiCHu
         r5KvIl4Tet3R1c/9TejSdHiGfoaqesF7uOEQw7ojv/eQmViMMn4ziBN5XBxnff8lwuyu
         RzRA==
X-Gm-Message-State: APjAAAVw51YSfNYdaRWFfVYWzI2qHFg1S1wIl+e4PadatbKCaKGwA7KZ
        mEelssapk38iouOdPxgPWID+qYQRVmguQ/PwxFMZbw==
X-Google-Smtp-Source: APXvYqyqLD7xiKOt/BVvYR17z0F3zuEtukYV8wiIMpZYqlCIc7cXV0rD1a61DK9E6m8OgvWKU40I9SBozY9ylRqSnwc=
X-Received: by 2002:a5e:cb43:: with SMTP id h3mr1781449iok.252.1558944262167;
 Mon, 27 May 2019 01:04:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190526062825.23059-1-amir73il@gmail.com>
In-Reply-To: <20190526062825.23059-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 27 May 2019 10:04:11 +0200
Message-ID: <CAJfpegvsN4qUXOpRGwv-0PkE8tjy6dGNCtekfbFaJviiDQd8Xg@mail.gmail.com>
Subject: Re: [PATCH] ovl: support the FS_IOC_FS[SG]ETXATTR ioctls
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 26, 2019 at 8:28 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> They are the extended version of FS_IOC_FS[SG]ETFLAGS ioctls.
> xfs_io -c "chattr <flags>" uses the new ioctls for setting flags.
>
> This used to work in kernel pre v4.19, before stacked file ops
> introduced the ovl_ioctl whitelist.
>
> Reported-by: Dave Chinner <david@fromorbit.com>
> Fixes: d1d04ef8572b ("ovl: stack file ops")
> Cc: <stable@vger.kernel.org> # v4.19
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Thanks,  applied.

Miklos
