Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA65F0357
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Nov 2019 17:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390206AbfKEQoz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 5 Nov 2019 11:44:55 -0500
Received: from verein.lst.de ([213.95.11.211]:46460 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390388AbfKEQoz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Nov 2019 11:44:55 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id B09C768AFE; Tue,  5 Nov 2019 17:44:52 +0100 (CET)
Date:   Tue, 5 Nov 2019 17:44:52 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/34] xfs: add a bests pointer to struct
 xfs_dir3_icfree_hdr
Message-ID: <20191105164452.GA15708@lst.de>
References: <20191101220719.29100-1-hch@lst.de> <20191101220719.29100-16-hch@lst.de> <20191104202145.GP4153244@magnolia> <20191105014403.GD32531@lst.de> <20191105020553.GA4153244@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105020553.GA4153244@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 04, 2019 at 06:05:53PM -0800, Darrick J. Wong wrote:
> > It is not specified in ISO C, but clearly specified in the GNU C
> > extensions and used all over the kernel.
> 
> Just out of curiosity, do you know if clang supports that extension?

Yes.  Basically any modern C compiler does.

> > I don't really understand that sentence.  What would do you instead?
> 
> if (xfs_sb_version_hascrc(&mp->m_sb)) {
> 	struct xfs_dir3_free	*from3 = (struct xfs_dir3_free *)from;
> 
> 	...
> 	to->nused = be32_to_cpu(from3->hdr.nused);
> 	to->bests = &from3->bests[0];
> }
> 
> Since we're already passing around pointers to the xfs_dir[23]_free
> structure, we might as well use it instead of open-coding the arithmetic.
> Sorry that wasn't clear. :/

Sure, that is much better and I'll switch to it.
