Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC02B1D617A
	for <lists+linux-xfs@lfdr.de>; Sat, 16 May 2020 15:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgEPN6L (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 16 May 2020 09:58:11 -0400
Received: from verein.lst.de ([213.95.11.211]:60634 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgEPN6L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 May 2020 09:58:11 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B472B68B05; Sat, 16 May 2020 15:58:08 +0200 (CEST)
Date:   Sat, 16 May 2020 15:58:08 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: move the fork format fields into struct
 xfs_ifork
Message-ID: <20200516135807.GA14540@lst.de>
References: <20200510072404.986627-1-hch@lst.de> <20200510072404.986627-6-hch@lst.de> <20200514212541.GL6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514212541.GL6714@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 14, 2020 at 02:25:41PM -0700, Darrick J. Wong wrote:

[~1000 lines of fullquote deleted until I hit the first comment, sigh..]

> > diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> > index 157f72efec5e9..dfa1533b4edfc 100644
> > --- a/fs/xfs/scrub/bmap.c
> > +++ b/fs/xfs/scrub/bmap.c
> > @@ -598,7 +598,7 @@ xchk_bmap_check_rmaps(
> >  		size = 0;
> >  		break;
> >  	}
> > -	if (XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_BTREE &&
> > +	if (ifp->if_format != XFS_DINODE_FMT_BTREE &&
> 
> ifp can be null here if bmapbt scrub is called on a file that has no
> xattrs; this crashed my test vm immediately...

What tests is that?  And xfstests auto run did not hit it, even if a
NULL check here seems sensible.
