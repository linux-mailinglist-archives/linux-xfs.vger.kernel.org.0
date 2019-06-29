Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAE45A97A
	for <lists+linux-xfs@lfdr.de>; Sat, 29 Jun 2019 09:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfF2Hlr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 29 Jun 2019 03:41:47 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:45346 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbfF2Hlr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Jun 2019 03:41:47 -0400
Received: by mail-yb1-f195.google.com with SMTP id j133so949085ybj.12
        for <linux-xfs@vger.kernel.org>; Sat, 29 Jun 2019 00:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ujp/yG7s5w2RRfXra+Wl5pSc+EJ++atPMXI8MQVdXFM=;
        b=pHHfIt3bEmRfLK+KJCWUjfZIfkqXHW0q6A4GYJoc50D1frImKrZaic2HVPd9tdXm0Z
         k718M/Q2hGwRjKSz3YMG/+0o0ZFnIhHv2PfKmstocxoXBlGMIBuxSU4vo5fvigvSA2RC
         1ck/P2Lg7O8QxNDJMVYrcgg2AEqgl9QRtrVW53U438pN9IXhpYWGLeVaw/7vk/V7UUDs
         zgEPLXKgKpsSfiOntyxOL6w4EyD1vMVfFndUsN9gxcOPR/IkFSWkP8W5Q2aqI95pzu2X
         R/23ongPb7hcGgkm2Q9i6aXw+BZSQIqqRcmER4iMSkIsW6MAR4jWeGbC8/97gVFlYvFS
         357w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ujp/yG7s5w2RRfXra+Wl5pSc+EJ++atPMXI8MQVdXFM=;
        b=jnuWQ+vMcO+3p3GrTN0y2LYXaF9Bi+FvOwotHtq4aA85g5CUFF8nkKLU8cO4IIpA2M
         wuHlPIX1uUsruANiPWFMcwunQmZGFRVzYK+Dxg5FZNfmoHKJleHugd77X7r+vsc2A9Q+
         S06TwsWSxiDGll8Dr8mexz8W7WDHlGQCXU9/aNq3JyNVJlv4ThRpAfq77qwle2L6oarj
         eqXyh/iqXiTodIMTAKk5W8KN1yrv2vfP3LeB720lS1HZqaMIDFKiVA5Aacwx+AnLLOCO
         2IOHE0OZGvJHnq7S1s6aXzQyGlcnfVriBYJ67DtbzBNe2MJiFEYcI3V5HPA9fzp8CZza
         Rtxg==
X-Gm-Message-State: APjAAAW9av5vOothD6iIP3UIttcLaYQwaHUD0r+3Q73XxIauMEZot/Pm
        MTZjnncu+RZcNGUXYF2VnHjgEUEDJ6nmVUKol7w=
X-Google-Smtp-Source: APXvYqzVxX8fMt1AmIiij/2D5Rh5789MnRqYhVcW8mrR8+TQYHZQ5S63wiBENHo1jND6NM93I/P+AtRmTpwjfcnij74=
X-Received: by 2002:a25:8489:: with SMTP id v9mr8976327ybk.144.1561794106749;
 Sat, 29 Jun 2019 00:41:46 -0700 (PDT)
MIME-Version: 1.0
References: <a665a93a-0bf8-aedb-2ba3-d4b2fb672970@linux.alibaba.com>
 <20190627155455.GA30113@42.do-not-panic.com> <CAOQ4uxgqgDAdKZDYwmf0M35M3D6Ctn25-VVj3wu5XSj_4c-WdA@mail.gmail.com>
 <20190627213520.GG19023@42.do-not-panic.com> <CAOQ4uxht-inVEjRWXtkbRPXTA9DvRNTLSPNEZ0Eh=nUhEhNO-A@mail.gmail.com>
 <20190628215051.GE30113@42.do-not-panic.com>
In-Reply-To: <20190628215051.GE30113@42.do-not-panic.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 29 Jun 2019 10:41:35 +0300
Message-ID: <CAOQ4uxgU_Ad50ZJLhmfY0mGHWutNXJU1DhEkA++-Jak2PgkUcA@mail.gmail.com>
Subject: Re: [backport request][stable] xfs: xfstests generic/538 failed on xfs
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Alvin Zheng <Alvin@linux.alibaba.com>,
        gregkh <gregkh@linuxfoundation.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        "joseph.qi" <joseph.qi@linux.alibaba.com>,
        caspar <caspar@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 29, 2019 at 12:50 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Fri, Jun 28, 2019 at 07:46:34AM +0300, Amir Goldstein wrote:
> > On Fri, Jun 28, 2019 at 12:35 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > >
> > > On Thu, Jun 27, 2019 at 07:18:40PM +0300, Amir Goldstein wrote:
> > > > On Thu, Jun 27, 2019 at 6:55 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > > > >
> > > > > On Thu, Jun 27, 2019 at 08:10:56PM +0800, Alvin Zheng wrote:
> > > > > > Hi,
> > > > > >
> > > > > >     I  was using kernel v4.19.y and found that it cannot pass the
> > > > > > generic/538 due to data corruption. I notice that upstream has fix this
> > > > > > issue with commit 2032a8a27b5cc0f578d37fa16fa2494b80a0d00a. Will v4.19.y
> > > > > > backport this patch?
> > > > >
> > > > > Hey Alvin,
> > > > >
> > > > > Thanks for Bringing this to attention.  I'll look into this a bit more.
> > > > > Time for a new set of stable fixes for v4.19.y. Of course, I welcome
> > > > > Briant's feedback, but if he's busy I'll still look into it.
> > > > >
> > > >
> > > > FWIW, I tested -g quick on xfs with reflink=1,rmapbt=1 and did not
> > > > observe any regressions from v4.19.55.
> > >
> > > As you may recall I test all agreed upon configurations. Just one is not
> > > enough.
> >
> > Of course. It's just a heads up that testing looks sane so far.
> >
> > >
> > > > Luis, sorry I forgot to CC you on a request I just sent to consider 4 xfs
> > > > patches for stable to fix generic/529 and generic/530:
> > > >
> > > > 3b50086f0c0d xfs: don't overflow xattr listent buffer
> > > > e1f6ca113815 xfs: rename m_inotbt_nores to m_finobt_nores
> > > > 15a268d9f263 xfs: reserve blocks for ifree transaction during log recovery
> > > > c4a6bf7f6cc7 xfs: don't ever put nlink > 0 inodes on the unlinked list
> > > >
> > > > If you can run those patches through your setup that would be great.
> > >
> > > Sure, it may take 1-2 weeks, just a heads up. If you're OK with waiting
> > > then great. Otherwise I personally cannot vouch for them. What types of
> > > tests did you run and what configurations?
> > >
> >
> > So far I tested, -g quick with reflink=1,rmapbt=1.

FYI, -g auto found no regression with reflink=1,rmapbt=1.

> >
> > Sasha wrote that more results will be in tomorrow...
>
> I'd rather be cautious, how about we wait until I also confirm
> no regressions as well. In this case since we already have candidates
> you identified, and Darrick vouchces for, I can just jump start the
> process and deal with both manually reviewing each of these changes
> and also confirming no regressions are in place on my tests as well.
>
> Then we'd have at least 3 XFS pair of eyeballs reviewing and at least
> 2 full independent tests vouching for these.
>

Sure, that'd be great. How long does your full run take?

Thanks,
Amir.
