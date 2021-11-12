Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942FB44EA68
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Nov 2021 16:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235334AbhKLPj7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 12 Nov 2021 10:39:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33872 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235336AbhKLPjY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Nov 2021 10:39:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636731393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1yRNkydUNK+ZkSMdy54HzNSiQ/CpVQa1C/0YRKMDt6I=;
        b=S2/s6xaSvbupJpLmNnyrFGANXEQLTwdtQg/CVV3DEzxjgpRqt5SeoatsRFodhOnwz7XfDS
        LLy+QyDumPZWnHjEVgIzWvdUDizgeK/XBwwKc7kHqVAk2oEhzBnjq95OuYdOzvs92RZJ9d
        tR847qHnDkTrpCvHsCYll5Gk8FB0OQg=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-49TH5PAoMNCxdmVslCdM0A-1; Fri, 12 Nov 2021 10:36:32 -0500
X-MC-Unique: 49TH5PAoMNCxdmVslCdM0A-1
Received: by mail-qv1-f72.google.com with SMTP id dz17-20020ad45891000000b003bbb4aba6d7so8678906qvb.12
        for <linux-xfs@vger.kernel.org>; Fri, 12 Nov 2021 07:36:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1yRNkydUNK+ZkSMdy54HzNSiQ/CpVQa1C/0YRKMDt6I=;
        b=D5qkcz3DJ7ncmGfNm1ROnfGO9dbI6gHc13lpHWl3CQwZJGlSjxQmkYSL0dFbML+hvO
         0RL/bQs3TEkH02sJLrOOZ/9Pws/XwoZ2XIuChOpo5yyRi/72hSetZwIWOK/4C0W9V8GI
         PH4yKXfZB41MUGz9aqE26ObyqaCu4TpmiHt41aMVts3T6p+aiQWLVJwdZeWOVYDlLW3P
         0EFKT7bJIxyerCut0bkeZNwxQminml5aCa5sO66AIVaOk/ZArZ/MCAYN7HmirZEiqrPY
         y3tcTYzVlVpsrWB72KL4NSzfFuZ4f4ctsDjKQeaotQHVOrKxD2AyrRZJE22BO0obTlR+
         nZUQ==
X-Gm-Message-State: AOAM532fr2kz0Zi6up+4k+87sDGrGDySXfsWOVECnnvuwguTlQb0T4Tj
        L4txGExAM4aK3iCI5gGcYtuThshJOqo93zkfk6h1USeCVtJn4JuFrpjnLl7NkNeQlWPo6O9xo3W
        HQrF4OJQqITk54636YPg=
X-Received: by 2002:a05:620a:2889:: with SMTP id j9mr13666567qkp.135.1636731392005;
        Fri, 12 Nov 2021 07:36:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyFKfis7Tfvod70r4n3+rCxCai5vb1NmzpAB89WVpeGak/SPYaHK+9rktro10Lf1pYOihkdQw==
X-Received: by 2002:a05:620a:2889:: with SMTP id j9mr13666538qkp.135.1636731391781;
        Fri, 12 Nov 2021 07:36:31 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id j13sm2955023qkp.111.2021.11.12.07.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 07:36:31 -0800 (PST)
Date:   Fri, 12 Nov 2021 10:36:30 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Jane Chu <jane.chu@oracle.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        david <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alasdair Kergon <agk@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Weiny, Ira" <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] dax,pmem: Implement pmem based dax data recovery
Message-ID: <YY6J/mdSmrfK8moV@redhat.com>
References: <20211106011638.2613039-1-jane.chu@oracle.com>
 <20211106011638.2613039-3-jane.chu@oracle.com>
 <YYoi2JiwTtmxONvB@infradead.org>
 <CAPcyv4hQrUEhDOK-Ys1_=Sxb8f+GJZvpKZHTUPKQvVMaMe8XMg@mail.gmail.com>
 <15f01d51-2611-3566-0d08-bdfbec53f88c@oracle.com>
 <CAPcyv4gwbZ=Z6xCjDCASpkPnw1EC8NMAJDh9_sa3n2PAG5+zAA@mail.gmail.com>
 <795a0ced-68b4-4ed8-439b-c539942b925e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <795a0ced-68b4-4ed8-439b-c539942b925e@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 10 2021 at  1:26P -0500,
Jane Chu <jane.chu@oracle.com> wrote:

