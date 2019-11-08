Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13A93F400B
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Nov 2019 06:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbfKHFi0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Nov 2019 00:38:26 -0500
Received: from verein.lst.de ([213.95.11.211]:32969 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbfKHFi0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Nov 2019 00:38:26 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id F320D68BE1; Fri,  8 Nov 2019 06:38:23 +0100 (CET)
Date:   Fri, 8 Nov 2019 06:38:23 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/46] xfs: cleanup xchk_dir_rec
Message-ID: <20191108053823.GA29959@lst.de>
References: <20191107182410.12660-1-hch@lst.de> <20191107182410.12660-32-hch@lst.de> <20191108005700.GB6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108005700.GB6219@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 04:57:00PM -0800, Darrick J. Wong wrote:
> >  	struct xfs_dir2_data_entry	*dent;
> >  	struct xfs_buf			*bp;
> >  	struct xfs_dir2_leaf_entry	*ent;
> > -	char				*p, *endp;
> > +	void				*endp;
> > +	unsigned int			offset;
> 
> Can this be named iter_off or something?  There's already an @off variable
> which is the offset-within-block that wa calculated from the entry pointer.

Ok.

> > +		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
> > +		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
> > +	
> 
> Extra whitespace.

Fixed.
