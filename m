Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A84817020C
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Feb 2020 16:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgBZPOc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Feb 2020 10:14:32 -0500
Received: from verein.lst.de ([213.95.11.211]:49316 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgBZPOc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Feb 2020 10:14:32 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id B06F268CEE; Wed, 26 Feb 2020 16:14:29 +0100 (CET)
Date:   Wed, 26 Feb 2020 16:14:29 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 27/30] xfs: clean up the attr flag confusion
Message-ID: <20200226151429.GC19599@lst.de>
References: <20200225231012.735245-1-hch@lst.de> <20200225231012.735245-28-hch@lst.de> <20200226010311.GV10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226010311.GV10776@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 26, 2020 at 12:03:11PM +1100, Dave Chinner wrote:
> > @@ -59,7 +59,8 @@ typedef struct xfs_da_args {
> >  	uint8_t		filetype;	/* filetype of inode for directories */
> >  	void		*value;		/* set of bytes (maybe contain NULLs) */
> >  	int		valuelen;	/* length of value */
> > -	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
> > +	unsigned int	attr_filter;	/* XFS_ATTR_{ROOT,SECURE} */
> > +	unsigned int	attr_flags;	/* XATTR_{CREATE,REPLACE} */
> 
> At this point, these are really operation flags. I would have named
> the variable attr_opflags but I don't think it's worth redoing the
> entire patch and others over this.

I've renamed it for the next spin together with the other suggstion.
I'll also add tracing for the opflags.
