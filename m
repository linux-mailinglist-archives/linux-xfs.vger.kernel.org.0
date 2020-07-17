Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE535222FC3
	for <lists+linux-xfs@lfdr.de>; Fri, 17 Jul 2020 02:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgGQAOF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Jul 2020 20:14:05 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:59641 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726204AbgGQAOF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 20:14:05 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id B7F0D10E8D3;
        Fri, 17 Jul 2020 10:14:01 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jwE0l-0001YH-NY; Fri, 17 Jul 2020 10:13:59 +1000
Date:   Fri, 17 Jul 2020 10:13:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/11] xfs: improve ondisk dquot flags checking
Message-ID: <20200717001359.GW2005@dread.disaster.area>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488198306.3813063.16348101518917273554.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159488198306.3813063.16348101518917273554.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=vSbW3Y9lqedW5so-dcAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 11:46:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create an XFS_DQTYPE_ANY mask for ondisk dquots flags, and use that to
> ensure that we never accept any garbage flags when we're loading dquots.
> While we're at it, restructure the quota type flag checking to use the
> proper masking.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c |   11 ++++++++---
>  fs/xfs/libxfs/xfs_format.h    |    2 ++
>  2 files changed, 10 insertions(+), 3 deletions(-)

Ok, I looked at this and questioned why it existed and why the
code didn't just use XFS_DQTYPE_REC_MASK directly. I think this
change exists because you plan on adding a new on-disk flag for
bigtime support and hence XFS_DQTYPE_ANY will grow to include the
new flag, right?

If so, can you add that to the commit message?

Code looks fine assuming I've understood this correctly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
