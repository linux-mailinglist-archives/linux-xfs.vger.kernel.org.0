Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 048BE37D9C
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Jun 2019 21:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfFFTvR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 6 Jun 2019 15:51:17 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45932 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfFFTvQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jun 2019 15:51:16 -0400
Received: by mail-qk1-f193.google.com with SMTP id s22so2243018qkj.12
        for <linux-xfs@vger.kernel.org>; Thu, 06 Jun 2019 12:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fVbv7ZkCU0XRJ9jD+fxd4ieH6waXD3NIwch6tKZrfLk=;
        b=JK8En4/CLh0QaNpMzjO2iMeOMpfrAAx/gr5SgNV/sb4SY2gHe/v8MOPkfC/9wPWIZ9
         ZL8QsvlzUZu3/QV2sR8DriCxzBeBuTLKUUPKPgdfpcAKVXgCaQb7rGQ3TRW8g1PxMby9
         +wxeHaZK6IN3egjgnP9IJZ+w011avGG0F3y8TTnoGrINoPzy0TddWA78C+1Q+KMGIdzz
         92AxUAVNZWhAkEVYstL8INWhYQ829J/YpWO2ZbVyA8ZS8ksWZ7LFyB1R04yWWmr5UAZu
         N8V2QVFH6XXSPdpk/99Edhk0JJ7bEpSx2FL6IQyeiD+YQVzMZEgvotOVmE8xHx4nh57Z
         Aq3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fVbv7ZkCU0XRJ9jD+fxd4ieH6waXD3NIwch6tKZrfLk=;
        b=pMITzjvHGO/T20iABZ13vG2E60ql+oDNDTjCx1lwISYDLKTVcTEkv4jcpogEZlL843
         /wOyDvO0/97bHD0Xyh8K7lN41davpMK11zhK9MmGgm/48ZugLWhLGku9QcO+w0/wRYCB
         3ODFxfdK8ji4ubqbSmxDS5o8rXJ15b7dl7OjCKkVXiOPSFhmcsu5DxomFuCZF1y/oTmU
         PUXx2Vv/OMT8ywdjBZ5oyjD/3LUk+O0rLRZg6CZrBdwg9wY2D/CjoUYZolVWaLfFRoJf
         KD6tCRR/ekJ2N+7CVw4quubNBm+PWpPKdtGUZMnnyhx4VmnCTp9zs3FqXnN2lKo8L3nt
         uVrw==
X-Gm-Message-State: APjAAAVa9JdbWzcM4Lm/KMOCTxfwgyXDbjKIieFCn9xDHXbZtkO4+IjE
        3PJiXZF0I5aKsTladL32GcAr4Q==
X-Google-Smtp-Source: APXvYqzyssiuyqvk956epvDv1OTyC6TvGNp+K2MqufTjNzhdzVN0pIMcZor/PXhzGoG5BWQnFWZbfw==
X-Received: by 2002:a37:a9c3:: with SMTP id s186mr41012233qke.190.1559850676118;
        Thu, 06 Jun 2019 12:51:16 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id t197sm1415555qke.2.2019.06.06.12.51.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Jun 2019 12:51:15 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hYyPr-00081O-0q; Thu, 06 Jun 2019 16:51:15 -0300
Date:   Thu, 6 Jun 2019 16:51:15 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jan Kara <jack@suse.cz>
Cc:     ira.weiny@intel.com, Dan Williams <dan.j.williams@intel.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Jeff Layton <jlayton@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Message-ID: <20190606195114.GA30714@ziepe.ca>
References: <20190606014544.8339-1-ira.weiny@intel.com>
 <20190606104203.GF7433@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606104203.GF7433@quack2.suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 06, 2019 at 12:42:03PM +0200, Jan Kara wrote:

> So I'd like to actually mandate that you *must* hold the file lease until
> you unpin all pages in the given range (not just that you have an option to
> hold a lease). And I believe the kernel should actually enforce this. That
> way we maintain a sane state that if someone uses a physical location of
> logical file offset on disk, he has a layout lease. Also once this is done,
> sysadmin has a reasonably easy way to discover run-away RDMA application
> and kill it if he wishes so.
> 
> The question is on how to exactly enforce that lease is taken until all
> pages are unpinned. I belive it could be done by tracking number of
> long-term pinned pages within a lease. Gup_longterm could easily increment
> the count when verifying the lease exists, gup_longterm users will somehow
> need to propagate corresponding 'filp' (struct file pointer) to
> put_user_pages_longterm() callsites so that they can look up appropriate
> lease to drop reference - probably I'd just transition all gup_longterm()
> users to a saner API similar to the one we have in mm/frame_vector.c where
> we don't hand out page pointers but an encapsulating structure that does
> all the necessary tracking. Removing a lease would need to block until all
> pins are released - this is probably the most hairy part since we need to
> handle a case if application just closes the file descriptor which
> would

I think if you are going to do this then the 'struct filp' that
represents the lease should be held in the kernel (ie inside the RDMA
umem) until the kernel is done with it.

Actually does someone have a pointer to this userspace lease API, I'm
not at all familiar with it, thanks

And yes, a better output format from GUP would be great..

> Maybe we could block only on explicit lease unlock and just drop the layout
> lease on file close and if there are still pinned pages, send SIGKILL to an
> application as a reminder it did something stupid...

Which process would you SIGKILL? At least for the rdma case a FD is
holding the GUP, so to do the put_user_pages() the kernel needs to
close the FD. I guess it would have to kill every process that has the
FD open? Seems complicated...

Regards,
Jason
