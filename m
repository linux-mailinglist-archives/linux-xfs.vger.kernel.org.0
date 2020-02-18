Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1CF16296C
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Feb 2020 16:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgBRPaa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Feb 2020 10:30:30 -0500
Received: from verein.lst.de ([213.95.11.211]:38736 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbgBRPaa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Feb 2020 10:30:30 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3E04F68BE1; Tue, 18 Feb 2020 16:30:27 +0100 (CET)
Date:   Tue, 18 Feb 2020 16:30:27 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/31] xfs: remove the xfs_inode argument to
 xfs_attr_get_ilocked
Message-ID: <20200218153026.GD21275@lst.de>
References: <20200217125957.263434-1-hch@lst.de> <20200217125957.263434-14-hch@lst.de> <20200217230608.GN10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217230608.GN10776@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 10:06:08AM +1100, Dave Chinner wrote:
> >  	lock_mode = xfs_ilock_attr_map_shared(args->dp);
> > -	error = xfs_attr_get_ilocked(args->dp, args);
> > +	error = xfs_attr_get_ilocked(args);
> >  	xfs_iunlock(args->dp, lock_mode);
> 
> ... at this point I really would like to see the "args->dp" pointer
> get renamed. "dp" was originally short for "directory inode
> pointer", but it's clear that it hasn't meant that for a long time.
> It's just an inode pointer.
> 
> That's out of scope for this patch set, though, so maybe the next
> cleanup patchset?

That's for another time.  And while I found the dp naming rather odd
I'm not sure it really is worth the churn on its own.  That being said
the da_args structure really needs to be split into dir and attr args,
as those can be almost entirely separate anyway.
