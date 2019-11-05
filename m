Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15E5FEF2EC
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Nov 2019 02:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbfKEBmT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 Nov 2019 20:42:19 -0500
Received: from verein.lst.de ([213.95.11.211]:42494 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728602AbfKEBmT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Nov 2019 20:42:19 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4342968BE1; Tue,  5 Nov 2019 02:42:16 +0100 (CET)
Date:   Tue, 5 Nov 2019 02:42:15 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/34] xfs: move the max dir2 leaf entries count to
 struct xfs_da_geometry
Message-ID: <20191105014215.GC32531@lst.de>
References: <20191101220719.29100-1-hch@lst.de> <20191101220719.29100-12-hch@lst.de> <20191104200744.GL4153244@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104200744.GL4153244@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 04, 2019 at 12:07:44PM -0800, Darrick J. Wong wrote:
> > diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> > index 5e3e954fee77..c8b137685ca7 100644
> > --- a/fs/xfs/libxfs/xfs_da_btree.h
> > +++ b/fs/xfs/libxfs/xfs_da_btree.h
> > @@ -27,6 +27,7 @@ struct xfs_da_geometry {
> >  	int		magicpct;	/* 37% of block size in bytes */
> >  	xfs_dablk_t	datablk;	/* blockno of dir data v2 */
> >  	int		leaf_hdr_size;	/* dir2 leaf header size */
> > +	unsigned int	leaf_max_ents;	/* # of entries in dir2 leaf */
> 
> Why does this one get 'unsigned' but the header size fields don't?
> Or maybe I should rephase that: Why aren't the header sizes unsigned
> too?

They probably should all be unsigned and I should add a prep patch
for the existing ones.
