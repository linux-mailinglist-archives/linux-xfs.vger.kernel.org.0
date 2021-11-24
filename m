Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B31145B483
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Nov 2021 07:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237792AbhKXGyE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Nov 2021 01:54:04 -0500
Received: from verein.lst.de ([213.95.11.211]:35860 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231722AbhKXGyD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Nov 2021 01:54:03 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id E12D568AFE; Wed, 24 Nov 2021 07:50:50 +0100 (CET)
Date:   Wed, 24 Nov 2021 07:50:50 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 18/29] fsdax: decouple zeroing from the iomap buffered
 I/O code
Message-ID: <20211124065050.GB7075@lst.de>
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-19-hch@lst.de> <CAPcyv4hDG9-BQHjuJnQUQLJhq=xmrNi+w-uiu6TnV4Rcf0VDfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hDG9-BQHjuJnQUQLJhq=xmrNi+w-uiu6TnV4Rcf0VDfQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 23, 2021 at 01:46:35PM -0800, Dan Williams wrote:
> > +               const struct iomap_ops *ops)
> > +{
> > +       unsigned int blocksize = i_blocksize(inode);
> > +       unsigned int off = pos & (blocksize - 1);
> > +
> > +       /* Block boundary? Nothing to do */
> > +       if (!off)
> > +               return 0;
> 
> It took me a moment to figure out why this was correct. I see it was
> also copied from iomap_truncate_page(). It makes sense for DAX where
> blocksize >= PAGE_SIZE so it's always the case that the amount of
> capacity to zero relative to a page is from @pos to the end of the
> block. Is there something else that protects the blocksize < PAGE_SIZE
> case outside of DAX?
> 
> Nothing to change for this patch, just a question I had while reviewing.

This is a helper for truncate ->setattr, where everything outside the
block is deallocated.  So zeroing is only needed inside the block.
