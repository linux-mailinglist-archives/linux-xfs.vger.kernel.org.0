Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5717B1D637C
	for <lists+linux-xfs@lfdr.de>; Sat, 16 May 2020 20:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgEPSRB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 16 May 2020 14:17:01 -0400
Received: from verein.lst.de ([213.95.11.211]:33065 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbgEPSRB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 May 2020 14:17:01 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2643268B05; Sat, 16 May 2020 20:16:59 +0200 (CEST)
Date:   Sat, 16 May 2020 20:16:58 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: move the fork format fields into struct
 xfs_ifork
Message-ID: <20200516181658.GA22612@lst.de>
References: <20200510072404.986627-1-hch@lst.de> <20200510072404.986627-6-hch@lst.de> <20200514212541.GL6714@magnolia> <20200516135807.GA14540@lst.de> <20200516170143.GO1984748@magnolia> <20200516180150.GC6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516180150.GC6714@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 16, 2020 at 11:01:50AM -0700, Darrick J. Wong wrote:
> > In my case it was the xfs_scrub run after generic/001 that did it.
> > 
> > I think we're covered against null *ifp in most cases because they're
> > guarded by an if(XFS_IFORK_Q()); it's jut here where I went around
> > shortcutting.  Maybe I should just fix this function for you... :)
> 
> Hmm, that sounded meaner than I intended it to be. :/
> 
> Also, it turns out that it's pretty easy to fix this as part of fixing
> the contorted logic in patch 1 (aka xchk_bmap_check_rmaps) so I'll do
> that there.

How about you send a patch to just fix up that function for now,
and I'll rebase on top of that?
