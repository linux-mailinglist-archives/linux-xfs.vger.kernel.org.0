Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8692E5BB
	for <lists+linux-xfs@lfdr.de>; Wed, 29 May 2019 22:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfE2UH3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 May 2019 16:07:29 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33579 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbfE2UH2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 16:07:28 -0400
Received: by mail-io1-f66.google.com with SMTP id u13so3022092iop.0
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 13:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E7q0Sakd1TMkC1/w4DpfOGtUEuXYbC69ZIx84jI1pQE=;
        b=DOIjodoKBpVvicd8iDtrrwhif6Fib/sukeSD0x56bYmuIi1beWgtXwdytda7dWQgMd
         gJ2U5BibWYNUP2VaPQxUld1xky26JJBe0Ywg6g4AGWVI57ApfHMaGaai7ThzOR2KE0b7
         mrt1w7wiTb22NSefuJS1fE0oNa2zhUNQ4XBSU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E7q0Sakd1TMkC1/w4DpfOGtUEuXYbC69ZIx84jI1pQE=;
        b=b/hiCJgCkT2vC+bh/yeOVDlGJY/rYM4wweIy9i4keB8c+uDc6lh4/H9YoRWiEdSkxi
         7AMgSR8aSuP6+1m0ha60vsutmmyjZF2nyEzeBZQRO8jt2QYqRAIxKT1lsKE9ufi3DmHA
         Mta56L0xcy7sTCeIoMAaqbbPvOGKHGlZflXvBIWUqO2Ulf8EQ1OictybDd8AfLxukVTe
         yq9OECpKcA1x7B52ilQVjF/067M6xp+Gu+yID3TFenGpu42X2tug6e/MOPDLtCJefv1O
         IcdDbvCr4m9d/1C00uXtRg0ViqxB2vxOq1EPCuYWpCHh4nh4Mw+jEe3PG2JA+BbzYq8y
         Yg3g==
X-Gm-Message-State: APjAAAUEkYjHdiFxl3QIPMYujBWH5LV7QGBT5AMkdmrllgxGhRDS8LCr
        gLpbYhCGBwX5LKvWn2ProNHA91M0FuF7g2UELgciwQ==
X-Google-Smtp-Source: APXvYqwLZb/ME4zrVxF6lxBEvoSyJfBdg+7QPeUl990G3Qs2vdNuL/EBUo+uiDuS9u57oCFZKxBV641QCIayNm/fiJ0=
X-Received: by 2002:a5d:9f11:: with SMTP id q17mr20213351iot.212.1559160448108;
 Wed, 29 May 2019 13:07:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190529174318.22424-1-amir73il@gmail.com> <20190529174318.22424-12-amir73il@gmail.com>
 <CAOQ4uxiAa5jCCqkRbq7cn8Mmnb0rX7piMOfy9W4qk7g=7ziJnA@mail.gmail.com>
In-Reply-To: <CAOQ4uxiAa5jCCqkRbq7cn8Mmnb0rX7piMOfy9W4qk7g=7ziJnA@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 29 May 2019 22:07:17 +0200
Message-ID: <CAJfpegsft_1TZ-OjaAdmGE--a8+deCQwFjbcAYJsEdbp2YWQSw@mail.gmail.com>
Subject: Re: [PATCH v3 11/13] fuse: copy_file_range needs to strip setuid bits
 and update timestamps
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        Luis Henriques <lhenriques@suse.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 29, 2019 at 9:38 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Hi Miklos,
>
> Could we get an ACK on this patch.
> It is a prerequisite for merging the cross-device copy_file_range work.
>
> It depends on a new helper introduced here:
> https://lore.kernel.org/linux-fsdevel/CAOQ4uxjbcSWX1hUcuXbn8hFH3QYB+5bAC9Z1yCwJdR=T-GGtCg@mail.gmail.com/T/#m1569878c41f39fac3aadb3832a30659c323b582a

That likely is actually an unlikely.

Otherwise ACK.

Thanks,
Miklos
