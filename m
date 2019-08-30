Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 729B2A3A63
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Aug 2019 17:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbfH3Pc4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Aug 2019 11:32:56 -0400
Received: from verein.lst.de ([213.95.11.211]:56556 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727751AbfH3Pc4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Aug 2019 11:32:56 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8050168BFE; Fri, 30 Aug 2019 17:32:53 +0200 (CEST)
Date:   Fri, 30 Aug 2019 17:32:53 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add a xfs_valid_startblock helper
Message-ID: <20190830153253.GA20550@lst.de>
References: <20190830102411.519-1-hch@lst.de> <20190830102411.519-2-hch@lst.de> <20190830150650.GA5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830150650.GA5354@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 08:06:50AM -0700, Darrick J. Wong wrote:
> > --- a/fs/xfs/libxfs/xfs_bmap.h
> > +++ b/fs/xfs/libxfs/xfs_bmap.h
> > @@ -171,6 +171,9 @@ static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
> >  		!isnullstartblock(irec->br_startblock);
> >  }
> >  
> > +#define xfs_valid_startblock(ip, startblock) \
> > +	((startblock) != 0 || XFS_IS_REALTIME_INODE(ip))
> 
> We have more robust validators for data/rtdev fsblock_t, so why not:
> 
> #define xfs_valid_startblock(ip, startblock) \
> 	(XFS_IS_REALTIME_INODE(ip) ? xfs_verify_rtbno(startblock) : \
> 				     xfs_verify_fsbno(startblock))
> 
> and why not make it a static inline function too?

I tried an inline function, but I could not find a header to place
it that would actually easily compile everywhere...  Maybe we should
just make that a xfs_verify_bno(mp, startblock) and move that out of
line such in a way that a smart compiler avoids the function call
overhead for xfs_verify_rtbno / xfs_verify_fsbno.  I'll take another
stab at this.
