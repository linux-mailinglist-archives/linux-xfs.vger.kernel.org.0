Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F36212A0F4
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Dec 2019 12:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfLXL7z (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Dec 2019 06:59:55 -0500
Received: from verein.lst.de ([213.95.11.211]:59154 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbfLXL7z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Dec 2019 06:59:55 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1A67168B20; Tue, 24 Dec 2019 12:59:53 +0100 (CET)
Date:   Tue, 24 Dec 2019 12:59:52 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 05/33] xfs: remove the ATTR_INCOMPLETE flag
Message-ID: <20191224115952.GD30689@lst.de>
References: <20191212105433.1692-1-hch@lst.de> <20191212105433.1692-6-hch@lst.de> <20191218214309.GH7489@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218214309.GH7489@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 18, 2019 at 01:43:09PM -0800, Darrick J. Wong wrote:
> > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > index 91c2cb14276e..04a628016728 100644
> > --- a/fs/xfs/libxfs/xfs_attr.h
> > +++ b/fs/xfs/libxfs/xfs_attr.h
> > @@ -36,11 +36,10 @@ struct xfs_attr_list_context;
> >  #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
> >  #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
> >  
> > -#define ATTR_INCOMPLETE	0x4000	/* [kernel] return INCOMPLETE attr keys */
> 
> Hmm, did we used to allow ATTR_INCOMPLETE from the attr_multi userspace
> calls?

We allowed that, but it didn't do anything as only the attr list code
checked for ATTR_INCOMPLETE.

> Maybe we should leave ATTR_INCOMPLETE so that we can blacklist
> it in case we ever see it coming from userspace?  Or at least prevent
> anyone from reusing 0x4000 and suffering the confusion.

At then end of the series the whole flags mess is cleaned up and there
is a hard barrier from user to kernel flags, so this should all be set.

> I also wonder if we can break userspace this way, but OTOH userspace
> should never be able to query incomplete attrs and this is an obscure
> ioctl anyway so maybe it's fine....

Exactly.  Incomplete attrs are an implementation detail that must not leak
to userspace.
