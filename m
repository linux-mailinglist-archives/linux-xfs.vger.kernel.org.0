Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD2E16298E
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Feb 2020 16:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgBRPib (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Feb 2020 10:38:31 -0500
Received: from verein.lst.de ([213.95.11.211]:38766 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgBRPib (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Feb 2020 10:38:31 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 14AC868BE1; Tue, 18 Feb 2020 16:38:28 +0100 (CET)
Date:   Tue, 18 Feb 2020 16:38:27 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 21/31] xfs: move the legacy xfs_attr_list to xfs_ioctl.c
Message-ID: <20200218153827.GA21780@lst.de>
References: <20200217125957.263434-1-hch@lst.de> <20200217125957.263434-22-hch@lst.de> <20200217234136.GV10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217234136.GV10776@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 10:41:36AM +1100, Dave Chinner wrote:
> On Mon, Feb 17, 2020 at 01:59:47PM +0100, Christoph Hellwig wrote:
> > The old xfs_attr_list code is only used by the attrlist by handle
> > ioctl.  Move it to xfs_ioctl.c with its user.  Also move the
> > attrlist and attrlist_ent structure to xfs_fs.h, as they are exposed
> > user ABIs.  They are used through libattr headers with the same name
> > by at least xfsdump.  Also document this relation so that it doesn't
> > require a research project to figure out.
> 
> That's a bit nasty. I suspect that also needs documentation in the
> path_to_handle(3) man page, too.

Probably.

> > +	/*
> > +	 * Initialize the output buffer.
> > +	 */
> > +	memset(&context, 0, sizeof(context));
> > +	context.dp = dp;
> > +	context.cursor = cursor;
> > +	context.resynch = 1;
> > +	context.flags = flags;
> > +	context.buffer = buffer;
> > +	context.bufsize = (bufsize & ~(sizeof(int)-1));  /* align */
> 
> ALIGN()?

Isn't round_down the macro to use here?  I'll add another patch to the
end of the series for that.
