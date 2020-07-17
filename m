Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940CF222F9C
	for <lists+linux-xfs@lfdr.de>; Fri, 17 Jul 2020 02:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgGQACt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Jul 2020 20:02:49 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50630 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbgGQACs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 20:02:48 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 38D1A7EAF69;
        Fri, 17 Jul 2020 10:02:45 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jwDpq-0001XV-NS; Fri, 17 Jul 2020 10:02:42 +1000
Date:   Fri, 17 Jul 2020 10:02:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: replace a few open-coded XFS_DQTYPE_REC_MASK
 uses
Message-ID: <20200717000242.GU2005@dread.disaster.area>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488197022.3813063.2727213433560259185.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159488197022.3813063.2727213433560259185.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=96thu50UQX-aXa72sGMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 11:46:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix a few places where we open-coded this mask constant.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dquot_item_recover.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> index d7eb85c7d394..93178341569a 100644
> --- a/fs/xfs/xfs_dquot_item_recover.c
> +++ b/fs/xfs/xfs_dquot_item_recover.c
> @@ -39,7 +39,7 @@ xlog_recover_dquot_ra_pass2(
>  	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot))
>  		return;
>  
> -	type = recddq->d_flags & (XFS_DQTYPE_USER | XFS_DQTYPE_PROJ | XFS_DQTYPE_GROUP);
> +	type = recddq->d_flags & XFS_DQTYPE_REC_MASK;
>  	ASSERT(type);
>  	if (log->l_quotaoffs_flag & type)
>  		return;
> @@ -91,7 +91,7 @@ xlog_recover_dquot_commit_pass2(
>  	/*
>  	 * This type of quotas was turned off, so ignore this record.
>  	 */
> -	type = recddq->d_flags & (XFS_DQTYPE_USER | XFS_DQTYPE_PROJ | XFS_DQTYPE_GROUP);
> +	type = recddq->d_flags & XFS_DQTYPE_REC_MASK;

Couldn't these both be converted to xfs_dquot_type(recddq)?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
