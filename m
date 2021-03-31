Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB38348053
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Mar 2021 19:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhCXSU7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Mar 2021 14:20:59 -0400
Received: from verein.lst.de ([213.95.11.211]:38225 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237539AbhCXSUp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:20:45 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2E7CC68B05; Wed, 24 Mar 2021 19:20:43 +0100 (CET)
Date:   Wed, 24 Mar 2021 19:20:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/18] xfs: remove the di_dmevmask and di_dmstate
 fields from struct xfs_icdinode
Message-ID: <20210324182042.GA16478@lst.de>
References: <20210324142129.1011766-1-hch@lst.de> <20210324142129.1011766-6-hch@lst.de> <20210324181429.GD22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324181429.GD22100@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 11:17:59AM -0700, Darrick J. Wong wrote:
> On Wed, Mar 24, 2021 at 03:21:16PM +0100, Christoph Hellwig wrote:
> > The legacy DMAPI fields were never set by upstream Linux XFS, and have no
> > way to be read using the kernel APIs.  So instead of bloating the in-core
> > inode for them just copy them from the on-disk inode into the log when
> > logging the inode.  The only caveat is that we need to make sure to zero
> > the fields for newly read or deleted inodes, which is solved using a new
> > flag in the inode.
> 
> How long ago /did/ non-upstream XFS have DMAPI support?  Does it still
> have it now?  What's the cost of zeroing the fields?
> 
> (Really what I'm saying is that I have so little clue of what dmevmask
> and dmstate do that I don't really know what Magic Smoke comes out if
> these fields get zeroed by an upstream kernel.)

SuSE is shipping SGI patches for it in SLES12, their second newest
release. Which is still supported AFAIK.
