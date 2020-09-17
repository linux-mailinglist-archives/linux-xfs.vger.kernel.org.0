Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88AAB26D2E3
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 07:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgIQFJD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 01:09:03 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:49115 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726106AbgIQFJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 01:09:03 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 34D033AB8BD;
        Thu, 17 Sep 2020 15:09:01 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kImAG-0001ST-EM; Thu, 17 Sep 2020 15:09:00 +1000
Date:   Thu, 17 Sep 2020 15:09:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: clean up bmap intent item recovery checking
Message-ID: <20200917050900.GE12131@dread.disaster.area>
References: <160031336397.3624582.9639363323333392474.stgit@magnolia>
 <160031337029.3624582.3821482653073391016.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031337029.3624582.3821482653073391016.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=XJ9OtjpE c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=csxR608z7dPfA4rsG-YA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 08:29:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The bmap intent item checking code in xfs_bui_item_recover is spread all
> over the function.  We should check the recovered log item at the top
> before we allocate any resources or do anything else, so do that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_item.c |   57 ++++++++++++++++--------------------------------
>  1 file changed, 19 insertions(+), 38 deletions(-)

Looks good - I have a very similar patch here....

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
