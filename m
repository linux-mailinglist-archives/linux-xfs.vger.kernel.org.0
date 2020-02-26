Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC3981701FF
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Feb 2020 16:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgBZPK0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Feb 2020 10:10:26 -0500
Received: from verein.lst.de ([213.95.11.211]:49307 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727108AbgBZPKZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Feb 2020 10:10:25 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id BA56B68CEE; Wed, 26 Feb 2020 16:10:22 +0100 (CET)
Date:   Wed, 26 Feb 2020 16:10:22 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/30] xfs: pass an initialized xfs_da_args to
 xfs_attr_get
Message-ID: <20200226151022.GB19599@lst.de>
References: <20200225231012.735245-1-hch@lst.de> <20200225231012.735245-12-hch@lst.de> <20200226003310.GT10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226003310.GT10776@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 26, 2020 at 11:33:10AM +1100, Dave Chinner wrote:
> > -	error = xfs_attr_get(XFS_I(inode), name, namelen, &kbuf, (int *)len,
> > -			     flags);
> > +	error = xfs_attr_get(&args);
> >  	if (error)
> >  		goto out_kfree;
> >  
> > -	if (copy_to_user(ubuf, kbuf, *len))
> > +	*len = args.valuelen;
> > +	if (copy_to_user(ubuf, args.value, args.valuelen))
> >  		error = -EFAULT;
> >  
> >  out_kfree:
> > -	kmem_free(kbuf);
> > +	kmem_free(args.value);
> >  	return error;
> 
> This would seem like a prime candidate for ATTR_ALLOC conversion?

I'll add a patch to the end of the series to use lazy allocation here.
