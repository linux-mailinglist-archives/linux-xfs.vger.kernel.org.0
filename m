Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17564741FD
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Jul 2019 01:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbfGXXYM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jul 2019 19:24:12 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49113 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726314AbfGXXYM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 19:24:12 -0400
Received: from dread.disaster.area (pa49-195-139-63.pa.nsw.optusnet.com.au [49.195.139.63])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F383E43C504;
        Thu, 25 Jul 2019 09:24:06 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hqQb5-0006QU-T8; Thu, 25 Jul 2019 09:22:59 +1000
Date:   Thu, 25 Jul 2019 09:22:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 7/3] xfs/194: unmount forced v4 fs during cleanup
Message-ID: <20190724232259.GC7777@dread.disaster.area>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
 <20190724155656.GH7084@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724155656.GH7084@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0 cx=a_idp_d
        a=fNT+DnnR6FjB+3sUuX8HHA==:117 a=fNT+DnnR6FjB+3sUuX8HHA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=0o9FgrsRnhwA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=0pExPX0TmpO2bnAZzrgA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 24, 2019 at 08:56:56AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Unmount the V4 filesystem we forcibly created to run this test during
> test cleanup so that the post-test wrapup checks won't try to remount
> the filesystem with different MOUNT_OPTIONS (specifically, the ones
> that get screened out by _force_xfsv4_mount_options) and fail.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/194 |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tests/xfs/194 b/tests/xfs/194
> index 3e186528..1f46d403 100755
> --- a/tests/xfs/194
> +++ b/tests/xfs/194
> @@ -18,6 +18,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  _cleanup()
>  {
>      cd /
> +    _scratch_unmount

Comment as to why this is necessary here so we don't go and remove
it because unmounting in cleanup should generally be unnecessary....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
