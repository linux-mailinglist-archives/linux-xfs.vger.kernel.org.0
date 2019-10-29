Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2A6E8059
	for <lists+linux-xfs@lfdr.de>; Tue, 29 Oct 2019 07:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732336AbfJ2G2n (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 29 Oct 2019 02:28:43 -0400
Received: from verein.lst.de ([213.95.11.211]:38149 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732535AbfJ2G2n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Oct 2019 02:28:43 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E0C1D68AFE; Tue, 29 Oct 2019 07:28:40 +0100 (CET)
Date:   Tue, 29 Oct 2019 07:28:40 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@lst.de
Subject: Re: [PATCH 2/2] xfs: refactor xfs_iread_extents to use
 xfs_btree_visit_blocks
Message-ID: <20191029062840.GB17004@lst.de>
References: <157232185555.594704.14846501683468956862.stgit@magnolia> <157232186801.594704.5915391485002020723.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157232186801.594704.5915391485002020723.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 09:04:28PM -0700, Darrick J. Wong wrote:
> @@ -4313,6 +4314,11 @@ xfs_btree_visit_blocks(
>  			xfs_btree_copy_ptrs(cur, &lptr, ptr, 1);

>  
> +		/* Skip whatever we don't want. */
> +		if ((level == 0 && !(flags & XFS_BTREE_VISIT_RECORDS)) ||
> +		    (level > 0 && !(flags & XFS_BTREE_VISIT_LEAVES)))
> +			continue;

Nipick:  I'd make this two separate if statements as that flows a little
easier.  In fact the closing brace above is the start of a level > 0
check, so the whole thing could become:

		if (level > 0) {
			// existing code, maybe also move the comment above
			// the if here

			if (!(flags & XFS_BTREE_VISIT_RECORDS))
				continue;
		} else {
			if (!(flags & XFS_BTREE_VISIT_LEAVES))
				continue;
		}

which would be even nicer.  Otherwise this patch looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
