Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 761A1FBD88
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Nov 2019 02:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfKNBiq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 Nov 2019 20:38:46 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50355 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726098AbfKNBiq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 20:38:46 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D3DDF43E7EF;
        Thu, 14 Nov 2019 12:38:44 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iV45r-0000Wn-R5; Thu, 14 Nov 2019 12:38:43 +1100
Date:   Thu, 14 Nov 2019 12:38:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 4/5] xfs: remove the xfs_qoff_logitem_t typedef
Message-ID: <20191114013843.GZ4614@dread.disaster.area>
References: <20191112213310.212925-1-preichl@redhat.com>
 <20191112213310.212925-5-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112213310.212925-5-preichl@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=ojsdLs9NLU-s52GCh_UA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 10:33:09PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c |  5 ++---
>  fs/xfs/xfs_dquot_item.h        | 28 +++++++++++++++-------------
>  fs/xfs/xfs_qm_syscalls.c       | 29 ++++++++++++++++-------------
>  fs/xfs/xfs_trans_dquot.c       | 12 ++++++------
>  4 files changed, 39 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 271cca13565b..da6642488177 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -741,8 +741,7 @@ xfs_calc_qm_dqalloc_reservation(
>  
>  /*
>   * Turning off quotas.
> - *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
> - *    the superblock for the quota flags: sector size
> + * the quota off logitems: sizeof(struct xfs_qoff_logitem) * 2

Still needs the comment about the superblock. i.e. the initial
quota-off transaction modifies the quota flags in the superblock, so
it has to reserve space for that as well. Essentially the text of
the comment is iterating all the items that get modified in the
transaction and are accounted for in the function.

Everything else looks fine, though. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
