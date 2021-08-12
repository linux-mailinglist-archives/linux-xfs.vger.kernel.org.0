Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FB73EAC48
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Aug 2021 23:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235246AbhHLVNt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Aug 2021 17:13:49 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:44207 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231270AbhHLVNt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 17:13:49 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id E50DD1B50FD;
        Fri, 13 Aug 2021 07:13:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mEI0u-00HacL-Oc; Fri, 13 Aug 2021 07:13:20 +1000
Date:   Fri, 13 Aug 2021 07:13:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: remove the xfs_dinode_t typedef
Message-ID: <20210812211320.GD3657114@dread.disaster.area>
References: <20210812084343.27934-1-hch@lst.de>
 <20210812084343.27934-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812084343.27934-2-hch@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=7-415B0cAAAA:8
        a=sWdXBT-FfqaZGUN-yIwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 12, 2021 at 10:43:41AM +0200, Christoph Hellwig wrote:
> Remove the few leftover instances of the xfs_dinode_t typedef.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

True for the kernel, but there are: 

$ git grep xfs_dinode_t |wc -l
126

A *lot* of userspace uses of this typedef. So either the typedef
stays defined in libxfs, or this also needs a patch for the removal
of the typedef from xfsprogs as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
