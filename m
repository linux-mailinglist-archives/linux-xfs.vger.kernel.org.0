Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1C916700
	for <lists+linux-xfs@lfdr.de>; Tue,  7 May 2019 17:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfEGPkl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 7 May 2019 11:40:41 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37179 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfEGPkl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 May 2019 11:40:41 -0400
Received: by mail-ot1-f66.google.com with SMTP id u3so9912298otq.4
        for <linux-xfs@vger.kernel.org>; Tue, 07 May 2019 08:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eDjq30ddseBaIw6socWxfPv6NTtk+5QW4X1Ug5iEyJk=;
        b=P0NmBCU8zUOfaF8xaYZsuZ8crvxFB33fl7wDNB9MZv5fgE9bufZ9uXOFacVBRIyhyk
         7jy7cEut0ZZu1RaoDtrr50BVaB/CX/skGeBOtXxoGAGKW89ZemgDpFwl6g0BCyZNTY71
         c96Bv/+lzcoe4YYcd5EMePUR4gTK7GrAqK6itLr2obeqWzYKb3Dql3mDDHzIv1x+/JnT
         zIvYGvdBDonXfV8sEZV0PvMIvA63l1OoRV+8kWQPCfuhVRSXMOb+jYMxWFhFzCGAXSHH
         RES21PeWYeTfPIbRNgVP3JVS3PVW0F6JNq0X1vpUrTbfXgSQ4Ev5ZlVumch1kGRMghci
         mHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eDjq30ddseBaIw6socWxfPv6NTtk+5QW4X1Ug5iEyJk=;
        b=cyL8tCaiKZItbQE/fmltKRv24bK9MdVwVmNHPIV3hve04IPhoWCfJDKNFBybrVk/Cf
         VHsB2YRDj1S8I/g8LQF+Pm16ZgfIA8/6Qa5TIRa1Ut/vhtI0jeYTXyM7c8WYd6iD5sCb
         irmrBa768PiyncbKoc9+vjn46sF3+1wLyeJSKmGdEIky/TUOBYtP+3vvqO69l7h8dOWm
         3Wlvt9LlEzvJURAG+qjKm7PYjZf57zUngOTjpGkbVDspcgaPA8ZQQtXkR2kIhsaJTyWE
         iZ3s32EHidCNmVuB55ib93v67b4f9UeYbR/Tb3L4kojCS+DE5Qjhg02uvxHDuwNvzltE
         nDzA==
X-Gm-Message-State: APjAAAViO3TxDtakNU431x2APA7W4q0j/ZN9JyJrnLFGgc0P9pQSAxM3
        WIdyHkRnW1ERBdXBYVxpQE9Xw0Rld5mWQvOryDxr5A==
X-Google-Smtp-Source: APXvYqxgIWANkc/KHq9kAogc8tqlkqRrOccsWEIKbqAeeZcNH5LiQg3MPoGwMh9hdCCYG0LuKCXgqpIi0akzNLzuZFI=
X-Received: by 2002:a9d:222c:: with SMTP id o41mr22033787ota.353.1557243640877;
 Tue, 07 May 2019 08:40:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190426050039.17460-1-pagupta@redhat.com> <20190426050039.17460-4-pagupta@redhat.com>
In-Reply-To: <20190426050039.17460-4-pagupta@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 7 May 2019 08:40:30 -0700
Message-ID: <CAPcyv4hRdvypEj4LBTMfUFm80BdpRYbOugrkkj-3Kk_LErXPqQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/6] libnvdimm: add dax_dev sync flag
To:     Pankaj Gupta <pagupta@redhat.com>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        KVM list <kvm@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Qemu Developers <qemu-devel@nongnu.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Ross Zwisler <zwisler@kernel.org>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Christoph Hellwig <hch@infradead.org>,
        Len Brown <lenb@kernel.org>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        jmoyer <jmoyer@redhat.com>,
        Nitesh Narayan Lal <nilal@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        david <david@fromorbit.com>, cohuck@redhat.com,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kilobyte@angband.pl,
        yuval shaia <yuval.shaia@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 25, 2019 at 10:02 PM Pankaj Gupta <pagupta@redhat.com> wrote:
>
> This patch adds 'DAXDEV_SYNC' flag which is set
> for nd_region doing synchronous flush. This later
> is used to disable MAP_SYNC functionality for
> ext4 & xfs filesystem for devices don't support
> synchronous flush.
>
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
[..]
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 0dd316a74a29..c97fc0cc7167 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -7,6 +7,9 @@
>  #include <linux/radix-tree.h>
>  #include <asm/pgtable.h>
>
> +/* Flag for synchronous flush */
> +#define DAXDEV_F_SYNC true

I'd feel better, i.e. it reads more canonically, if this was defined
as (1UL << 0) and the argument to alloc_dax() was changed to 'unsigned
long flags' rather than a bool.
