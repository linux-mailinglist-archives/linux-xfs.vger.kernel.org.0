Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEFD669EE7
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Jul 2019 00:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbfGOWXT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 15 Jul 2019 18:23:19 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:38499 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730669AbfGOWXT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 18:23:19 -0400
Received: from dread.disaster.area (pa49-195-139-63.pa.nsw.optusnet.com.au [49.195.139.63])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 0A9DA3DCA5B;
        Tue, 16 Jul 2019 08:23:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hn9MH-0006Hw-Jk; Tue, 16 Jul 2019 08:22:09 +1000
Date:   Tue, 16 Jul 2019 08:22:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: sync up xfs_trans_inode with userspace
Message-ID: <20190715222209.GN7689@dread.disaster.area>
References: <68ef2df9-3f8e-6547-4e2b-181bce30ca3c@redhat.com>
 <112d2e52-c96c-af83-7e53-5fca12448c76@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <112d2e52-c96c-af83-7e53-5fca12448c76@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=fNT+DnnR6FjB+3sUuX8HHA==:117 a=fNT+DnnR6FjB+3sUuX8HHA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=0o9FgrsRnhwA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=E2BXcW75DJQbEYrhQcoA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 12, 2019 at 12:46:17PM -0500, Eric Sandeen wrote:
> Add an XFS_ICHGTIME_CREATE case to xfs_trans_ichgtime() to keep in
> sync with userspace.  (Currently no kernel caller sends this flag.)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index 93d14e47269d..a9ad90926b87 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -66,6 +66,10 @@ xfs_trans_ichgtime(
>  		inode->i_mtime = tv;
>  	if (flags & XFS_ICHGTIME_CHG)
>  		inode->i_ctime = tv;
> +	if (flags & XFS_ICHGTIME_CREATE) {
> +		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
> +		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
> +	}

Please use the same format as the rest of the function. i.e.

	if (flags & XFS_ICHGTIME_CREATE)
		ip->i_d.di_crtime = tv;

And convert userspace over to the same :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
