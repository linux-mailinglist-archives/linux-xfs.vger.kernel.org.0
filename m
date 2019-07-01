Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F42B42F52
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 20:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfFLSuD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Jun 2019 14:50:03 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41243 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfFLSuD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 14:50:03 -0400
Received: by mail-oi1-f194.google.com with SMTP id g7so9286266oia.8
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 11:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oLKBk3Q7ccO0NJJMRJYYFBU09UJHS0/ornRP0j3Fxnk=;
        b=gmeYon7zauy3OQh0dds8NZYm6t5UDisLz6yhyFv+zAHzAQld3I1PlASf7zsZM+CaaZ
         CehQMBgQdj6gortTquDOB3N7bsSZoRiiIPq0F65TSYhGSEiVglTlgXcZdamdruNK0EZE
         L4hW+NB6I/OXN8FIUSFL51bNjJWJFW8hzlwgXFjesNuMtfLc6oA7+M/3K2vidJa0br9V
         czG4Eoe/orE9D++K3+lLCE4n/UgTBq+X11qW/QB7IGhWEAbaQV6NagrYsJ8UOQey3FsU
         R4uBxwDIf6zhdzoruyQQmgKdtCNWOHRzy7IMkgSp8cIYB925DCaZB8zX5lMCi8WnCkui
         Earw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oLKBk3Q7ccO0NJJMRJYYFBU09UJHS0/ornRP0j3Fxnk=;
        b=QyNxR2wh+kpbJM2wgTUm8dTcGH39ImsHcYdC1pLLr7W2Vo/r5W8NJFW5UmYby2fRiq
         dFi3pLwMg+MTX6so+exd1RwDgshCzlweiNJXKn5r3aZoB7Xe1G5rrePyMftUpV2Lwb8h
         8nAumAZ+/+vWmIRSR4Jc/wVRmF0c+QaTeHJOAsWQnvDYYhNz2KllMJ2pRVRrgdtteDgM
         VuHX39Np7T6iaR0jEvP6LJyK+0GAqHntEOAtfPBVs0ae/FHhgZIgGlDqa6PA8M8IGs6/
         85jQwf54N5xVYmJXml/UsbL4mFcKgXWFCo5eA8pd30/jPlOphGbWA43fADlh0rA0VXLE
         mT6w==
X-Gm-Message-State: APjAAAXYEUF29K9nHO9LgX4U/DXZaIvNgfr+2eNu/nebgPP4Fbn9yWP6
        TCp1oDq5VWdOjp8Hyu4mPc7Kgwk0OsrSVK23RgTHYw==
X-Google-Smtp-Source: APXvYqxnUAltCxrDlkjMuVh0Fis6UXRXzk4ak5OCGI7cs5NoWVrVaXVk3zYCAPwY8b7pSu88qbXHjB+1CYR77yxpUws=
X-Received: by 2002:aca:ec82:: with SMTP id k124mr420099oih.73.1560365403007;
 Wed, 12 Jun 2019 11:50:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190606014544.8339-1-ira.weiny@intel.com> <20190606104203.GF7433@quack2.suse.cz>
 <20190606195114.GA30714@ziepe.ca> <20190606222228.GB11698@iweiny-DESK2.sc.intel.com>
 <20190607103636.GA12765@quack2.suse.cz> <20190607121729.GA14802@ziepe.ca>
 <20190607145213.GB14559@iweiny-DESK2.sc.intel.com> <20190612102917.GB14578@quack2.suse.cz>
In-Reply-To: <20190612102917.GB14578@quack2.suse.cz>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 12 Jun 2019 11:49:52 -0700
Message-ID: <CAPcyv4jSyTjC98UsWb3-FnZekV0oyboiSe9n1NYDC2TSKAqiqw@mail.gmail.com>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
To:     Jan Kara <jack@suse.cz>
Cc:     Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
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

On Wed, Jun 12, 2019 at 3:29 AM Jan Kara <jack@suse.cz> wrote:
>
> On Fri 07-06-19 07:52:13, Ira Weiny wrote:
> > On Fri, Jun 07, 2019 at 09:17:29AM -0300, Jason Gunthorpe wrote:
> > > On Fri, Jun 07, 2019 at 12:36:36PM +0200, Jan Kara wrote:
> > >
> > > > Because the pins would be invisible to sysadmin from that point on.
> > >
> > > It is not invisible, it just shows up in a rdma specific kernel
> > > interface. You have to use rdma netlink to see the kernel object
> > > holding this pin.
> > >
> > > If this visibility is the main sticking point I suggest just enhancing
> > > the existing MR reporting to include the file info for current GUP
> > > pins and teaching lsof to collect information from there as well so it
> > > is easy to use.
> > >
> > > If the ownership of the lease transfers to the MR, and we report that
> > > ownership to userspace in a way lsof can find, then I think all the
> > > concerns that have been raised are met, right?
> >
> > I was contemplating some new lsof feature yesterday.  But what I don't
> > think we want is sysadmins to have multiple tools for multiple
> > subsystems.  Or even have to teach lsof something new for every potential
> > new subsystem user of GUP pins.
>
> Agreed.
>
> > I was thinking more along the lines of reporting files which have GUP
> > pins on them directly somewhere (dare I say procfs?) and teaching lsof to
> > report that information.  That would cover any subsystem which does a
> > longterm pin.
>
> So lsof already parses /proc/<pid>/maps to learn about files held open by
> memory mappings. It could parse some other file as well I guess. The good
> thing about that would be that then "longterm pin" structure would just hold
> struct file reference. That would avoid any needs of special behavior on
> file close (the file reference in the "longterm pin" structure would make
> sure struct file and thus the lease stays around, we'd just need to make
> explicit lease unlock block until the "longterm pin" structure is freed).
> The bad thing is that it requires us to come up with a sane new proc
> interface for reporting "longterm pins" and associated struct file. Also we
> need to define what this interface shows if the pinned pages are in DRAM
> (either page cache or anon) and not on NVDIMM.

The anon vs shared detection case is important because a longterm pin
might be blocking a memory-hot-unplug operation if it is pinning
ZONE_MOVABLE memory, but I don't think we want DRAM vs NVDIMM to be an
explicit concern of the interface. For the anon / cached case I expect
it might be useful to put that communication under the memory-blocks
sysfs interface. I.e. a list of pids that are pinning that
memory-block from being hot-unplugged.
