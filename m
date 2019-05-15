Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C18421FBA3
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 22:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfEOUqV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 16:46:21 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33940 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727659AbfEOUqU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 16:46:20 -0400
Received: by mail-ot1-f68.google.com with SMTP id l17so1377925otq.1
        for <linux-xfs@vger.kernel.org>; Wed, 15 May 2019 13:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kQMkVem+f5BUJTL0ohOK8s/LBe9AOQLQXzJAVF0NO2o=;
        b=Cy2EIYX1Pq2jZ4OZSz2yQkq0F9kd5atoA7LKrqdgOhRjKiFVlVYA2gODEElFw67K45
         tpjRxjmowCB5ex6K1svZPmFMGUJvDyewft/V9f+O8H7U1VGbN+OU4Z/xpXBeMQgdofxU
         HwFKIrN+ZDE05AjnzxypOVzx8FHhxfQfSPDlE24jH7d0yRidX/qCp6tGapcyXMIsQ/FN
         xTviZEpkXwuB4/hLQMP71dgjub+M7+e9+NQASiodAsRVquNojGSwTZ5hM/gNAMDb2yEk
         Teybs5bgEInBpgzEo9DC1MccDV1z1SSDczRUyu9xTatdTpheOTQU+jZivdK6ZvGITWFx
         bOkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kQMkVem+f5BUJTL0ohOK8s/LBe9AOQLQXzJAVF0NO2o=;
        b=e9awe468UPG52fpr5+bI9oGVDotOT7Qjq/UJgz3u2ghCwpkrUotsuP1hIga4bN7OYF
         0mnB3Gynb5bBbFLwjtCJtKGSvLbw5ODIHgc6J9GhYHTIrdpo2nW2DlnQreo/et75/Rhr
         T4lmKk0p9kEnw3500j74Qv2CnNldedYJDY5s8MMyunMsLsluGubHlEgVWLrGHb1glvyS
         s5kgewVPcL0nWFulKCNXclXEw6hUoI3q0YoObtZrWMFouAnH6jRYSdcrL7ljlYzISQBk
         2PFuZ/hPae72kseoNHzEvyt3+GpWq8lxYEhkIVX5gu8Um7XvI6WIyl5AjFFfSpGhNDzu
         jwLA==
X-Gm-Message-State: APjAAAUghm8d0j5BKNsvqSy46jrxdmnrI1YcuYmMx7aCdqql4f3o4b+P
        GXx8NLkIpQfwyJgic4q6kAmRfGAJxI9CIsLKSEXzCw==
X-Google-Smtp-Source: APXvYqzmFFlcg/jPSqhKzy3t5czXCo+ojmXW5WVgFrjk+NAmke64X9x4AGwl9LoR92w5/nxaP9HiWHsnxe/dpzoT3CE=
X-Received: by 2002:a9d:6116:: with SMTP id i22mr26141595otj.13.1557953179336;
 Wed, 15 May 2019 13:46:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190514145422.16923-1-pagupta@redhat.com> <20190514145422.16923-3-pagupta@redhat.com>
 <c22d42f6-ef94-0310-36f2-e9085d3464c2@infradead.org> <1112624345.28705248.1557847520326.JavaMail.zimbra@redhat.com>
In-Reply-To: <1112624345.28705248.1557847520326.JavaMail.zimbra@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 15 May 2019 13:46:08 -0700
Message-ID: <CAPcyv4iK1ivHkdw3JQV1wVLeLi0TA++VgKDZvYjPGo_i1j_pbA@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH v9 2/7] virtio-pmem: Add virtio pmem driver
To:     Pankaj Gupta <pagupta@redhat.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        KVM list <kvm@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Qemu Developers <qemu-devel@nongnu.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, david <david@fromorbit.com>,
        lcapitulino@redhat.com, adilger kernel <adilger.kernel@dilger.ca>,
        Ross Zwisler <zwisler@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        dave jiang <dave.jiang@intel.com>, jstaron@google.com,
        darrick wong <darrick.wong@oracle.com>,
        vishal l verma <vishal.l.verma@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        jmoyer <jmoyer@redhat.com>,
        Nitesh Narayan Lal <nilal@redhat.com>,
        Len Brown <lenb@kernel.org>,
        Adam Borowski <kilobyte@angband.pl>,
        Rik van Riel <riel@surriel.com>,
        yuval shaia <yuval.shaia@oracle.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        xiaoguangrong eric <xiaoguangrong.eric@gmail.com>,
        cohuck@redhat.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Igor Mammedov <imammedo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 14, 2019 at 8:25 AM Pankaj Gupta <pagupta@redhat.com> wrote:
>
>
> > On 5/14/19 7:54 AM, Pankaj Gupta wrote:
> > > diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> > > index 35897649c24f..94bad084ebab 100644
> > > --- a/drivers/virtio/Kconfig
> > > +++ b/drivers/virtio/Kconfig
> > > @@ -42,6 +42,17 @@ config VIRTIO_PCI_LEGACY
> > >
> > >       If unsure, say Y.
> > >
> > > +config VIRTIO_PMEM
> > > +   tristate "Support for virtio pmem driver"
> > > +   depends on VIRTIO
> > > +   depends on LIBNVDIMM
> > > +   help
> > > +   This driver provides access to virtio-pmem devices, storage devices
> > > +   that are mapped into the physical address space - similar to NVDIMMs
> > > +    - with a virtio-based flushing interface.
> > > +
> > > +   If unsure, say M.
> >
> > <beep>
> > from Documentation/process/coding-style.rst:
> > "Lines under a ``config`` definition
> > are indented with one tab, while help text is indented an additional two
> > spaces."
>
> ah... I changed help text and 'checkpatch' did not say anything :( .
>
> Will wait for Dan, If its possible to add two spaces to help text while applying
> the series.

I'm inclined to handle this with a fixup appended to the end of the
series just so the patchwork-bot does not get confused by the content
changing from what was sent to the list.
