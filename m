Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408D31C962A
	for <lists+linux-xfs@lfdr.de>; Thu,  7 May 2020 18:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgEGQPC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 May 2020 12:15:02 -0400
Received: from verein.lst.de ([213.95.11.211]:47614 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgEGQPC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 May 2020 12:15:02 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 40DD168B05; Thu,  7 May 2020 18:14:59 +0200 (CEST)
Date:   Thu, 7 May 2020 18:14:58 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: libxfs 5.7 resync
Message-ID: <20200507161458.GA1033@lst.de>
References: <20200507121851.304002-1-hch@lst.de> <20200507154809.GH6714@magnolia> <20200507155454.GB32006@lst.de> <20200507161117.GA718@lst.de> <b7a71ad3-646c-dbb7-fdf8-84e65511099e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7a71ad3-646c-dbb7-fdf8-84e65511099e@sandeen.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 07, 2020 at 11:12:55AM -0500, Eric Sandeen wrote:
> 
> 
> On 5/7/20 11:11 AM, Christoph Hellwig wrote:
> > And FYI, the xfs_check failures also appear with your branch.
> > 
> 
> 
> diff -Nurp -x .git -x m4 xfsprogs-hch-5.7/db/check.c xfsprogs-maint-5.7/db/check.c
> --- xfsprogs-hch-5.7/db/check.c	2020-05-07 12:00:56.134700951 -0400
> +++ xfsprogs-maint-5.7/db/check.c	2020-05-01 23:33:19.864639307 -0400
> @@ -2707,6 +2707,8 @@ process_inode(
>  		"dev", "local", "extents", "btree", "uuid"
>  	};
>  
> +	/* xfs_inode_from_disk expects to have an mp to work with */
> +	xino.i_mount = mp;
>  	libxfs_inode_from_disk(&xino, dip);

That looks like a hot contender :)  I'm curious why it didn't crash,
though.
