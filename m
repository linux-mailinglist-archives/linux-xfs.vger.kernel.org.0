Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38F38162990
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Feb 2020 16:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgBRPj1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Feb 2020 10:39:27 -0500
Received: from verein.lst.de ([213.95.11.211]:38770 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgBRPj1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Feb 2020 10:39:27 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 686C968BE1; Tue, 18 Feb 2020 16:39:25 +0100 (CET)
Date:   Tue, 18 Feb 2020 16:39:24 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 23/31] xfs: properly type the buffer field in struct
 xfs_fsop_attrlist_handlereq
Message-ID: <20200218153924.GB21780@lst.de>
References: <20200217125957.263434-1-hch@lst.de> <20200217125957.263434-24-hch@lst.de> <20200217235315.GY10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217235315.GY10776@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 10:53:16AM +1100, Dave Chinner wrote:
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index ae77bcd8c05b..21920f613d42 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -597,7 +597,7 @@ typedef struct xfs_fsop_attrlist_handlereq {
> >  	struct xfs_attrlist_cursor	pos; /* opaque cookie, list offset */
> >  	__u32				flags;	/* which namespace to use */
> >  	__u32				buflen;	/* length of buffer supplied */
> > -	void				__user *buffer;	/* returned names */
> > +	struct xfs_attrlist __user	*buffer;/* returned names */
> >  } xfs_fsop_attrlist_handlereq_t;
> 
> This changes the userspace API, right? So, in theory, it could break
> compilation of userspace applications that treat it as an attrlist_t
> and don't specifically cast the assignment because it's currently
> a void pointer?

IFF userspace was using this header it would change the API.  But
userspace uses the libattr definition exclusively.
