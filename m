Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF91F958D
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Nov 2019 17:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbfKLQZb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 Nov 2019 11:25:31 -0500
Received: from verein.lst.de ([213.95.11.211]:56726 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbfKLQZb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Nov 2019 11:25:31 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 149B268BE1; Tue, 12 Nov 2019 17:25:28 +0100 (CET)
Date:   Tue, 12 Nov 2019 17:25:26 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: don't reset the "inode core" in xfs_iread
Message-ID: <20191112162526.GA14170@lst.de>
References: <20191020082145.32515-1-hch@lst.de> <20191020082145.32515-4-hch@lst.de> <20191112162421.GZ6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112162421.GZ6219@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 08:24:21AM -0800, Darrick J. Wong wrote:
> On Sun, Oct 20, 2019 at 10:21:44AM +0200, Christoph Hellwig wrote:
> > We have the exact same memset in xfs_inode_alloc, which is always called
> > just before xfs_iread.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Seems fine on its own, but then I looked at all the zero initializers
> and memsets in xfs_inode_alloc and wondered why we don't just
> kmem_zone_zalloc the inode?

Because kmem_zone_zalloc doesn't interact well with the rcu lookup
schemes and the constructor.  That being said I have some plans
for this area as part of getting rid of the "dinode core" later on.

