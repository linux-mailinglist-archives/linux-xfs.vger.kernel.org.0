Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D970104A8E
	for <lists+linux-xfs@lfdr.de>; Thu, 21 Nov 2019 07:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbfKUGGa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 21 Nov 2019 01:06:30 -0500
Received: from verein.lst.de ([213.95.11.211]:44087 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfKUGGa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Nov 2019 01:06:30 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id D1D8468B05; Thu, 21 Nov 2019 07:06:27 +0100 (CET)
Date:   Thu, 21 Nov 2019 07:06:27 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 03/10] xfs: improve the xfs_dabuf_map calling
 conventions
Message-ID: <20191121060627.GA22808@lst.de>
References: <20191120111727.16119-1-hch@lst.de> <20191120111727.16119-4-hch@lst.de> <20191120181708.GM6219@magnolia> <20191120182035.GA11912@lst.de> <20191121054458.GX6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121054458.GX6219@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 09:44:58PM -0800, Darrick J. Wong wrote:
> On Wed, Nov 20, 2019 at 07:20:35PM +0100, Christoph Hellwig wrote:
> > On Wed, Nov 20, 2019 at 10:17:08AM -0800, Darrick J. Wong wrote:
> > > > -	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork,
> > > > -				&mapp, &nmap);
> > > > +	error = xfs_dabuf_map(dp, bno,
> > > > +			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
> > > > +			whichfork, &mapp, &nmap);
> > > >  	if (error) {
> > > >  		/* mapping a hole is not an error, but we don't continue */
> > > > -		if (error == -1)
> > > > +		if (error == -ENOENT)
> > > 
> > > Shouldn't this turn into:
> > > 
> > > if (error || !nmap)
> > > 	goto out_free;
> > > 
> > > Otherwise looks ok to me.
> > 
> > Yes, it should.  Looks like that hunk got lost in the reshuffle.
> 
> With that and the other change I mentioned, it seems to test ok.  Do you
> want to respin the patch, or just let me keep my staged version?

I've just done the respin and was about to re-start testing.  If you
have a sensible version I'll skip that and will let you proceed.
