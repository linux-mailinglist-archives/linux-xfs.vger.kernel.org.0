Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114D62D1376
	for <lists+linux-xfs@lfdr.de>; Mon,  7 Dec 2020 15:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgLGOWX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 7 Dec 2020 09:22:23 -0500
Received: from verein.lst.de ([213.95.11.211]:42098 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbgLGOWX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Dec 2020 09:22:23 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8396E67373; Mon,  7 Dec 2020 15:21:40 +0100 (CET)
Date:   Mon, 7 Dec 2020 15:21:40 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3 3/6] xfs: move on-disk inode allocation out of
 xfs_ialloc()
Message-ID: <20201207142140.GA32764@lst.de>
References: <20201207001533.2702719-1-hsiangkao@redhat.com> <20201207001533.2702719-4-hsiangkao@redhat.com> <20201207134941.GD29249@lst.de> <20201207141948.GB2817641@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207141948.GB2817641@xiangao.remote.csb>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 10:19:48PM +0800, Gao Xiang wrote:
> > Maybe spell out parent_inode?  pino reminds of some of the weird Windows
> > code that start all variable names for pointers with a "p".
> 
> Ok, yet pino is somewhat common, as I saw it in f2fs and jffs2 before.
> I know you mean 'Hungarian naming conventions'.
> 
> If you don't like pino. How about parent_ino? since parent_inode occurs me
> about "struct inode *" or something like this (a pointer around some inode),
> rather than an inode number.

Yeah, parent_ino is what I mean to suggest anyway, sorry for the typo.
