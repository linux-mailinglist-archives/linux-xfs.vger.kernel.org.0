Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18063E82D8
	for <lists+linux-xfs@lfdr.de>; Tue, 29 Oct 2019 08:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfJ2H6p (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 29 Oct 2019 03:58:45 -0400
Received: from verein.lst.de ([213.95.11.211]:38634 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbfJ2H6p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Oct 2019 03:58:45 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7CEC368AFE; Tue, 29 Oct 2019 08:58:43 +0100 (CET)
Date:   Tue, 29 Oct 2019 08:58:43 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: don't log the inode in xfs_fs_map_blocks if
 it wasn't modified
Message-ID: <20191029075843.GD18999@lst.de>
References: <20191025150336.19411-1-hch@lst.de> <20191025150336.19411-5-hch@lst.de> <20191028161245.GD15222@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028161245.GD15222@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 09:12:45AM -0700, Darrick J. Wong wrote:
> On Fri, Oct 25, 2019 at 05:03:32PM +0200, Christoph Hellwig wrote:
> > Even if we are asked for a write layout there is no point in logging
> > the inode unless we actually modified it in some way.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_pnfs.c | 43 +++++++++++++++++++------------------------
> >  1 file changed, 19 insertions(+), 24 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> > index 9c96493be9e0..fa90c6334c7c 100644
> > --- a/fs/xfs/xfs_pnfs.c
> > +++ b/fs/xfs/xfs_pnfs.c
> > @@ -147,32 +147,27 @@ xfs_fs_map_blocks(
> >  	if (error)
> >  		goto out_unlock;
> >  
> > -	if (write) {
> > -		enum xfs_prealloc_flags	flags = 0;
> > -
> > +	if (write &&
> > +	    (!nimaps || imap.br_startblock == HOLESTARTBLOCK)) {
> >  		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
> 
> The change in code flow makes this assert rather useless, I think, since
> we only end up in this branch if we have a write and a hole.  If the
> condition that it checks is important (and it seems to be?) then it
> ought to be hoisted up a level and turned into:
> 
> ASSERT(!write || !nimaps || imap.br_startblock != DELAYSTARTBLOCK);
> 
> Right?

Actually even for !write we should not see delalloc blocks here.
So I'll fix up the assert in a separate prep patch.
