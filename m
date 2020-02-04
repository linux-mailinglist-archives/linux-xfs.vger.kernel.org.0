Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBE161515C8
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Feb 2020 07:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgBDGPs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Feb 2020 01:15:48 -0500
Received: from verein.lst.de ([213.95.11.211]:59432 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgBDGPs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Feb 2020 01:15:48 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9ABBD68BFE; Tue,  4 Feb 2020 07:15:46 +0100 (CET)
Date:   Tue, 4 Feb 2020 07:15:46 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 6/6] xfs: remove XFS_BUF_TO_SBP
Message-ID: <20200204061546.GA31878@lst.de>
References: <20200130133343.225818-1-hch@lst.de> <20200130133343.225818-7-hch@lst.de> <d965fc02-1fa6-c52c-9d91-7803ac77a824@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d965fc02-1fa6-c52c-9d91-7803ac77a824@sandeen.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 03, 2020 at 12:38:34PM -0600, Eric Sandeen wrote:
> > @@ -707,7 +707,7 @@ xfs_sb_read_verify(
> >  	 * Check all the superblock fields.  Don't byteswap the xquota flags
> >  	 * because _verify_common checks the on-disk values.
> >  	 */
> > -	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
> > +	__xfs_sb_from_disk(&sb, bp->b_addr, false);
> 
> why not dsb here

Yes, this should just pass dsb.

> In any case seems like if you already have a local xfs_dsb, use that vs.
> bp->b_addr?

That was the planned, but I obviously missed one spot.
