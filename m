Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E62D3164DDF
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Feb 2020 19:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgBSSpX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 19 Feb 2020 13:45:23 -0500
Received: from verein.lst.de ([213.95.11.211]:45855 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbgBSSpW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Feb 2020 13:45:22 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id BD3AE68B20; Wed, 19 Feb 2020 19:45:19 +0100 (CET)
Date:   Wed, 19 Feb 2020 19:45:19 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the di_version field from struct icdinode
Message-ID: <20200219184519.GB22307@lst.de>
References: <20200116104640.489259-1-hch@lst.de> <20200218210615.GA3142@infradead.org> <20200219001852.GA9506@magnolia> <20200219145234.GE24157@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219145234.GE24157@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 09:52:34AM -0500, Brian Foster wrote:
> FWIW, I don't really view this patch as a straightforward
> simplification. IMO, this slightly sacrifices readability for slightly
> less code and a smaller xfs_icdinode. That might be acceptable... I

I actually find it easier to read.  The per-inode versioning seems
to suggest inodes could actually be different on the same fs, while
the new one makes it clear that all inodes on the fs are the same.

> don't feel terribly strongly against it, but to me the explicit version
> checks are more clear in cases where the _hascrc() check is not used for
> something that is obviously CRC related (which is a pattern I'm
> generally not a fan of).

xfs_sb_version_hascrc is rather misnamed unfortunately.  In fact I think
just open coding it as 'XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5'
would improve things quite a bit.
