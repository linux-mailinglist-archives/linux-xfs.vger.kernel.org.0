Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E044A42F39
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 20:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbfFLSmK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Jun 2019 14:42:10 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41987 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727480AbfFLSmF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 14:42:05 -0400
Received: by mail-oi1-f195.google.com with SMTP id s184so12455435oie.9
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 11:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tLkmphJnLjEku4wPa26GqmShS2e5likwCcmpQlFLS9E=;
        b=zfGP+t+9ivTiw9crHzyoG37UKVT39+ZjMSRc6i4RLF5qzgoEzM0PJJFpTl3UpomLM/
         kX7wxsRh/bfXL05Kn2SjQT8PDTQbpZvw2lUD2P17lgifKk9462SiGOzy9eolZxENP8tF
         +j8h3CL4xbOvN0NcXJng0ZhfijbK4zlpWlo5g45OKeiNBbSWh4j6EO8XjD4uzxYBWXSc
         XQXw6jfUAUrXoISJcc1nasZDsCw2vNnJrgvivK5m8U97df7yj+O0/KKRytyMUK2vV5wL
         CVPInnibqz35AZHLe+QENPOC6d6PXPPLQ6FBHTljTMKMRhnltIiFojDH2RTb0H3+DeCQ
         awHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tLkmphJnLjEku4wPa26GqmShS2e5likwCcmpQlFLS9E=;
        b=aNtmUdDFrADYxuc9iFgz/15mF+K27LZw20NqpuQ+0weFwgaRUBgVps2Kte8zHBDjKI
         4NsLsMJM6krbDSCf7EzZj6O+AkoIKRV7+pWmXKGteW9Kx49Yb73rX+4BZtLPY5DkDqKO
         fJV0aWU8yI1d4RQ34AuO5oSiOYGwgYIu0EQIlCDz+kqMtPzwj6FyD9LfpAbG44SsckBq
         rIKKpL9a0DqsWCcGY6QkENtxGPpUpzzJABdPeJX+UC6LfEucR9rfc17Ii0QHJ95t8fP+
         HAk2x4kFPB3hNG6a2U+nbvlJIwChBamgEl1A7qmFlp0DdPww9eUrD7Xgg8Y5vC6HHeqn
         htrw==
X-Gm-Message-State: APjAAAW5Yvo+LqV/Cc/paeiNKoxecmt04zq5oi6hYMZ3UQuUrHsJ/fvJ
        xNLloJoEaNHlPsCzhjYc2IPqpgwUIPgNiDmL4o8b3g==
X-Google-Smtp-Source: APXvYqxw8Jxg8VjrdgkzfIw+Yn35hC16YxwrfmO4tE9KRMFgYTyKNK9pqaozSKJ82RqVYk9X5Uls8HWSSM7jkwOY/uo=
X-Received: by 2002:aca:ed4c:: with SMTP id l73mr412323oih.149.1560364924898;
 Wed, 12 Jun 2019 11:42:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190606014544.8339-1-ira.weiny@intel.com> <20190606104203.GF7433@quack2.suse.cz>
 <20190606195114.GA30714@ziepe.ca> <20190606222228.GB11698@iweiny-DESK2.sc.intel.com>
 <20190607103636.GA12765@quack2.suse.cz> <20190607121729.GA14802@ziepe.ca>
 <20190607145213.GB14559@iweiny-DESK2.sc.intel.com> <20190612102917.GB14578@quack2.suse.cz>
 <20190612114721.GB3876@ziepe.ca> <20190612120907.GC14578@quack2.suse.cz>
In-Reply-To: <20190612120907.GC14578@quack2.suse.cz>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 12 Jun 2019 11:41:53 -0700
Message-ID: <CAPcyv4ikn219XUgHwsPdYp06vBNAJB9Rk-hjZA-fYT4GB3gi+w@mail.gmail.com>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
To:     Jan Kara <jack@suse.cz>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Ira Weiny <ira.weiny@intel.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Layton <jlayton@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 12, 2019 at 5:09 AM Jan Kara <jack@suse.cz> wrote:
>
> On Wed 12-06-19 08:47:21, Jason Gunthorpe wrote:
> > On Wed, Jun 12, 2019 at 12:29:17PM +0200, Jan Kara wrote:
> >
> > > > > The main objection to the current ODP & DAX solution is that very
> > > > > little HW can actually implement it, having the alternative still
> > > > > require HW support doesn't seem like progress.
> > > > >
> > > > > I think we will eventually start seein some HW be able to do this
> > > > > invalidation, but it won't be universal, and I'd rather leave it
> > > > > optional, for recovery from truely catastrophic errors (ie my DAX is
> > > > > on fire, I need to unplug it).
> > > >
> > > > Agreed.  I think software wise there is not much some of the devices can do
> > > > with such an "invalidate".
> > >
> > > So out of curiosity: What does RDMA driver do when userspace just closes
> > > the file pointing to RDMA object? It has to handle that somehow by aborting
> > > everything that's going on... And I wanted similar behavior here.
> >
> > It aborts *everything* connected to that file descriptor. Destroying
> > everything avoids creating inconsistencies that destroying a subset
> > would create.
> >
> > What has been talked about for lease break is not destroying anything
> > but very selectively saying that one memory region linked to the GUP
> > is no longer functional.
>
> OK, so what I had in mind was that if RDMA app doesn't play by the rules
> and closes the file with existing pins (and thus layout lease) we would
> force it to abort everything. Yes, it is disruptive but then the app didn't
> obey the rule that it has to maintain file lease while holding pins. Thus
> such situation should never happen unless the app is malicious / buggy.

When you say 'close' do you mean the final release of the fd? The vma
keeps a reference to a 'struct file' live even after the fd is closed.
