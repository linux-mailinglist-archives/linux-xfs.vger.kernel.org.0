Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D0224F0AB
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Aug 2020 02:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgHXAKu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 23 Aug 2020 20:10:50 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:41174 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726737AbgHXAKu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Aug 2020 20:10:50 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 2C1CED5BC88;
        Mon, 24 Aug 2020 10:10:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kA04R-0000ol-8P; Mon, 24 Aug 2020 10:10:43 +1000
Date:   Mon, 24 Aug 2020 10:10:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 06/11] xfs: refactor inode timestamp coding
Message-ID: <20200824001043.GO7941@dread.disaster.area>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797592873.965217.7436192080471557112.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159797592873.965217.7436192080471557112.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=5O4kqcYfuxubJiNQITkA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 07:12:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor inode timestamp encoding and decoding into helper functions so
> that we can add extra behaviors in subsequent patches.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c |   42 ++++++++++++++++++++++++---------------
>  fs/xfs/libxfs/xfs_inode_buf.h |    5 +++++
>  fs/xfs/scrub/inode.c          |   25 ++++++++++++++++-------
>  fs/xfs/xfs_inode_item.c       |   44 ++++++++++++++++++++++++++---------------
>  4 files changed, 76 insertions(+), 40 deletions(-)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
