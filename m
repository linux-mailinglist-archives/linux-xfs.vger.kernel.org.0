Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD05C5A691
	for <lists+linux-xfs@lfdr.de>; Fri, 28 Jun 2019 23:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfF1Vuy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 28 Jun 2019 17:50:54 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37423 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfF1Vuy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 17:50:54 -0400
Received: by mail-pg1-f196.google.com with SMTP id g15so1256849pgi.4
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 14:50:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=B+IlCAVet3lspEZrSZe0iAml+PObdNciE/YgpB++BF8=;
        b=LY4N0zRPKcASyxkoBXGuPG66r8eOscWT2QSQbqcfDA49PPDoXhhAYmxhlc0KEMCmUW
         tz8qfgSIiR3kQ8WivYW6/qM9DgP2yvY8AzPlC+uwwqaHZSZTZ4ZUAYvOfO6zUo2JWngM
         357AE7rmPYWBIgTzYSA04KZk6brySNczecQbP57qiNt1w0O3culyrCCJk8KalJuhyLmV
         GvCbDM7qnVZZNaedCoYR5xYeZG2mAz6JQcQBb2S52WUdoWR7kzwGLf+BWKjLFwV01iFv
         1F1V1h+6q7H2mihy435pluZpwPlHKztZLMrZbpcxbM/m4GOh4yK2ReTSNarXLDtMBqq/
         WWXQ==
X-Gm-Message-State: APjAAAX5yYhAfNyB+NpkiW8oFFQ7V/S7FQ0PxJhfn/3LPHy8iteFZEf/
        cPT9/Q2aCgPrnOToMf+rofCLGjTW4J0=
X-Google-Smtp-Source: APXvYqw6jhbwCrkblrQ2AypJfb7EW1SAo6ClECEI6yqfQwZlPDHxTBEip/BtGYdUfmsy69nzhbGb9w==
X-Received: by 2002:a63:e43:: with SMTP id 3mr10567073pgo.402.1561758653369;
        Fri, 28 Jun 2019 14:50:53 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id b8sm7615784pff.20.2019.06.28.14.50.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 14:50:52 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 9F7F5402AC; Fri, 28 Jun 2019 21:50:51 +0000 (UTC)
Date:   Fri, 28 Jun 2019 21:50:51 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Alvin Zheng <Alvin@linux.alibaba.com>,
        gregkh <gregkh@linuxfoundation.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        "joseph.qi" <joseph.qi@linux.alibaba.com>,
        caspar <caspar@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [backport request][stable] xfs: xfstests generic/538 failed on
 xfs
Message-ID: <20190628215051.GE30113@42.do-not-panic.com>
References: <a665a93a-0bf8-aedb-2ba3-d4b2fb672970@linux.alibaba.com>
 <20190627155455.GA30113@42.do-not-panic.com>
 <CAOQ4uxgqgDAdKZDYwmf0M35M3D6Ctn25-VVj3wu5XSj_4c-WdA@mail.gmail.com>
 <20190627213520.GG19023@42.do-not-panic.com>
 <CAOQ4uxht-inVEjRWXtkbRPXTA9DvRNTLSPNEZ0Eh=nUhEhNO-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxht-inVEjRWXtkbRPXTA9DvRNTLSPNEZ0Eh=nUhEhNO-A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 28, 2019 at 07:46:34AM +0300, Amir Goldstein wrote:
> On Fri, Jun 28, 2019 at 12:35 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > On Thu, Jun 27, 2019 at 07:18:40PM +0300, Amir Goldstein wrote:
> > > On Thu, Jun 27, 2019 at 6:55 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > > >
> > > > On Thu, Jun 27, 2019 at 08:10:56PM +0800, Alvin Zheng wrote:
> > > > > Hi,
> > > > >
> > > > >     I  was using kernel v4.19.y and found that it cannot pass the
> > > > > generic/538 due to data corruption. I notice that upstream has fix this
> > > > > issue with commit 2032a8a27b5cc0f578d37fa16fa2494b80a0d00a. Will v4.19.y
> > > > > backport this patch?
> > > >
> > > > Hey Alvin,
> > > >
> > > > Thanks for Bringing this to attention.  I'll look into this a bit more.
> > > > Time for a new set of stable fixes for v4.19.y. Of course, I welcome
> > > > Briant's feedback, but if he's busy I'll still look into it.
> > > >
> > >
> > > FWIW, I tested -g quick on xfs with reflink=1,rmapbt=1 and did not
> > > observe any regressions from v4.19.55.
> >
> > As you may recall I test all agreed upon configurations. Just one is not
> > enough.
> 
> Of course. It's just a heads up that testing looks sane so far.
> 
> >
> > > Luis, sorry I forgot to CC you on a request I just sent to consider 4 xfs
> > > patches for stable to fix generic/529 and generic/530:
> > >
> > > 3b50086f0c0d xfs: don't overflow xattr listent buffer
> > > e1f6ca113815 xfs: rename m_inotbt_nores to m_finobt_nores
> > > 15a268d9f263 xfs: reserve blocks for ifree transaction during log recovery
> > > c4a6bf7f6cc7 xfs: don't ever put nlink > 0 inodes on the unlinked list
> > >
> > > If you can run those patches through your setup that would be great.
> >
> > Sure, it may take 1-2 weeks, just a heads up. If you're OK with waiting
> > then great. Otherwise I personally cannot vouch for them. What types of
> > tests did you run and what configurations?
> >
> 
> So far I tested, -g quick with reflink=1,rmapbt=1.
> 
> Sasha wrote that more results will be in tomorrow...

I'd rather be cautious, how about we wait until I also confirm
no regressions as well. In this case since we already have candidates
you identified, and Darrick vouchces for, I can just jump start the
process and deal with both manually reviewing each of these changes
and also confirming no regressions are in place on my tests as well.

Then we'd have at least 3 XFS pair of eyeballs reviewing and at least
2 full independent tests vouching for these.

  Luis
