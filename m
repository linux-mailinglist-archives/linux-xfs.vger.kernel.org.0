Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E085E2D084F
	for <lists+linux-xfs@lfdr.de>; Mon,  7 Dec 2020 00:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgLFX4p (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 6 Dec 2020 18:56:45 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36416 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728657AbgLFX4p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:56:45 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C8D803C48F4;
        Mon,  7 Dec 2020 10:56:03 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1km3so-001GTO-Ur; Mon, 07 Dec 2020 10:56:02 +1100
Date:   Mon, 7 Dec 2020 10:56:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: refactor file range validation
Message-ID: <20201206235602.GQ3913616@dread.disaster.area>
References: <160729625074.1608297.13414859761208067117.stgit@magnolia>
 <160729626928.1608297.12355625902682243490.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160729626928.1608297.12355625902682243490.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=4DdJfOSJBEhAbIok0OIA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 06, 2020 at 03:11:09PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor all the open-coded validation of file block ranges into a
> single helper, and teach the bmap scrubber to check the ranges.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c  |    2 +-
>  fs/xfs/libxfs/xfs_types.c |   25 +++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_types.h |    3 +++
>  fs/xfs/scrub/bmap.c       |    4 ++++
>  fs/xfs/xfs_bmap_item.c    |    2 +-
>  fs/xfs/xfs_rmap_item.c    |    2 +-
>  6 files changed, 35 insertions(+), 3 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
