Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94B241833DD
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Mar 2020 15:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbgCLOzl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Mar 2020 10:55:41 -0400
Received: from verein.lst.de ([213.95.11.211]:37787 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgCLOzl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Mar 2020 10:55:41 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2446E68BFE; Thu, 12 Mar 2020 15:55:39 +0100 (CET)
Date:   Thu, 12 Mar 2020 15:55:38 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] libxfs: remove xfs_buf_oneshot
Message-ID: <20200312145538.GA18244@lst.de>
References: <20200312141715.550387-1-hch@lst.de> <20200312141715.550387-3-hch@lst.de> <20200312145308.GM8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312145308.GM8045@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 07:53:08AM -0700, Darrick J. Wong wrote:
> > index 4f750d19..b931fee7 100644
> > --- a/libxfs/xfs_sb.c
> > +++ b/libxfs/xfs_sb.c
> > @@ -982,7 +982,6 @@ xfs_update_secondary_sbs(
> >  		}
> >  
> >  		bp->b_ops = &xfs_sb_buf_ops;
> > -		xfs_buf_oneshot(bp);
> 
> Removing this will cause xfsprogs' libxfs to fall further out of sync
> with the kernel's libxfs.  Eric and I have been trying to keep that to a
> minimum.

Oops.  Somehow I was under the impression that xfs_buf_oneshot didn't
exist in the kernel, but in fact it does.  Feel free to skip this
patch.
