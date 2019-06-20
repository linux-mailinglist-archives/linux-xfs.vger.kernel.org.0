Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9424DC99
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 23:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbfFTVcH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 17:32:07 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59689 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726549AbfFTVcH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 17:32:07 -0400
Received: from dread.disaster.area (pa49-195-189-25.pa.nsw.optusnet.com.au [49.195.189.25])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 712D6439224;
        Fri, 21 Jun 2019 07:32:05 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1he4e9-0006fZ-E0; Fri, 21 Jun 2019 07:31:05 +1000
Date:   Fri, 21 Jun 2019 07:31:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: move xfs_ino_geometry to xfs_shared.h
Message-ID: <20190620213105.GD26375@dread.disaster.area>
References: <20190618205935.GS5387@magnolia>
 <20190619011309.GT5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619011309.GT5387@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0 cx=a_idp_d
        a=K5LJ/TdJMXINHCwnwvH1bQ==:117 a=K5LJ/TdJMXINHCwnwvH1bQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=dq6fvYVFJ5YA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=Hq3NnKovOj3MnDf3MzUA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 18, 2019 at 06:13:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The inode geometry structure isn't related to ondisk format; it's
> support for the mount structure.  Move it to xfs_shared.h.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: move it to xfs_shared.h, which now every file has to include
> ---
>  fs/xfs/libxfs/xfs_dir2.c       |    1 +
>  fs/xfs/libxfs/xfs_dir2_block.c |    1 +
>  fs/xfs/libxfs/xfs_dir2_data.c  |    1 +
>  fs/xfs/libxfs/xfs_dir2_leaf.c  |    1 +
>  fs/xfs/libxfs/xfs_dir2_node.c  |    1 +
>  fs/xfs/libxfs/xfs_dir2_sf.c    |    1 +
>  fs/xfs/libxfs/xfs_format.h     |   41 ---------------------------------------
>  fs/xfs/libxfs/xfs_iext_tree.c  |    1 +
>  fs/xfs/libxfs/xfs_inode_fork.c |    1 +
>  fs/xfs/libxfs/xfs_shared.h     |   42 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_acl.c               |    1 +
>  fs/xfs/xfs_attr_list.c         |    1 +
>  fs/xfs/xfs_buf.c               |    1 +
>  fs/xfs/xfs_buf_item.c          |    1 +
>  fs/xfs/xfs_dir2_readdir.c      |    1 +
>  fs/xfs/xfs_discard.c           |    1 +
>  fs/xfs/xfs_dquot_item.c        |    1 +
>  fs/xfs/xfs_error.c             |    1 +
>  fs/xfs/xfs_export.c            |    1 +
>  fs/xfs/xfs_filestream.c        |    1 +
>  fs/xfs/xfs_icache.c            |    1 +
>  fs/xfs/xfs_inode_item.c        |    1 +
>  fs/xfs/xfs_ioctl32.c           |    1 +
>  fs/xfs/xfs_message.c           |    1 +
>  fs/xfs/xfs_pnfs.c              |    1 +
>  fs/xfs/xfs_qm_bhv.c            |    1 +
>  fs/xfs/xfs_quotaops.c          |    1 +
>  fs/xfs/xfs_trans_ail.c         |    1 +
>  fs/xfs/xfs_xattr.c             |    1 +
>  29 files changed, 69 insertions(+), 41 deletions(-)

Bigger patch, but I think it's the right way to do this.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
