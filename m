Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EE02D3FCE
	for <lists+linux-xfs@lfdr.de>; Wed,  9 Dec 2020 11:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729704AbgLIKXU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 9 Dec 2020 05:23:20 -0500
Received: from verein.lst.de ([213.95.11.211]:49573 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727800AbgLIKXU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Dec 2020 05:23:20 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8640867373; Wed,  9 Dec 2020 11:22:37 +0100 (CET)
Date:   Wed, 9 Dec 2020 11:22:37 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v4 3/6] xfs: move on-disk inode allocation out of
 xfs_ialloc()
Message-ID: <20201209102237.GA19388@lst.de>
References: <20201208122003.3158922-1-hsiangkao@redhat.com> <20201208122003.3158922-4-hsiangkao@redhat.com> <20201209075246.GA10645@lst.de> <20201209084342.GA83673@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209084342.GA83673@xiangao.remote.csb>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 09, 2020 at 04:43:42PM +0800, Gao Xiang wrote:
> Yeah, so maybe I should revert back to the old code? not sure... Anyway,
> I think codebase could be changed over time from a single change. Anyway,
> I'm fine with either way. So I may hear your perference about this and send
> out the next version (I think such cleanup can be fited in 5.11, so I can
> base on this and do more work....)

Personally I'd prefer to just use the errno return and ipp by reference
calling convention for the newly added helper as well.  But I'm ok with
all variants, so maybe I should add my:

Reviewed-by: Christoph Hellwig <hch@lst.de>

here in case Darrick wants to pick this up.

Looking at idmapped mounts series it would really help to get this in
ASAP to avoid conflicts.
