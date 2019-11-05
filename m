Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD1DEF2F3
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Nov 2019 02:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730250AbfKEBoH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 Nov 2019 20:44:07 -0500
Received: from verein.lst.de ([213.95.11.211]:42497 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730127AbfKEBoG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Nov 2019 20:44:06 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id CC36568BE1; Tue,  5 Nov 2019 02:44:03 +0100 (CET)
Date:   Tue, 5 Nov 2019 02:44:03 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/34] xfs: add a bests pointer to struct
 xfs_dir3_icfree_hdr
Message-ID: <20191105014403.GD32531@lst.de>
References: <20191101220719.29100-1-hch@lst.de> <20191101220719.29100-16-hch@lst.de> <20191104202145.GP4153244@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104202145.GP4153244@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 04, 2019 at 12:21:45PM -0800, Darrick J. Wong wrote:
> > @@ -233,6 +233,7 @@ xfs_dir2_free_hdr_from_disk(
> >  		to->firstdb = be32_to_cpu(from3->hdr.firstdb);
> >  		to->nvalid = be32_to_cpu(from3->hdr.nvalid);
> >  		to->nused = be32_to_cpu(from3->hdr.nused);
> > +		to->bests = (void *)from3 + sizeof(struct xfs_dir3_free_hdr);
> 
> Urgh, isn't void pointer arithmetic technically illegal according to C?

It is not specified in ISO C, but clearly specified in the GNU C
extensions and used all over the kernel.

> In any case, shouldn't this cast through struct xfs_dir3_free instead of
> open-coding details of the disk format that we've already captured?  The
> same question also applies to the other patches that add pointers to
> ondisk leaf and intnode pointers into the incore header struct.

I don't really understand that sentence.  What would do you instead?
