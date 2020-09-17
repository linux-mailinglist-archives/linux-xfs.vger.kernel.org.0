Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF6026D2D6
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 06:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgIQEzA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 00:55:00 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49900 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725886AbgIQEzA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 00:55:00 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A26CB8271FA;
        Thu, 17 Sep 2020 14:54:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kIlwe-0001Q6-Ng; Thu, 17 Sep 2020 14:54:56 +1000
Date:   Thu, 17 Sep 2020 14:54:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: attach inode to dquot in xfs_bui_item_recover
Message-ID: <20200917045456.GC12131@dread.disaster.area>
References: <160031332353.3624373.16349101558356065522.stgit@magnolia>
 <160031333615.3624373.7775190767495604737.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031333615.3624373.7775190767495604737.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=KcmsTjQD c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=7WxjoEH1VMJeCECGdSMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 08:28:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In the bmap intent item recovery code, we must be careful to attach the
> inode to its dquots (if quotas are enabled) so that a change in the
> shape of the bmap btree doesn't cause the quota counters to be
> incorrect.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_item.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 815a0563288f..598f713831c9 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -24,6 +24,7 @@
>  #include "xfs_error.h"
>  #include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
> +#include "xfs_quota.h"
>  
>  kmem_zone_t	*xfs_bui_zone;
>  kmem_zone_t	*xfs_bud_zone;
> @@ -498,6 +499,10 @@ xfs_bui_item_recover(
>  	if (error)
>  		goto err_inode;
>  
> +	error = xfs_qm_dqattach(ip);
> +	if (error)
> +		goto err_inode;

Won't this deadlock as the inode is already locked when it is
returned by xfs_iget()?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
