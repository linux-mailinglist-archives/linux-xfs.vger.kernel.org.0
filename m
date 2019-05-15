Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1C871E812
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 07:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbfEOF4t (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 01:56:49 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36809 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbfEOF4t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 01:56:49 -0400
Received: from dread.disaster.area (pa49-181-171-240.pa.nsw.optusnet.com.au [49.181.171.240])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0A549105FE73;
        Wed, 15 May 2019 15:56:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hQmuE-0002UE-1m; Wed, 15 May 2019 15:56:46 +1000
Date:   Wed, 15 May 2019 15:56:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11 V2] libxfs: remove unused cruft
Message-ID: <20190515055646.GW29573@dread.disaster.area>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-4-git-send-email-sandeen@redhat.com>
 <7b7e0bb3-3fac-6602-cff0-c868d6d0540c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b7e0bb3-3fac-6602-cff0-c868d6d0540c@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0 cx=a_idp_d
        a=LhzQONXuMOhFZtk4TmSJIw==:117 a=LhzQONXuMOhFZtk4TmSJIw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=sg197kI0fsquh3AkcIEA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 14, 2019 at 07:17:44PM -0500, Eric Sandeen wrote:
> Remove many unused #defines and functions.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
....
>  /* miscellaneous kernel routines not in user space */
> -#define down_read(a)		((void) 0)
> -#define up_read(a)		((void) 0)
>  #define spin_lock_init(a)	((void) 0)
>  #define spin_lock(a)		((void) 0)
>  #define spin_unlock(a)		((void) 0)

The lack of locking in the userspace code scares me somewhat :P

> @@ -400,7 +397,6 @@ roundup_64(uint64_t x, uint32_t y)
>  
>  #define XBRW_READ			LIBXFS_BREAD
>  #define XBRW_WRITE			LIBXFS_BWRITE
> -#define xfs_buf_iomove(bp,off,len,data,f)	libxfs_iomove(bp,off,len,data,f)
>  #define xfs_buf_zero(bp,off,len)     libxfs_iomove(bp,off,len,NULL,LIBXFS_BZERO)
>  
>  /* mount stuff */
> @@ -436,8 +432,6 @@ roundup_64(uint64_t x, uint32_t y)
>  #define xfs_sort					qsort
>  
>  #define xfs_ilock(ip,mode)				((void) 0)
> -#define xfs_ilock_nowait(ip,mode)			((void) 0)
> -#define xfs_ilock_demote(ip,mode)			((void) 0)

Especially that we have transactions that run without inode locks.

But that's not a problem this patch solves, so may as well get rid
of the unused interfaces...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
