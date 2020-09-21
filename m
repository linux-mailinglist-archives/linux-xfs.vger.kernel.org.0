Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF190271B1C
	for <lists+linux-xfs@lfdr.de>; Mon, 21 Sep 2020 08:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgIUGvU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 21 Sep 2020 02:51:20 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33486 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726149AbgIUGvU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Sep 2020 02:51:20 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7F85D3A9AB1;
        Mon, 21 Sep 2020 16:51:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kKFfQ-0006jv-Pj; Mon, 21 Sep 2020 16:51:16 +1000
Date:   Mon, 21 Sep 2020 16:51:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/2] xfs: don't free rt blocks when we're doing a
 REMAP bunmapi call
Message-ID: <20200921065116.GN12131@dread.disaster.area>
References: <160031330694.3624286.7407913899137083972.stgit@magnolia>
 <160031331319.3624286.3971628628820322437.stgit@magnolia>
 <20200918021450.GU7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918021450.GU7955@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=DKXxHBFb c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=Vln5cvk_7K0HmjbmufAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 07:14:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When callers pass XFS_BMAPI_REMAP into xfs_bunmapi, they want the extent
> to be unmapped from the given file fork without the extent being freed.
> We do this for non-rt files, but we forgot to do this for realtime
> files.  So far this isn't a big deal since nobody makes a bunmapi call
> to a rt file with the REMAP flag set, but don't leave a logic bomb.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: only compute bno if we're going to use it
> ---
>  fs/xfs/libxfs/xfs_bmap.c |   19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