> On 11/9/2021 1:02 PM, Dan Williams wrote:
> > On Tue, Nov 9, 2021 at 11:59 AM Jane Chu <jane.chu@oracle.com> wrote:
> >>
> >> On 11/9/2021 10:48 AM, Dan Williams wrote:
> >>> On Mon, Nov 8, 2021 at 11:27 PM Christoph Hellwig <hch@infradead.org> wrote:
> >>>>
> >>>> On Fri, Nov 05, 2021 at 07:16:38PM -0600, Jane Chu wrote:
> >>>>>    static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
> >>>>>                 void *addr, size_t bytes, struct iov_iter *i, int mode)
> >>>>>    {
> >>>>> +     phys_addr_t pmem_off;
> >>>>> +     size_t len, lead_off;
> >>>>> +     struct pmem_device *pmem = dax_get_private(dax_dev);
> >>>>> +     struct device *dev = pmem->bb.dev;
> >>>>> +
> >>>>> +     if (unlikely(mode == DAX_OP_RECOVERY)) {
> >>>>> +             lead_off = (unsigned long)addr & ~PAGE_MASK;
> >>>>> +             len = PFN_PHYS(PFN_UP(lead_off + bytes));
> >>>>> +             if (is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, len)) {
> >>>>> +                     if (lead_off || !(PAGE_ALIGNED(bytes))) {
> >>>>> +                             dev_warn(dev, "Found poison, but addr(%p) and/or bytes(%#lx) not page aligned\n",
> >>>>> +                                     addr, bytes);
> >>>>> +                             return (size_t) -EIO;
> >>>>> +                     }
> >>>>> +                     pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
> >>>>> +                     if (pmem_clear_poison(pmem, pmem_off, bytes) !=
> >>>>> +                                             BLK_STS_OK)
> >>>>> +                             return (size_t) -EIO;
> >>>>> +             }
> >>>>> +     }
> >>>>
> >>>> This is in the wrong spot.  As seen in my WIP series individual drivers
> >>>> really should not hook into copying to and from the iter, because it
> >>>> really is just one way to write to a nvdimm.  How would dm-writecache
> >>>> clear the errors with this scheme?
> >>>>
> >>>> So IMHO going back to the separate recovery method as in your previous
> >>>> patch really is the way to go.  If/when the 64-bit store happens we
> >>>> need to figure out a good way to clear the bad block list for that.
> >>>
> >>> I think we just make error management a first class citizen of a
> >>> dax-device and stop abstracting it behind a driver callback. That way
> >>> the driver that registers the dax-device can optionally register error
> >>> management as well. Then fsdax path can do:
> >>>
> >>>           rc = dax_direct_access(..., &kaddr, ...);
> >>>           if (unlikely(rc)) {
> >>>                   kaddr = dax_mk_recovery(kaddr);
> >>
> >> Sorry, what does dax_mk_recovery(kaddr) do?
> > 
> > I was thinking this just does the hackery to set a flag bit in the
> > pointer, something like:
> > 
> > return (void *) ((unsigned long) kaddr | DAX_RECOVERY)
> 
> Okay, how about call it dax_prep_recovery()?
> 
> > 
> >>
> >>>                   dax_direct_access(..., &kaddr, ...);
> >>>                   return dax_recovery_{read,write}(..., kaddr, ...);
> >>>           }
> >>>           return copy_{mc_to_iter,from_iter_flushcache}(...);
> >>>
> >>> Where, the recovery version of dax_direct_access() has the opportunity
> >>> to change the page permissions / use an alias mapping for the access,
> >>
> >> again, sorry, what 'page permissions'?  memory_failure_dev_pagemap()
> >> changes the poisoned page mem_type from 'rw' to 'uc-' (should be NP?),
> >> do you mean to reverse the change?
> > 
> > Right, the result of the conversation with Boris is that
> > memory_failure() should mark the page as NP in call cases, so
> > dax_direct_access() needs to create a UC mapping and
> > dax_recover_{read,write}() would sink that operation and either return
> > the page to NP after the access completes, or convert it to WB if the
> > operation cleared the error.
> 
> Okay,  will add a patch to fix set_mce_nospec().
> 
> How about moving set_memory_uc() and set_memory_np() down to
> dax_recovery_read(), so that we don't split the set_memory_X calls
> over different APIs, because we can't enforce what follows
> dax_direct_access()?
> 
> > 
> >>> dax_recovery_read() allows reading the good cachelines out of a
> >>> poisoned page, and dax_recovery_write() coordinates error list
> >>> management and returning a poison page to full write-back caching
> >>> operation when no more poisoned cacheline are detected in the page.
> >>>
> >>
> >> How about to introduce 3 dax_recover_ APIs:
> >>     dax_recover_direct_access(): similar to dax_direct_access except
> >>        it ignores error list and return the kaddr, and hence is also
> >>        optional, exported by device driver that has the ability to
> >>        detect error;
> >>     dax_recovery_read(): optional, supported by pmem driver only,
> >>        reads as much data as possible up to the poisoned page;
> > 
> > It wouldn't be a property of the pmem driver, I expect it would be a
> > flag on the dax device whether to attempt recovery or not. I.e. get
> > away from this being a pmem callback and make this a native capability
> > of a dax device.
> > 
> >>     dax_recovery_write(): optional, supported by pmem driver only,
> >>        first clear-poison, then write.
> >>
> >> Should we worry about the dm targets?
> > 
> > The dm targets after Christoph's conversion should be able to do all
> > the translation at direct access time and then dax_recovery_X can be
> > done on the resulting already translated kaddr.
> 
> I'm thinking about the mixed device dm where some provides
> dax_recovery_X, others don't, in which case we don't allow
> dax recovery because that causes confusion? or should we still
> allow recovery for part of the mixed devices?

I really don't like the all or nothing approach if it can be avoided.
I would imagine that if recovery possible it best to support it even
if the DM device happens to span a mix of devices with varying support
for recovery.

Thanks,
Mike

