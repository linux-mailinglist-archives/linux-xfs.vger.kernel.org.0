Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 332B3586DD
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Jun 2019 18:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfF0QSw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Jun 2019 12:18:52 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:41326 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfF0QSw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 12:18:52 -0400
Received: by mail-yb1-f196.google.com with SMTP id y67so1852373yba.8
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jun 2019 09:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zz6cmw43Z4bqXdFehBwYMRrbFUgC5H6h4woIdwEDLcs=;
        b=Colo3jWJWj3lyXL8CPLRQAl6u0sGVwyTEVmm1STSmKgCrG6tIFCfF6O4hkW2sktFi3
         eNSPTvNlw8Nvv4dnEZrZM5e+UqI+Tiqv6ICFqTo2OVowtmmnW4FRV6Z3Aq6tNzk30w8y
         4bdjyaLW0tV+GaagNnPjIgOCROL4dhKLEKr5whm+udboWOzqeE5C4rHhZepKBJr1Xn4i
         O7/D3IpmxYYhE1Q2FDASssHdK1k1+N2rbi8g/YVQcfuD+PdMke2f3KC4rKqFlqB7OkxH
         HPx9YFdy8doyvRs1NL5ISx08XC34hoW6mZXJkEpy+biuJPzD2DzTZW3LS+Ju4B03qsQl
         JpyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zz6cmw43Z4bqXdFehBwYMRrbFUgC5H6h4woIdwEDLcs=;
        b=CdnZ2YqUMPFIyrj6bktE1CRSz/u2erocNE3fIoQh4/cmyKsD7BSOGP2CI58Rejm/My
         eOvmu/VdMNcIgXVTtSHfcwDjIE/N6ezRgnx6hkzE0gy2yrPfO0W0F5ndJJaupmHp7rVI
         7ove57qORV5PFcbQ54UigpledWvxC4N+SKdVLwo9lxU+DSw6tMCeH3GGfzghYMx74tz7
         CsW4Oi2y/ZtNyDvPOdOxRJnlVZ1PK6YDLGwuABt1WgFqSyYLeqktnz3PQxLCesxzGcLl
         nRFCCaZpdOTX2T1iUAJY5H4KMhoJA9IoRlTu6phlTgF6GtOUkaMH3P14fU3Jtiz7JgdS
         LnSA==
X-Gm-Message-State: APjAAAW07v+mvjZfVBAEm3miVvhR3zJ0Yyh6ihfMc1d1oA1AuGUAVkAT
        e3hIINhZ7D+nmSmDxBylAM/syOAJz8LBkGe3eVQ=
X-Google-Smtp-Source: APXvYqyi5XRiYKGhAiAWOg7rms4xVr3C2+QyWGXZ8ATRHtASqRJBaqeM4ArdnkDLx6K9FUzi7aq4gBE2ztkDkuvf6Yo=
X-Received: by 2002:a25:bf85:: with SMTP id l5mr3244705ybk.45.1561652331284;
 Thu, 27 Jun 2019 09:18:51 -0700 (PDT)
MIME-Version: 1.0
References: <a665a93a-0bf8-aedb-2ba3-d4b2fb672970@linux.alibaba.com> <20190627155455.GA30113@42.do-not-panic.com>
In-Reply-To: <20190627155455.GA30113@42.do-not-panic.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 27 Jun 2019 19:18:40 +0300
Message-ID: <CAOQ4uxgqgDAdKZDYwmf0M35M3D6Ctn25-VVj3wu5XSj_4c-WdA@mail.gmail.com>
Subject: Re: [backport request][stable] xfs: xfstests generic/538 failed on xfs
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Alvin Zheng <Alvin@linux.alibaba.com>,
        gregkh <gregkh@linuxfoundation.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        "joseph.qi" <joseph.qi@linux.alibaba.com>,
        caspar <caspar@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 27, 2019 at 6:55 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Thu, Jun 27, 2019 at 08:10:56PM +0800, Alvin Zheng wrote:
> > Hi,
> >
> >     I  was using kernel v4.19.y and found that it cannot pass the
> > generic/538 due to data corruption. I notice that upstream has fix this
> > issue with commit 2032a8a27b5cc0f578d37fa16fa2494b80a0d00a. Will v4.19.y
> > backport this patch?
>
> Hey Alvin,
>
> Thanks for Bringing this to attention.  I'll look into this a bit more.
> Time for a new set of stable fixes for v4.19.y. Of course, I welcome
> Briant's feedback, but if he's busy I'll still look into it.
>

FWIW, I tested -g quick on xfs with reflink=1,rmapbt=1 and did not
observe any regressions from v4.19.55.

Luis, sorry I forgot to CC you on a request I just sent to consider 4 xfs
patches for stable to fix generic/529 and generic/530:

3b50086f0c0d xfs: don't overflow xattr listent buffer
e1f6ca113815 xfs: rename m_inotbt_nores to m_finobt_nores
15a268d9f263 xfs: reserve blocks for ifree transaction during log recovery
c4a6bf7f6cc7 xfs: don't ever put nlink > 0 inodes on the unlinked list

If you can run those patches through your setup that would be great.

Thanks,
Amir.
