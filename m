Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6D51D6684
	for <lists+linux-xfs@lfdr.de>; Sun, 17 May 2020 10:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgEQIMx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 17 May 2020 04:12:53 -0400
Received: from verein.lst.de ([213.95.11.211]:34305 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbgEQIMx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 17 May 2020 04:12:53 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 00A2068C4E; Sun, 17 May 2020 10:12:50 +0200 (CEST)
Date:   Sun, 17 May 2020 10:12:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: move the per-fork nextents fields into struct
 xfs_ifork
Message-ID: <20200517081250.GA30912@lst.de>
References: <20200510072404.986627-1-hch@lst.de> <20200510072404.986627-5-hch@lst.de> <20200512161053.GH37029@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512161053.GH37029@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 12:10:53PM -0400, Brian Foster wrote:
> >  	ip->i_d.di_forkoff = 0;
> >  	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
> >  
> > -	ASSERT(ip->i_d.di_anextents == 0);
> 
> Perhaps we could create an analogous assert in xfs_idestroy_fork()?

Added for the next version.

> > @@ -229,6 +228,8 @@ xfs_iformat_data_fork(
> >  	struct inode		*inode = VFS_I(ip);
> >  	int			error;
> >  
> > +	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
> > +
> 
> Could use a comment here that the format calls below might depend on
> this being set (i.e. xfs_iformat_btree() just above).

> >  	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
> > +	ip->i_afp->if_nextents = be16_to_cpu(dip->di_anextents);
> > +
> 
> Same here. Otherwise LGTM:

Sure.

