Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923BD26D2CA
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 06:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgIQEs0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 00:48:26 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:42887 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725267AbgIQEsZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 00:48:25 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E2B65826DE3;
        Thu, 17 Sep 2020 14:48:22 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kIlqH-0001P8-U8; Thu, 17 Sep 2020 14:48:21 +1000
Date:   Thu, 17 Sep 2020 14:48:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: check dabtree node hash values when loading
 child blocks
Message-ID: <20200917044821.GB12131@dread.disaster.area>
References: <160031330694.3624286.7407913899137083972.stgit@magnolia>
 <160031331944.3624286.5979437788459484830.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031331944.3624286.5979437788459484830.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=IuRgj43g c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=OzY0H6R7Nf9-9y8Rf9sA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 08:28:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When xchk_da_btree_block is loading a non-root dabtree block, we know
> that the parent block had to have a (hashval, address) pointer to the
> block that we just loaded.  Check that the hashval in the parent matches
> the block we just loaded.
> 
> This was found by fuzzing nbtree[3].hashval = ones in xfs/394.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/dabtree.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index e56786f0a13c..653f3280e1c1 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -441,6 +441,20 @@ xchk_da_btree_block(
>  		goto out_freebp;
>  	}
>  
> +	/*
> +	 * If we've been handed a block that is below the dabtree root, does
> +	 * its hashval match what the parent block expected to see?
> +	 */
> +	if (level > 0) {
> +		struct xfs_da_node_entry	*key;
> +
> +		key = xchk_da_btree_node_entry(ds, level - 1);
> +		if (be32_to_cpu(key->hashval) != blk->hashval) {
> +			xchk_da_set_corrupt(ds, level);
> +			goto out_freebp;
> +		}
> +	}

Looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
