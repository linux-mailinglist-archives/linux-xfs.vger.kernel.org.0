Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8C9F3FF7
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Nov 2019 06:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbfKHF2F (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Nov 2019 00:28:05 -0500
Received: from verein.lst.de ([213.95.11.211]:32929 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfKHF2F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Nov 2019 00:28:05 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9253268BE1; Fri,  8 Nov 2019 06:28:03 +0100 (CET)
Date:   Fri, 8 Nov 2019 06:28:03 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/46] xfs: refactor btree node scrubbing
Message-ID: <20191108052803.GB29783@lst.de>
References: <20191107182410.12660-1-hch@lst.de> <20191107182410.12660-4-hch@lst.de> <20191107224350.GM6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107224350.GM6219@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> >  /* Scrub a da btree hash (key). */
> > @@ -136,7 +113,7 @@ xchk_da_btree_hash(
> >  
> >  	/* Is this hash no larger than the parent hash? */
> >  	blks = ds->state->path.blk;
> > -	entry = xchk_da_btree_entry(ds, level - 1, blks[level - 1].index);
> 
> This eliminates the only user of blks, which means the variable can be
> removed.  The rest looks fine though.

Fixed.
