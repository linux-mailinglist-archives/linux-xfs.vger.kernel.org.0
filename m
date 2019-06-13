Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C665442D0
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 18:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732349AbfFMQ0G (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 12:26:06 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:33761 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731470AbfFMQ0G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 12:26:06 -0400
Received: by mail-oi1-f196.google.com with SMTP id q186so14912572oia.0
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 09:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wjBnZv2pCLDEwG4yb+2F3joyqEyCgCcLuoiul4+lDtg=;
        b=KHbKhiCEqP27YRm90NCLuB4c2IplNhmcOcBL7/TKZlk3SiaZQfwA9S0uY/GsQv03Pr
         aBL2AWfi8XTIFaky9LKQqE+K/NfNYYNrlmFC/I9jOaxHcs4tAfHfjcUQbqcl3RnXxild
         Tu3HngJ2BWQbjHKSA518A7LMdZsRAI0y2xoRezHhz45e3uyBcpgMb0voTy98I6u2hRnp
         NYEu7LcFVoYX1llZ3PhX+HJY3OdLwk1vk8E00NF1S8iWedYKuEKJl7E8AOFKwK6O5TC3
         f4HIkh3G/dWUfgrFHj9h1Gd+qxz3edzqRbXtlNTkaPme0fjX3JDzh/8PrIf6qw6dZLSg
         gtaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wjBnZv2pCLDEwG4yb+2F3joyqEyCgCcLuoiul4+lDtg=;
        b=hAXnRH9v7wxUbXY6y0qaxwhsbHIH0V6o+NoXmN/vjhn1q7kU+rwbf9BN+o6+HHIFif
         HoQAfTwNDDvEBH9noIZB2XFzJkP4fcH9YMkn1tjK4XHwcqoazi4+4JcpZGMGVwEgk/7M
         sFKMYndPPpKLiizAMomxo5Q2GrfzI83zBsfDLSxHKMjwUmqFZMZ1vPd5QNuYX3OiBPj9
         /LhfEWe5YDWSbiG8kMLLb1BMYJjy6OfgUS8xON3NR3qrKme3uL5Gjm5j/fhHQJTHwISv
         HNenSSOSqB5u9ynUWmZuT1EDy/ohAK+MJB/3vM043ldoQa57H5kTp4iFhfknO2NKsxKe
         1Cfg==
X-Gm-Message-State: APjAAAVSpJ4DebSyBjp5tTdAPsBhGAuWw9zwhoryzK5LYV2AvaWnvfKq
        TjSNUSR42KhlrFMT71em/ah9FPWQxBWh0lSYX20bjg==
X-Google-Smtp-Source: APXvYqyIpO3hOidIsXLbc4Y7aCrEkKlPPSiQhXNkmA/XJwYbaL526BswBcBQAMtK33IEuzEN5c+1wA+6c6zViqiveWY=
X-Received: by 2002:aca:7c5:: with SMTP id 188mr3423005oih.70.1560443165189;
 Thu, 13 Jun 2019 09:26:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190607121729.GA14802@ziepe.ca> <20190607145213.GB14559@iweiny-DESK2.sc.intel.com>
 <20190612102917.GB14578@quack2.suse.cz> <20190612114721.GB3876@ziepe.ca>
 <20190612120907.GC14578@quack2.suse.cz> <20190612191421.GM3876@ziepe.ca>
 <20190612221336.GA27080@iweiny-DESK2.sc.intel.com> <CAPcyv4gkksnceCV-p70hkxAyEPJWFvpMezJA1rEj6TEhKAJ7qQ@mail.gmail.com>
 <20190612233324.GE14336@iweiny-DESK2.sc.intel.com> <CAPcyv4jf19CJbtXTp=ag7Ns=ZQtqeQd3C0XhV9FcFCwd9JCNtQ@mail.gmail.com>
 <20190613151354.GC22901@ziepe.ca>
In-Reply-To: <20190613151354.GC22901@ziepe.ca>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 13 Jun 2019 09:25:54 -0700
Message-ID: <CAPcyv4hZsxd+eUrVCQmm-O8Zcu16O5R1d0reTM+JBBn7oP7Uhw@mail.gmail.com>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
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

On Thu, Jun 13, 2019 at 8:14 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Wed, Jun 12, 2019 at 06:14:46PM -0700, Dan Williams wrote:
> > > Effectively, we would need a way for an admin to close a specific file
> > > descriptor (or set of fds) which point to that file.  AFAIK there is no way to
> > > do that at all, is there?
> >
> > Even if there were that gets back to my other question, does RDMA
> > teardown happen at close(fd), or at final fput() of the 'struct
> > file'?
>
> AFAIK there is no kernel side driver hook for close(fd).
>
> rdma uses a normal chardev so it's lifetime is linked to the file_ops
> release, which is called on last fput. So all the mmaps, all the dups,
> everything must go before it releases its resources.

Oh, I must have missed where this conversation started talking about
the driver-device fd. I thought we were talking about the close /
release of the target file that is MAP_SHARED for the memory
registration. A release of the driver fd is orthogonal to coordinating
/ signalling actions relative to the leased file.
