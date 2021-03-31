Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBBC348BB0
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Mar 2021 09:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhCYIjz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Mar 2021 04:39:55 -0400
Received: from verein.lst.de ([213.95.11.211]:40179 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229619AbhCYIjy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 04:39:54 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 337CC68B05; Thu, 25 Mar 2021 09:39:53 +0100 (CET)
Date:   Thu, 25 Mar 2021 09:39:52 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/18] xfs: move the di_nblocks field to struct
 xfs_inode
Message-ID: <20210325083952.GB28146@lst.de>
References: <20210324142129.1011766-1-hch@lst.de> <20210324142129.1011766-10-hch@lst.de> <20210324182241.GG22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324182241.GG22100@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > @@ -194,7 +194,7 @@ xfs_iformat_btree(
> >  		     nrecs == 0 ||
> >  		     XFS_BMDR_SPACE_CALC(nrecs) >
> >  					XFS_DFORK_SIZE(dip, mp, whichfork) ||
> > -		     ifp->if_nextents > ip->i_d.di_nblocks) ||
> > +		     ifp->if_nextents > ip->i_nblocks) ||
> >  		     level == 0 || level > XFS_BTREE_MAXLEVELS) {
> 
> Minor merge conflict here with "xfs: validate ag btree levels using the
> precomputed values", but I can fix that up.  Everything else looks like
> a straightforward conversion.

Is that patch queue up somewhere so that I could rebase ontop of it?
