Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070E7134DC4
	for <lists+linux-xfs@lfdr.de>; Wed,  8 Jan 2020 21:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgAHUkp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 8 Jan 2020 15:40:45 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55351 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726426AbgAHUko (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 15:40:44 -0500
Received: from dread.disaster.area (pa49-180-68-255.pa.nsw.optusnet.com.au [49.180.68.255])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6FAFD3A4276;
        Thu,  9 Jan 2020 07:40:42 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ipI89-0005bt-G5; Thu, 09 Jan 2020 07:40:41 +1100
Date:   Thu, 9 Jan 2020 07:40:41 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: introduce XFS_MAX_FILEOFF
Message-ID: <20200108204041.GF23128@dread.disaster.area>
References: <157845705246.82882.11480625967486872968.stgit@magnolia>
 <157845705884.82882.5003824524655587269.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157845705884.82882.5003824524655587269.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=sbdTpStuSq8iNQE8viVliQ==:117 a=sbdTpStuSq8iNQE8viVliQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=PUWKjkzJjGX9PewAdI4A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 07, 2020 at 08:17:38PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce a new #define for the maximum supported file block offset.
> We'll use this in the next patch to make it more obvious that we're
> doing some operation for all possible inode fork mappings after a given
> offset.  We can't use ULLONG_MAX here because bunmapi uses that to
> detect when it's done.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_format.h |    1 +
>  fs/xfs/xfs_reflink.c       |    3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 1b7dcbae051c..c2976e441d43 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1540,6 +1540,7 @@ typedef struct xfs_bmdr_block {
>  #define BMBT_BLOCKCOUNT_BITLEN	21
>  
>  #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
> +#define XFS_MAX_FILEOFF		(BMBT_STARTOFF_MASK)

Isn't the maximum file offset in the BMBT the max start offset + the
max length of the extent that is located at BMBT_STARTOFF_MASK?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
