Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14CCA186DC6
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Mar 2020 15:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731579AbgCPOso (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Mar 2020 10:48:44 -0400
Received: from verein.lst.de ([213.95.11.211]:54751 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731549AbgCPOso (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Mar 2020 10:48:44 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5BA0D68BFE; Mon, 16 Mar 2020 15:48:42 +0100 (CET)
Date:   Mon, 16 Mar 2020 15:48:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: only check the superblock version for dinode
 size calculation
Message-ID: <20200316144842.GB19966@lst.de>
References: <20200312142235.550766-1-hch@lst.de> <20200312142235.550766-3-hch@lst.de> <20200316131707.GF12313@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316131707.GF12313@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 09:17:07AM -0400, Brian Foster wrote:
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index ad2b9c313fd2..518c6f0ec3a6 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -183,7 +183,7 @@ xfs_iformat_local(
> >  	 */
> >  	if (unlikely(size > XFS_DFORK_SIZE(dip, ip->i_mount, whichfork))) {
> >  		xfs_warn(ip->i_mount,
> > -	"corrupt inode %Lu (bad size %d for local fork, size = %d).",
> > +	"corrupt inode %Lu (bad size %d for local fork, size = %zd).",
> 
> Is this here intentionally? Otherwise seems fine:

Yes.  XFS_DFORK_SIZE now returns a size_t, so the format strings needs
to match.
