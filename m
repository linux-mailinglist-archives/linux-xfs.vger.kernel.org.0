Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D398E23FF09
	for <lists+linux-xfs@lfdr.de>; Sun,  9 Aug 2020 17:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgHIPlv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 9 Aug 2020 11:41:51 -0400
Received: from out20-39.mail.aliyun.com ([115.124.20.39]:34147 "EHLO
        out20-39.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgHIPls (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Aug 2020 11:41:48 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07534803|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.461947-0.00536089-0.532692;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03303;MF=guan@eryu.me;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.IEx-7kl_1596987703;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.IEx-7kl_1596987703)
          by smtp.aliyun-inc.com(10.147.42.253);
          Sun, 09 Aug 2020 23:41:44 +0800
Date:   Sun, 9 Aug 2020 23:41:43 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Bill O'Donnell <billodo@redhat.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, darrick.wong@oracle.com,
        sandeen@redhat.com
Subject: Re: [PATCH] xfs/518: modify timer/state commands to remove new g,p
 timer output
Message-ID: <20200809154143.GK2557159@desktop>
References: <20200731173739.390649-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731173739.390649-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 31, 2020 at 12:37:39PM -0500, Bill O'Donnell wrote:
> New xfs_quota kernel and xfsprogs add grace timers for group and project,
> in addition to existing user quota. Adjust xfs/518 to accommodate those
> changes, and avoid regression.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>

This looks good to me. But it'd be great if the kernel & xfsprogs
commits that change the behavior could be mentioned in the commit log as
well.

Thanks,
Eryu

> ---
>  tests/xfs/518 | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/xfs/518 b/tests/xfs/518
> index da39d8dc..c49c4e4d 100755
> --- a/tests/xfs/518
> +++ b/tests/xfs/518
> @@ -41,12 +41,12 @@ _qmount_option "usrquota"
>  _scratch_mount >> $seqres.full
>  
>  $XFS_QUOTA_PROG -x -c 'timer -u 300m' $SCRATCH_MNT
> -$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
> +$XFS_QUOTA_PROG -x -c 'state -u' $SCRATCH_MNT | grep 'grace time'
>  _scratch_unmount
>  
>  # Remount and check the limits
>  _scratch_mount >> $seqres.full
> -$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
> +$XFS_QUOTA_PROG -x -c 'state -u' $SCRATCH_MNT | grep 'grace time'
>  _scratch_unmount
>  
>  # Run repair to force quota check
> @@ -57,12 +57,12 @@ _scratch_xfs_repair >> $seqres.full 2>&1
>  # while the incore copy stays at whatever was read in prior to quotacheck.
>  # This will show up after the /next/ remount.
>  _scratch_mount >> $seqres.full
> -$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
> +$XFS_QUOTA_PROG -x -c 'state -u' $SCRATCH_MNT | grep 'grace time'
>  _scratch_unmount
>  
>  # Remount and check the limits
>  _scratch_mount >> $seqres.full
> -$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
> +$XFS_QUOTA_PROG -x -c 'state -u' $SCRATCH_MNT | grep 'grace time'
>  _scratch_unmount
>  
>  # success, all done
> -- 
> 2.26.2
