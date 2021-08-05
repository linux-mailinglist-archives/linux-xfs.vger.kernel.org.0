Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCF73E0DC3
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Aug 2021 07:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhHEFbt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Aug 2021 01:31:49 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:45632 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230215AbhHEFbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Aug 2021 01:31:49 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id C18AC80C330;
        Thu,  5 Aug 2021 15:31:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mBVyg-00EgYv-88; Thu, 05 Aug 2021 15:31:34 +1000
Date:   Thu, 5 Aug 2021 15:31:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 06/14] xfs: queue inactivation immediately when free
 space is tight
Message-ID: <20210805053134.GW2757197@dread.disaster.area>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
 <162812921593.2589546.139493086066282940.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162812921593.2589546.139493086066282940.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=95N0oa6M86rbP4G3xlEA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 04, 2021 at 07:06:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we have made the inactivation of unlinked inodes a background
> task to increase the throughput of file deletions, we need to be a
> little more careful about how long of a delay we can tolerate.
> 
> On a mostly empty filesystem, the risk of the allocator making poor
> decisions due to fragmentation of the free space on account a lengthy
> delay in background updates is minimal because there's plenty of space.
> However, if free space is tight, we want to deallocate unlinked inodes
> as quickly as possible to avoid fallocate ENOSPC and to give the
> allocator the best shot at optimal allocations for new writes.
> 
> Therefore, queue the percpu worker immediately if the filesystem is more
> than 95% full.  This follows the same principle that XFS becomes less
> aggressive about speculative allocations and lazy cleanup (and more
> precise about accounting) when nearing full.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Makes sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
