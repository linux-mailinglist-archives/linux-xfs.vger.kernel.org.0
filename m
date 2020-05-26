Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C67A1C1AB4
	for <lists+linux-xfs@lfdr.de>; Fri,  1 May 2020 18:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgEAQkM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 May 2020 12:40:12 -0400
Received: from verein.lst.de ([213.95.11.211]:47737 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728443AbgEAQkM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 May 2020 12:40:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 22EAF68BFE; Fri,  1 May 2020 18:40:10 +0200 (CEST)
Date:   Fri, 1 May 2020 18:40:09 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: refactor xfs_inode_verify_forks
Message-ID: <20200501164009.GB18426@lst.de>
References: <20200501081424.2598914-1-hch@lst.de> <20200501081424.2598914-10-hch@lst.de> <20200501155724.GP40250@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501155724.GP40250@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 11:57:24AM -0400, Brian Foster wrote:
> >  	if (!XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
> > -		return __this_address;
> > -	return xfs_attr_shortform_verify(ip);
> > +		fa = __this_address;
> > +	else
> > +		fa = xfs_attr_shortform_verify(ip);
> > +
> > +	if (fa) {
> > +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
> > +			ip->i_afp->if_u1.if_data, ip->i_afp->if_bytes, fa);
> > +		return -EFSCORRUPTED;
> 
> This explicitly makes !ip->i_afp one of the handled corruption cases for
> XFS_DINODE_FMT_LOCAL, but then attempts to access it anyways. Otherwise
> seems Ok modulo the comments on the previous patch...

No, it keeps the existing bogus behavior, just making the bug more
obvious by moving the bits closer together :(

That being said this is getting fixed later in the series.
