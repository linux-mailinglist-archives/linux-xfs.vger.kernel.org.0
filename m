Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91101CBECD
	for <lists+linux-xfs@lfdr.de>; Sat,  9 May 2020 10:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgEIIRS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 9 May 2020 04:17:18 -0400
Received: from verein.lst.de ([213.95.11.211]:56071 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbgEIIRS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 9 May 2020 04:17:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 10A1168C7B; Sat,  9 May 2020 10:17:16 +0200 (CEST)
Date:   Sat, 9 May 2020 10:17:15 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: remove xfs_ifork_ops
Message-ID: <20200509081715.GA21748@lst.de>
References: <20200508063423.482370-1-hch@lst.de> <20200508063423.482370-9-hch@lst.de> <20200508150543.GF27577@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508150543.GF27577@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 11:05:43AM -0400, Brian Foster wrote:
> On Fri, May 08, 2020 at 08:34:19AM +0200, Christoph Hellwig wrote:
> > xfs_ifork_ops add up to two indirect calls per inode read and flush,
> > despite just having a single instance in the kernel.  In xfsprogs
> > phase6 in xfs_repair overrides the verify_dir method to deal with inodes
> > that do not have a valid parent, but that can be fixed pretty easily
> > by ensuring they always have a valid looking parent.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> Code looks fine, but I assume we'll want a repair fix completed and
> merged before wiping this out:

With the xfsprogs merge delays I'm not sure merged will work, but I'll
happily take your patch and get it in shape for submission.
