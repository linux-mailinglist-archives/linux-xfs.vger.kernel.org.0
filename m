Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F304B16C8
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Sep 2019 01:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfILXzb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Sep 2019 19:55:31 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38383 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727325AbfILXzb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Sep 2019 19:55:31 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4DC3643E8CC;
        Fri, 13 Sep 2019 09:55:29 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1i8Yvw-00083a-Ri; Fri, 13 Sep 2019 09:55:28 +1000
Date:   Fri, 13 Sep 2019 09:55:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_scrub: convert to per-ag inode bulkstat
 operations
Message-ID: <20190912235528.GT16973@dread.disaster.area>
References: <156774093859.2644581.13218735172589605186.stgit@magnolia>
 <156774096375.2644581.13727363113842017974.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156774096375.2644581.13727363113842017974.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=dFDqdkXLeZF3asbn4QMA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 08:36:03PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we're done reworking the xfrog bulkstat wrapper functions, we
> can adapt xfs_scrub to use the per-ag iteration functionality.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  scrub/fscounters.c |   22 ++++++----------------
>  scrub/inodes.c     |   20 ++++++--------------
>  2 files changed, 12 insertions(+), 30 deletions(-)

Nice simplification.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
